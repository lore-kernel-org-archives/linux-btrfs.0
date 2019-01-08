Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD88C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9D19206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546947793;
	bh=BaAWNy44Ue9kKhbdasAm5gkesSwMxJ32hdk5hkOARKg=;
	h=From:To:Subject:Date:List-ID:From;
	b=amy20gxV9d71an35ESJAd4JQQU/anBHxD6STb/v9o0irb3gTrMMqFAFQfxMCmrbKc
	 Mx/j+9AppDq75R7xvd1SxZztRK5Gakl1TcHsPQFfRMp6wfF6JXwUQpJ0zF0F84vBmn
	 IQTmalRq/XUkHko1QkN/Ob/M9bQjnTMj1IOB3M8U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbfAHLnL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 06:43:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727701AbfAHLnL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 06:43:11 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5499E206B7
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Jan 2019 11:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546947789;
        bh=BaAWNy44Ue9kKhbdasAm5gkesSwMxJ32hdk5hkOARKg=;
        h=From:To:Subject:Date:From;
        b=aKlM7oTojd/MVUA/Q0Owg99+Qx4/6o+9BiP2ouDbMuSdWgXvK4kLekkWj9ZghaTi+
         EyfDwj66dLwE/GxH2dhBrVyRwUEvObCyQdVSvgvs5pjncR+mg9yn/LfBjw03uUpZsO
         9YqPl5xtbqhV2Mb0iJ3SYsktJDnZuYo2kGPckqmM=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix race between reflink/dedupe and relocation
Date:   Tue,  8 Jan 2019 11:43:07 +0000
Message-Id: <20190108114307.3509-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The recent rework that makes btrfs' remap_file_range operation use the
generic helper generic_remap_file_range_prep() introduced a race between
relocation and reflinking (for both cloning and deduplication) the file
extents between the source and destination inodes.

This happens because we no longer lock the source range anymore, and we do
not lock it anymore because we wait for direct IO writes and writeback to
complete early on the code path right after locking the inodes, which
guarantees no other file operations interfere with the reflinking. However
there is one exception which is relocation, since it replaces the byte
number of file extents items in the fs tree after locking the range the
file extent items represent. This is a problem because after finding each
file extent to clone in the fs tree, the reflink process copies the file
extent item into a local buffer, releases the search path, inserts new
file extent items in the destination range and then increments the
reference count for the extent mentioned in the file extent item that it
previously copied to the buffer. If right after copying the file extent
item into the buffer and releasing the path the relocation process
updates the file extent item to point to the new extent, the reflink
process ends up creating a delayed reference to increment the reference
count of the old extent, for which the relocation process already created
a delayed reference to drop it. This results in failure to run delayed
references because we will attempt to increment the count of a reference
that was already dropped. This is illustrated by the following diagram:

        CPU 1                                       CPU 2

                                        relocation is running

  btrfs_clone_files()

    btrfs_clone()
      --> finds extent item
          in source range
          point to extent
          at bytenr X
      --> copies it into a
          local buffer
      --> releases path

                                        replace_file_extents()
                                          --> successfully locks the
                                              range represented by
                                              the file extent item
                                          --> replaces disk_bytenr
                                              field in the file
                                              extent item with some
                                              other value Y
                                          --> creates delayed reference
                                              to increment reference
                                              count for extent at
                                              bytenr Y
                                          --> creates delayed reference
                                              to drop the extent at
                                              bytenr X

      --> starts transaction
      --> creates delayed
          reference to
          increment extent
          at bytenr X

                    <delayed references are run, due to a transaction
                     commit for example, and the transaction is aborted
                     with -EIO because we attempt to increment reference
                     count for the extent at bytenr X after we freed it>

When this race is hit the running transaction ends up getting aborted with
an -EIO error and a trace like the following is produced:

[ 4382.553858] WARNING: CPU: 2 PID: 3648 at fs/btrfs/extent-tree.c:1552 lookup_inline_extent_backref+0x4f4/0x650 [btrfs]
(...)
[ 4382.556293] CPU: 2 PID: 3648 Comm: btrfs Tainted: G        W         4.20.0-rc6-btrfs-next-41 #1
[ 4382.556294] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626ccb91-prebuilt.qemu-project.org 04/01/2014
[ 4382.556308] RIP: 0010:lookup_inline_extent_backref+0x4f4/0x650 [btrfs]
(...)
[ 4382.556310] RSP: 0018:ffffac784408f738 EFLAGS: 00010202
[ 4382.556311] RAX: 0000000000000001 RBX: ffff8980673c3a48 RCX: 0000000000000001
[ 4382.556312] RDX: 0000000000000008 RSI: 0000000000000000 RDI: 0000000000000000
[ 4382.556312] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
[ 4382.556313] R10: 0000000000000001 R11: ffff897f40000000 R12: 0000000000001000
[ 4382.556313] R13: 00000000c224f000 R14: ffff89805de9bd40 R15: ffff8980453f4548
[ 4382.556315] FS:  00007f5e759178c0(0000) GS:ffff89807b300000(0000) knlGS:0000000000000000
[ 4382.563130] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4382.563562] CR2: 00007f2e9789fcbc CR3: 0000000120512001 CR4: 00000000003606e0
[ 4382.564005] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4382.564451] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 4382.564887] Call Trace:
[ 4382.565343]  insert_inline_extent_backref+0x55/0xe0 [btrfs]
[ 4382.565796]  __btrfs_inc_extent_ref.isra.60+0x88/0x260 [btrfs]
[ 4382.566249]  ? __btrfs_run_delayed_refs+0x93/0x1650 [btrfs]
[ 4382.566702]  __btrfs_run_delayed_refs+0xa22/0x1650 [btrfs]
[ 4382.567162]  btrfs_run_delayed_refs+0x7e/0x1d0 [btrfs]
[ 4382.567623]  btrfs_commit_transaction+0x50/0x9c0 [btrfs]
[ 4382.568112]  ? _raw_spin_unlock+0x24/0x30
[ 4382.568557]  ? block_rsv_release_bytes+0x14e/0x410 [btrfs]
[ 4382.569006]  create_subvol+0x3c8/0x830 [btrfs]
[ 4382.569461]  ? btrfs_mksubvol+0x317/0x600 [btrfs]
[ 4382.569906]  btrfs_mksubvol+0x317/0x600 [btrfs]
[ 4382.570383]  ? rcu_sync_lockdep_assert+0xe/0x60
[ 4382.570822]  ? __sb_start_write+0xd4/0x1c0
[ 4382.571262]  ? mnt_want_write_file+0x24/0x50
[ 4382.571712]  btrfs_ioctl_snap_create_transid+0x117/0x1a0 [btrfs]
[ 4382.572155]  ? _copy_from_user+0x66/0x90
[ 4382.572602]  btrfs_ioctl_snap_create+0x66/0x80 [btrfs]
[ 4382.573052]  btrfs_ioctl+0x7c1/0x30e0 [btrfs]
[ 4382.573502]  ? mem_cgroup_commit_charge+0x8b/0x570
[ 4382.573946]  ? do_raw_spin_unlock+0x49/0xc0
[ 4382.574379]  ? _raw_spin_unlock+0x24/0x30
[ 4382.574803]  ? __handle_mm_fault+0xf29/0x12d0
[ 4382.575215]  ? do_vfs_ioctl+0xa2/0x6f0
[ 4382.575622]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
[ 4382.576020]  do_vfs_ioctl+0xa2/0x6f0
[ 4382.576405]  ksys_ioctl+0x70/0x80
[ 4382.576776]  __x64_sys_ioctl+0x16/0x20
[ 4382.577137]  do_syscall_64+0x60/0x1b0
[ 4382.577488]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
(...)
[ 4382.578837] RSP: 002b:00007ffe04bf64c8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[ 4382.579174] RAX: ffffffffffffffda RBX: 00005564136f3050 RCX: 00007f5e74724dd7
[ 4382.579505] RDX: 00007ffe04bf64d0 RSI: 000000005000940e RDI: 0000000000000003
[ 4382.579848] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000044
[ 4382.580164] R10: 0000000000000541 R11: 0000000000000202 R12: 00005564136f3010
[ 4382.580477] R13: 0000000000000003 R14: 00005564136f3035 R15: 00005564136f3050
[ 4382.580792] irq event stamp: 0
[ 4382.581106] hardirqs last  enabled at (0): [<0000000000000000>]           (null)
[ 4382.581441] hardirqs last disabled at (0): [<ffffffff8d085842>] copy_process.part.32+0x6e2/0x2320
[ 4382.581772] softirqs last  enabled at (0): [<ffffffff8d085842>] copy_process.part.32+0x6e2/0x2320
[ 4382.582095] softirqs last disabled at (0): [<0000000000000000>]           (null)
[ 4382.582413] ---[ end trace d3c188e3e9367382 ]---
[ 4382.623855] BTRFS: error (device sdc) in btrfs_run_delayed_refs:2981: errno=-5 IO failure
[ 4382.624295] BTRFS info (device sdc): forced readonly

Fix this by locking the source range before searching for the file extent
items in the fs tree, since the relocation process will try to lock the
range a file extent item represents before updating it with the new extent
location.

Fixes: 34a28e3d7753 ("Btrfs: use generic_remap_file_range_prep() for cloning and deduplication")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0db60bfee99a..996a26befc1d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3221,6 +3221,26 @@ static void btrfs_double_inode_lock(struct inode *inode1, struct inode *inode2)
 	inode_lock_nested(inode2, I_MUTEX_CHILD);
 }
 
+static void btrfs_double_extent_unlock(struct inode *inode1, u64 loff1,
+				       struct inode *inode2, u64 loff2, u64 len)
+{
+	unlock_extent(&BTRFS_I(inode1)->io_tree, loff1, loff1 + len - 1);
+	unlock_extent(&BTRFS_I(inode2)->io_tree, loff2, loff2 + len - 1);
+}
+
+static void btrfs_double_extent_lock(struct inode *inode1, u64 loff1,
+				     struct inode *inode2, u64 loff2, u64 len)
+{
+	if (inode1 < inode2) {
+		swap(inode1, inode2);
+		swap(loff1, loff2);
+	} else if (inode1 == inode2 && loff2 < loff1) {
+		swap(loff1, loff2);
+	}
+	lock_extent(&BTRFS_I(inode1)->io_tree, loff1, loff1 + len - 1);
+	lock_extent(&BTRFS_I(inode2)->io_tree, loff2, loff2 + len - 1);
+}
+
 static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 olen,
 				   struct inode *dst, u64 dst_loff)
 {
@@ -3242,11 +3262,12 @@ static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 olen,
 		return -EINVAL;
 
 	/*
-	 * Lock destination range to serialize with concurrent readpages().
+	 * Lock destination range to serialize with concurrent readpages() and
+	 * source range to serialize with relocation.
 	 */
-	lock_extent(&BTRFS_I(dst)->io_tree, dst_loff, dst_loff + len - 1);
+	btrfs_double_extent_lock(src, loff, dst, dst_loff, len);
 	ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
-	unlock_extent(&BTRFS_I(dst)->io_tree, dst_loff, dst_loff + len - 1);
+	btrfs_double_extent_unlock(src, loff, dst, dst_loff, len);
 
 	return ret;
 }
@@ -3926,11 +3947,12 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	}
 
 	/*
-	 * Lock destination range to serialize with concurrent readpages().
+	 * Lock destination range to serialize with concurrent readpages() and
+	 * source range to serialize with relocation.
 	 */
-	lock_extent(&BTRFS_I(inode)->io_tree, destoff, destoff + len - 1);
+	btrfs_double_extent_lock(src, off, inode, destoff, len);
 	ret = btrfs_clone(src, inode, off, olen, len, destoff, 0);
-	unlock_extent(&BTRFS_I(inode)->io_tree, destoff, destoff + len - 1);
+	btrfs_double_extent_unlock(src, off, inode, destoff, len);
 	/*
 	 * Truncate page cache pages so that future reads will see the cloned
 	 * data immediately and not the previous data.
-- 
2.11.0

