Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v-27-120-84-145.ub-freebit.net ([27.120.84.145]:41259 "EHLO
        mail.reasonset.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbcH1F2y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 01:28:54 -0400
Received: from rose (218-45-17-226.flets.kamome.or.jp [218.45.17.226])
        by mail.reasonset.net (Postfix) with ESMTPSA id E8BA67C48001
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 14:22:52 +0900 (JST)
Date: Sun, 28 Aug 2016 14:22:52 +0900
From: MASAKI Yuhsuke <yek@reasonset.net>
To: linux-btrfs@vger.kernel.org
Subject: Crush on btrfs device delete missing
Message-ID: <20160828142252.0ded31f7@rose>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs device delete missing always crushes and stop system.
It log console only not STDOUT/STDERR or core file.

This is copy from leaved message on console's last screen.

=====
oops_end+0x9c/0cd0
die+0x4b/0x70
do_trap+0xb2/0x140
do_error_trap+0x89/0x110
? update_inline_extent_backref+0x2ab/0x2b0 [btrfs]
? btrfs_set_lock_blocking_rw+0x80/0c0 [btrfs]
do_invalid_op+0x20/0x30
invalid_op+0x1e/0x30
? update_inline_extent_backref+0x2ab/0x2b0 [btrfs]
? update_inline_extent_backref+0x1e8/0x2b0 [btrfs]
remove_extent_backref+0x3f/0x80 [btrfs]
__btrfs_free_extent.isra.34+0x709/0x80 [btrfs]
__btrfs_run_delayed_refs+0x567/0x1260 [btrfs]
btrfs_run_delayed_refs+0x0x9f/0x2c0 [btrfs]
delayed_ref_async_start+0x94/0xb0 [btrfs]
btrfs_scrubparity_helper+0x77/0x350
btrfs_extent_refs_helper+0xe/0x10 [btrfs]
? process_one_work+0x480/0x480
kthread+0xd8/0xf0
ret_from_fork+0x1f/0x40
? kthread_worker_fn+0x170/0x170
=====

This btrfs volume has seven disks including new blank disk and removed
missing disk, and it's mounted with degraded option.

---
MASAKI Yuhsuke <yek@reasonset.net>
