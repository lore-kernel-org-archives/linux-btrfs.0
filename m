Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhfb01.myregisteredsite.com ([209.17.115.55]:50783 "EHLO
	atl4mhfb01.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226Ab3KNRTP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 12:19:15 -0500
Received: from atl4mhob01.myregisteredsite.com (atl4mhob01.myregisteredsite.com [209.17.115.39])
	by atl4mhfb01.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id rAEHJENB011895
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 12:19:14 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.116])
	by atl4mhob01.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id rAEHICWe001559
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 12:18:12 -0500
Message-ID: <528505E2.3060501@chinilu.com>
Date: Thu, 14 Nov 2013 09:18:26 -0800
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
CC: linux-btrfs@vger.kernel.org
Subject: Re: Does btrfs "raid1" actually provide any resilience?
References: <l62akc$ujc$1@ger.gmane.org>
In-Reply-To: <l62akc$ujc$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The read only mount issue is by design.  It is intended to make sure you 
know exactly what is going on before you proceed.  For example, a drive 
may actually be fine, but may have been caused by a cable failure.  In 
that case you would want to fix the cable problem before you break the 
mirror by writing to a single drive.  The read only function is designed 
to make certain you know that you are simplex before you proceed further.

As for the rest of it, hopefully someone else here can shed more light.  
For sure RAID1 mode works fairly reliably (like traditional RAID1) in a 
non virtual setting.  But it IS still experimental.  I am using btrfs 
RAID1 on my workstation, four partitions spread over five hard drives, 
but I back everything up 100% multiple times daily via anacron and cron 
functions.  I certainly wouldn't trust it just yet as it is not fully 
production ready.  That said, I have been using it for over six months 
now, coming off of 3ware RAID, and I have no regrets.


On 11/14/2013 03:02 AM, Lutz Vieweg wrote:
> Hi,
>
> on a server that so far uses an MD RAID1 with XFS on it we wanted
> to try btrfs, instead.
>
> But even the most basic check for btrfs actually providing
> resilience against one of the physical storage devices failing
> yields a "does not work" result - so I wonder whether I misunderstood
> that btrfs is meant to not require block-device level RAID
> functionality underneath.
>
> Here are the test procedure:
>
> Testing was done using vanilla linux-3.12 (x86_64) plus btrfs-progs at
> commit c652e4efb8e2dd76ef1627d8cd649c6af5905902.
>
> Preparing two 100 MB image files:
>> # dd if=/dev/zero of=/tmp/img1 bs=1024k count=100
>> 100+0 records in
>> 100+0 records out
>> 104857600 bytes (105 MB) copied, 0.201003 s, 522 MB/s
>>
>> # dd if=/dev/zero of=/tmp/img2 bs=1024k count=100
>> 100+0 records in
>> 100+0 records out
>> 104857600 bytes (105 MB) copied, 0.185486 s, 565 MB/s
>
> Preparing two loop devices on those images to act as the underlying
> block devices for btrfs:
>> # losetup /dev/loop1 /tmp/img1
>> # losetup /dev/loop2 /tmp/img2
>
> Preparing the btrfs filesystem on the loop devices:
>> # mkfs.btrfs --data raid1 --metadata raid1 --label test /dev/loop1 
>> /dev/loop2
>> SMALL VOLUME: forcing mixed metadata/data groups
>>
>> WARNING! - Btrfs v0.20-rc1-591-gc652e4e IS EXPERIMENTAL
>> WARNING! - see http://btrfs.wiki.kernel.org before using
>>
>> Performing full device TRIM (100.00MiB) ...
>> Turning ON incompat feature 'mixed-bg': mixed data and metadata block 
>> groups
>> Created a data/metadata chunk of size 8388608
>> Performing full device TRIM (100.00MiB) ...
>> adding device /dev/loop2 id 2
>> fs created label test on /dev/loop1
>>         nodesize 4096 leafsize 4096 sectorsize 4096 size 200.00MiB
>> Btrfs v0.20-rc1-591-gc652e4e
>
> Mounting the btfs filesystem:
>> # mount -t btrfs /dev/loop1 /mnt/tmp
>
> Copying just 70MB of zeroes into a test file:
>> # dd if=/dev/zero of=/mnt/tmp/testfile bs=1024k count=70
>> 70+0 records in
>> 70+0 records out
>> 73400320 bytes (73 MB) copied, 0.0657669 s, 1.1 GB/s
>
> Checking that the testfile can be read:
>> # md5sum /mnt/tmp/testfile
>> b89fdccdd61d57b371f9611eec7d3cef  /mnt/tmp/testfile
>
> Unmounting before further testing:
>> # umount /mnt/tmp
>
>
> Now we assume that one of the two "storage devices" is broken,
> so we remove one of the two loop devices:
>> # losetup -d /dev/loop1
>
> Trying to mount the btrfs filesystem from the one storage device that 
> is left:
>> # mount -t btrfs -o device=/dev/loop2,degraded /dev/loop2 /mnt/tmp
>> mount: wrong fs type, bad option, bad superblock on /dev/loop2,
>>        missing codepage or helper program, or other error
>>        In some cases useful info is found in syslog - try
>>        dmesg | tail  or so
> ... does not work.
>
> In /var/log/messages we find:
>> kernel: btrfs: failed to read chunk root on loop2
>> kernel: btrfs: open_ctree failed
>
> (The same happenes when adding ",ro" to the mount options.)
>
> Ok, so if the first of two disks was broken, so is our filesystem.
> Isn't that what RAID1 should prevent?
>
> We tried a different scenario, now the first disk remains
> but the second is broken:
>
>> # losetup -d /dev/loop2
>> # losetup /dev/loop1 /tmp/img1
>>
>> # mount -t btrfs -o degraded /dev/loop1 /mnt/tmp
>> mount: wrong fs type, bad option, bad superblock on /dev/loop1,
>>        missing codepage or helper program, or other error
>>        In some cases useful info is found in syslog - try
>>        dmesg | tail  or so
>>
>> In /var/log/messages:
>> kernel: Btrfs: too many missing devices, writeable mount is not allowed
>
> The message is different, but still unsatisfactory: Not being
> able to write to a RAID1 because one out of two disks failed
> is not what one would expect - the machine should be operable just
> normal with a degraded RAID1.
>
> But let's try if at least a read-only mount works:
>> # mount -t btrfs -o degraded,ro /dev/loop1 /mnt/tmp
> The mount command itself does work.
>
> But then:
>> # md5sum /mnt/tmp/testfile
>> md5sum: /mnt/tmp/testfile: Input/output error
>
> The testfile is not readable anymore. (At this point, no messages
> are to be found in dmesg/syslog - I would expect such on an
> input/output error.)
>
> So the bottom line is: All the double writing that comes with RAID1
> mode did not provide any usefule resilience.
>
> I am kind of sure this is not as intended, or is it?
>
> Regards,
>
> Lutz Vieweg
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

