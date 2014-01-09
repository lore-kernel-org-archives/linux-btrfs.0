Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay0-omc1-s6.bay0.hotmail.com ([65.54.190.17]:21863 "EHLO
	bay0-omc1-s6.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755295AbaAITSk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 14:18:40 -0500
Message-ID: <BAY172-W37E3465B365B9EA9C2AA4FB0B00@phx.gbl>
From: Kyle Gates <kylegates@hotmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: How does btrfs handle bad blocks in raid1?
Date: Thu, 9 Jan 2014 13:13:16 -0600
In-Reply-To: <3A9CDBC9-ACFF-43E3-AFB9-33A6FFE7FB35@colorremedies.com>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>
 <20140109104247.GH15634@carfax.org.uk>,<3A9CDBC9-ACFF-43E3-AFB9-33A6FFE7FB35@colorremedies.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 9 Jan 2014 11:40:20 -0700 Chris Murphy wrote:
>
> On Jan 9, 2014, at 3:42 AM, Hugo Mills wrote:
>
>> On Thu, Jan 09, 2014 at 11:26:26AM +0100, Clemens Eisserer wrote:
>>> Hi,
>>>
>>> I am running write-intensive (well sort of, one write every 10s)
>>> workloads on cheap flash media which proved to be horribly unreliable.
>>> A 32GB microSDHC card reported bad blocks after 4 days, while a usb
>>> pen drive returns bogus data without any warning at all.
>>>
>>> So I wonder, how would btrfs behave in raid1 on two such devices?
>>> Would it simply mark bad blocks as "bad" and continue to be
>>> operational, or will it bail out when some block can not be
>>> read/written anymore on one of the two devices?
>>
>> If a block is read and fails its checksum, then the other copy (in
>> RAID-1) is checked and used if it's good. The bad copy is rewritten to
>> use the good data.
>>
>> If the block is bad such that writing to it won't fix it, then
>> there's probably two cases: the device returns an IO error, in which
>> case I suspect (but can't be sure) that the FS will go read-only. Or
>> the device silently fails the write and claims success, in which case
>> you're back to the situation above of the block failing its checksum.
>
> In a normally operating drive, when the drive firmware locates a physical sector with persistent write failures, it's dereferenced. So the LBA points to a reserve physical sector, the originally can't be accessed by LBA. If all of the reserve sectors get used up, the next persistent write failure will result in a write error reported to libata and this will appear in dmesg, and should be treated as the drive being no longer in normal operation. It's a drive useful for storage developers, but not for production usage.
>
>> There's no marking of bad blocks right now, and I don't know of
>> anyone working on the feature, so the FS will probably keep going back
>> to the bad blocks as it makes CoW copies for modification.
>
> This is maybe relevant:
> https://www.kernel.org/doc/htmldocs/libata/ataExceptions.html
>
> "READ and WRITE commands report CHS or LBA of the first failed sector but ATA/ATAPI standard specifies that the amount of transferred data on error completion is indeterminate, so we cannot assume that sectors preceding the failed sector have been transferred and thus cannot complete those sectors successfully as SCSI does."
>
> If I understand that correctly, Btrfs really ought to either punt the device, or make the whole volume read-only. For production use, going read-only very well could mean data loss, even while preserving the state of the file system. Eventually I'd rather see the offending device ejected from the volume, and for the volume to remain rw,degraded.

I would like to see btrfs hold onto the device in a read-only state like is done during a device replace operation. New writes would maintain the raid level but go out to the remaining devices and only go full filesystem read-only if the minimum number of writable devices is not met. Once a new device is added in, the replace operation could commence and drop the bad device when complete. 		 	   		  