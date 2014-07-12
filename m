Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:34631 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaGLBXn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jul 2014 21:23:43 -0400
From: Russell Coker <russell@coker.com.au>
To: constantine <costas.magnuse@gmail.com>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs and LBA errors
Date: Sat, 12 Jul 2014 11:23:38 +1000
Message-ID: <3431118.WpiWX9X6ip@xev>
In-Reply-To: <CANcfdL1Ldf0-Bbe16bRyUtA+cpupTzqYLdzmHrsOJacE5c92Lw@mail.gmail.com>
References: <CANcfdL3ZUwOGPf2YQpyXYSd8ZoNntyaX8rdQXdciSADGCsb-Sg@mail.gmail.com> <5907875.Oun3LlLFiV@xev> <CANcfdL1Ldf0-Bbe16bRyUtA+cpupTzqYLdzmHrsOJacE5c92Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 11 Jul 2014 21:29:07 constantine wrote:
> Thank you very much for your response:
> 
> # file -s /dev/sda1 /dev/sdc1
> /dev/sda1: BTRFS Filesystem label "partition", sectorsize 4096,
> nodesize 4096, leafsize 4096,
> UUID=c1eb1aaf-665a-4337-9d04-3c3921aa67e0, 1683870334976/3010310701056
> bytes used, 2 devices
> /dev/sdc1: data

Looks like the primary superblock on /dev/sdc1 is corrupt.

http://www.funtoo.org/BTRFS_Fun#btrfs-select-super_.2F_btrfs-zero-log

The above URL documents how to use the other superblocks.  It notes that you 
only get one chance - if you do this wrong you will dramatically reduce the 
probability of getting your data back.  Do not do this on the master copy of 
your data!

Buy 2 disks of equal or greater capacity, copy the block devices, and then 
working with the copy.  sdc needs to be replaced anyway no matter what you do 
and getting a replacement for sda would be a good strategy anyway.  Buy 2*4TB 
disks and you can make a new RAID-1 array that has more capacity than the non-
RAID filesystem you currently have.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

