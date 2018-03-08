Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:38184 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbeCHWuB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 17:50:01 -0500
Received: by mail-vk0-f67.google.com with SMTP id s1so975464vke.5
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Mar 2018 14:50:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180308141833.3fb57913bceae38f18db2bf1@linux-foundation.org>
References: <20180308214045.GA6787@beast> <20180308141833.3fb57913bceae38f18db2bf1@linux-foundation.org>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 8 Mar 2018 14:49:59 -0800
Message-ID: <CAGXu5j+6rPgn1biniy6Xju5w7=n9ogiOZvHs_kvT55LT9u9y2Q@mail.gmail.com>
Subject: Re: [PATCH] kernel.h: Skip single-eval logic on literals in min()/max()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
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
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 8, 2018 at 2:18 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 8 Mar 2018 13:40:45 -0800 Kees Cook <keescook@chromium.org> wrote:
>
>> When max() is used in stack array size calculations from literal values
>> (e.g. "char foo[max(sizeof(struct1), sizeof(struct2))]", the compiler
>> thinks this is a dynamic calculation due to the single-eval logic, which
>> is not needed in the literal case. This change removes several accidental
>> stack VLAs from an x86 allmodconfig build:
>>
>> $ diff -u before.txt after.txt | grep ^-
>> -drivers/input/touchscreen/cyttsp4_core.c:871:2: warning: ISO C90 forbids variable length array ‘ids’ [-Wvla]
>> -fs/btrfs/tree-checker.c:344:4: warning: ISO C90 forbids variable length array ‘namebuf’ [-Wvla]
>> -lib/vsprintf.c:747:2: warning: ISO C90 forbids variable length array ‘sym’ [-Wvla]
>> -net/ipv4/proc.c:403:2: warning: ISO C90 forbids variable length array ‘buff’ [-Wvla]
>> -net/ipv6/proc.c:198:2: warning: ISO C90 forbids variable length array ‘buff’ [-Wvla]
>> -net/ipv6/proc.c:218:2: warning: ISO C90 forbids variable length array ‘buff64’ [-Wvla]
>>
>> Based on an earlier patch from Josh Poimboeuf.
>>
>> ...
>>
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -787,37 +787,57 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
>>   * strict type-checking.. See the
>>   * "unnecessary" pointer comparison.
>>   */
>> -#define __min(t1, t2, min1, min2, x, y) ({           \
>> +#define __single_eval_min(t1, t2, min1, min2, x, y) ({       \
>>       t1 min1 = (x);                                  \
>>       t2 min2 = (y);                                  \
>>       (void) (&min1 == &min2);                        \
>>       min1 < min2 ? min1 : min2; })
>>
>> +/*
>> + * In the case of builtin constant values, there is no need to do the
>> + * double-evaluation protection, so the raw comparison can be made.
>> + * This allows min()/max() to be used in stack array allocations and
>> + * avoid the compiler thinking it is a dynamic value leading to an
>> + * accidental VLA.
>> + */
>> +#define __min(t1, t2, x, y)                                          \
>> +     __builtin_choose_expr(__builtin_constant_p(x) &&                \
>> +                           __builtin_constant_p(y) &&                \
>> +                           __builtin_types_compatible_p(t1, t2),     \
>> +                           (t1)(x) < (t2)(y) ? (t1)(x) : (t2)(y),    \
>> +                           __single_eval_min(t1, t2,                 \
>> +                                             __UNIQUE_ID(max1_),     \
>> +                                             __UNIQUE_ID(max2_),     \
>> +                                             x, y))
>> +
>
> Holy crap.
>
> I suppose gcc will one day be fixed and we won't need this.
>
> Is there a good reason to convert min()?  Surely nobody will be using
> min to dimension an array - always max?  Just for symmetry, I guess.

I just went with symmetry. It seems like an ugly risk to implement min
and mix differently. :) In theory it may produce smaller code for rare
min() uses, but I haven't actually verified that.

I will send a v2 with the two nits mentioned...

-Kees

-- 
Kees Cook
Pixel Security
