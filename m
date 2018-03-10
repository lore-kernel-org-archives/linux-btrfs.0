Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33859 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932401AbeCJQam (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 11:30:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLtKAUsoYemHZTrJqKEH9=BqwO_QXk=x3BPfCKqZ6DRYA@mail.gmail.com>
References: <20180309200536.GA5670@beast> <20180309160719.154a3158e2d8ee56e43a918f@linux-foundation.org>
 <e8874944-f0b7-7a1f-26f3-446d7d7fcc38@infradead.org> <CANiq72k_vsTPMXvcfTNo+sjRoVMkihvRz-fzeXdcXvNEEeY-Pw@mail.gmail.com>
 <CAGXu5jLtKAUsoYemHZTrJqKEH9=BqwO_QXk=x3BPfCKqZ6DRYA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 10 Mar 2018 08:30:40 -0800
Message-ID: <CA+55aFyLicYSe+R4yQ2Eu+P9m6qsRfso-HiK78Sw+-dPuZvAYg@mail.gmail.com>
Subject: Re: [PATCH v3] kernel.h: Skip single-eval logic on literals in min()/max()
To: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
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
        Borislav Petkov <bp@suse.de>, Ian Abbott <abbotti@mev.co.uk>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 10, 2018 at 7:33 AM, Kees Cook <keescook@chromium.org> wrote:
>
> Alright, I'm giving up on fixing max(). I'll go back to STACK_MAX() or
> some other name for the simple macro. Bleh.

Oh, and I'm starting to see the real problem.

It's not that our current "min/max()" are broiken. It's that "-Wvla" is garbage.

Lookie here:

        int array[(1,2)];

results in gcc saying

     warning: ISO C90 forbids variable length array ‘array’ [-Wvla]
       int array[(1,2)];
       ^~~

and that error message - and the name of the flag - is obviously pure garbage.

What is *actually* going on is that ISO C90 requires an array size to
be not a constant value, but a constant *expression*. Those are two
different things.

A constant expression has little to do with "compile-time constant".
It's a more restricted form of it, and has actual syntax requirements.
A comma expression is not a constant expression, for example, which
was why I tested this.

So "-Wvla" is garbage, with a misleading name, and a misleading
warning string. It has nothing to do with "variable length" and
whether the compiler can figure it out at build time, and everything
to do with a _syntax_ rule.

                      Linus
