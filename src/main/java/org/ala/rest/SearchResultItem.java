package org.ala.rest;

import java.util.List;
import org.apache.lucene.document.Fieldable;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamAsAttribute;
import java.io.Serializable;
import java.util.logging.Logger;
import org.geotools.util.logging.Logging;

@XStreamAlias("result")
public class SearchResultItem implements Serializable {

    String id;
    String name;
    String serial;
    String description;
    String state;
    String layerName;
    String idAttribute1;
    String idAttribute2;
    Float score;
    @XStreamAlias("xlink:href")
    @XStreamAsAttribute
    String link;
    private static final Logger logger = Logging.getLogger("org.ala.rest.SearchResultItem");

    SearchResultItem(String layerName, String name, String idAttribute1, Float score) {
        this.id = layerName + "/" + idAttribute1;
        if (idAttribute2.compareTo("") != 0) {
            this.id += "/" + idAttribute2;
        }
        this.name = name;
        this.layerName = layerName;
        this.idAttribute1 = idAttribute1;
        this.score = score;
        this.link = "/gazetteer/";
        this.link += this.id.replace(" ", "_") + ".json";
    }

    SearchResultItem(List<Fieldable> fields, Boolean includeLink, Float score) {

        this.description = "";
        for (Fieldable field : fields) {
            if (field.name().contentEquals("description")){
                this.description = description;
            }
            else if(field.name().contentEquals("name")) {
                this.name = field.stringValue();
            }
            else if (field.name().contentEquals("layerName")) {
                GazetteerConfig gc = new GazetteerConfig();
                //if a layer alias exists the id will always use the alias in preference to the layer name
                String layerAlias = gc.getLayerAlias(field.stringValue());
                if (layerAlias.compareTo("") == 0){
                    this.layerName = field.stringValue();
                }
                else{
                    this.layerName = layerAlias;
                }
            } else if (field.name().contentEquals("idAttribute1")) {
                this.idAttribute1 = field.stringValue();
            }
        }
        this.id = this.layerName + "/" + idAttribute1.replace(" ", "_");

        this.score = score;

        if (includeLink == true) {
            this.link = "/gazetteer/";
            this.link += id + ".json";
        }
    }
}
