Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:35946 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaHQOvu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Aug 2014 10:51:50 -0400
Received: from xev.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 46D0920955
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Aug 2014 00:51:47 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: Re: Putting very big and small files in one subvolume?
Date: Mon, 18 Aug 2014 00:51:45 +1000
Message-ID: <2834974.yZzVPeX4cV@xev>
In-Reply-To: <pan$df1ba$a20420a2$2ac33113$90ec0a1@cox.net>
References: <CAH-HCWVDtPv9gYxpcA4drK=FDes_0z8QTxqOBcocWf9T_b4tyQ@mail.gmail.com> <pan$df1ba$a20420a2$2ac33113$90ec0a1@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 17 Aug 2014 12:31:42 Duncan wrote:
> OTOH, I tend to be rather more of an independent partition booster than 
> many.  The biggest reason for that is the too many eggs in one basket 
> problem.  Fully separate filesystems on separate partitions separate 
> those data "eggs" into separate baskets, so if the metaphorical bottom 
> drops out of one of those filesystem baskets, only the data eggs in that 
> filesystem basket are lost, while the eggs in the separate filesystem 
> baskets are still safe and sound, not affected at all. =:^)
> 
> The thing that troubles me about replacing a bunch of independent 
> partitions and filesystems with a bunch of subvolumes on a single btrfs 
> filesystem is thus just that, you've nicely divided that big basket into 
> little subvolume compartments, but it's still one big basket, and if the 
> bottom falls out, you potentially lose EVERYTHING in that filesystem 
> basket!

I'll write the counter-point to this.

If you have several partitions for /, /var/log, and /home then losing any one 
of them will result in a system that's mostly unusable.  So for continuous 
service there doesn't seem to be a benefit in having multiple partitions.

When you have to restore a backup in adverse circumstances the restore time is 
important.  For example if you have 10*4TB disks and need RAID-1 redundancy 
(which you need on any BTRFS filesystem of note as I don't think RAID-5 and 
RAID-6 are trustworthy) then an advantage of 5*4TB RAID-1 filesystems over a 
20TB RAID-10 is that restore time will be a lot smaller.  But this isn't an 
issue for typical BTRFS users who are working with much smaller amounts of 
data, at this time I have to recommend ZFS over BTRFS for most systems that 
manage 20TB of data.

If you have a RAID-1 array of the biggest disks available (which is probably 
the biggest storage for >99% of BTRFS users) then you are looking at a restore 
time of maybe 4TB at 160MB/s == something less than 7 hours.  For a home 
network 7 hours delay in getting things going after a major failure is quite 
OK.

Finally failures of filesystems on different partitions won't be independent.  
If one filesystem on a disk becomes unusable due to drive firmware issues or 
other serious problems then other filesystems on the same physical disk are 
likely to suffer the same fate.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

