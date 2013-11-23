Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:50924 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3KWLoc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Nov 2013 06:44:32 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id AD21715276
	for <linux-btrfs@vger.kernel.org>; Sat, 23 Nov 2013 11:44:28 +0000 (GMT)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id t5Bw1fRyHU5V for <linux-btrfs@vger.kernel.org>;
	Sat, 23 Nov 2013 11:44:26 +0000 (GMT)
Message-ID: <52909519.7080508@pocock.com.au>
Date: Sat, 23 Nov 2013 12:44:25 +0100
From: Daniel Pocock <daniel@pocock.com.au>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Nagios probe for btrfs RAID status?
References: <528F6085.4020603@pocock.com.au> <52902808.8020706@oracle.com> <5290695E.80506@pocock.com.au> <pan$13621$9e5c77ca$1502a49b$4b791baa@cox.net>
In-Reply-To: <pan$13621$9e5c77ca$1502a49b$4b791baa@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23/11/13 11:35, Duncan wrote:
> Daniel Pocock posted on Sat, 23 Nov 2013 09:37:50 +0100 as excerpted:
> 
>> What about when btrfs detects a bad block checksum and recovers data
>> from the equivalent block on another disk?  The wiki says there will be
>> a syslog event.  Does btrfs keep any stats on the number of blocks that
>> it considers unreliable and can this be queried from user space?
> 
> The way you phrased that question is strange to me (considers unreliable?
> does that mean ones that it had to fix, or ones that it had to fix more 
> than once, or...), so I'm not sure this answers it, but from the btrfs 
> manpage...


Let me clarify: when I said unreliable, I was referring to those blocks
where the block device driver reads the block without reporting any
error but where btrfs has decided the checksum is bad and not used the
data from the block.

Such blocks definitely exist. Sometimes the data was corrupted at the
moment of writing and no matter how many times you read the block, you
always get a bad checksum.


>>>>>
> 
> btrfs device stats [-z] {<path>|<device>}
> 
> Read and print the device IO stats for all devices of the filesystem 
> identified by <path> or for a single <device>.
> 
> Options
> 
> -z   Reset stats to zero after reading them.
> 
> <<<<
> 
> Here's the output for my (dual device btrfs raid1) rootfs, here:
> 
> btrfs dev stat /
> [/dev/sdc5].write_io_errs   0
> [/dev/sdc5].read_io_errs    0
> [/dev/sdc5].flush_io_errs   0
> [/dev/sdc5].corruption_errs 0
> [/dev/sdc5].generation_errs 0
> [/dev/sda5].write_io_errs   0
> [/dev/sda5].read_io_errs    0
> [/dev/sda5].flush_io_errs   0
> [/dev/sda5].corruption_errs 0
> [/dev/sda5].generation_errs 0
> 
> As you can see, for multi-device filesystems it gives the stats per 
> component device.  Any errors accumulate until a reset using -z, so you 
> can easily see if the numbers are increasing over time and by how much.
> 


That looks interesting - are these explained anywhere?

Should a Nagios plugin just look for any non-zero value or just focus on
some of those?

Are they runtime stats (since system boot) or are they maintained in the
filesystem on disk?

My own version of the btrfs utility doesn't have that command though, I
am using a Debian stable system.  I tried a newer version and it gives

ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS)

so I probably need to update my kernel too.


