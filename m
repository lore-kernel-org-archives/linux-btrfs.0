Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:36387 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbaDMUSW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 16:18:22 -0400
Received: by mail-we0-f176.google.com with SMTP id x48so7161082wes.7
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Apr 2014 13:18:21 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 13 Apr 2014 22:18:21 +0200
Message-ID: <CAA7TVBzRubwy-xUOGFGAJCi+mVvBBwwpqXHs9RRKxjpsrAd_=A@mail.gmail.com>
Subject: Btrfs RAID1 corrupted after crash
From: =?UTF-8?Q?Maximilian_Br=C3=A4utigam?= <m@xbra.de>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

unfortunately, I am very very deperate and I highly appreciate any help.
One week ago, I move my entire system to btrfs to setup a RAID1. I
created the RAID between device /dev/sdb and /dev/sdc with no
partition table on normal HDDs. Everything was working smoothly until
my computer crashed and at reboot I was not able to mount the device
(my home dir) again and got the following messages:

[  125.834802] BTRFS info (device sdc): disk space caching is enabled
[  130.600101] BTRFS error (device sdc): block group 1268688879616 has
wrong amount of free space
[  130.600113] BTRFS error (device sdc): failed to load free space
cache for block group 1268688879616
[  130.751274] BTRFS critical (device sdc): corrupt leaf, slot offset
bad: block=1268477591552,root=1, slot=137
[  130.751659] BTRFS critical (device sdc): corrupt leaf, slot offset
bad: block=1268477591552,root=1, slot=137

So I cleared the cache with trying the mount option clear_cache, but
it stayed problematic and I was not able to mount it:

[  368.159594] BTRFS: error (device sdc) in __btrfs_free_extent:5755:
errno=-5 IO failure
[  368.159602] BTRFS: error (device sdc) in
btrfs_run_delayed_refs:2713: errno=-5 IO failure
[  368.165584] BTRFS warning (device sdc): Skipping commit of aborted
transaction.
[  368.165589] BTRFS: error (device sdc) in cleanup_transaction:1545:
errno=-5 IO failure
[  368.165787] BTRFS: error (device sdc) in open_ctree:2839: errno=-5
IO failure (Failed to recover log tree)
[  368.227161] BTRFS: open_ctree failed

Now, if I tried to mount it manually with degraded option enabled:

# mount -t btrfs -o degraded /dev/sdb /mnt/sonst/
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

Now I run btrfsck with repair option enabled but still I cannot mount it.
Here you can find the dmesg and btrfsck outputs:
dmesg: http://pastebin.com/zsaKQ0h1
btrfsck: http://pastebin.com/xva6uJwT

Please, help me! ;( Are there other options to investigate my RAID or
to even temporarily mount it to get some data? What went wrong here?
What can I do? Why is a simple crash making my RAID unusable? Can I
use other tools for a recovery?

Again, every help is highly appreciated.
Best wishes,
Max
PS: Archlinux, linux-3.14-5, btrfs-progs-3.14-1
