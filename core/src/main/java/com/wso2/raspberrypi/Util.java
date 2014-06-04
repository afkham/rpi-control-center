/*
*  Copyright (c) 2005-2011, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
*
*  WSO2 Inc. licenses this file to you under the Apache License,
*  Version 2.0 (the "License"); you may not use this file except
*  in compliance with the License.
*  You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an
* "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
* KIND, either express or implied.  See the License for the
* specific language governing permissions and limitations
* under the License.
*/
package com.wso2.raspberrypi;

import org.apache.commons.dbcp.BasicDataSource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * TODO: class description
 */
public class Util {
    public static List<RaspberryPi> getRaspberryPis(String orderBy) {
        System.out.println("Listing registered Raspberry Pis...");

        if(orderBy == null){
            orderBy = "ip";
        }
        List<RaspberryPi> results = new ArrayList<RaspberryPi>();

        BasicDataSource ds = getBasicDataSource();

        Connection dbConnection = null;
        PreparedStatement prepStmt = null;
        ResultSet rs = null;
        try {
            dbConnection = ds.getConnection();
            prepStmt = dbConnection.prepareStatement("SELECT * FROM RASP_PI ORDER BY " + orderBy);
            rs = prepStmt.executeQuery();

            while (rs.next()) {
                RaspberryPi pi = toRaspberryPi(rs);
                results.add(pi);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (dbConnection != null) {
                    dbConnection.close();
                }
                if (prepStmt != null) {
                    prepStmt.close();
                }
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return results;
    }

    private static RaspberryPi toRaspberryPi(ResultSet rs) throws SQLException {
        RaspberryPi pi = new RaspberryPi();
        pi.setMacAddress(rs.getString("mac"));
        pi.setIpAddress(rs.getString("ip"));
        pi.setLastUpdated(rs.getLong("last_updated"));
        pi.setLabel(rs.getString("label"));
        pi.setReservedFor(rs.getString("owner"));
        pi.setBlink(rs.getBoolean("blink"));
        pi.setReboot(rs.getBoolean("reboot"));
        pi.setSelected(rs.getBoolean("selected"));
        pi.setZoneID(rs.getString("zone"));
        pi.setConsumerKey(rs.getString("consumer_key"));
        pi.setConsumerSecret(rs.getString("consumer_secret"));
        return pi;
    }

    public static RaspberryPi getRaspberryPi(String macAddress) {
        System.out.println("Listing Raspberry Pi with Mac Address: " + macAddress);
        RaspberryPi pi = null;

        BasicDataSource ds = getBasicDataSource();

        Connection dbConnection = null;
        PreparedStatement prepStmt = null;
        ResultSet rs = null;
        try {
            dbConnection = ds.getConnection();
            prepStmt = dbConnection.prepareStatement("SELECT * FROM RASP_PI WHERE mac='" + macAddress + "'");
            rs = prepStmt.executeQuery();

            while (rs.next()) {
                pi = toRaspberryPi(rs);
                break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (dbConnection != null) {
                    dbConnection.close();
                }
                if (prepStmt != null) {
                    prepStmt.close();
                }
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return pi;
    }

    public static void registerRaspberryPi(String macAddress, String ipAddress) {
        System.out.println("Registering Raspberry Pi: " + macAddress + "/" + ipAddress);
        BasicDataSource ds = getBasicDataSource();
        Connection dbConnection = null;
        PreparedStatement prepStmt = null;
        ResultSet rs = null;
        try {
            dbConnection = ds.getConnection();
            prepStmt =
                    dbConnection.prepareStatement("SELECT * FROM RASP_PI WHERE mac='" + macAddress + "'");
            rs = prepStmt.executeQuery();

            if (rs.next()) {   // If it exists
                prepStmt =
                        dbConnection.
                                prepareStatement("UPDATE RASP_PI SET ip='" + ipAddress + "',last_updated='" + System.currentTimeMillis() + "' WHERE mac='" + macAddress + "'");
                prepStmt.executeUpdate();
            } else {
                prepStmt =
                        dbConnection.
                                prepareStatement("INSERT INTO RASP_PI (mac,ip,last_updated) VALUES ('" + macAddress + "','" + ipAddress + "','" + System.currentTimeMillis() + "' )");
                prepStmt.execute();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (dbConnection != null) {
                    dbConnection.close();
                }
                if (prepStmt != null) {
                    prepStmt.close();
                }
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void clearAllRaspberryPis() throws RaspberryPiException {
        List<RaspberryPi> raspberryPis = getRaspberryPis(null);
        for (RaspberryPi raspberryPi : raspberryPis) {
            if (raspberryPi.getReservedFor() != null && !raspberryPi.getReservedFor().isEmpty()) {
                throw new RaspberryPiException("Cannot clear Raspberry Pis because some are reserved");
            }
        }
        System.out.println("Removing all Raspberry Pis...");
        BasicDataSource ds = getBasicDataSource();
        Connection dbConnection = null;
        PreparedStatement prepStmt = null;
        try {
            dbConnection = ds.getConnection();
            prepStmt =
                    dbConnection.prepareStatement("DELETE FROM RASP_PI");
            prepStmt.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (dbConnection != null) {
                    dbConnection.close();
                }
                if (prepStmt != null) {
                    prepStmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void reservePi(String owner, String macAddress) {
        System.out.println("Changing owner of RPi " + macAddress + " to " + owner);
        BasicDataSource ds = getBasicDataSource();
        Connection dbConnection = null;
        PreparedStatement prepStmt = null;
        ResultSet rs = null;
        try {
            dbConnection = ds.getConnection();
            prepStmt =
                    dbConnection.prepareStatement("SELECT * FROM RASP_PI where mac='" + macAddress + "'");
            rs = prepStmt.executeQuery();
            boolean alreadyOwned = false;
            while (rs.next()) {
                String oldOwner = rs.getString("owner");
                if (oldOwner != null && !oldOwner.isEmpty()) {
                    alreadyOwned = true;
                }
            }
            if (!alreadyOwned) {
                prepStmt =
                        dbConnection.prepareStatement("UPDATE RASP_PI SET owner='" + owner + "' where mac='" + macAddress + "'");
                prepStmt.execute();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (dbConnection != null) {
                    dbConnection.close();
                }
                if (prepStmt != null) {
                    prepStmt.close();
                }
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void releasePi(String macAddress) {
        System.out.println("Releasing RPi " + macAddress);
        BasicDataSource ds = getBasicDataSource();
        Connection dbConnection = null;
        PreparedStatement prepStmt = null;
        try {
            dbConnection = ds.getConnection();
            prepStmt =
                    dbConnection.prepareStatement("UPDATE RASP_PI SET owner='' where mac='" + macAddress + "'");
            prepStmt.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (dbConnection != null) {
                    dbConnection.close();
                }
                if (prepStmt != null) {
                    prepStmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static List<KVPair> getKeyValuePairs() {
        List<KVPair> results = new ArrayList<KVPair>();

        BasicDataSource ds = getBasicDataSource();

        Connection dbConnection = null;
        PreparedStatement prepStmt = null;
        ResultSet rs = null;
        try {
            dbConnection = ds.getConnection();
            prepStmt = dbConnection.prepareStatement("SELECT * FROM KV_PAIR ORDER BY k");
            rs = prepStmt.executeQuery();

            while (rs.next()) {
                results.add(new KVPair(rs.getString("k"), rs.getString("v")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (dbConnection != null) {
                    dbConnection.close();
                }
                if (prepStmt != null) {
                    prepStmt.close();
                }
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return results;
    }

    public static String getValue(String key) {
        String value = null;
        BasicDataSource ds = getBasicDataSource();

        Connection dbConnection = null;
        PreparedStatement prepStmt = null;
        ResultSet rs = null;
        try {
            dbConnection = ds.getConnection();
            prepStmt = dbConnection.prepareStatement("SELECT * FROM KV_PAIR WHERE k='" + key + "'");
            rs = prepStmt.executeQuery();

            while (rs.next()) {
                value = rs.getString("v");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (dbConnection != null) {
                    dbConnection.close();
                }
                if (prepStmt != null) {
                    prepStmt.close();
                }
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return value;
    }

    private static BasicDataSource getBasicDataSource() {
        BasicDataSource ds = new BasicDataSource();
        ds.setDriverClassName("com.mysql.jdbc.Driver");
        ds.setUrl("jdbc:mysql://localhost:3306/RPI_CONTROL_CENTER");
        ds.setUsername("admin");
        ds.setPassword("admin");
        ds.setValidationQuery("SELECT 1");
        return ds;
    }

    public static void updateKeyValuePair(String key, String value) {
        BasicDataSource ds = getBasicDataSource();
        Connection dbConnection = null;
        PreparedStatement prepStmt = null;
        try {
            dbConnection = ds.getConnection();
            prepStmt =
                    dbConnection.prepareStatement("UPDATE KV_PAIR SET v='" + value + "' where k='" + key + "'");
            prepStmt.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (dbConnection != null) {
                    dbConnection.close();
                }
                if (prepStmt != null) {
                    prepStmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void updateRaspberryPi(RaspberryPi raspberryPi) {
        BasicDataSource ds = getBasicDataSource();
        Connection dbConnection = null;
        PreparedStatement prepStmt = null;
        try {
            dbConnection = ds.getConnection();
            prepStmt =
                    dbConnection.prepareStatement("UPDATE RASP_PI SET blink=" + raspberryPi.isBlink() +
                                                  ",reboot=" + raspberryPi.isReboot() +
                                                  ",selected=" + raspberryPi.isSelected() +
                                                  ",label='" + raspberryPi.getLabel() +"'" +
                                                  ",consumer_key='" + raspberryPi.getConsumerKey() +"'" +
                                                  ",consumer_secret='" + raspberryPi.getConsumerSecret() +"'" +
                                                  ",zone='" + raspberryPi.getZoneID() +"'" +
                                                  " where mac='" + raspberryPi.getMacAddress() + "'");
            prepStmt.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (dbConnection != null) {
                    dbConnection.close();
                }
                if (prepStmt != null) {
                    prepStmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void deleteRaspberryPi(String mac) {
        System.out.println("Removing Raspberry Pi: " + mac);
        BasicDataSource ds = getBasicDataSource();
        Connection dbConnection = null;
        PreparedStatement prepStmt = null;
        try {
            dbConnection = ds.getConnection();
            prepStmt =
                    dbConnection.prepareStatement("DELETE FROM RASP_PI WHERE mac='" + mac + "'");
            prepStmt.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (dbConnection != null) {
                    dbConnection.close();
                }
                if (prepStmt != null) {
                    prepStmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static List<RaspberryPi> getSelectedPis() {
        List<RaspberryPi> results = new ArrayList<RaspberryPi>();

        BasicDataSource ds = getBasicDataSource();

        Connection dbConnection = null;
        PreparedStatement prepStmt = null;
        ResultSet rs = null;
        try {
            dbConnection = ds.getConnection();
            prepStmt = dbConnection.prepareStatement("SELECT * FROM RASP_PI WHERE selected=true");
            rs = prepStmt.executeQuery();

            while (rs.next()) {
                RaspberryPi pi = toRaspberryPi(rs);
                results.add(pi);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (dbConnection != null) {
                    dbConnection.close();
                }
                if (prepStmt != null) {
                    prepStmt.close();
                }
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return results;
    }
}
