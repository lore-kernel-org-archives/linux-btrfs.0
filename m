Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp145.dfw.emailsrvr.com ([67.192.241.145]:60996 "EHLO
        smtp145.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbdDCICE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Apr 2017 04:02:04 -0400
Subject: Re: Do different btrfs volumes compete for CPU?
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>, linux-btrfs@vger.kernel.org
References: <43a14754-1047-552e-78a9-6503dfc0d121@rqc.ru>
 <pan$8edd9$3260f40b$e8e8873f$59ccb7af@cox.net>
 <ef8ec943-6d26-d7e9-d4ac-05e2ce7a8532@rqc.ru>
 <22751.32343.177176.307907@tree.ty.sabi.co.uk>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <07258eab-5a2a-f028-48fb-60906b689cfa@rqc.ru>
Date: Mon, 3 Apr 2017 11:02:00 +0300
MIME-Version: 1.0
In-Reply-To: <22751.32343.177176.307907@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/04/17 13:17, Peter Grandi wrote:
> That "USB-connected is a rather bad idea. On the IRC channel
> #Btrfs whenever someone reports odd things happening I ask "is
> that USB?" and usually it is and then we say "good luck!" :-).
You're right, but USB/eSATA arrays are dirt cheap in comparison with 
similar-performance SAN/NAS etc. things, that we unfortunately cannot 
really afford here.

Just a bit of a back-story: I tried to use eSATA and ext4 first, but 
observed silent data corruption and irrecoverable kernel hangs -- 
apparently, SATA is not really designed for external use. That's when I 
switched to both USB and, coincidently, btrfs, and stability became 
orders of magnitude better even on re-purposed consumer-grade PC (Z77 
chipset, 3rd gen. i5) with horribly outdated kernel. Now I'm rebuilding 
same configuration on server-grade hardware (C610 chipset, 40 io-channel 
Xeon) and modern kernel, and thus would be very surprised to find 
problems in USB throughput.

> As written that question is meaningless: despite the current
> mania for "threads"/"threadlets" a filesystem driver is a
> library, not a set of processes (all those '[btrfs-*]'
> threadlets are somewhat misguided ways to do background
> stuff).
But these threadlets, misguided as the are, do exist, don't they?

> * Qgroups are famously system CPU intensive, even if less so
>    than in earlier releases, especially with subvolumes, so the
>    16 hours CPU is both absurd and expected. I think that qgroups
>    are still effectively unusable.
I understand that qgroups is very much work in progress, but (correct me 
if I'm wrong) right now it's the only way to estimate real usage of 
subvolume and its snapshots. For instance, if I have dozen 1TB 
subvolumes each having ~50 snapshots and suddenly run out of space on a 
24TB volume, how do I find the culprit without qgroups? Keeping eye on 
storage use is essential for any real life use of snapshots, and they 
are too convenient as backup de-duplication tool to give up.

Just a stray thought:  btrfs seem to lack object type in between of 
volume and subvolume, that would keep track of storage use by several 
subvolumes+their snapshots, allow snapshotting/transferring multiple 
subvolumes at once etc. Some kind of super-subvolume (supervolume?) that 
is hierarchical. With increasing use of subvolumes/snapshots within a 
single system installation, and multiple system installations (belonging 
to different users) in one volume due to liberal use of LXC and similar 
technologies this will become more and more of a pressing problem.

> * The scheduler gives excessive priority to kernel threads, so
>    they can crowd out user processes. When for whatever reason
>    the system CPU percentage rises everything else usually
>    suffers.
I thought it was clear, but probably needs spelling out: while 1 core 
was completely occupied with [btrfs-transacti] thread, 5 more were 
mostly idle serving occasional network requests without any problems. 
And only a process that used storage intensively died. Fortunately or 
not, it's the only data point so far -- smaller snapshot cullings do not 
cause problems.

> Only Intel/AMD USB chipsets and a few others are fairly
> reliable, and for mass storage only with USB3 with UASPI, which
> is basically SATA-over-USB (more precisely SCSI-command-set over
> USB). Your system-side card seems to be recent enough to do
> UASPI, but probably the peripheral-side chipset isn't. Things
> are so bad with third-party chipsets that even several types of
> add-on SATA and SAS cards are too buggy.
Thank you very much for this hint. The card is indeed unknown factor 
here and I'll keep a close eye on it. The chip is ASM1142, not Intel/AMD 
sadly but quite popular nevertheless.

--

With Best Regards,
Marat Khalili

