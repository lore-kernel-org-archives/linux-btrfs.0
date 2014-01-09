Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41748 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752543AbaAISkX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 13:40:23 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How does btrfs handle bad blocks in raid1?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140109104247.GH15634@carfax.org.uk>
Date: Thu, 9 Jan 2014 11:40:20 -0700
Cc: Hugo Mills <hugo@carfax.org.uk>
Message-Id: <3A9CDBC9-ACFF-43E3-AFB9-33A6FFE7FB35@colorremedies.com>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com> <20140109104247.GH15634@carfax.org.uk>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 9, 2014, at 3:42 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Thu, Jan 09, 2014 at 11:26:26AM +0100, Clemens Eisserer wrote:
>> Hi,
>> 
>> I am running write-intensive (well sort of, one write every 10s)
>> workloads on cheap flash media which proved to be horribly unreliable.
>> A 32GB microSDHC card reported bad blocks after 4 days, while a usb
>> pen drive returns bogus data without any warning at all.
>> 
>> So I wonder, how would btrfs behave in raid1 on two such devices?
>> Would it simply mark bad blocks as "bad" and continue to be
>> operational, or will it bail out when some block can not be
>> read/written anymore on one of the two devices?
> 
>   If a block is read and fails its checksum, then the other copy (in
> RAID-1) is checked and used if it's good. The bad copy is rewritten to
> use the good data.
> 
>   If the block is bad such that writing to it won't fix it, then
> there's probably two cases: the device returns an IO error, in which
> case I suspect (but can't be sure) that the FS will go read-only. Or
> the device silently fails the write and claims success, in which case
> you're back to the situation above of the block failing its checksum.

In a normally operating drive, when the drive firmware locates a physical sector with persistent write failures, it's dereferenced. So the LBA points to a reserve physical sector, the originally can't be accessed by LBA. If all of the reserve sectors get used up, the next persistent write failure will result in a write error reported to libata and this will appear in dmesg, and should be treated as the drive being no longer in normal operation. It's a drive useful for storage developers, but not for production usage.

>   There's no marking of bad blocks right now, and I don't know of
> anyone working on the feature, so the FS will probably keep going back
> to the bad blocks as it makes CoW copies for modification.

This is maybe relevant:
https://www.kernel.org/doc/htmldocs/libata/ataExceptions.html

"READ and WRITE commands report CHS or LBA of the first failed sector but ATA/ATAPI standard specifies that the amount of transferred data on error completion is indeterminate, so we cannot assume that sectors preceding the failed sector have been transferred and thus cannot complete those sectors successfully as SCSI does."

If I understand that correctly, Btrfs really ought to either punt the device, or make the whole volume read-only. For production use, going read-only very well could mean data loss, even while preserving the state of the file system. Eventually I'd rather see the offending device ejected from the volume, and for the volume to remain rw,degraded.


Chris Murphy

