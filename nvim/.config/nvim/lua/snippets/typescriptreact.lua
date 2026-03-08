-- Next.js / React snippets for TSX/JSX files
-- Place: lua/snippets/typescriptreact.lua

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    -- =========================================================================
    -- Next.js App Router
    -- =========================================================================

    -- Page component (App Router)
    s("nxpage", fmt([[
import type {{ Metadata }} from 'next';

export const metadata: Metadata = {{
    title: '{}',
    description: '{}',
}};

export default function {}Page() {{
    return (
        <main>
            <h1>{}</h1>
            {}
        </main>
    );
}}
]], { i(1, "Page Title"), i(2, "Page description"), i(3, "Home"), i(4, "Welcome"), i(5, "") })),

    -- Layout component (App Router)
    s("nxlayout", fmt([[
export default function {}Layout({{
    children,
}}: {{
    children: React.ReactNode;
}}) {{
    return (
        <>
            {}
            {{children}}
        </>
    );
}}
]], { i(1, "Root"), i(2, "") })),

    -- Server Component (default in App Router)
    s("nxsc", fmt([[
interface {}Props {{
    {}
}}

export default async function {}({{ {} }}: {}Props) {{
    {}

    return (
        <div>
            {}
        </div>
    );
}}
]], { i(1, "MyComponent"), i(2, ""), i(3, "MyComponent"), i(4, ""), i(5, "MyComponent"), i(6, ""), i(7, "") })),

    -- Client Component
    s("nxcc", fmt([[
'use client';

import {{ useState }} from 'react';

interface {}Props {{
    {}
}}

export default function {}({{ {} }}: {}Props) {{
    const [state, setState] = useState({});

    return (
        <div>
            {}
        </div>
    );
}}
]], { i(1, "MyComponent"), i(2, ""), i(3, "MyComponent"), i(4, ""), i(5, "MyComponent"), i(6, "null"), i(7, "") })),

    -- API Route Handler (App Router)
    s("nxapi", fmt([[
import {{ NextResponse }} from 'next/server';
import type {{ NextRequest }} from 'next/server';

export async function GET(request: NextRequest) {{
    {}
    return NextResponse.json({{ {} }});
}}

export async function POST(request: NextRequest) {{
    const body = await request.json();
    {}
    return NextResponse.json({{ {} }}, {{ status: 201 }});
}}
]], { i(1, ""), i(2, "data: []"), i(3, ""), i(4, "data: body") })),

    -- Server Action
    s("nxaction", fmt([[
'use server';

export async function {}(formData: FormData) {{
    {}
}}
]], { i(1, "myAction"), i(2, "// perform server action") })),

    -- getServerSideProps (Pages Router)
    s("nxgssp", fmt([[
export async function getServerSideProps(context) {{
    const {{ params }} = context;
    {}

    return {{
        props: {{
            {}
        }},
    }};
}}
]], { i(1, ""), i(2, "") })),

    -- getStaticProps (Pages Router)
    s("nxgsp", fmt([[
export async function getStaticProps() {{
    {}

    return {{
        props: {{
            {}
        }},
        revalidate: {},
    }};
}}
]], { i(1, ""), i(2, ""), i(3, "60") })),

    -- useRouter hook with navigation
    s("nxrouter", fmt([[
import {{ useRouter }} from 'next/navigation';

const router = useRouter();
router.push('{}');
]], { i(1, "/") })),

    -- Link component
    s("nxlink", fmt([[
import Link from 'next/link';

<Link href="{}">{}</Link>
]], { i(1, "/"), i(2, "Click here") })),

    -- Image component
    s("nximage", fmt([[
import Image from 'next/image';

<Image
    src="{}"
    alt="{}"
    width={{{}}}
    height={{{}}}
/>
]], { i(1, "/image.png"), i(2, "Description"), i(3, "500"), i(4, "300") })),

    -- =========================================================================
    -- React General
    -- =========================================================================

    -- Functional Component
    s("rfc", fmt([[
interface {}Props {{
    {}
}}

export function {}({{ {} }}: {}Props) {{
    return (
        <div>
            {}
        </div>
    );
}}
]], { i(1, "MyComponent"), i(2, ""), i(3, "MyComponent"), i(4, ""), i(5, "MyComponent"), i(6, "") })),

    -- useState
    s("ust", fmt([[
const [{}, set{}] = useState<{}>({});
]], { i(1, "value"), i(2, "Value"), i(3, "string"), i(4, "''") })),

    -- useEffect
    s("uef", fmt([[
useEffect(() => {{
    {}
    return () => {{
        {}
    }};
}}, [{}]);
]], { i(1, "// effect"), i(2, "// cleanup"), i(3, "") })),

    -- useCallback
    s("ucb", fmt([[
const {} = useCallback(() => {{
    {}
}}, [{}]);
]], { i(1, "myCallback"), i(2, ""), i(3, "") })),

    -- useMemo
    s("umemo", fmt([[
const {} = useMemo(() => {{
    return {};
}}, [{}]);
]], { i(1, "memoValue"), i(2, ""), i(3, "") })),

    -- Custom hook
    s("hook", fmt([[
import {{ useState, useEffect }} from 'react';

export function use{}({}) {{
    const [state, setState] = useState({});

    useEffect(() => {{
        {}
    }}, []);

    return {{ state }};
}}
]], { i(1, "MyHook"), i(2, ""), i(3, "null"), i(4, "") })),
}
