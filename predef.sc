import $ivy.`org.typelevel::cats-core:2.6.1`, cats._, cats.implicits._
import $ivy.`org.scalatest::scalatest:3.0.8`,org.scalatest._
import $ivy.`org.scalacheck::scalacheck:1.14.0`
import $ivy.`dev.zio::zio:1.0.0-RC15`
import $ivy.`org.typelevel::cats-effect:2.1.0`
import $ivy.`co.fs2::fs2-core:2.2.0`

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration._
import cats.effect.IO
import java.time.Instant.now
implicit val timer = IO.timer(global)

