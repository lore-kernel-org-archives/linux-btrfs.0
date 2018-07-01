Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57898 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965503AbeGAQ12 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2018 12:27:28 -0400
Date: Sun, 1 Jul 2018 09:27:22 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20180701162722.mnm5wjgxc7weymiz@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: btrfs check of a raid0?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Howdy,

I have a btrfs filesystem made out of 2 devices:
[   75.141414] BTRFS: device label btrfs_space devid 1 transid 429220 /dev/bcache3
[   75.164745] BTRFS: device label btrfs_space devid 2 transid 429220 /dev/bcache2

One of the 2 devices had a hardware error (not btrfs' fault):
[201504.939659] BTRFS error (device bcache3): bdev /dev/bcache2 errs: wr 552, rd 39, flush 1, corrupt 0, gen 0
[201504.995967] BTRFS warning (device bcache3): bcache3 checksum verify failed on 399998976 wanted F3019EEA found E6A97DC4 level 0
[201505.032209] BTRFS error (device bcache3): bdev /dev/bcache2 errs: wr 552, rd 40, flush 1, corrupt 0, gen 0
[201505.062447] BTRFS error (device bcache3): parent transid verify failed on 399998976 wanted 434763 found 434245
[201600.262142] BTRFS error (device bcache3): bdev /dev/bcache2 errs: wr 552, rd 41, flush 1, corrupt 0, gen 0

I unmounted it, and I'm trying to check the filesystem now.

How is it supposed to work when you have multiple devices for a btrfs
filesystem?

gargamel:~# btrfs check --repair -p /dev/bcache2 
enabling repair mode
ERROR: mount check: cannot open /dev/bcache2: No such device or address
ERROR: could not check mount status: No such device or address
gargamel:~# btrfs check --repair -p /dev/bcache3
enabling repair mode
ERROR: cannot open device '/dev/bcache3': Device or resource busy
ERROR: cannot open file system

[205248.299528] BTRFS info (device bcache3): disk space caching is enabled
[205248.320335] BTRFS error (device bcache3): Remounting read-write after error is not allowed

Yes, rebooting should likely get around the problem, but I'd rather not
reboot, I have long running stuff I would rather not stop.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
