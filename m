Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:33381 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab3KNSWG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 13:22:06 -0500
Message-ID: <528514CA.8080903@libero.it>
Date: Thu, 14 Nov 2013 19:22:02 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Lutz Vieweg <lvml@5t9.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Does btrfs "raid1" actually provide any resilience?
References: <l62akc$ujc$1@ger.gmane.org>
In-Reply-To: <l62akc$ujc$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-11-14 12:02, Lutz Vieweg wrote:
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

I don't think that you have misunderstood btrfs. On the basis of my
knowledge you are right.

With a kernel v3.11.6 I made your test and I got the following:

- 2 disks of 100M each and 1 file of 70M: I was *unable* to create the
file because I got a "No space left on device". I was not surprise BTRFS
behaves bad when the free space is low. However I was able to remove a
disk and remount the filesystem in "degraded" mode.

- 2 disk of 3G each and 1 file of 100M: I was *able* to create the file,
and to remount the filesystem in degraded mode when I deleted a disk.

Note: in any case I needed to mount the filesystem in read-only mode.

I will try also with a 3.12 kernel.

BR
G.Baroncelli
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
> Trying to mount the btrfs filesystem from the one storage device that is
> left:
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


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
