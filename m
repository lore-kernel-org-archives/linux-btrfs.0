Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:38424 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752832AbeAFSKj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Jan 2018 13:10:39 -0500
Received: by mail-ot0-f175.google.com with SMTP id h2so6365132oti.5
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Jan 2018 10:10:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$ef2b8$3487070c$fddf5d1f$59a5a7a2@cox.net>
References: <CAAMvbhEL4gw29ttxN9xbey3YFwUpmeYht2_m4rPFn9F3fn1rqQ@mail.gmail.com>
 <VI1PR08MB03368FD615EFAF0C3BB6195B92030@VI1PR08MB0336.eurprd08.prod.outlook.com>
 <CAAMvbhHV=BvRLv14U0JRrYmhiXeREOTNiVLPkuq=MO6dH4jDiQ@mail.gmail.com>
 <CAAMvbhG62rbphgWXQ_UiHHtH89wpsZXaLU0mut+4E+uuK2nbFw@mail.gmail.com> <pan$ef2b8$3487070c$fddf5d1f$59a5a7a2@cox.net>
From: James Courtier-Dutton <james.dutton@gmail.com>
Date: Sat, 6 Jan 2018 18:09:58 +0000
Message-ID: <CAAMvbhFUAQ7M2CET5gdmgGsF-FLZMYviSQusdB8s1ObdXZwzDg@mail.gmail.com>
Subject: Re: btrfs balance problems
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28 December 2017 at 00:39, Duncan <1i5t5.duncan@cox.net> wrote:
>
> AFAIK, ionice only works for some IO schedulers, not all.  It does work
> with the default CFQ scheduler, but I don't /believe/ it works with
> deadline, certainly not with noop, and I'd /guess/ it doesn't work with
> block-multiqueue (and thus not with bfq or kyber) at all, tho it's
> possible it does in the latest kernels, since multi-queue is targeted to
> eventually replace, at least as default, the older single-queue options.
>
> So which scheduler are you using and are you on multi-queue or not?
>

Thank you. The install had defaulted to deadline.
I have now switched it to CFQ, and the system is much more
responsive/interactive now during a btrfs balance.

I will test it when I next get a chance, to see if that has helped me.
After reading about it:
deadline:  more likely to complete long sequential reads/writes and
not switch tasks.Thus reducing the amount of seeking but impacting
concurrent tasks.
cfq: more likely to break up long sequential reads/writes to permit
other tasks to do some work. Thus increasing the amount of seeking but
helping concurrent tasks.

This would explain why "cfq" is best for me.
I have not yet looked at "multi-queue".
