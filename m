Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:33577 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751622AbdHQFNH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 01:13:07 -0400
Received: by mail-ua0-f171.google.com with SMTP id r9so11767729uad.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 22:13:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR-WhXKKM27J2WKVwdMT589eBo+R9Ay0h9WG1EKZ6=oGg@mail.gmail.com>
References: <CAFcRpx4q7N1zG4gz-g6MgkU6c-F_gQ6+2-4ibgm+nyRCp5pTXQ@mail.gmail.com>
 <20170727151038.GT7140@carfax.org.uk> <pan$2c543$d5ad45a3$4b673920$5f7cee9a@cox.net>
 <CAJCQCtR-WhXKKM27J2WKVwdMT589eBo+R9Ay0h9WG1EKZ6=oGg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 16 Aug 2017 23:13:05 -0600
Message-ID: <CAJCQCtS2qihDyCNnHC4iq6jBB6Jy1sCUOJ-8QgfH21FCjSqOKA@mail.gmail.com>
Subject: Re: Raid0 rescue
To: Chris Murphy <lists@colorremedies.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK this time, also -mraid1 -draid0, and filled it with some more
metadata this time, but I then formatted NTFS, then ext4, then xfs.
And then wiped those signatures. Brutal, especially ext4 which writes
a lot more stuff and zeros a bunch of areas too.



# btrfs rescue super -v /dev/mapper/vg-2
All Devices:
    Device: id = 1, name = /dev/mapper/vg-1
    Device: id = 2, name = /dev/mapper/vg-2

Before Recovering:
    [All good supers]:
        device name = /dev/mapper/vg-1
        superblock bytenr = 65536

        device name = /dev/mapper/vg-1
        superblock bytenr = 67108864

        device name = /dev/mapper/vg-2
        superblock bytenr = 67108864

    [All bad supers]:

All supers are valid, no need to recover


Obviously vg-2 is missing its first superblock and this tool is not
complaining about it at all. Normal mount does not work (generic open
ctree error).

# btrfs check /dev/mapper/vg-1
warning, device 2 is missing
....

Umm, no. But yeah because the first super is missing the kernel isn't
considering it a Btrfs volume at all. There's also other errors with
the check, due to metadata being stepped on I'm guessing. But we need
a way to fix an obviously stepped on first super, and I don't like the
idea of using btrfs check for that anyway. All I need is the first
copy fixed up, and then just do a normal mount. But let's see how
messy this gets, pointing check to the damaged device and the known
good 2nd super (-s0 is the first super):

# btrfs check -s 1 /dev/mapper/vg-2
using SB copy 1, bytenr 67108864
...skipping checksum errors etc

OK so I guess I have to try --repair.

# btrfs check --repair -s1 /dev/mapper/vg-2
enabling repair mode
using SB copy 1, bytenr 67108864
...skipping checksum errors etc.

]# btrfs rescue super -v /dev/mapper/vg-1
All Devices:
    Device: id = 1, name = /dev/mapper/vg-1

Before Recovering:
    [All good supers]:
        device name = /dev/mapper/vg-1
        superblock bytenr = 67108864

    [All bad supers]:
        device name = /dev/mapper/vg-1
        superblock bytenr = 65536


That is fucked. It broke the previously good super on vg-1?

[root@f26wnuc ~]# btrfs rescue super -v /dev/mapper/vg-2
All Devices:
    Device: id = 1, name = /dev/mapper/vg-1
    Device: id = 2, name = /dev/mapper/vg-2

Before Recovering:
    [All good supers]:
        device name = /dev/mapper/vg-1
        superblock bytenr = 67108864

        device name = /dev/mapper/vg-2
        superblock bytenr = 67108864

    [All bad supers]:
        device name = /dev/mapper/vg-1
        superblock bytenr = 65536


Worse, it did not actually fix the bad/missing superblock on vg-2
either. Let's answer Y to its questions...

[root@f26wnuc ~]# btrfs rescue super -v /dev/mapper/vg-2
All Devices:
    Device: id = 1, name = /dev/mapper/vg-1
    Device: id = 2, name = /dev/mapper/vg-2

Before Recovering:
    [All good supers]:
        device name = /dev/mapper/vg-1
        superblock bytenr = 67108864

        device name = /dev/mapper/vg-2
        superblock bytenr = 67108864

    [All bad supers]:
        device name = /dev/mapper/vg-1
        superblock bytenr = 65536


Make sure this is a btrfs disk otherwise the tool will destroy other
fs, Are you sure? [y/N]: y
checksum verify failed on 20971520 found 348F13AD wanted 00008100
checksum verify failed on 20971520 found 348F13AD wanted 00008100
Recovered bad superblocks successful
[root@f26wnuc ~]# btrfs rescue super -v /dev/mapper/vg-2
All Devices:
    Device: id = 1, name = /dev/mapper/vg-1
    Device: id = 2, name = /dev/mapper/vg-2

Before Recovering:
    [All good supers]:
        device name = /dev/mapper/vg-1
        superblock bytenr = 65536

        device name = /dev/mapper/vg-1
        superblock bytenr = 67108864

        device name = /dev/mapper/vg-2
        superblock bytenr = 65536

        device name = /dev/mapper/vg-2
        superblock bytenr = 67108864

    [All bad supers]:

All supers are valid, no need to recover



OK! That's better! Mount it.

dmesg
https://pastebin.com/6kVzYLfZ

Pretty boring, bad tree block, and then some read errors corrected. I
get more similarly formatted errors, different numbers... but no
failures. Scrub it...

# btrfs scrub status /mnt/yo
scrub status for b2ee5125-cf56-493a-b094-81fe8330115a
    scrub started at Wed Aug 16 23:08:54 2017, running for 00:00:30
    total bytes scrubbed: 1.19GiB with 5 errors
    error details: csum=5
    corrected errors: 5, uncorrectable errors: 0, unverified errors: 0
#

There's almost no data on this file system, it's mostly metadata which
is raid1 so that's why data survives. But even in the previous example
where some data is clobbered, the data loss is limited. The file
system itself survives, and can continue to be used. The 'btrfs rescue
super' function could be better, and it looks like there's a bug in
btrfs check's superblock repair.



Chris Murphy
