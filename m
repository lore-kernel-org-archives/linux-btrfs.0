Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:47841 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbaFSAH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 20:07:28 -0400
From: Russell Coker <russell@coker.com.au>
To: Daniel =?utf-8?B?Q2VnaWXFgmth?= <daniel.cegielka@gmail.com>
Reply-To: russell@coker.com.au
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs on whole disk (no partitions)
Date: Thu, 19 Jun 2014 10:07:24 +1000
Message-ID: <2316027.LZEnVG8laK@xev>
In-Reply-To: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 18 Jun 2014 21:29:39 Daniel Cegiełka wrote:
> Everything works fine. Is such a solution is recommended? In my
> opinion, the creation of the partitions seems to be completely
> unnecessary if you can use btrfs.

For boot disks I use the traditional partitioning system.  So far I don't run 
any systems that have a boot disk larger than 2TB so I haven't needed to use 
GPT.

I have a BTRFS RAID-1 on 2*3TB disks which have no partition tables, when the 
filesystem is going to use the entire device and there's no boot loader there 
is no reason to have a partition table.

I also have some SATA disks I use for backup which have no partition table 
because one filesystem is going to use all the space.

If you don't need to have a boot loader or swap space on the disk then there's 
no reason to have a partition table.  Note that it's often good to have some 
swap space even if everything can fit in RAM because Linux sometimes pages 
things out to make more space for cache.

While it's possible to boot a system without a partition table are you going 
to get a real benefit from that?  Having a separate /boot filesystem may 
"waste" 500M of disk space, but as it seems impossible to buy any new SATA 
device smaller than a 60G SSD (and the 120G SSDs don't cost much more) is that 
500M really an issue?

When a system fails to boot it's a major PITA and having an unusual boot setup 
will make it much more difficult to Google for help if you boot in an unusual 
way.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

