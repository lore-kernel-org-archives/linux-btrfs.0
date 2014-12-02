Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mdfmta010.mxout.tbr.inty.net ([91.221.168.51]:51600 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751141AbaLBS4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 13:56:19 -0500
Received: from mdfmta010.tbr.inty.net (unknown [127.0.0.1])
	by mdfmta010.tbr.inty.net (Postfix) with ESMTP id 380676F92BE
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Dec 2014 18:55:58 +0000 (GMT)
Received: from mdfmta010.tbr.inty.net (unknown [127.0.0.1])
	by mdfmta010.tbr.inty.net (Postfix) with ESMTP id 12AB56F97B2
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Dec 2014 18:55:58 +0000 (GMT)
Received: from iarmst.demon.co.uk (unknown [62.49.16.35])
	by mdfmta010.tbr.inty.net (Postfix) with SMTP
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Dec 2014 18:55:57 +0000 (GMT)
Date: Tue, 2 Dec 2014 18:56:13 +0000
From: Ian Armstrong <btrfs@iarmst.co.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs stuck with lot's of files
Message-ID: <20141202185613.72992959@spike.private.network>
In-Reply-To: <pan$9649c$5bf442fc$686ccac2$96f1d79b@cox.net>
References: <1417434411.20237.1.camel@gentoo.org>
	<547CB7D0.4040800@pobox.com>
	<1417485029.4310.22.camel@gentoo.org>
	<pan$9649c$5bf442fc$686ccac2$96f1d79b@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2 Dec 2014 12:48:21 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> Peter Volkov posted on Tue, 02 Dec 2014 04:50:29 +0300 as excerpted:
> 
> > В Пн, 01/12/2014 в 10:47 -0800, Robert White пишет:
> >> On 12/01/2014 03:46 AM, Peter Volkov wrote:
> >>  > (stuff about getting hung up trying to write to one drive)
> >> 
> >> That drive (/dev/sdn) is probably starting to fail.
> >> (about failed drive)
> > 
> > Thank you Robert for the answer. It is not likely that drive fails
> > here. Similar condition (write to a single drive) happens with
> > other drives i.e. such write pattern may happen with any drive.
> >
> > After looking at what happens longer I see the following. During
> > stuck single processor core is busy 100% of CPU in kernel space
> > (some kworker is taking 100% CPU).
> 
> FWIW, agreed that it's unlikely to be the drive, especially if you're
> not seeing bus resets or drive errors in dmesg and smart says the
> drive is fine, as I expect it does/will.  It may be a btrfs bug or
> scaling issue, of which btrfs still has some, or it could simply be
> the single mode vs raid0 mode issue I explain below.

I encountered a similar problem here a few days ago on a btrfs raid1
partition while using rsync to clone a (~30GB) directory.

Everything started fine, but I came back an hour later to find rsync had
apparently stalled at about 20% with cpu usage at 100% on a single
kworker thread. I was able to kill rsync eventually, and after a while
(don't know how long, but >10 minutes) cpu usage returned to normal.
Restarting rsync resulted in kworker at 100% cpu in less than a minute.
Once stalled there was little drive access happening. Another raid1
partition (mdadm/ext4) on the same drive pair was having no problems.
Nothing showed in the system logs.

In this instance I'd forgotten to delete a temporary 500GB file before
starting rsync, so although recently balanced (musage=80/dusage=80) it
was running at near capacity.

After a reboot, deleting the 500GB file & running balance, everything
returned to normal. Ran rsync again & it completed fine.

Running slackware current, with Kernel 3.16.4

# btrfs filesystem df /mnt/general
Data, RAID1: total=1.38TiB, used=1.38TiB
System, RAID1: total=32.00MiB, used=256.00KiB
Metadata, RAID1: total=6.00GiB, used=4.67GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

# btrfs filesystem show /mnt/general
Label: none  uuid: 592376ea-769f-4abb-915e-aa5e49162d90
        Total devices 2 FS bytes used 1.38TiB
        devid    1 size 1.79TiB used 1.39TiB path /dev/sda4
        devid    2 size 1.79TiB used 1.39TiB path /dev/sdd4

Btrfs v3.17.2

-- 
Ian
