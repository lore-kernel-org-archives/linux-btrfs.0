Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moltke.seatribe.se ([178.63.100.209]:60051 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3BLXbj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 18:31:39 -0500
Received: from [2002:54d9:e26d::1] (helo=nerv.dolda2000.com)
	by moltke.seatribe.se with esmtp (Exim 4.72)
	(envelope-from <fredrik@dolda2000.com>)
	id 1U5Oqf-00065u-1h
	for linux-btrfs@vger.kernel.org; Wed, 13 Feb 2013 00:01:16 +0100
Received: from [2002:54d9:e26d:200:ca60:ff:fe16:97ac] ([IPv6:2002:54d9:e26d:200:ca60:ff:fe16:97ac])
	(authenticated bits=0)
	by nerv.dolda2000.com (8.14.3/8.14.3/Debian-9.4) with ESMTP id r1CN1B1Y004473
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 00:01:12 +0100
Date: Wed, 13 Feb 2013 00:01:11 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: linux-btrfs@vger.kernel.org
Subject: Rebalancing RAID1
Message-ID: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

I'm sorry if this is a dumb n3wb question, but I couldn't find anything 
about it, so please bear with me.

I just decided to try BtrFS for the first time, to replace an old ReiserFS 
data partition currently on a mdadm mirror. To do so, I'm using two 3 TB 
disks that were initially detected as sdd and sde, on which I have a 
single large GPT partition, so the devices I'm using for btrfs are sdd1 
and sde1.

I created a filesystem on them using RAID1 from the start (mkfs.btrfs -d 
raid -m raid1 /dev/sd{d,e}1), and started copying the data from the old 
partition onto it during the night. As it happened, I immediately got 
reason to try out BtrFS recovery because sometime during the copying 
operation /dev/sdd had some kind of cable failure and was removed from the 
system. A while later, however, it was apparently auto-redetected, this 
time as /dev/sdi, and BtrFS seems to have inserted it back into the 
filesystem somehow.

The current situation looks like this:

> $ sudo ./btrfs fi show
> Label: none  uuid: 40d346bb-2c77-4a78-8803-1e441bf0aff7
>         Total devices 2 FS bytes used 1.64TB
>         devid    1 size 2.73TB used 1.64TB path /dev/sdi1
>         devid    2 size 2.73TB used 2.67TB path /dev/sde1
> 
> Btrfs v0.20-rc1-56-g6cd836d

As you can see, /dev/sdi1 has much less space used, which I can only 
assume is because extents weren't allocated on it while it was off-line. 
I'm now trying to remedy this, but I'm not sure if I'm doing it right.

What I'm doing is to run "btrfs fi bal start /mnt &", and it gives me a 
ton of kernel messages that look like this:

Feb 12 22:57:16 nerv kernel: [59596.948464] btrfs: relocating block group 2879804932096 flags 17
Feb 12 22:57:45 nerv kernel: [59626.618280] btrfs_end_buffer_write_sync: 8 callbacks suppressed
Feb 12 22:57:45 nerv kernel: [59626.621893] lost page write due to I/O error on /dev/sdd1
Feb 12 22:57:45 nerv kernel: [59626.621893] btrfs_dev_stat_print_on_error: 8 callbacks suppressed
Feb 12 22:57:45 nerv kernel: [59626.621893] btrfs: bdev /dev/sdd1 errs: wr 66339, rd 26, flush 1, corrupt 0, gen 0
Feb 12 22:57:45 nerv kernel: [59626.644110] lost page write due to I/O error on /dev/sdd1
[Lots of the above, and occasionally a couple of lines like these]
Feb 12 22:57:48 nerv kernel: [59629.569278] btrfs: found 46 extents
Feb 12 22:57:50 nerv kernel: [59631.685067] btrfs_dev_stat_print_on_error: 5 callbacks suppressed

This barrage of messages combined with the fact that the rebalance is 
going quite slowly (btrfs fi bal stat indicates about 1 extent per minute, 
where an extent seems to be about 1 GB; which is several factors slower 
than it took to copy the data onto the filesystem) leads me to think that 
something is wrong. Is it, or should I just wait 2 days for it to 
complete, ignoring the error?

Also, why does it say that the errors are occuring /dev/sdd1? Is it just 
remembering the whole filesystem by that name since that's how I mounted 
it, or is it still trying to access the old removed instance of that disk 
and is that, then, why it's giving all these errors?

Thanks for reading!

--

Fredrik Tolf
