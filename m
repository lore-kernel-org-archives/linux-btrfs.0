Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35217 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750850AbdHUEd2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 00:33:28 -0400
Received: by mail-oi0-f54.google.com with SMTP id r200so7521431oie.2
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Aug 2017 21:33:27 -0700 (PDT)
MIME-Version: 1.0
From: Robert LeBlanc <robert@leblancnet.us>
Date: Sun, 20 Aug 2017 22:33:26 -0600
Message-ID: <CAANLjFoLZ_CtO1XQNRfSCu0p2OSN7HECscAPy5ru6dTt3-qffQ@mail.gmail.com>
Subject: Btrfs Raid5 issue.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been running btrfs in a raid5 for about a year now with bcache in
front of it. Yesterday, one of my drives was acting really slow, so I
was going to move it to a different port. I guess I get too
comfortable hot plugging drives in at work and didn't think twice
about what could go wrong, hey I set it up in RAID5 so it will be
fine. Well, it wasn't...

I was aware of the write hole issue, and thought it was committed to
the 4.12 branch, so I was running 4.12.5 at the time. I have two SSDs
that are in an md RAID1 that is the cache for the three backing
devices in bcache (bcache{0..2} or bcache{0,16,32} depending on the
kernel booted. I have all my critical data saved off on btrfs
snapshots on a different host, but I don't transfer my MythTV subs
that often, so I'd like to try to recover some of that if possible.

What is really interesting is that I could not boot the first time
(root on the btrfs volume), but I rebooted again and the fs was in
read-only mode, but only one of the three disks was in read-only. I
tried to reboot again and it never mounted again after that. I see
some messages in dmesg like this:

[  151.201637] BTRFS info (device bcache0): disk space caching is enabled
[  151.201640] BTRFS info (device bcache0): has skinny extents
[  151.215697] BTRFS info (device bcache0): bdev /dev/bcache16 errs:
wr 309, rd 319, flush 39, corrupt 0, gen 0
[  151.931764] BTRFS info (device bcache0): detected SSD devices,
enabling SSD mode
[  152.058915] BTRFS error (device bcache0): parent transid verify
failed on 5309837426688 wanted 1620383 found 1619473
[  152.059944] BTRFS error (device bcache0): parent transid verify
failed on 5309837426688 wanted 1620383 found 1619473
[  152.060018] BTRFS: error (device bcache0) in
__btrfs_free_extent:6989: errno=-5 IO failure
[  152.060060] BTRFS: error (device bcache0) in
btrfs_run_delayed_refs:3009: errno=-5 IO failure
[  152.071613] BTRFS info (device bcache0): delayed_refs has NO entry
[  152.074126] BTRFS: error (device bcache0) in btrfs_replay_log:2475:
errno=-5 IO failure (Failed to recover log tree)
[  152.074244] BTRFS error (device bcache0): cleaner transaction
attach returned -30
[  152.148993] BTRFS error (device bcache0): open_ctree failed

So, I thought that the log was corrupted, I could live without the
last 30 seconds or so, I tried `btrfs rescue zero-log /dev/bcache0`
and I get a backtrace. I ran `btrfs rescue chunk-recover /dev/bcache0`
and it spent hours scanning the three disks and at the end tried to
fix the logs (or tree, I can't remember exactly) and then I got
another backtrace.

Today, I compiled 4.13-rc6 to see if some of the latest fixes would
help, no dice (the dmesg above is from 4.13-rc6). I compiled the
latest master of btrfs-progs, no progress.

Things I've tried:
mount
mount -o degraded
mount -o degraded,ro
mount -o degraded (with each drive disconnected in turn to see if in
would start without one of the drives)
btrfs rescue chunk-recover
btrfs rescue super-recover (all drives report the superblocks are fine)
btrfs rescue zero-log (always has a backtrace)
btrfs check

I know that bcache complicates things, but I'm hoping for two things.
1. Try to get what I can off the volume. 2. Provide some information
that can help make btrfs/bcache better for the future.

Here is what `btrfs rescue zero-log` outputs:

# ./btrfs rescue zero-log /dev/bcache0
Clearing log on /dev/bcache0, previous log_root 2876047507456, level 0
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
bytenr mismatch, want=5309233872896, have=65536
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
bytenr mismatch, want=5309233872896, have=65536
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
bytenr mismatch, want=5309233872896, have=65536
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
bytenr mismatch, want=5309233872896, have=65536
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
bytenr mismatch, want=5309233872896, have=65536
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
bytenr mismatch, want=5309233872896, have=65536
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
bytenr mismatch, want=5309233872896, have=65536
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
parent transid verify failed on 5309233872896 wanted 1620381 found 1619462
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
checksum verify failed on 5309233872896 found 6A103358 wanted 8EF38EEE
bytenr mismatch, want=5309233872896, have=65536
btrfs unable to find ref byte nr 5310039638016 parent 0 root 2  owner 2 offset 0
parent transid verify failed on 5309275930624 wanted 1620381 found 1619462
parent transid verify failed on 5309275930624 wanted 1620381 found 1619462
checksum verify failed on 5309275930624 found A2FDBB6A wanted 461E06DC
parent transid verify failed on 5309275930624 wanted 1620381 found 1619462
Ignoring transid failure
bad key ordering 67 68
btrfs unable to find ref byte nr 5310039867392 parent 0 root 2  owner 1 offset 0
bad key ordering 67 68
extent-tree.c:2725: alloc_reserved_tree_block: BUG_ON `ret` triggered, value -1
./btrfs(+0x1c624)[0x562fde546624]
./btrfs(+0x1d91a)[0x562fde54791a]
./btrfs(+0x1da2b)[0x562fde547a2b]
./btrfs(+0x1f3a5)[0x562fde5493a5]
./btrfs(+0x1f91f)[0x562fde54991f]
./btrfs(btrfs_alloc_free_block+0xd2)[0x562fde54c20c]
./btrfs(__btrfs_cow_block+0x182)[0x562fde53c778]
./btrfs(btrfs_cow_block+0xea)[0x562fde53d0ea]
./btrfs(+0x185a3)[0x562fde5425a3]
./btrfs(btrfs_commit_transaction+0x96)[0x562fde54411c]
./btrfs(+0x6a702)[0x562fde594702]
./btrfs(handle_command_group+0x44)[0x562fde53b40c]
./btrfs(cmd_rescue+0x15)[0x562fde59486d]
./btrfs(main+0x85)[0x562fde53b5c3]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7fd3931692b1]
./btrfs(_start+0x2a)[0x562fde53b13a]
Aborted

Please let me know if there is any other information I can provide
that would be helpful.

Thank you,

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
