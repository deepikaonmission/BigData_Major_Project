name := "MusicDataAnalysisProject"

version := "1.0"

scalaVersion := "2.11.8"

val sparkVersion = "2.0.0"

//Override Scala Version to the above 2.11.8 version
//ivyScala := ivyScala.value map { _.copy(overrideScalaVersion = true) }

resolvers ++= Seq(
  "apache-snapshots" at "https://repository.apache.org/snapshots/"
)


libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" %sparkVersion,
  "org.apache.spark" %% "spark-sql" %sparkVersion,
  "org.apache.spark" %% "spark-mllib" %sparkVersion,
  "org.apache.spark" %% "spark-streaming" %sparkVersion,
  "org.apache.spark" %% "spark-hive" %sparkVersion,
  "com.crealytics" % "spark-excel_2.10" % "0.8.3",
  "org.scalatest" %% "scalatest" % "2.2.4" %"test"
)
        