Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:39762 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754302AbeCHDb3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Mar 2018 22:31:29 -0500
Received: by mail-pg0-f66.google.com with SMTP id e3so1742586pga.6
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Mar 2018 19:31:29 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        corbet@lwn.net, gustavo@embeddedor.com, rostedt@goodmis.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Borislav Petkov <bp@suse.de>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>,
        "Tobin C. Harding" <me@tobin.cc>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        linux-btrfs@vger.kernel.org, netdev@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: [PATCH 0/3] Remove accidental VLA usage
Date: Wed,  7 Mar 2018 19:30:44 -0800
Message-Id: <1520479847-39174-1-git-send-email-keescook@chromium.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This series adds SIMPLE_MAX() to be used in places where a stack array
is actually fixed, but the compiler still warns about VLA usage due to
confusion caused by the safety checks in the max() macro.

I'm sending these via -mm since that's where I've introduced SIMPLE_MAX(),
and they should all have no operational differences.

-Kees

