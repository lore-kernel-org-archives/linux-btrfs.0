Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:34928 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933485Ab3BSUW2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 15:22:28 -0500
Received: by mail-oa0-f49.google.com with SMTP id j6so7452343oag.36
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2013 12:22:27 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 19 Feb 2013 14:22:27 -0600
Message-ID: <CAKcLGm-Zk_8mZZUwz3Y-rsM-_ySFOSSR0OYcK2VU=2iYFQ=ZWA@mail.gmail.com>
Subject: Snapshot Cleaner not Working with inode_cache
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've encountered an issue where the space from previously deleted
snapshots is not being freed up by the cleaner thread.

I'm only encountering this issue when I mount with the inode_cache option.

I've reproduced this on a 3.7.9 kernel merged with the latest
for-linus branch.  No additional patches are involved.  My testing
partition is 16 GB.

There is nothing in dmesg indicating any issues.

A simple manual test can reproduce the issue on my box

(1)  Format a fresh, scratch btrfs partition (it would probably work
with an existing test partition, but I always like to test things that
seem broken on a scratch partition).
(2)  Mount partition (my options are -o
compress-force=lzo,inode_cache).  My mount command was:
mount -o compress-force=lzo,inode_cache /dev/sda7 /mnt/benchmark/
(3)  Make a subvolume:  cd /mnt/<device>; btrfs su create test1
(4)  Untar kernel sources to the subvolume:  cd test1; tar -xpf
<path/to/kernel/source/tarball>
I believe anything you use to populate the subvolume is sufficient.
(5)  Make a note of the disk usage:  df -T /mnt/<device>
(6)  Remove the subvolume:  cd ..; btrfs su delete test1
(7)  Wait 2 minutes, and notice that the space has not been freed up.
I've waited much longer, but I forget the exact timeout on the cleaner
thread.
df -T /mnt/<device>

If I unmount and remount the partition with the same mount options,
the cleaner will begin to correctly free the space.

I've never used the inode_cache option before, so I'll try a few other
kernels to see if this is a regression.
