Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:33975 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751313AbeCIApF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 19:45:05 -0500
Received: by mail-ua0-f195.google.com with SMTP id m43so1192126uah.1
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Mar 2018 16:45:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+55aFyf-ajRzW2sUwFrrMOAu5UyuOk5L8g9xfkr4VuJeWjV9w@mail.gmail.com>
References: <20180308214045.GA6787@beast> <CA+55aFyf-ajRzW2sUwFrrMOAu5UyuOk5L8g9xfkr4VuJeWjV9w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 8 Mar 2018 16:45:03 -0800
Message-ID: <CAGXu5j+JiYcsdaC4V9+SmUM2SKW1yRHr18d74G5SM_sSrQm=Nw@mail.gmail.com>
Subject: Re: [PATCH] kernel.h: Skip single-eval logic on literals in min()/max()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>,
        Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
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
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 8, 2018 at 3:48 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Mar 8, 2018 at 1:40 PM, Kees Cook <keescook@chromium.org> wrote:
>> +#define __min(t1, t2, x, y)                                            \
>> +       __builtin_choose_expr(__builtin_constant_p(x) &&                \
>> +                             __builtin_constant_p(y) &&                \
>> +                             __builtin_types_compatible_p(t1, t2),     \
>> +                             (t1)(x) < (t2)(y) ? (t1)(x) : (t2)(y),    \
>
> I understand why you use __builtin_types_compatible_p(), but please don't.
>
> It will mean that trivial constants like "5" and "sizeof(x)" won't
> simplify, because they have different types.

Rasmus mentioned this too. What I said there was that I was shy to
make that change, since we already can't mix that kind of thing with
the existing min()/max() implementation. The existing min()/max() is
already extremely strict, so there are no instances of this in the
tree. If I explicitly add one, I see this with or without the patch:

In file included from drivers/misc/lkdtm.h:7:0,
                 from drivers/misc/lkdtm_core.c:33:
drivers/misc/lkdtm_core.c: In function ‘lkdtm_module_exit’:
./include/linux/kernel.h:809:16: warning: comparison of distinct
pointer types lacks a cast
  (void) (&max1 == &max2);   \
                ^
./include/linux/kernel.h:818:2: note: in expansion of macro ‘__max’
  __max(typeof(x), typeof(y),   \
  ^~~~~
./include/linux/printk.h:308:34: note: in expansion of macro ‘max’
  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
                                  ^~~~~~~~~~~
drivers/misc/lkdtm_core.c:500:2: note: in expansion of macro ‘pr_info’
  pr_info("%lu\n", max(16, sizeof(unsigned long)));
  ^~~~~~~

> The ?: will give the right combined type anyway, and if you want the
> type comparison warning, just add a comma-expression with something
> like like
>
>    (t1 *)1 == (t2 *)1
>
> to get the type compatibility warning.

When I tried removing __builtin_types_compatible_p(), I still got the
type-check warning because I think the preprocessor still sees the
"(void) (&min1 == &min2)" before optimizing? So, I technically _can_
drop the __builtin_types_compatible_p(), and still keep the type
warning. :P

> Yeah, yeah, maybe none of the VLA cases triggered that, but it seems
> silly to not just get that obvious constant case right.
>
> Hmm?

So are you saying you _want_ the type enforcement weakened here, or
that I should just not use __builtin_types_compatible_p()?

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
