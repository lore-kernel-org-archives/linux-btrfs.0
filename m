Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:46136 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbJAKuM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Oct 2015 06:50:12 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 1 Oct 2015 16:20:10 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 60ABFE0054
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2015 16:19:52 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t91Ao6jt42074132
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Oct 2015 16:20:06 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t91Ao5RI021118
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Oct 2015 16:20:06 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        chandan@mykolab.com
Subject: [PATCH] Btrfs: create_subvol: Commit the current transaction if stale root entry exists.
Date: Thu,  1 Oct 2015 16:19:55 +0530
Message-Id: <1443696595-20641-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following call trace is seen when btrfs/031 test is executed in a loop,

[  120.577208] WARNING: CPU: 3 PID: 6202 at /home/chandan/repos/linux/fs/btrfs/ioctl.c:558 create_subvol+0x3e6/0x729()
[  120.581521] BTRFS: Transaction aborted (error -2)
[  120.585410] Modules linked in:
[  120.587460] CPU: 3 PID: 6202 Comm: btrfs Not tainted 4.2.0-rc5+ #27
[  120.591232] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[  120.596134]  ffffffff81c009d0 ffff880c846ff918 ffffffff81988f34 0000000000000001
[  120.600754]  ffff880c846ff968 ffff880c846ff958 ffffffff81050315 ffff880c846ff938
[  120.605166]  ffff880c85ae6000 ffff8809b944e000 ffff880a96c5a448 0000000000000000
[  120.609589] Call Trace:
[  120.610936]  [<ffffffff81988f34>] dump_stack+0x45/0x57
[  120.613868]  [<ffffffff81050315>] warn_slowpath_common+0x85/0xc0
[  120.616812]  [<ffffffff81050391>] warn_slowpath_fmt+0x41/0x50
[  120.619681]  [<ffffffff81985a84>] create_subvol+0x3e6/0x729
[  120.622390]  [<ffffffff8112d977>] ? zone_statistics+0x77/0x90
[  120.625111]  [<ffffffff8136577e>] btrfs_mksubvol.isra.30+0x37e/0x530
[  120.628091]  [<ffffffff8111a248>] ? __alloc_pages_nodemask+0x1b8/0x950
[  120.631091]  [<ffffffff81180f6a>] ? __mnt_want_write_file+0x1a/0x30
[  120.635156]  [<ffffffff81365a31>] btrfs_ioctl_snap_create_transid+0x101/0x180
[  120.639936]  [<ffffffff81365b02>] btrfs_ioctl_snap_create+0x52/0x70
[  120.643942]  [<ffffffff813684ae>] btrfs_ioctl+0x46e/0x2450
[  120.647204]  [<ffffffff8111f926>] ? lru_cache_add_active_or_unevictable+0x26/0x80
[  120.651647]  [<ffffffff81174dd1>] do_vfs_ioctl+0x2c1/0x4a0
[  120.655111]  [<ffffffff813be198>] ? selinux_file_ioctl+0x48/0xd0
[  120.658500]  [<ffffffff813b875e>] ? security_file_ioctl+0x3e/0x60
[  120.661680]  [<ffffffff81175024>] SyS_ioctl+0x74/0x80
[  120.664464]  [<ffffffff819932d7>] entry_SYSCALL_64_fastpath+0x12/0x6a
[  120.667824] ---[ end trace 13f2ab1e5917a256 ]---
[  120.670159] BTRFS: error (device loop0) in create_subvol:558: errno=-2 No such entry
[  120.673872] BTRFS info (device loop0): forced readonly
[  120.701265] BTRFS info (device loop0): disk space caching is enabled
[  120.704934] BTRFS error (device loop0): Remounting read-write after error is not allowed
[  120.904385] BTRFS error (device loop0): cleaner transaction attach returned -30

This occurs because,

Mount filesystem
Create subvol with ID 257
Unmount filesystem
Mount filesystem
Delete subvol with ID 257
  btrfs_drop_snapshot()
    Add root corresponding to subvol 257 into
    btrfs_transaction->dropped_roots list
Create new subvol (i.e. create_subvol())
  257 is returned as the next free objectid
  btrfs_read_fs_root_no_name()
    Finds the btrfs_root instance corresponding to the old subvol with ID 257
    in btrfs_fs_info->fs_roots_radix.
    Returns error since btrfs_root_item->refs has the value of 0.

To fix the issue we now check for the existance of stale btrfs_root entry in
the btrfs_fs_info->fs_roots_radix tree and if such an entry does exist we
commit the current transaction.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c |  4 ++--
 fs/btrfs/disk-io.h |  2 ++
 fs/btrfs/ioctl.c   | 26 ++++++++++++++++++++------
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index aa59871..0c9e9d2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1583,8 +1583,8 @@ fail:
 	return ret;
 }
 
-static struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
-					       u64 root_id)
+struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
+					u64 root_id)
 {
 	struct btrfs_root *root;
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index bdfb479..7f06e1f 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -86,6 +86,8 @@ void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root);
 void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
 				 struct btrfs_root *root);
 void btrfs_free_fs_root(struct btrfs_root *root);
+struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
+					u64 root_id);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct btrfs_root *btrfs_alloc_dummy_root(void);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0adf542..7123e96 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -474,13 +474,27 @@ static noinline int create_subvol(struct inode *dir,
 	if (ret)
 		return ret;
 
-	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans)) {
-		ret = PTR_ERR(trans);
-		btrfs_subvolume_release_metadata(root, &block_rsv,
-						 qgroup_reserved);
-		return ret;
+	while (1) {
+		trans = btrfs_start_transaction(root, 0);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			btrfs_subvolume_release_metadata(root, &block_rsv,
+							qgroup_reserved);
+			return ret;
+		}
+
+		new_root = btrfs_lookup_fs_root(root->fs_info, objectid);
+		if (!new_root)
+			break;
+
+		ret = btrfs_commit_transaction(trans, root);
+		if (ret) {
+			btrfs_subvolume_release_metadata(root, &block_rsv,
+							qgroup_reserved);
+			return ret;
+		}
 	}
+
 	trans->block_rsv = &block_rsv;
 	trans->bytes_reserved = block_rsv.size;
 
-- 
2.1.0

