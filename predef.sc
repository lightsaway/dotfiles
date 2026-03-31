// =============================================================================
// Ammonite Predef - Scala REPL Configuration
// =============================================================================

// --- Dependencies ---
import $ivy.`org.typelevel::cats-core:2.12.0`
import $ivy.`org.typelevel::cats-effect:3.5.7`
import $ivy.`co.fs2::fs2-core:3.11.0`
import $ivy.`co.fs2::fs2-io:3.11.0`
import $ivy.`io.circe::circe-core:0.14.10`
import $ivy.`io.circe::circe-generic:0.14.10`
import $ivy.`io.circe::circe-parser:0.14.10`
import $ivy.`com.lihaoyi::requests:0.9.0`
import $ivy.`com.lihaoyi::os-lib:0.11.3`
import $ivy.`com.lihaoyi::upickle:4.0.2`
import $ivy.`com.lihaoyi::pprint:0.9.0`

// Uncomment as needed:
// import $ivy.`org.scalatest::scalatest:3.2.19`
// import $ivy.`org.scalacheck::scalacheck:1.18.1`
// import $ivy.`dev.zio::zio:2.1.14`
// import $ivy.`com.softwaremill.sttp.client3::core:3.10.2`
// import $ivy.`org.http4s::http4s-ember-client:0.23.30`
// import $ivy.`org.http4s::http4s-circe:0.23.30`
// import $ivy.`org.http4s::http4s-dsl:0.23.30`

// --- Cats ---
import cats._
import cats.data._
import cats.implicits._
import cats.syntax.all._

// --- Cats Effect ---
import cats.effect.{IO, Resource, Ref, Deferred, Fiber}
import cats.effect.std.{Queue, Semaphore, Console}
import cats.effect.unsafe.implicits.global

// --- FS2 ---
import fs2.{Stream, Pipe, Chunk}
import fs2.io.file.{Files, Path}

// --- Circe (JSON) ---
import io.circe._
import io.circe.syntax._
import io.circe.parser.{decode, parse}
import io.circe.generic.auto._

// --- HTTP (li haoyi requests - simple & sync) ---
// Usage: requests.get("https://api.github.com/users/atoshi")
// Usage: requests.post("https://...", data = ujson.Obj("key" -> "value"))

// --- OS-Lib (file system) ---
// Usage: os.list(os.pwd), os.read(os.pwd / "file.txt"), os.write(os.pwd / "out.txt", "content")

// --- Pretty printing ---
// Usage: pprint.pprintln(myObject)

// --- Scala stdlib ---
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration._
import scala.concurrent.Future
import scala.util.{Try, Success, Failure}
import scala.util.matching.Regex
import scala.collection.immutable.{SortedMap, SortedSet}
import scala.collection.mutable.{Buffer, ArrayBuffer, ListBuffer}

// --- Java Time ---
import java.time._
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit
import java.util.concurrent.TimeUnit

// --- Java Common ---
import java.util.{UUID, Base64, Optional}
import java.nio.file.{Paths, Path => JPath, Files => JFiles}
import java.nio.charset.StandardCharsets
import java.net.{URL, URI, URLEncoder, URLDecoder}
import java.io.{File, InputStream, OutputStream}

// --- Converters ---
import scala.jdk.CollectionConverters._
import scala.jdk.OptionConverters._

// --- Helpers ---

/** Run an IO and get the result */
def run[A](io: IO[A]): A = io.unsafeRunSync()

/** Run an FS2 Stream and collect results */
def runS[A](s: Stream[IO, A]): List[A] = s.compile.toList.unsafeRunSync()

/** Time a block of code */
def timed[A](label: String)(block: => A): A = {
  val start = System.nanoTime()
  val result = block
  val elapsed = (System.nanoTime() - start) / 1e6
  println(f"[$label] ${elapsed}%.1f ms")
  result
}

/** Pretty print JSON string */
def ppJson(s: String): Unit =
  parse(s).fold(
    err => println(s"Parse error: $err"),
    json => println(json.spaces2)
  )

// Welcome
println("Ammonite REPL ready — cats, cats-effect, fs2, circe, requests, os-lib loaded")
