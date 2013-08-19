Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47283 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3HSUak (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Aug 2013 16:30:40 -0400
Received: by mail-wg0-f47.google.com with SMTP id j13so3863630wgh.26
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Aug 2013 13:30:39 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v4] Btrfs: fix memory leak of orphan block rsv
Date: Mon, 19 Aug 2013 21:30:33 +0100
Message-Id: <1376944233-1094-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1376935725-27427-1-git-send-email-fdmanana@gmail.com>
References: <1376935725-27427-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This issue is simple to reproduce and observe if kmemleak is enabled.
Two simple ways to reproduce it:

** 1

$ mkfs.btrfs -f /dev/loop0
$ mount /dev/loop0 /mnt/btrfs
$ btrfs balance start /mnt/btrfs
$ umount /mnt/btrfs

** 2

$ mkfs.btrfs -f /dev/loop0
$ mount /dev/loop0 /mnt/btrfs
$ touch /mnt/btrfs/foobar
$ rm -f /mnt/btrfs/foobar
$ umount /mnt/btrfs

After a while, kmemleak reports the leak:

$ cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff880402b13e00 (size 128):
  comm "btrfs", pid 19621, jiffies 4341648183 (age 70057.844s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 fc c6 b1 04 88 ff ff 04 00 04 00 ad 4e ad de  .............N..
  backtrace:
    [<ffffffff817275a6>] kmemleak_alloc+0x26/0x50
    [<ffffffff8117832b>] kmem_cache_alloc_trace+0xeb/0x1d0
    [<ffffffffa04db499>] btrfs_alloc_block_rsv+0x39/0x70 [btrfs]
    [<ffffffffa04f8bad>] btrfs_orphan_add+0x13d/0x1b0 [btrfs]
    [<ffffffffa04e2b13>] btrfs_remove_block_group+0x143/0x500 [btrfs]
    [<ffffffffa0518158>] btrfs_relocate_chunk.isra.63+0x618/0x790 [btrfs]
    [<ffffffffa051bc27>] btrfs_balance+0x8f7/0xe90 [btrfs]
    [<ffffffffa05240a0>] btrfs_ioctl_balance+0x250/0x550 [btrfs]
    [<ffffffffa05269ca>] btrfs_ioctl+0xdfa/0x25f0 [btrfs]
    [<ffffffff8119c936>] do_vfs_ioctl+0x96/0x570
    [<ffffffff8119cea1>] SyS_ioctl+0x91/0xb0
    [<ffffffff81750242>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

This affects btrfs-next, revision be8e3cd00d7293dd177e3f8a4a1645ce09ca3acb
(Btrfs: separate out tests into their own directory).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: removed atomic_t member in struct btrfs_block_rsv, as suggested by
    Josef Bacik, and use instead the condition reserved == 0 to decide
    when to free the block.
V3: simplified patch, just kfree() (and not btrfs_free_block_rsv) the
    root's orphan_block_rsv when free'ing the root. Thanks Josef for
    the suggestion.
V4: use btrfs_free_block_rsv() instead of kfree(). The error I was getting
    in xfstests when using btrfs_free_block_rsv() was unrelated, Josef just
    pointed it to me (separate issue).

 fs/btrfs/disk-io.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3b12c26..c4b90a0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3428,6 +3428,8 @@ void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
 
 static void free_fs_root(struct btrfs_root *root)
 {
+	btrfs_free_block_rsv(root, root->orphan_block_rsv);
+	root->orphan_block_rsv = NULL;
 	iput(root->cache_inode);
 	WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
 	if (root->anon_dev)
-- 
1.7.9.5

