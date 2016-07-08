Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33944 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbcGHLOR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 07:14:17 -0400
Received: by mail-lf0-f66.google.com with SMTP id a10so4086330lfb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 04:14:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <577F3107.6040806@gmail.com>
References: <577D82AE.3040005@gmail.com> <03E1A820-7029-4022-9D46-900C4FCA1ADC@gmail.com>
 <7d6827bd-a978-13ab-6732-b7cf7d21bdb8@gmail.com> <577F3107.6040806@gmail.com>
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Date: Fri, 8 Jul 2016 12:14:14 +0100
Message-ID: <CAKinxcWScz6Azu=RDQPcnj4zr0jjyZ62QEQT18O7mOKz-E+jfQ@mail.gmail.com>
Subject: Re: raid1 has failing disks, but smart is clear
To: Corey Coughlin <corey.coughlin.cc3@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> Well, I was able to run memtest on the system last night, that passed with
> flying colors, so I'm now leaning toward the problem being in the sas card.
> But I'll have to run some more tests.
>

Seriously use the "stres.sh" for couple of days, When I was running
memtest it was running continuously for 3 days without the error, day
of stres.sh and errors started showing up.
Be VERY careful with trusting any sort of that tool, modern CPU's lye
to you continuously !!!
1. You may think that you've wrote best on the planet code that
bypasses a CPU cache, but in reality since CPU's are multicore you can
end up with overzealous MPMD traping you inside of you cache memory
and all you resting will do is write a page (trapped in cache) read it
from cache (coherency mechanism, not the mis/hit one) will trap you
inside of L3 so you have no clue you don't touch the ram, then CPU
will just dump your page to RAM and "job done"
2. Since coherency problems and real problems with non blocking on
mpmd you can have a DMA controller sucking pages out your own cache,
due to ram being marked as dirty and CPU will try to spare the time
and accelerate the operation to push DMA straigh out of L3 to
somewhere else (mentioning that sine some testers use crazy way of
forcing your ram access via DMA to somewhere and back to force droping
out of L3)
3. This one is actually funny: some testers didn't claim the pages to
the process so for some reason pages that the were using were not
showing up as used / dirty etc so all the testing was done 32kB of L1
... tests were fast thou :)

srters.sh will test operation of the whole system !!! it shifts a lot
of data so disks are engaged, CPU keeps pumping out CRC32 all the time
so it's busy, RAM gets hit nicely as well due to high DMA.

When come to think about it, if your device points change during
operation of the system it might be an LSI card dying -> reinitialize
-> rediscovering drives -> drives show up in different point. On my
system I can hot swap sata and it will come up with different dev even
thou it was connected to same place on the controller.

I think, most important - I presume you run nonECC ?
