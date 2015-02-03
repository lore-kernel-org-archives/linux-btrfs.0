Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:63330 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965229AbbBCAZS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Feb 2015 19:25:18 -0500
Received: by mail-la0-f41.google.com with SMTP id gm9so46676287lab.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Feb 2015 16:25:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54C75683.80903@mpi-dortmund.mpg.de>
References: <54C75683.80903@mpi-dortmund.mpg.de>
From: Tobias Holst <tobby@tobby.eu>
Date: Tue, 3 Feb 2015 01:24:55 +0100
Message-ID: <CAGwxe4gjxwb5OsSLHqqC5kPzKK1_ERz0_rKHL2Eu+o4CgoBFHA@mail.gmail.com>
Subject: Re: how to repair a damaged filesystem with btrfs raid5
To: Alexander Fieroch <alexander.fieroch@mpi-dortmund.mpg.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

There is a known bug when you re-plug in a missing hdd of a btrfs raid
without wiping the device before. In worst case this results in a
totally corrupted filesystem as it did sometimes during my tests of
the raid6 implementation. With raid1 it may just "go back in time" to
the point when you unplugged the device. Which is also bad but still
no complete data loss - but in raid6 sometimes it was worse.

Sounds like you did that (plug in the missing device without wiping)?

Next thing is, that scrub and filesystem-check of raid5/6 is not
implemented/completed (yet) as Duncan said. It will be (mostly)
included in 3.19, but maybe with bugs.

You may try to do a balance instead of a scrub as this should read and
check your data and then write it back. This worked for me most of the
time during my personal raid6 stability and stress tests. But maybe
your filesystem has already been corrupted...
Give it a try :)

Regards
Tobias


2015-01-27 10:12 GMT+01:00 Alexander Fieroch
<alexander.fieroch@mpi-dortmund.mpg.de>:
> Hello,
>
> I'm testing btrfs RAID5 on three encrypted hdds (dm-crypt) and I'm
> simulating a harddisk failure by unplugging one device while writing some
> files.
> Now the filesystem is damaged. By now is there any chance to repair the
> filesystem?
>
> My operating system is ubuntu server (vivid) with kernel 3.18 and btrfs
> 3.18.1 (external PPA).
> I've unplugged device sdb with UUID 65f62f63-6526-4d5e-82d4-adf6d7508092 and
> crypt device name /dev/mapper/crypt-1. This one should be repaired.
> Attached is the dmesg log file with corresponding errors.
>
> btrfs check do not seem to work.
>
> # btrfs check --repair /dev/mapper/crypt-1 enabling repair mode
> Checking filesystem on /dev/mapper/crypt-1
> UUID: 504c2850-3977-4340-8849-18dd3ac2e5e4
> checking extents
> Check tree block failed, want=165396480, have=5385177728513973313
> Check tree block failed, want=165396480, have=5385177728513973313
> Check tree block failed, want=165396480, have=65536
> Check tree block failed, want=165396480, have=5385177728513973313
> Check tree block failed, want=165396480, have=5385177728513973313
> read block failed check_tree_block
> Check tree block failed, want=165740544, have=6895225932619678086
> Check tree block failed, want=165740544, have=6895225932619678086
> Check tree block failed, want=165740544, have=65536
> Check tree block failed, want=165740544, have=6895225932619678086
> Check tree block failed, want=165740544, have=6895225932619678086
> read block failed check_tree_block
> Check tree block failed, want=165756928, have=13399486021073017810
> Check tree block failed, want=165756928, have=13399486021073017810
> Check tree block failed, want=165756928, have=65536
> Check tree block failed, want=165756928, have=13399486021073017810
> Check tree block failed, want=165756928, have=13399486021073017810
> read block failed check_tree_block
> Check tree block failed, want=165773312, have=12571697019259051064
> Check tree block failed, want=165773312, have=12571697019259051064
> Check tree block failed, want=165773312, have=65536
> Check tree block failed, want=165773312, have=12571697019259051064
> Check tree block failed, want=165773312, have=12571697019259051064
> read block failed check_tree_block
> Check tree block failed, want=165789696, have=4069002570438424782
> Check tree block failed, want=165789696, have=4069002570438424782
> Check tree block failed, want=165789696, have=65536
> Check tree block failed, want=165789696, have=4069002570438424782
> Check tree block failed, want=165789696, have=4069002570438424782
> read block failed check_tree_block
> Check tree block failed, want=165838848, have=9612508092910615774
> Check tree block failed, want=165838848, have=9612508092910615774
> Check tree block failed, want=165838848, have=65536
> Check tree block failed, want=165838848, have=9612508092910615774
> Check tree block failed, want=165838848, have=9612508092910615774
> read block failed check_tree_block
> ref mismatch on [99516416 16384] extent item 1, found 0
> failed to repair damaged filesystem, aborting
>
>
>
> Trying a btrfs scrub is finishing with uncorrectable errors:
> # btrfs scrub start -d /dev/mapper/crypt-1 scrub started on
> /dev/mapper/crypt-1, fsid 504c2850-3977-4340-8849-18dd3ac2e5e4 (pid=2014)
> # btrfs scrub status -d /mnt/data/
> scrub status for 504c2850-3977-4340-8849-18dd3ac2e5e4
> scrub device /dev/mapper/crypt-1 (id 1) history
>         scrub started at Mon Jan 26 14:36:57 2015 and finished after 617
> seconds
>         total bytes scrubbed: 29.78GiB with 10906 errors
>         error details: csum=10906
>         corrected errors: 0, uncorrectable errors: 10906, unverified errors:
> 0
> scrub device /dev/mapper/crypt-2 (id 2)         no stats available
> scrub device /dev/mapper/crypt-3 (id 3)         no stats available
>
>
> Any chance to fix the errors or do I have to wait for the next btrfs
> version?
> Thank you very much,
> Alexander
>
>
> # uname -a
> Linux antares 3.18.0-9-generic #10-Ubuntu SMP Mon Jan 12 21:41:54 UTC 2015
> x86_64 x86_64 x86_64 GNU/Linux
>
> # btrfs --version
> Btrfs v3.18.1
>
> # btrfs fi show
> Label: 'antares-data'  uuid: 504c2850-3977-4340-8849-18dd3ac2e5e4
>           Total devices 3 FS bytes used 89.35GiB
>           devid    1 size 698.63GiB used 47.03GiB path /dev/mapper/crypt-1
>           devid    2 size 698.63GiB used 47.01GiB path /dev/mapper/crypt-2
>           devid    3 size 698.63GiB used 47.01GiB path /dev/mapper/crypt-3
>
> # btrfs fi df /mnt/data/
> Data, single: total=8.00MiB, used=0.00B
> Data, RAID5: total=92.00GiB, used=89.25GiB
> System, single: total=4.00MiB, used=0.00B
> System, RAID5: total=16.00MiB, used=16.00KiB
> Metadata, single: total=8.00MiB, used=0.00B
> Metadata, RAID5: total=2.00GiB, used=100.44MiB
> GlobalReserve, single: total=48.00MiB, used=0.00B
>
>
>
>
