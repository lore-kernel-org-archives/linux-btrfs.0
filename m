Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52557 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbbJaLKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Oct 2015 07:10:40 -0400
Received: from merkaba.localnet (ppp-62-216-209-156.dynamic.mnet-online.de [62.216.209.156])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 819DB202
	for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2015 12:10:38 +0100 (CET)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.3-rc4] scrubbing aborts before finishing
Date: Sat, 31 Oct 2015 12:10:37 +0100
Message-ID: <1475910.a5YfPuWqAN@merkaba>
In-Reply-To: <16063727.bYixifcRQC@merkaba>
References: <16063727.bYixifcRQC@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 22. Oktober 2015, 10:41:15 CET schrieb Martin Steigerwald:
> I get this:
> 
> merkaba:~> btrfs scrub status -d /       
> scrub status for […]
> scrub device /dev/mapper/sata-debian (id 1) history
>         scrub started at Thu Oct 22 10:05:49 2015 and was aborted after 00:00:00
>         total bytes scrubbed: 0.00B with 0 errors
> scrub device /dev/dm-2 (id 2) history
>         scrub started at Thu Oct 22 10:05:49 2015 and was aborted after 00:01:30
>         total bytes scrubbed: 23.81GiB with 0 errors
> 
> For / scrub aborts for sata SSD immediately.
> 
> For /home scrub aborts for both SSDs at some time.
> 
> merkaba:~> btrfs scrub status -d /home
> scrub status for […]
> scrub device /dev/mapper/msata-home (id 1) history
>         scrub started at Thu Oct 22 10:09:37 2015 and was aborted after 00:01:31
>         total bytes scrubbed: 22.03GiB with 0 errors
> scrub device /dev/dm-3 (id 2) history
>         scrub started at Thu Oct 22 10:09:37 2015 and was aborted after 00:03:34
>         total bytes scrubbed: 53.30GiB with 0 errors
> 
> Also single volume BTRFS is affected:
> 
> merkaba:~> btrfs scrub status /daten
> scrub status for […]
>         scrub started at Thu Oct 22 10:36:38 2015 and was aborted after 00:00:00
>         total bytes scrubbed: 0.00B with 0 errors
> 
> 
> No errors in dmesg, btrfs device stat or smartctl -a.
> 
> Any known issue?

I am still seeing this in 4.3-rc7. It happens so that on one SSD BTRFS
doesn´t even start scrubbing. But in the end it aborts it scrubbing anyway.

I do not see any other issue so far. But I would really like to be able to
scrub my BTRFS filesystems completely again. Any hints? Any further
information needed? 

merkaba:~> btrfs scrub status -d /
scrub status for […]
scrub device /dev/dm-5 (id 1) history
        scrub started at Sat Oct 31 11:58:45 2015, running for 00:00:00
        total bytes scrubbed: 0.00B with 0 errors
scrub device /dev/mapper/msata-debian (id 2) status
        scrub started at Sat Oct 31 11:58:45 2015, running for 00:00:20
        total bytes scrubbed: 5.27GiB with 0 errors
merkaba:~> btrfs scrub status -d /
scrub status for […]
scrub device /dev/dm-5 (id 1) history
        scrub started at Sat Oct 31 11:58:45 2015, running for 00:00:00
        total bytes scrubbed: 0.00B with 0 errors
scrub device /dev/mapper/msata-debian (id 2) status
        scrub started at Sat Oct 31 11:58:45 2015, running for 00:00:25
        total bytes scrubbed: 6.59GiB with 0 errors
merkaba:~> btrfs scrub status -d /
scrub status for […]
scrub device /dev/dm-5 (id 1) history
        scrub started at Sat Oct 31 11:58:45 2015, running for 00:00:00
        total bytes scrubbed: 0.00B with 0 errors
scrub device /dev/mapper/msata-debian (id 2) status
        scrub started at Sat Oct 31 11:58:45 2015, running for 00:01:25
        total bytes scrubbed: 21.97GiB with 0 errors
merkaba:~> btrfs scrub status -d /
scrub status for […]
scrub device /dev/dm-5 (id 1) history
        scrub started at Sat Oct 31 11:58:45 2015 and was aborted after 00:00:00
        total bytes scrubbed: 0.00B with 0 errors
scrub device /dev/mapper/msata-debian (id 2) history
        scrub started at Sat Oct 31 11:58:45 2015 and was aborted after 00:01:32
        total bytes scrubbed: 23.63GiB with 0 errors


For the sake of it I am going to btrfs check one of the filesystem where
BTRFS aborts scrubbing (which is all of the laptop filesystems, not only
the RAID 1 one).

I will use the /daten filesystem as I can unmount it during laptop runtime
easily. There scrubbing aborts immediately:

merkaba:~> btrfs scrub start /daten 
scrub started on /daten, fsid […] (pid=13861)
merkaba:~> btrfs scrub status /daten
scrub status for […]
        scrub started at Sat Oct 31 12:04:25 2015 and was aborted after 00:00:00
        total bytes scrubbed: 0.00B with 0 errors

It is single device:

merkaba:~> btrfs fi sh /daten
Label: 'daten'  uuid: […]
        Total devices 1 FS bytes used 227.23GiB
        devid    1 size 230.00GiB used 230.00GiB path /dev/mapper/msata-daten

btrfs-progs v4.2.2
merkaba:~> btrfs fi df /daten
Data, single: total=228.99GiB, used=226.79GiB
System, single: total=4.00MiB, used=48.00KiB
Metadata, single: total=1.01GiB, used=449.50MiB
GlobalReserve, single: total=160.00MiB, used=0.00B


I do not see any output in btrfs check that points to any issue:

merkaba:~> btrfs check /dev/msata/daten
Checking filesystem on /dev/msata/daten
UUID: 7918274f-e2ec-4983-bbb0-aa93ef95fcf7
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 243936530607 bytes used err is 0
total csum bytes: 237758932
total tree bytes: 471384064
total fs tree bytes: 116473856
total extent tree bytes: 78544896
btree space waste bytes: 57523323
file data blocks allocated: 422700576768
 referenced 243803443200
btrfs-progs v4.2.2

Thanks,
-- 
Martin
