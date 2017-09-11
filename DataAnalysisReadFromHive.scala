import org.apache.hadoop.hive.serde2.`lazy`.LazySimpleSerDe
import org.apache.spark.sql.SparkSession

object DataAnalysisReadFromHive {

  def main(args: Array[String]): Unit = {
    val sparkSession = SparkSession.builder()
      .master("local[2]")
      .appName("Data Analysis Read From Hive")
      .config("spark.sql.warehouse.dir", "/user/hive/warehouse")
      .config("hive.metastore.uris", "thrift://127.0.0.1:9083")
      .enableHiveSupport()
      .getOrCreate()

    //<<<<<<<<<----------------------- PROBLEM 1  ---------------------->>>>>>>>>>>>
    //Determine top 10 station_id(s) where maximum number of songs were played, which were liked by unique users.

    val set_properties = sparkSession.sqlContext.sql("set hive.auto.convert.join=false")

    val use_project_database = sparkSession.sqlContext.sql("USE project")

    sparkSession.sqlContext.sql("select station_id from top_10_stations").show()

    //<<<<<<<<<----------------------- PROBLEM 2  ---------------------->>>>>>>>>>>>
    /*Determine total duration of songs played by each type of user, where type of user can be 'subscribed' or 'unsubscribed'.
    An unsubscribed user is the one whose record is either not present in Subscribed_users lookup table or has subscription_end_date
    earlier than the timestamp of the song played by him.*/

    sparkSession.sqlContext.sql("select user_type,sum(total_duration_in_minutes) as total_song_duration from song_duration" +
      " where total_duration_in_minutes>=0" +
      " group by user_type").show()

    //<<<<<<<<<----------------------- PROBLEM 3  ---------------------->>>>>>>>>>>>
    //Determine top 10 connected artists.
    //Connected artists are those whose songs are most listened by the unique users who follow them.

    sparkSession.sqlContext.sql("select artist_id from connected_artists").show()

    //<<<<<<<<<----------------------- PROBLEM 4  ---------------------->>>>>>>>>>>>
    //Determine top 10 songs who have generated the maximum revenue.
    //NOTE: Royalty applies to a song only if it was liked or was completed successfully or both.

    sparkSession.sqlContext.sql("select song_id from top_10_songs_maxrevenue").show()

    //<<<<<<<<<----------------------- PROBLEM 5  ---------------------->>>>>>>>>>>>
    //Determine top 10 unsubscribed users who listened to the songs for the longest duration.

    sparkSession.sqlContext.sql("select user_id from top_10_unsubscribed_users").show()

  }
}
