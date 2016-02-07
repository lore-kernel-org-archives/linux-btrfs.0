Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34337 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbcBGR2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Feb 2016 12:28:46 -0500
Received: by mail-wm0-f50.google.com with SMTP id 128so128833219wmz.1
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Feb 2016 09:28:45 -0800 (PST)
Received: from redPill (x4d0ca7a3.dyn.telefonica.de. [77.12.167.163])
        by smtp.googlemail.com with ESMTPSA id w80sm8667484wme.17.2016.02.07.09.28.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sun, 07 Feb 2016 09:28:43 -0800 (PST)
Date: Sun, 7 Feb 2016 18:28:41 +0100
From: Benjamin Valentin <benpicco@googlemail.com>
To: linux-btrfs@vger.kernel.org
Subject: One disc of 3-disc btrfs-raid5 failed - files only partially
 readable
Message-ID: <20160207182841.0d749ea7@redPill>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I created a btrfs volume with 3x8TB drives (ST8000AS0002-1NA) in raid5
configuration.
I copied some TB of data onto it without errors (from eSATA drives, so
rather fast - I mention that because of [1]), then set it up as a
fileserver where it had data read and written to it over a gigabit
ethernet connection for several days.
This however didn't go so well because after one day, one of the drives
dropped off the SATA bus.

I don't know if that was related to [1] (I was running Linux 4.4-rc6 to
avoid that) and by now all evidence has been eaten by logrotate :\

But I was not concerned for I had set up raid5 to provide redundancy
against one disc failure - unfortunately it did not.

When trying to read a file I'd get an I/O error after some hundret MB
(this is random across multiple files, but consistent for the same
file) on both files written before and after the disc failue.

(There was still data being written to the volume at this point.)

After a reboot a couple days later the drive showed up again and SMART
reported no errors, but the I/O errors remained.

I then ran btrfs scrub (this took about 10 days) and afterwards I was
again able to completely read all files written *before* the disc
failure.

However, many files written *after* the event (while only 2 drives were
online) are still only readable up to a point:

$ dd if=Dr.Strangelove.mkv of=/dev/null
dd: error reading ‘Dr.Strangelove.mkv’:
Input/output error
5331736+0 records in
5331736+0 records out
2729848832 bytes (2,7 GB) copied, 11,1318 s, 245 MB/s

$ ls -sh
4,4G Dr.Strangelove.mkv

[  197.321552] BTRFS warning (device sda): csum failed ino 171545 off 2269564928 csum 2566472073 expected csum 2434927850 
[  197.321574] BTRFS warning (device sda): csum failed ino 171545 off 2269569024 csum 566472073 expected csum 212160686
[  197.321592] BTRFS warning (device sda): csum failed ino 171545 off 2269573120 csum 2566472073 expected sum 2202342500

I tried btrfs check --repair but to no avail, got some

[ 4549.762299] BTRFS warning (device sda): failed to load free space cache for block group 1614937063424, rebuilding it now
[ 4549.790389] BTRFS error (device sda): csum mismatch on free space cache

and this result

checking extents
Fixed 0 roots.
checking free space cache
checking fs roots
checking csums
checking root refs
enabling repair mode
Checking filesystem on /dev/sda
UUID: ed263a9a-f65c-4bb6-8ee7-0df42b7fbfb8
cache and super generation don't match, space cache will be invalidated
found 11674258875712 bytes used err is 0
total csum bytes: 11387937220
total tree bytes: 13011156992
total fs tree bytes: 338083840
total extent tree bytes: 99123200
btree space waste bytes: 1079766991
file data blocks allocated: 14669115838464
 referenced 14668840665088

when I mount the volume with -o nospace_cache I instead get

[ 6985.165421] BTRFS warning (device sda): csum failed ino 171545 off 2269560832 csum 2566472073 expected csum 874509527
[ 6985.165469] BTRFS warning (device sda): csum failed ino 171545 off 2269564928 csum 566472073 expected csum 2434927850
[ 6985.165490] BTRFS warning (device sda): csum failed ino 171545 off 2269569024 csum 2566472073 expected csum 212160686

when trying to read the file.

Do you think there is still a chance to recover those files?
Also am I mistaken to believe that btrfs-raid5 would continue to
function when one disc fails?

If you need any more info I'm happy to provide that - here is some
information about the system:

Linux nashorn 4.4.0-2-generic #16-Ubuntu SMP Thu Jan 28 15:44:21 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

btrfs-progs v4.4

Label: 'data'  uuid: ed263a9a-f65c-4bb6-8ee7-0df42b7fbfb8
	Total devices 3 FS bytes used 10.62TiB
	devid    1 size 7.28TiB used 5.33TiB path /dev/sda
	devid    2 size 7.28TiB used 5.33TiB path /dev/sdb
	devid    3 size 7.28TiB used 5.33TiB path /dev/sdc

Data, RAID5: total=10.64TiB, used=10.61TiB
System, RAID1: total=40.00MiB, used=928.00KiB
Metadata, RAID1: total=13.00GiB, used=12.12GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Thank you!

[1] https://bugzilla.kernel.org/show_bug.cgi?id=93581
[2] full dmesg: http://paste.ubuntu.com/14965237/
