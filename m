Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob05.myregisteredsite.com ([209.17.115.43]:36766 "EHLO
	atl4mhob05.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237Ab3EHQ6B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 May 2013 12:58:01 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.119])
	by atl4mhob05.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r48GvxnQ014601
	for <linux-btrfs@vger.kernel.org>; Wed, 8 May 2013 12:57:59 -0400
Message-ID: <518A841B.1090205@chinilu.com>
Date: Wed, 08 May 2013 09:58:03 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Best Practice - Partition, or not?
References: <loom.20130501T094600-451@post.gmane.org> <CW2IaniPCXB@helmut.hullen.de> <njbp5a-7tq.ln1@hurikhan.ath.cx>
In-Reply-To: <njbp5a-7tq.ln1@hurikhan.ath.cx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/08/2013 12:31 AM, Kai Krakow wrote:
> Helmut Hullen <Hullen@t-online.de> schrieb:
>
>>> If I want to manage a complete disk with btrfs, what's the "Best
>>> Practice"? Would it be best to create the btrfs filesystem on
>>> "/dev/sdb", or would it be better to create just one partition from
>>> start to end and then do "mkfs.btrfs /dev/sdb1"?
>>> Would the same recomendation hold true, if we're talking about huge
>>> disks, like 4TB or so?
>> I've tested both versions on a 3 disk bundle of 3 TByte disks (data
>> raid0, meta raid1).
>>
>>    mkfs.btrfs ... /dev/sdb /dev/sdc /dev/sdd
>>
>> made some more problems, especially when recognizing or deleting the
>> disk(s). Maybe that's a problem more related to "util-linux" (especially
>> "wipefs" and "blkid").
>>
>> Partitioning first with gdisk and then
>>
>>    mkfs.btrfs ... /dev/sdb1 /dev/sdc1 /dev/sdd1
>>
>> runs better (perhaps without problems).
> I can only second that experience. Most apps and utilities do not expect
> filesystems on raw partitions, most expect partitions first. Some may even
> just destroy your filesystem because they only find what appears junk to
> them on the disk. OP is not going to dual-boot (which would raise such
> problems with the highest chance) but if you want to evade unexpected
> behavior use GPT partitioning - it supports huge disks and takes care on the
> block alignment.
>
> I used formatting raw disks in a VM because adding new disks was a matter of
> adding a new VD image to the machine and I didn't need more than one
> partition on a disk. But that created more headache than I expected and I
> didn't want to persuade tools and scripts any longer to accept raw disks as
> filesystems and work around ugly quirks (like scripts expecting /dev/sd[a-z]
> to never be a filesystem but always raw device, and requiring /dev/sd[a-z]
> [0-9]+ for partitions, and more such fun).
>
> So I suggest: Go with partitions.
>
> Regards,
> Kai
>
>
>
I very much agree with that advice in the short term, however, in the 
longer term I am convinced that the larger ecosystem is going to have to 
catch up.  Next gen filesystems like btrfs and zfs have made old 
standbys like block raid and lvm anachronisms an I really think that 
partitioning is not going to escape the same fate. Partitioning adds 
management overhead, wastes drive space and reduces flexibility.  And as 
far as problems with filesystem tools, util-linux being a prime example, 
they ALREADY have problems with btrfs even WITH partitioning.  I am in 
the process of discussing an issue right now on the util-linux list 
regarding failure of both umount and findmnt to properly handle btrfs 
volumes.  Both EXPECT a btrfs volume to be on a single partition.  On my 
system I currently have btrfs raid 1 volumes spread over up to 5 
partitions on 5 different drives.  mount handles this OK, but, in the 
case of umount, it will very often respond with "umount: LABEL=XXXX: not 
found.  Using a debug statement suggested by Karel Zak demonstrates the 
problem.  umount finds a device name matching one of the volumes, but it 
is not the mount point, thus umount is unable to verify that the volume 
is mounted (since it is searching the mount list for the wrong device) 
and fails.  Same problem with findmnt. Its all a process over time, but 
they are just going to need to catch up and in the long run we will all 
benefit from that. Currently I have completely converted my main desktop 
to btrfs with everything except backup on raid 1 (I have one backup 
drive formatted JFS just in case!!!).  I am extremely happy with it.  My 
five 500GB system drives are conventionally partitioned.  My 4TB backup 
drive is unpartioned formatted raw to btrfs.  So I am getting experience 
with both and finding and working through the issues. Some time ago I 
had a problem deleting btrfs from a drive formatted raw without 
partitions, but later that got fixed and wipefs found the raw formatted 
btrfs remnants and successfully deleted them, leaving the drives in 
pristine shape and ready to be formatted for a new role in life.  So we 
are getting there, its just going to take time.  These of course only 
represent my opinions on the matter, I am sure not everyone will agree, 
and I fully accept that.  - George
