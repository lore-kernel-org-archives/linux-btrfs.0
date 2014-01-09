Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55659 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755498AbaAITbq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 14:31:46 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:50681 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W1LKT-003wci-5I
	for linux-btrfs@vger.kernel.org; Thu, 09 Jan 2014 12:31:45 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How does btrfs handle bad blocks in raid1?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <BAY172-W37E3465B365B9EA9C2AA4FB0B00@phx.gbl>
Date: Thu, 9 Jan 2014 12:31:46 -0700
Message-Id: <75CB34F7-0BC3-47B7-8817-94F74BC5FD18@colorremedies.com>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com> <20140109104247.GH15634@carfax.org.uk>,<3A9CDBC9-ACFF-43E3-AFB9-33A6FFE7FB35@colorremedies.com> <BAY172-W37E3465B365B9EA9C2AA4FB0B00@phx.gbl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 9, 2014, at 12:13 PM, Kyle Gates <kylegates@hotmail.com> wrote:

> On Thu, 9 Jan 2014 11:40:20 -0700 Chris Murphy wrote:
>> 
>> On Jan 9, 2014, at 3:42 AM, Hugo Mills wrote:
>> 
>>> On Thu, Jan 09, 2014 at 11:26:26AM +0100, Clemens Eisserer wrote:
>>>> Hi,
>>>> 
>>>> I am running write-intensive (well sort of, one write every 10s)
>>>> workloads on cheap flash media which proved to be horribly unreliable.
>>>> A 32GB microSDHC card reported bad blocks after 4 days, while a usb
>>>> pen drive returns bogus data without any warning at all.
>>>> 
>>>> So I wonder, how would btrfs behave in raid1 on two such devices?
>>>> Would it simply mark bad blocks as "bad" and continue to be
>>>> operational, or will it bail out when some block can not be
>>>> read/written anymore on one of the two devices?
>>> 
>>> If a block is read and fails its checksum, then the other copy (in
>>> RAID-1) is checked and used if it's good. The bad copy is rewritten to
>>> use the good data.
>>> 
>>> If the block is bad such that writing to it won't fix it, then
>>> there's probably two cases: the device returns an IO error, in which
>>> case I suspect (but can't be sure) that the FS will go read-only. Or
>>> the device silently fails the write and claims success, in which case
>>> you're back to the situation above of the block failing its checksum.
>> 
>> In a normally operating drive, when the drive firmware locates a physical sector with persistent write failures, it's dereferenced. So the LBA points to a reserve physical sector, the originally can't be accessed by LBA. If all of the reserve sectors get used up, the next persistent write failure will result in a write error reported to libata and this will appear in dmesg, and should be treated as the drive being no longer in normal operation. It's a drive useful for storage developers, but not for production usage.
>> 
>>> There's no marking of bad blocks right now, and I don't know of
>>> anyone working on the feature, so the FS will probably keep going back
>>> to the bad blocks as it makes CoW copies for modification.
>> 
>> This is maybe relevant:
>> https://www.kernel.org/doc/htmldocs/libata/ataExceptions.html
>> 
>> "READ and WRITE commands report CHS or LBA of the first failed sector but ATA/ATAPI standard specifies that the amount of transferred data on error completion is indeterminate, so we cannot assume that sectors preceding the failed sector have been transferred and thus cannot complete those sectors successfully as SCSI does."
>> 
>> If I understand that correctly, Btrfs really ought to either punt the device, or make the whole volume read-only. For production use, going read-only very well could mean data loss, even while preserving the state of the file system. Eventually I'd rather see the offending device ejected from the volume, and for the volume to remain rw,degraded.
> 
> I would like to see btrfs hold onto the device in a read-only state like is done during a device replace operation. New writes would maintain the raid level but go out to the remaining devices and only go full filesystem read-only if the minimum number of writable devices is not met. Once a new device is added in, the replace operation could commence and drop the bad device when complete. 	

Sure that's a fine optimization for a bad device to be read-only while the volume is still rw, if that's possible.

Chris Murphy

