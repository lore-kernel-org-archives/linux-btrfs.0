Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Transportmtw02.mindtree.com ([119.226.208.136]:1170 "EHLO
	transportmtw01.mindtree.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751137Ab2FMIqY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 04:46:24 -0400
From: Santosh Hosamani <Santosh_Hosamani@mindtree.com>
To: Hugo Mills <hugo@carfax.org.uk>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Bug in btrfs-debug-tree for two  or more devices.
Date: Wed, 13 Jun 2012 08:40:48 +0000
Message-ID: <24763ECA27C26742BD79B0D67389CD0E071B34B6@MTW02MBX05.mindtree.com>
References: <24763ECA27C26742BD79B0D67389CD0E071B3067@MTW02MBX05.mindtree.com>
 <20120612200650.GA28932@carfax.org.uk>
In-Reply-To: <20120612200650.GA28932@carfax.org.uk>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-----Original Message-----
From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Hugo Mills
Sent: Wednesday, June 13, 2012 1:37 AM
To: Santosh Hosamani
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Bug in btrfs-debug-tree for two or more devices.

On Tue, Jun 12, 2012 at 06:53:00AM +0000, Santosh Hosamani wrote:
>
> Hi btrfs folks,
>                 I am working on btrfs filesystem on how it manages the free space. And found out btrfs maintain a ctree which manages the physical location of the chunks and stripes of the filesystem.
> Btrfs-debug-tree also gives the information on the chunk tree
>
> I created btrfs on single device and two device.I have attached the output of both on running btrfs-debug-tree.
> For single device sum of all the length in the chunks will add upto the total used bytes which is expected behavior.
>
> But for two devices sum of all lengths in the chunks does not add to the total bytes .Am I missing something .

   Without actually seeing the details of your technique and expectations, I shall make a guess that you're not accounting for the double-counting of RAID-1 metadata. In other words, you will find that all of the metadata device extents (or chunks) will appear twice -- once on each device.

   Actually, this isn't quite right either -- what you really need to do is look at the RAID-1, RAID-10 and DUP bits in the chunk flags, add up all of those chunks, divide by two, and then add in the remaining
(RAID-0 and single) chunks. That total should then add up to the total value of allocated space that you get from the output of "btrfs fi df".

>>
 chunk tree leaf 20971520 items 8 free space 3023 generation 4 owner 3 fs uuid 23f86d1e-038a-4f5b-b87c-2ba78018135c
chunk uuid db672366-6801-4f83-99ef-2087a60bb394
        item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 3897 itemsize 98
                dev item devid 1 total_bytes 3221225472 bytes used 673579008
        item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 3799 itemsize 98
                dev item devid 2 total_bytes 3221225472 bytes used 652607488
        item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 0) itemoff 3719 itemsize 80
                chunk length 4194304 owner 2 type 2 num_stripes 1
                        stripe 0 devid 1 offset 0
        item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 4194304) itemoff 3639 itemsize 80
                chunk length 8388608 owner 2 type 4 num_stripes 1
                        stripe 0 devid 1 offset 4194304
        item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 12582912) itemoff 3559 itemsize 80
                chunk length 8388608 owner 2 type 1 num_stripes 1
                        stripe 0 devid 1 offset 12582912
        item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 3447 itemsize 112
                chunk length 8388608 owner 2 type 18 num_stripes 2
                        stripe 0 devid 2 offset 1048576
                        stripe 1 devid 1 offset 20971520
        item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 29360128) itemoff 3335 itemsize 112
                chunk length 322109440 owner 2 type 20 num_stripes 2
                        stripe 0 devid 2 offset 9437184
                        stripe 1 devid 1 offset 29360128
        item 7 key (FIRST_CHUNK_TREE CHUNK_ITEM 351469568) itemoff 3223 itemsize 112
                chunk length 644218880 owner 2 type 9 num_stripes 2
                        stripe 0 devid 2 offset 331546624
                        stripe 1 devid 1 offset 351469568
chunk tree will tell me where the physical stripes are there right .?Irrespective of the raid type ... correct me if I am wrong.
If not how will you know which all blocks are occupied and which all block are free.

Basically  what I want to do is .
 get the used blocks of all the devices and create a bitmap of that and zero out all the free block. Then I should not overwrite the used blocks.
I should be able to mount the filesystem without any error.
How do I achieve that?

> Also I notice that for the second device the superblock location 0x10000 is not considered as used .
>
> I would be really grateful if you folks can answer my query.
>
> I hav run these tests on SLES11-sp2-x86 Kernel 3.0.13.0.27-default

   This is pretty old, but shouldn't affect the results. It will cause reliability problems if you try running it seriously.

   Hugo.

--
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "There's a Martian war machine outside -- they want to talk ---
                to you about a cure for the common cold."

________________________________

http://www.mindtree.com/email/disclaimer.html
