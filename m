Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:34090 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759635AbeD1IaU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 04:30:20 -0400
Received: by mail-vk0-f46.google.com with SMTP id t63-v6so2481240vkb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Apr 2018 01:30:20 -0700 (PDT)
MIME-Version: 1.0
From: Michael Wade <spikewade@gmail.com>
Date: Sat, 28 Apr 2018 09:30:19 +0100
Message-ID: <CAB+znrFyimDnOZt46CqterRJ6MvwD4TSWagQvv-oQxjPvG-m2w@mail.gmail.com>
Subject: BTRFS RAID filesystem unmountable
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I was hoping that someone would be able to help me resolve the issues
I am having with my ReadyNAS BTRFS volume. Basically my trouble
started after a power cut, subsequently the volume would not mount.
Here are the details of my setup as it is at the moment:

uname -a
Linux QAI 4.4.116.alpine.1 #1 SMP Mon Feb 19 21:58:38 PST 2018 armv7l GNU/Linux

btrfs --version
btrfs-progs v4.12

btrfs fi show
Label: '11baed92:data'  uuid: 20628cda-d98f-4f85-955c-932a367f8821
Total devices 1 FS bytes used 5.12TiB
devid    1 size 7.27TiB used 6.24TiB path /dev/md127

Here are the relevant dmesg logs for the current state of the device:

[   19.119391] md: md127 stopped.
[   19.120841] md: bind<sdb3>
[   19.121120] md: bind<sdc3>
[   19.121380] md: bind<sda3>
[   19.125535] md/raid:md127: device sda3 operational as raid disk 0
[   19.125547] md/raid:md127: device sdc3 operational as raid disk 2
[   19.125554] md/raid:md127: device sdb3 operational as raid disk 1
[   19.126712] md/raid:md127: allocated 3240kB
[   19.126778] md/raid:md127: raid level 5 active with 3 out of 3
devices, algorithm 2
[   19.126784] RAID conf printout:
[   19.126789]  --- level:5 rd:3 wd:3
[   19.126794]  disk 0, o:1, dev:sda3
[   19.126799]  disk 1, o:1, dev:sdb3
[   19.126804]  disk 2, o:1, dev:sdc3
[   19.128118] md127: detected capacity change from 0 to 7991637573632
[   19.395112] Adding 523708k swap on /dev/md1.  Priority:-1 extents:1
across:523708k
[   19.434956] BTRFS: device label 11baed92:data devid 1 transid
151800 /dev/md127
[   19.739276] BTRFS info (device md127): setting nodatasum
[   19.740440] BTRFS critical (device md127): unable to find logical
3208757641216 len 4096
[   19.740450] BTRFS critical (device md127): unable to find logical
3208757641216 len 4096
[   19.740498] BTRFS critical (device md127): unable to find logical
3208757641216 len 4096
[   19.740512] BTRFS critical (device md127): unable to find logical
3208757641216 len 4096
[   19.740552] BTRFS critical (device md127): unable to find logical
3208757641216 len 4096
[   19.740560] BTRFS critical (device md127): unable to find logical
3208757641216 len 4096
[   19.740576] BTRFS error (device md127): failed to read chunk root
[   19.783975] BTRFS error (device md127): open_ctree failed

In an attempt to recover the volume myself I run a few BTRFS commands
mostly using advice from here:
https://lists.opensuse.org/opensuse/2017-02/msg00930.html. However
that actually seems to have made things worse as I can no longer mount
the file system, not even in readonly mode.

So starting from the beginning here is a list of things I have done so
far (hopefully I remembered the order in which I ran them!)

1. Noticed that my backups to the NAS were not running (didn't get
notified that the volume had basically "died")
2. ReadyNAS UI indicated that the volume was inactive.
3. SSHed onto the box and found that the first drive was not marked as
operational (log showed I/O errors / UNKOWN (0x2003))  so I replaced
the disk and let the array resync.
4. After resync the volume still was unaccessible so I looked at the
logs once more and saw something like the following which seemed to
indicate that the replay log had been corrupted when the power went
out:

BTRFS critical (device md127): corrupt leaf, non-root leaf's nritems
is 0: block=232292352, root=7, slot=0
BTRFS critical (device md127): corrupt leaf, non-root leaf's nritems
is 0: block=232292352, root=7, slot=0
BTRFS: error (device md127) in btrfs_replay_log:2524: errno=-5 IO
failure (Failed to recover log tree)
BTRFS error (device md127): pending csums is 155648
BTRFS error (device md127): cleaner transaction attach returned -30
BTRFS critical (device md127): corrupt leaf, non-root leaf's nritems
is 0: block=232292352, root=7, slot=0

5. Then:

btrfs rescue zero-log

6. Was then able to mount the volume in readonly mode.

btrfs scrub start

Which fixed some errors but not all:

scrub status for 20628cda-d98f-4f85-955c-932a367f8821

scrub started at Tue Apr 24 17:27:44 2018, running for 04:00:34
total bytes scrubbed: 224.26GiB with 6 errors
error details: csum=6
corrected errors: 0, uncorrectable errors: 6, unverified errors: 0

scrub status for 20628cda-d98f-4f85-955c-932a367f8821
scrub started at Tue Apr 24 17:27:44 2018, running for 04:34:43
total bytes scrubbed: 224.26GiB with 6 errors
error details: csum=6
corrected errors: 0, uncorrectable errors: 6, unverified errors: 0

6. Seeing this hanging I rebooted the NAS
7. Think this is when the volume would not mount at all.
8. Seeing log entries like these:

BTRFS warning (device md127): checksum error at logical 20800943685632
on dev /dev/md127, sector 520167424: metadata node (level 1) in tree 3

I ran

btrfs check --fix-crc

And that brings us to where I am now: Some seemly corrupted BTRFS
metadata and unable to mount the drive even with the recovery option.

Any help you can give is much appreciated!

Kind regards
Michael
