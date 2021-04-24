package davetcode

import io.ktor.application.*
import io.ktor.response.*
import io.ktor.request.*
import io.ktor.routing.*
import io.ktor.http.*
import io.ktor.gson.*
import io.ktor.features.*

data class CpuFlags(var sign: Boolean = false, var zero: Boolean = false, var auxCarry: Boolean = false, var parity: Boolean = false, var carry: Boolean = false);

data class CpuState(var a: Int, var b: Int, var c: Int, var d: Int, var e: Int, var h: Int, var l: Int, var stackPointer: Int, var programCounter: Int, var cycles: Long, var flags: CpuFlags);

data class Cpu(var opcode: Int, var id: String, var state: CpuState);

fun main(args: Array<String>): Unit = io.ktor.server.netty.EngineMain.main(args)

@Suppress("unused") // Referenced in application.conf
@kotlin.jvm.JvmOverloads
fun Application.module(testing: Boolean = false) {
    install(ContentNegotiation) {
        gson {
        }
    }

    routing {
        post("/api/v1/execute") {
            val cpu = call.receive<Cpu>();
            cpu.state.programCounter = ((cpu.state.h shl 8) and 0xFFFF) or cpu.state.l;
            cpu.state.cycles += 5;
            call.respond(cpu);
        }

        get("/status") {
            call.respond("Healthy");
        }
    }
}

