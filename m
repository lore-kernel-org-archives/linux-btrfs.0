Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34916 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbcA2NgS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 08:36:18 -0500
Received: by mail-pf0-f196.google.com with SMTP id 66so3368306pfe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jan 2016 05:36:18 -0800 (PST)
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com, kinglongmee@gmail.com
From: Kinglong Mee <kinglongmee@gmail.com>
Subject: [PATCH 1/3] btrfs: fix memory leak of fs_info in block group cache
Message-ID: <56AB6AC0.4040909@gmail.com>
Date: Fri, 29 Jan 2016 21:36:00 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When starting up linux with btrfs filesystem, I got many memory leak
messages by kmemleak as,

unreferenced object 0xffff880066882000 (size 4096):
  comm "modprobe", pid 730, jiffies 4294690024 (age 196.599s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8174d52e>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff811d09aa>] kmem_cache_alloc_trace+0xea/0x1e0
    [<ffffffffa03620fb>] btrfs_alloc_dummy_fs_info+0x6b/0x2a0 [btrfs]
    [<ffffffffa03624fc>] btrfs_alloc_dummy_block_group+0x5c/0x120 [btrfs]
    [<ffffffffa0360aa9>] btrfs_test_free_space_cache+0x39/0xed0 [btrfs]
    [<ffffffffa03b5a74>] trace_raw_output_xfs_attr_class+0x54/0xe0 [xfs]
    [<ffffffff81002122>] do_one_initcall+0xb2/0x1f0
    [<ffffffff811765aa>] do_init_module+0x5e/0x1e9
    [<ffffffff810fec09>] load_module+0x20a9/0x2690
    [<ffffffff810ff439>] SyS_finit_module+0xb9/0xf0
    [<ffffffff81757daf>] entry_SYSCALL_64_fastpath+0x12/0x76
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800573f8000 (size 10256):
  comm "modprobe", pid 730, jiffies 4294690185 (age 196.460s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8174d52e>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff8119ca6e>] kmalloc_order+0x5e/0x70
    [<ffffffff8119caa4>] kmalloc_order_trace+0x24/0x90
    [<ffffffffa03620b3>] btrfs_alloc_dummy_fs_info+0x23/0x2a0 [btrfs]
    [<ffffffffa03624fc>] btrfs_alloc_dummy_block_group+0x5c/0x120 [btrfs]
    [<ffffffffa036603d>] run_test+0xfd/0x320 [btrfs]
    [<ffffffffa0366f34>] btrfs_test_free_space_tree+0x94/0xee [btrfs]
    [<ffffffffa03b5aab>] trace_raw_output_xfs_attr_class+0x8b/0xe0 [xfs]
    [<ffffffff81002122>] do_one_initcall+0xb2/0x1f0
    [<ffffffff811765aa>] do_init_module+0x5e/0x1e9
    [<ffffffff810fec09>] load_module+0x20a9/0x2690
    [<ffffffff810ff439>] SyS_finit_module+0xb9/0xf0
    [<ffffffff81757daf>] entry_SYSCALL_64_fastpath+0x12/0x76
    [<ffffffffffffffff>] 0xffffffffffffffff

This patch lets btrfs using fs_info stored in btrfs_root for
block group cache directly without allocating a new one.

Fixes: d0bd456074 ("Btrfs: add fragment=* debug mount option")
Signed-off-by: Kinglong Mee <kinglongmee@gmail.com>
---
 fs/btrfs/tests/btrfs-tests.c           | 6 ------
 fs/btrfs/tests/free-space-tree-tests.c | 1 +
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index b1d920b..ba28cef 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -189,12 +189,6 @@ btrfs_alloc_dummy_block_group(unsigned long length)
 		kfree(cache);
 		return NULL;
 	}
-	cache->fs_info = btrfs_alloc_dummy_fs_info();
-	if (!cache->fs_info) {
-		kfree(cache->free_space_ctl);
-		kfree(cache);
-		return NULL;
-	}
 
 	cache->key.objectid = 0;
 	cache->key.offset = length;
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index d05fe1a..7cea446 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -485,6 +485,7 @@ static int run_test(test_func_t test_func, int bitmaps)
 	cache->bitmap_low_thresh = 0;
 	cache->bitmap_high_thresh = (u32)-1;
 	cache->needs_free_space = 1;
+	cache->fs_info = root->fs_info;
 
 	btrfs_init_dummy_trans(&trans);
 
-- 
2.5.0

