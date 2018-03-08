Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from benson.default.arb33.uk0.bigv.io ([46.43.0.16]:42259 "EHLO
        benson.default.arb33.uk0.bigv.io" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750883AbeCHWRn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 17:17:43 -0500
Message-ID: <1520546351.23648.32.camel@hellion.org.uk>
Subject: Re: [PATCH] kernel.h: Skip single-eval logic on literals in
 min()/max()
From: Ian Campbell <ijc@hellion.org.uk>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Tobin C. Harding" <me@tobin.cc>, rostedt@goodmis.org, corbet@lwn.net,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        linux-btrfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Date: Thu, 08 Mar 2018 21:59:11 +0000
In-Reply-To: <20180308214045.GA6787@beast>
References: <20180308214045.GA6787@beast>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2018-03-08 at 13:40 -0800, Kees Cook wrote:
> 
> +#define __min(t1, t2, x, y)						\
> +	__builtin_choose_expr(__builtin_constant_p(x) &&		\
> +			      __builtin_constant_p(y) &&		\
> +			      __builtin_types_compatible_p(t1, t2),	\
> +			      (t1)(x) < (t2)(y) ? (t1)(x) : (t2)(y),	\
> +			      __single_eval_min(t1, t2,			\
> +						__UNIQUE_ID(max1_),	\
> +						__UNIQUE_ID(max2_),	\

min1_ etc?

Ian.
