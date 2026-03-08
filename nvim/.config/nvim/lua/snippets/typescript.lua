-- NestJS snippets for TypeScript files
-- Place: lua/snippets/typescript.lua
-- Trigger these by typing the prefix and pressing Tab

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    -- =========================================================================
    -- NestJS Core
    -- =========================================================================

    -- Controller
    s("ncon", fmt([[
import {{ Controller, Get, Post, Put, Delete, Body, Param, HttpCode, HttpStatus }} from '@nestjs/common';
import {{ {} }} from './{}.service';

@Controller('{}')
export class {}Controller {{
    constructor(private readonly {}Service: {}Service) {{}}

    @Get()
    findAll() {{
        return this.{}Service.findAll();
    }}

    @Get(':id')
    findOne(@Param('id') id: string) {{
        return this.{}Service.findOne(+id);
    }}

    @Post()
    @HttpCode(HttpStatus.CREATED)
    create(@Body() createDto: {}) {{
        return this.{}Service.create(createDto);
    }}

    @Put(':id')
    update(@Param('id') id: string, @Body() updateDto: {}) {{
        return this.{}Service.update(+id, updateDto);
    }}

    @Delete(':id')
    @HttpCode(HttpStatus.NO_CONTENT)
    remove(@Param('id') id: string) {{
        return this.{}Service.remove(+id);
    }}
}}
]], {
        i(1, "ResourceService"), i(2, "resource"), i(3, "resource"),
        i(4, "Resource"), i(5, "resource"), i(6, "Resource"),
        i(7, "resource"), i(8, "resource"),
        i(9, "CreateResourceDto"),  i(10, "resource"),
        i(11, "UpdateResourceDto"), i(12, "resource"),
        i(13, "resource"),
    })),

    -- Injectable Service
    s("nsvc", fmt([[
import {{ Injectable, NotFoundException }} from '@nestjs/common';

@Injectable()
export class {}Service {{
    private {}s = [];

    findAll() {{
        return this.{}s;
    }}

    findOne(id: number) {{
        const item = this.{}s.find(item => item.id === id);
        if (!item) throw new NotFoundException(`{} #${{id}} not found`);
        return item;
    }}

    create(createDto: {}) {{
        {}
    }}

    update(id: number, updateDto: {}) {{
        {}
    }}

    remove(id: number) {{
        {}
    }}
}}
]], {
        i(1, "Resource"), i(2, "resource"),
        i(3, "resource"), i(4, "resource"), i(5, "Resource"),
        i(6, "CreateDto"), i(7, "// TODO: implement"),
        i(8, "UpdateDto"), i(9, "// TODO: implement"),
        i(10, "// TODO: implement"),
    })),

    -- Module
    s("nmod", fmt([[
import {{ Module }} from '@nestjs/common';
import {{ {}Controller }} from './{}.controller';
import {{ {}Service }} from './{}.service';

@Module({{
    controllers: [{}Controller],
    providers: [{}Service],
    exports: [{}Service],
}})
export class {}Module {{}}
]], {
        i(1, "Resource"), i(2, "resource"),
        i(3, "Resource"), i(4, "resource"),
        i(5, "Resource"), i(6, "Resource"), i(7, "Resource"),
        i(8, "Resource"),
    })),

    -- DTO with class-validator
    s("ndto", fmt([[
import {{ IsString, IsNumber, IsOptional, IsNotEmpty }} from 'class-validator';
import {{ ApiProperty }} from '@nestjs/swagger';

export class {}Dto {{
    @ApiProperty()
    @IsNotEmpty()
    @IsString()
    {}: string;

    {}
}}
]], {
        i(1, "Create"), i(2, "name"), i(3, ""),
    })),

    -- Guard
    s("nguard", fmt([[
import {{ Injectable, CanActivate, ExecutionContext }} from '@nestjs/common';
import {{ Observable }} from 'rxjs';

@Injectable()
export class {}Guard implements CanActivate {{
    canActivate(context: ExecutionContext): boolean | Promise<boolean> | Observable<boolean> {{
        {}
        return true;
    }}
}}
]], { i(1, "Auth"), i(2, "// TODO: implement guard logic") })),

    -- Interceptor
    s("ninter", fmt([[
import {{ Injectable, NestInterceptor, ExecutionContext, CallHandler }} from '@nestjs/common';
import {{ Observable }} from 'rxjs';
import {{ tap }} from 'rxjs/operators';

@Injectable()
export class {}Interceptor implements NestInterceptor {{
    intercept(context: ExecutionContext, next: CallHandler): Observable<any> {{
        {}
        return next.handle().pipe(tap(() => {}));
    }}
}}
]], { i(1, "Logging"), i(2, "// before"), i(3, "// after") })),

    -- Custom Decorator
    s("ndec", fmt([[
import {{ createParamDecorator, ExecutionContext }} from '@nestjs/common';

export const {} = createParamDecorator(
    (data: unknown, ctx: ExecutionContext) => {{
        const request = ctx.switchToHttp().getRequest();
        return {};
    }},
);
]], { i(1, "CurrentUser"), i(2, "request.user") })),

    -- Exception Filter
    s("nfilter", fmt([[
import {{ ExceptionFilter, Catch, ArgumentsHost, HttpException }} from '@nestjs/common';
import {{ Request, Response }} from 'express';

@Catch({})
export class {}Filter implements ExceptionFilter {{
    catch(exception: {}, host: ArgumentsHost) {{
        const ctx = host.switchToHttp();
        const response = ctx.getResponse<Response>();
        const request = ctx.getRequest<Request>();
        const status = exception instanceof HttpException ? exception.getStatus() : 500;

        response.status(status).json({{
            statusCode: status,
            timestamp: new Date().toISOString(),
            path: request.url,
        }});
    }}
}}
]], { i(1, "HttpException"), i(2, "Http"), i(3, "HttpException") })),

    -- =========================================================================
    -- TypeScript General
    -- =========================================================================

    -- interface
    s("iface", fmt([[
export interface {} {{
    {}
}}
]], { i(1, "MyInterface"), i(2, "") })),

    -- type alias
    s("ttype", fmt([[
export type {} = {}
]], { i(1, "MyType"), i(2, "string | number") })),

    -- async function
    s("afn", fmt([[
async function {}({}): Promise<{}> {{
    {}
}}
]], { i(1, "myFunction"), i(2, ""), i(3, "void"), i(4, "") })),

    -- arrow function
    s("fn", fmt([[
const {} = ({}) => {{
    {}
}}
]], { i(1, "myFn"), i(2, ""), i(3, "") })),

    -- try-catch
    s("tc", fmt([[
try {{
    {}
}} catch (error) {{
    {}
}}
]], { i(1, ""), i(2, "console.error(error)") })),

    -- console.log with label
    s("cl", fmt([[console.log('{}:', {});]], { i(1, "debug"), i(2, "value") })),
}
