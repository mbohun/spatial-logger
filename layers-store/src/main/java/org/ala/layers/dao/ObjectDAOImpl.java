/**************************************************************************
 *  Copyright (C) 2010 Atlas of Living Australia
 *  All Rights Reserved.
 *
 *  The contents of this file are subject to the Mozilla Public
 *  License Version 1.1 (the "License"); you may not use this file
 *  except in compliance with the License. You may obtain a copy of
 *  the License at http://www.mozilla.org/MPL/
 *
 *  Software distributed under the License is distributed on an "AS
 *  IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 *  implied. See the License for the specific language governing
 *  rights and limitations under the License.
 ***************************************************************************/
package org.ala.layers.dao;

import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.io.WKTReader;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Vector;
import java.util.zip.ZipInputStream;
import javax.annotation.Resource;
import javax.sql.DataSource;
import org.ala.layers.dto.GridClass;
import org.ala.layers.dto.IntersectionFile;
import org.ala.layers.dto.Objects;
import org.ala.layers.intersect.Grid;
import org.apache.log4j.Logger;
import org.geotools.data.DataUtilities;
import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.geotools.geojson.feature.FeatureJSON;
import org.geotools.kml.KML;
import org.geotools.kml.KMLConfiguration;
import org.geotools.xml.Encoder;
import org.opengis.feature.simple.SimpleFeatureType;
import org.springframework.jdbc.core.simple.ParameterizedBeanPropertyRowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcTemplate;
import org.springframework.stereotype.Service;

/**
 *
 * @author ajay
 */
@Service("objectDao")
public class ObjectDAOImpl implements ObjectDAO {

    //sld substitution strings
    private static final String SUB_LAYERNAME = "*layername*";
    private static final String SUB_COLOUR = "0xff0000"; //"*colour*";
    private static final String SUB_MIN_MINUS_ONE = "*min_minus_one*";
    private static final String SUB_MIN = "*min*";
    private static final String SUB_MAX = "*max*";
    private static final String SUB_MAX_PLUS_ONE = "*max_plus_one*";
    /** log4j logger */
    private static final Logger logger = Logger.getLogger(ObjectDAOImpl.class);
    private SimpleJdbcTemplate jdbcTemplate;
    @Resource(name = "layerIntersectDao")
    private LayerIntersectDAO layerIntersectDao;

    @Resource(name = "dataSource")
    public void setDataSource(DataSource dataSource) {
        this.jdbcTemplate = new SimpleJdbcTemplate(dataSource);
    }
    static final String objectWmsUrl = "/wms?service=WMS&version=1.1.0&request=GetMap&layers=ALA:Objects&format=image/png&viewparams=s:<pid>";
    static final String gridPolygonWmsUrl = "/wms?service=WMS&version=1.1.0&request=GetMap&layers=ALA:" + SUB_LAYERNAME + "&format=image/png&sld_body=";
    static final String gridPolygonSld;
    static final String gridClassSld;

    static {
        String polygonSld =
                "<?xml version=\"1.0\" encoding=\"UTF-8\"?><StyledLayerDescriptor xmlns=\"http://www.opengis.net/sld\">"
                + "<NamedLayer><Name>ALA:" + SUB_LAYERNAME + "</Name>"
                + "<UserStyle><FeatureTypeStyle><Rule><RasterSymbolizer><Geometry></Geometry>"
                + "<ColorMap>"
                + "<ColorMapEntry color=\"" + SUB_COLOUR + "\" opacity=\"0\" quantity=\"" + SUB_MIN_MINUS_ONE + "\"/>"
                + "<ColorMapEntry color=\"" + SUB_COLOUR + "\" opacity=\"1\" quantity=\"" + SUB_MIN + "\"/>"
                + "<ColorMapEntry color=\"" + SUB_COLOUR + "\" opacity=\"0\" quantity=\"" + SUB_MAX_PLUS_ONE + "\"/>"
                + "</ColorMap></RasterSymbolizer></Rule></FeatureTypeStyle></UserStyle></NamedLayer></StyledLayerDescriptor>";

        String classSld =
                "<?xml version=\"1.0\" encoding=\"UTF-8\"?><StyledLayerDescriptor xmlns=\"http://www.opengis.net/sld\">"
                + "<NamedLayer><Name>ALA:" + SUB_LAYERNAME + "</Name>"
                + "<UserStyle><FeatureTypeStyle><Rule><RasterSymbolizer><Geometry></Geometry>"
                + "<ColorMap>"
                + "<ColorMapEntry color=\"" + SUB_COLOUR + "\" opacity=\"0\" quantity=\"" + SUB_MIN_MINUS_ONE + "\"/>"
                + "<ColorMapEntry color=\"" + SUB_COLOUR + "\" opacity=\"1\" quantity=\"" + SUB_MIN + "\"/>"
                + "<ColorMapEntry color=\"" + SUB_COLOUR + "\" opacity=\"1\" quantity=\"" + SUB_MAX + "\"/>"
                + "<ColorMapEntry color=\"" + SUB_COLOUR + "\" opacity=\"0\" quantity=\"" + SUB_MAX_PLUS_ONE + "\"/>"
                + "</ColorMap></RasterSymbolizer></Rule></FeatureTypeStyle></UserStyle></NamedLayer></StyledLayerDescriptor>";
        try {
            polygonSld = URLEncoder.encode(polygonSld, "UTF-8");
        } catch (UnsupportedEncodingException ex) {
            logger.fatal("Invalid polygon sld string defined in ObjectDAOImpl.");
        }
        try {
            classSld = URLEncoder.encode(classSld, "UTF-8");
        } catch (UnsupportedEncodingException ex) {
            logger.fatal("Invalid class sld string defined in ObjectDAOImpl.");
        }

        gridPolygonSld = polygonSld;
        gridClassSld = classSld;

    }

    @Override
    public List<Objects> getObjects() {
        //return hibernateTemplate.find("from Objects");
        logger.info("Getting a list of all objects");
        String sql = "select o.pid as pid, o.id as id, o.name as name, o.desc as description, o.fid as fid, f.name as fieldname from objects o, fields f where o.fid = f.id";
        return jdbcTemplate.query(sql, ParameterizedBeanPropertyRowMapper.newInstance(Objects.class));
    }

    @Override
    public List<Objects> getObjectsById(String id) {
        //return hibernateTemplate.find("from Objects where id = ?", id);
        logger.info("Getting object info for fid = " + id);
        //String sql = "select * from objects where fid = ?";
        String sql = "select o.pid as pid, o.id as id, o.name as name, o.desc as description, o.fid as fid, f.name as fieldname, o.bbox, o.area_km from objects o, fields f where o.fid = ? and o.fid = f.id";
        List<Objects> objects = jdbcTemplate.query(sql, ParameterizedBeanPropertyRowMapper.newInstance(Objects.class), id);

        updateObjectWms(objects);

        //get grid classes
        if (objects == null || objects.isEmpty()) {
            objects = new ArrayList<Objects>();
            IntersectionFile f = layerIntersectDao.getConfig().getIntersectionFile(id);
            if (f != null && f.getClasses() != null) {
                for (Entry<Integer, GridClass> c : f.getClasses().entrySet()) {
                    if (f.getType().equals("a")) {           //class pid
                        Objects o = new Objects();
                        o.setPid(f.getLayerPid() + ":" + c.getKey());
                        o.setId(f.getLayerPid() + ":" + c.getKey());
                        o.setName(c.getValue().getName());
                        o.setFid(f.getFieldId());
                        o.setFieldname(f.getFieldName());
                        o.setBbox(c.getValue().getBbox());
                        o.setArea_km(c.getValue().getArea_km());
                        o.setWmsurl(getGridClassWms(f.getLayerName(), c.getValue()));
                        objects.add(o);
                    } else {                                //polygon pid
                        try {
//                            BufferedReader br = new BufferedReader(new FileReader(f.getFilePath() + File.separator + c.getKey() + ".wkt.index"));
//                            String line;
//                            while((line = br.readLine()) != null) {
//                                if(line.length() > 0) {
//                                    String [] cells = line.split(",");
//                                    Objects o = new Objects();
//                                    o.setPid(f.getLayerPid() + ":" + c.getKey() + ":" + cells[0]);
//                                    o.setId(f.getLayerPid() + ":" + c.getKey() + ":" + cells[0]);
//                                    o.setName(c.getValue().getName());
//                                    o.setFid(f.getFieldId());
//                                    o.setFieldname(f.getFieldName());
//
//                                    //Too costly to calculate on the fly, and not pre-calculated.
////                                    o.setBbox(c.getValue().getBbox());
////                                    o.setArea_km(c.getValue().getArea_km());
//                                    objects.add(o);
//                                }
//                            }
//                            br.close();
                            RandomAccessFile raf = new RandomAccessFile(f.getFilePath() + File.separator + c.getKey() + ".wkt.index.dat", "r");
                            long len = raf.length() / (4 + 4 + 4 * 4 + 4); //group number, character offset, minx, miny, maxx, maxy, area sq km
                            for (int i = 0; i < len; i++) {
                                int n = raf.readInt();
                                /*int charoffset = */ raf.readInt();
                                float minx = raf.readFloat();
                                float miny = raf.readFloat();
                                float maxx = raf.readFloat();
                                float maxy = raf.readFloat();
                                float area = raf.readFloat();

                                Objects o = new Objects();
                                o.setPid(f.getLayerPid() + ":" + c.getKey() + ":" + n);
                                o.setId(f.getLayerPid() + ":" + c.getKey() + ":" + n);
                                o.setName(c.getValue().getName());
                                o.setFid(f.getFieldId());
                                o.setFieldname(f.getFieldName());

                                o.setBbox("POLYGON((" + minx + " " + miny + ","
                                        + minx + " " + maxy + ","
                                        + +maxx + " " + maxy + ","
                                        + +maxx + " " + miny + ","
                                        + +minx + " " + miny + "))");
                                o.setArea_km(1.0 * area);

                                o.setWmsurl(getGridPolygonWms(f.getLayerName(), n));

                                objects.add(o);
                            }
                            raf.close();

                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }

        return objects;
    }

    @Override
    public String getObjectsGeometryById(String id, String geomtype) {
        logger.info("Getting object info for id = " + id + " and geometry as " + geomtype);

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try {
            streamObjectsGeometryById(baos, id, geomtype);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                baos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return new String(baos.toByteArray());
    }

    @Override
    public void streamObjectsGeometryById(OutputStream os, String id, String geomtype) throws IOException {
        logger.info("Getting object info for id = " + id + " and geometry as " + geomtype);
        String sql = "";
        if ("kml".equals(geomtype)) {
            sql = "SELECT ST_AsKml(the_geom) as geometry FROM objects WHERE pid=?;";
        } else if ("wkt".equals(geomtype)) {
            sql = "SELECT ST_AsText(the_geom) as geometry FROM objects WHERE pid=?;";
        } else if ("geojson".equals(geomtype)) {
            sql = "SELECT ST_AsGeoJSON(the_geom) as geometry FROM objects WHERE pid=?;";
        }

        List<Objects> l = jdbcTemplate.query(sql, ParameterizedBeanPropertyRowMapper.newInstance(Objects.class), id);

        if (l.size() > 0) {
            os.write(l.get(0).getGeometry().getBytes());
        } else {
            //get grid classes
            if (id.length() > 0) {
                //grid class pids are, 'layerPid:gridClassNumber'
                try {
                    String[] s = id.split(":");
                    if (s.length >= 2) {
                        int n = Integer.parseInt(s[1]);
                        IntersectionFile f = layerIntersectDao.getConfig().getIntersectionFile(s[0]);
                        if (f != null && f.getClasses() != null) {
                            GridClass gc = f.getClasses().get(n);
                            if (gc != null
                                    && ("kml".equals(geomtype)
                                    || "wkt".equals(geomtype)
                                    || "geojson".equals(geomtype))) {
                                //TODO: enable for type 'a' after implementation of fields table defaultLayer field
                                /*if (f.getType().equals("a") || s.length == 2) {           //class
                                File file = new File(f.getFilePath() + File.separator + s[1] + "." + geomtype + ".zip");
                                if (file.exists()) {
                                ZipInputStream zis = new ZipInputStream(new FileInputStream(file));
                                zis.getNextEntry();
                                byte[] buffer = new byte[1024];
                                int size;
                                while ((size = zis.read(buffer)) > 0) {
                                os.write(buffer, 0, size);
                                }
                                zis.close();
                                }
                                } else*/ {                                //polygon
                                    BufferedReader br = null;
                                    RandomAccessFile raf = null;
                                    try {
                                        String[] cells = null;

//                                    br = new BufferedReader(new FileReader(f.getFilePath() + File.separator + s[1] + ".wkt.index"));
//                                    String line;
//                                    while((line = br.readLine()) != null) {
//                                        if(line.length() > 0) {
//                                            cells = line.split(",");
//                                            if(cells[0].equals(s[2])) {
//                                                break;
//                                            }
//                                        }
//                                    }

                                        HashMap<String, Object> map = getGridIndexEntry(f.getFilePath() + File.separator + s[1], s[2]);

                                        cells = new String[]{s[2], String.valueOf(map.get("charoffset"))};
                                        if (cells != null) {
                                            //get polygon wkt string
                                            File file = new File(f.getFilePath() + File.separator + s[1] + ".wkt.zip");
                                            ZipInputStream zis = new ZipInputStream(new FileInputStream(file));
                                            zis.getNextEntry();
                                            InputStreamReader isr = new InputStreamReader(zis);
                                            isr.skip(Long.parseLong(cells[1]));
                                            char[] buffer = new char[1024];
                                            int size;
                                            StringBuilder sb = new StringBuilder();
                                            sb.append("POLYGON");
                                            int end = -1;
                                            while (end < 0 && (size = isr.read(buffer)) > 0) {
                                                sb.append(buffer, 0, size);
                                                end = sb.toString().indexOf("))");
                                            }
                                            end += 2;

                                            String wkt = sb.toString().substring(0, end);

                                            if (geomtype.equals("wkt")) {
                                                os.write(wkt.getBytes());
                                            } else {
                                                WKTReader r = new WKTReader();
                                                Geometry g = r.read(wkt);

                                                if (geomtype.equals("kml")) {
                                                    Encoder encoder = new Encoder(new KMLConfiguration());
                                                    encoder.setIndenting(true);
                                                    encoder.encode(g, KML.Geometry, os);
                                                } else if (geomtype.equals("geojson")) {
                                                    FeatureJSON fjson = new FeatureJSON();
                                                    final SimpleFeatureType TYPE = DataUtilities.createType("class", "the_geom:MultiPolygon,name:String");
                                                    SimpleFeatureBuilder featureBuilder = new SimpleFeatureBuilder(TYPE);
                                                    featureBuilder.add(g);
                                                    featureBuilder.add(gc.getName());
                                                    fjson.writeFeature(featureBuilder.buildFeature(null), os);
                                                }
                                            }
                                        }

                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (br != null) {
                                            br.close();
                                        }
                                        if (raf != null) {
                                            raf.close();
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    public Objects getObjectByPid(String pid) {
        //List<Objects> l = hibernateTemplate.find("from Objects where pid = ?", pid);
        logger.info("Getting object info for pid = " + pid);
        String sql = "select o.pid, o.id, o.name, o.desc as description, o.fid as fid, f.name as fieldname, o.bbox, o.area_km from objects o, fields f where o.pid = ? and o.fid = f.id";
        List<Objects> l = jdbcTemplate.query(sql, ParameterizedBeanPropertyRowMapper.newInstance(Objects.class), pid);

        //get grid classes
        if ((l == null || l.isEmpty()) && pid.length() > 0) {
            //grid class pids are, 'layerPid:gridClassNumber'
            try {
                String[] s = pid.split(":");
                if (s.length >= 2) {
                    int n = Integer.parseInt(s[1]);
                    IntersectionFile f = layerIntersectDao.getConfig().getIntersectionFile(s[0]);
                    if (f != null && f.getClasses() != null) {
                        GridClass gc = f.getClasses().get(n);
                        if (gc != null) {
                            Objects o = new Objects();
                            o.setPid(pid);
                            o.setId(pid);
                            o.setName(gc.getName());
                            o.setFid(f.getFieldId());
                            o.setFieldname(f.getFieldName());

                            if (/*f.getType().equals("a") ||*/s.length == 2) {
                                o.setBbox(gc.getBbox());
                                o.setArea_km(gc.getArea_km());
                                o.setWmsurl(getGridClassWms(f.getLayerName(), gc));
                            } else {
                                HashMap<String, Object> map = getGridIndexEntry(f.getFilePath() + File.separator + s[1], s[2]);
                                if (!map.isEmpty()) {
                                    o.setBbox("POLYGON(" + map.get("minx") + " " + map.get("miny") + ","
                                            + map.get("minx") + " " + map.get("maxy") + ","
                                            + map.get("maxx") + " " + map.get("maxy") + ","
                                            + map.get("maxx") + " " + map.get("miny") + ","
                                            + map.get("minx") + " " + map.get("miny") + ")");

                                    o.setArea_km(((Float) map.get("area")).doubleValue());

                                    o.setWmsurl(getGridPolygonWms(f.getLayerName(), Integer.parseInt(s[2])));
                                }
                            }

                            l.add(o);
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (l.size() > 0) {
            return l.get(0);
        } else {
            return null;
        }
    }

    @Override
    public Objects getObjectByIdAndLocation(String fid, Double lng, Double lat) {
        logger.info("Getting object info for fid = " + fid + " at loc: (" + lng + ", " + lat + ") ");
        String sql = "select o.pid, o.id, o.name, o.desc as description, o.fid as fid, f.name as fieldname, o.bbox, o.area_km from objects o, fields f where o.fid = ? and ST_Within(ST_SETSRID(ST_Point(?,?),4326), o.the_geom) and o.fid = f.id";
        List<Objects> l = jdbcTemplate.query(sql, ParameterizedBeanPropertyRowMapper.newInstance(Objects.class), new Object[]{fid, lng, lat});
        if (l == null || l.isEmpty()) {
            //get grid classes intersection
            l = new ArrayList<Objects>();
            IntersectionFile f = layerIntersectDao.getConfig().getIntersectionFile(fid);
            if (f != null && f.getClasses() != null) {
                Vector v = layerIntersectDao.samplingFull(fid, lng, lat);
                if (v != null && v.size() > 0 && v.get(0) != null) {
                    Map m = (Map) v.get(0);
                    int key = (int) Double.parseDouble(((String) m.get("pid")).split(":")[1]);
                    GridClass gc = f.getClasses().get(key);
                    if (f.getType().equals("a")) {           //class pid
                        Objects o = new Objects();
                        o.setName(gc.getName());
                        o.setFid(f.getFieldId());
                        o.setFieldname(f.getFieldName());
                        o.setPid(f.getLayerPid() + ":" + gc.getId());
                        o.setId(f.getLayerPid() + ":" + gc.getId());
                        o.setBbox(gc.getBbox());
                        o.setArea_km(gc.getArea_km());
                        l.add(o);
                    } else { // if(f.getType().equals("b")) {//polygon pid
                        Grid g = new Grid(f.getFilePath() + File.separator + "polygons");
                        if (g != null) {
                            float[] vs = g.getValues(new double[][]{{lng, lat}});
                            String pid = f.getLayerPid() + ":" + gc.getId() + ":" + ((int) vs[0]);
                            l.add(getObjectByPid(pid));
                        }
                    }
                }
            }
        }
        if (l.size() > 0) {
            return l.get(0);
        } else {
            return null;
        }
    }

    @Override
    public List<Objects> getNearestObjectByIdAndLocation(String fid, int limit, Double lng, Double lat) {
        logger.info("Getting " + limit + " nearest objects in field fid = " + fid + " to loc: (" + lng + ", " + lat + ") ");

        String sql = "select fid, name, \"desc\", pid, id, ST_AsText(the_geom) as geometry, "
                + "st_Distance_Sphere(ST_SETSRID(ST_Point( ? , ? ),4326), the_geom) as distance, "
                + "degrees(Azimuth( ST_SETSRID(ST_Point( ? , ? ),4326), the_geom)) as degrees "
                + "from objects where fid= ? order by distance limit ? ";

        return jdbcTemplate.query(sql, ParameterizedBeanPropertyRowMapper.newInstance(Objects.class), lng, lat, lng, lat, fid, new Integer(limit));
    }

    @Override
    public List<Objects> getObjectByFidAndName(String fid, String name) {
        logger.info("Getting object info for fid = " + fid + " and name: (" + name + ") ");
        String sql = "select o.pid, o.id, o.name, o.desc as description, o.fid as fid, f.name as fieldname, o.bbox, o.area_km, ST_AsText(the_geom) as geometry from objects o, fields f where o.fid = ? and o.name like ? and o.fid = f.id";
        return jdbcTemplate.query(sql, ParameterizedBeanPropertyRowMapper.newInstance(Objects.class), new Object[]{fid, name});
    }

    private String getGridPolygonWms(String layername, int n) {
        return layerIntersectDao.getConfig().getGeoserverUrl() + gridPolygonWmsUrl.replace(SUB_LAYERNAME, layername)
                + formatSld(gridPolygonSld, layername, String.valueOf(n - 1), String.valueOf(n), String.valueOf(n), String.valueOf(n + 1));
    }

    private String getGridClassWms(String layername, GridClass gc) {
        return layerIntersectDao.getConfig().getGeoserverUrl() + gridPolygonWmsUrl.replace(SUB_LAYERNAME, layername)
                + formatSld(gridClassSld, layername, String.valueOf(gc.getMinShapeIdx() - 1), String.valueOf(gc.getMinShapeIdx()), String.valueOf(gc.getMaxShapeIdx()), String.valueOf(gc.getMaxShapeIdx() + 1));
    }

    private String formatSld(String sld, String layername, String min_minus_one, String min, String max, String max_plus_one) {
        return sld.replace(SUB_LAYERNAME, layername).replace(SUB_MIN_MINUS_ONE, min_minus_one).replace(SUB_MIN, min).replace(SUB_MAX, max).replace(SUB_MAX_PLUS_ONE, max_plus_one);
    }

    private void updateObjectWms(List<Objects> objects) {
        for (Objects o : objects) {
            o.setWmsurl(layerIntersectDao.getConfig().getGeoserverUrl() + objectWmsUrl + o.getPid());
        }
    }

    private HashMap<String, Object> getGridIndexEntry(String path, String objectId) {
        HashMap<String, Object> map = new HashMap<String, Object>();
        RandomAccessFile raf = null;
        try {
            raf = new RandomAccessFile(path + ".wkt.index.dat", "r");

            int s2 = Integer.parseInt(objectId);

            //it is all in order, seek to the record
            int recordSize = 4 * 7; //2 int + 5 float
            int start = raf.readInt();
            raf.seek(recordSize * (s2 - start));

            map.put("gn", raf.readInt());
            map.put("charoffset", raf.readInt());
            map.put("minx", raf.readFloat());
            map.put("miny", raf.readFloat());
            map.put("maxx", raf.readFloat());
            map.put("maxy", raf.readFloat());
            map.put("area", raf.readFloat());
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (raf != null) {
                    raf.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return map;
    }
}