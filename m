Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55232 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab2GaRwx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 13:52:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SwGcm-00030x-DO
	for linux-btrfs@vger.kernel.org; Tue, 31 Jul 2012 19:52:52 +0200
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 19:52:52 +0200
Received: from eternaleye+usenet by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 19:52:52 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye+usenet@gmail.com>
Subject: Re: filesystem finder / fixer
Date: Tue, 31 Jul 2012 10:52:40 -0700
Message-ID: <jv9618$6nr$1@dough.gmane.org>
References: <36321.99.101.148.183.1343705202.squirrel@lavabit.com> <20120731113247.11aab72a@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just realized I messed up sending this to the list.

Roman Mamedov wrote:

> On Mon, 30 Jul 2012 23:26:42 -0400 (EDT)
> serialhex@lavabit.com wrote:
> 
>> 1) is there a tool to help me recover data from my fs? I don't have a
>> backup of my partition table and so I have about 500GB of space where a
>> few partitionns might reside... GPT partitions mind you
> 
> If you only lost the partition table, there's a tool (strangely)named
> TestDisk, which can find the actual partitions on disk and restore it.
> Don't know if it supports GPT and BTRFS, though.
> 

If TestDisk doesn't support it, then you may be able to do it manually with 
some trial and error.

I just dumped the first 4 megabytes of my disk, and it looks like at offset
0x10040 (64K + 64 bytes) there's the string BHRfS (hex 5F 42 48 52 66 53 
5f). That matches the documentation (the first superblock should be at 64K). 
Therefore, if you can find that string, subtract 64 from the byte offset (to 
get the offset of the block it's in in bytes), divide that by 512, and 
subtract 125 (64 kilobytes in 512-byte blocks), you should have the number 
of 512-byte blocks from the start of the device that the partition should 
be.

Note: I have not actually done this. You may want to set the device read-
only (blockdev --setro) and use dm-linear directly to test whether the 
offset you find this way is correct.

Once you have a mapping or partition in the right place, you have two 
options for recovering your files: the btrfsck repair tool, or the btrfs-
restore extraction tool. The repair tool still doesn't fix all problems, but 
using btrfs-restore with btrfs-find-root has worked well for me in the past 
in one case where btrfsck didn't. Another benefit is that you can use it 
even while the disk is still in read-only mode and mapped via dm-linear, 
with essentially zero risk of damaging your data further. The downside is 
that you need a second drive that's big enough for all of your data.

