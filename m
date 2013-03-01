Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab3CAPDG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Mar 2013 10:03:06 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 81996A3A78
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Mar 2013 16:03:03 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: try harder to allocate raid56 stripe cache
Date: Fri,  1 Mar 2013 16:03:00 +0100
Message-Id: <1362150180-13792-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The stripe hash table is large, starting with allocation order 4 and can go as
high as order 7 in case lock debugging is turned on and structure padding
happens.

Observed mount failure:

mount: page allocation failure: order:7, mode:0x200050
Pid: 8234, comm: mount Tainted: G        W    3.8.0-default+ #267
Call Trace:
 [<ffffffff81114353>] warn_alloc_failed+0xf3/0x140
 [<ffffffff811171d2>] ? __alloc_pages_direct_compact+0x92/0x250
 [<ffffffff81117ac3>] __alloc_pages_nodemask+0x733/0x9d0
 [<ffffffff81152878>] ? cache_alloc_refill+0x3f8/0x840
 [<ffffffff811528bc>] cache_alloc_refill+0x43c/0x840
 [<ffffffff811302eb>] ? is_kernel_percpu_address+0x4b/0x90
 [<ffffffffa00a00ac>] ? btrfs_alloc_stripe_hash_table+0x5c/0x130 [btrfs]
 [<ffffffff811531d7>] kmem_cache_alloc_trace+0x247/0x270
 [<ffffffffa00a00ac>] btrfs_alloc_stripe_hash_table+0x5c/0x130 [btrfs]
 [<ffffffffa003133f>] open_ctree+0xb2f/0x1f90 [btrfs]
 [<ffffffff81397289>] ? string+0x49/0xe0
 [<ffffffff813987b3>] ? vsnprintf+0x443/0x5d0
 [<ffffffffa0007cb6>] btrfs_mount+0x526/0x600 [btrfs]
 [<ffffffff8115127c>] ? cache_alloc_debugcheck_after+0x4c/0x200
 [<ffffffff81162b90>] mount_fs+0x20/0xe0
 [<ffffffff8117db26>] vfs_kern_mount+0x76/0x120
 [<ffffffff811801b6>] do_mount+0x386/0x980
 [<ffffffff8112a5cb>] ? strndup_user+0x5b/0x80
 [<ffffffff81180840>] sys_mount+0x90/0xe0
 [<ffffffff81962e99>] system_call_fastpath+0x16/0x1b

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c |    2 +-
 fs/btrfs/raid56.c  |   31 +++++++++++++++++++++++++------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5031e6d..02369a3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2197,7 +2197,7 @@ int open_ctree(struct super_block *sb,
 
 	ret = btrfs_alloc_stripe_hash_table(fs_info);
 	if (ret) {
-		err = -ENOMEM;
+		err = ret;
 		goto fail_alloc;
 	}
 
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index e34e568..0722205 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -188,13 +188,25 @@ int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info)
 	struct btrfs_stripe_hash *h;
 	int num_entries = 1 << BTRFS_STRIPE_HASH_TABLE_BITS;
 	int i;
+	int table_size;
 
 	if (info->stripe_hash_table)
 		return 0;
 
-	table = kzalloc(sizeof(*table) + sizeof(*h) * num_entries, GFP_NOFS);
-	if (!table)
-		return -ENOMEM;
+	/*
+	 * The table is large, starting with order 4 and can go as high as
+	 * order 7 in case lock debugging is turned on.
+	 *
+	 * Try harder to allocate and fallback to vmalloc to lower the chance
+	 * of a failing mount.
+	 */
+	table_size = sizeof(*table) + sizeof(*h) * num_entries;
+	table = kzalloc(table_size, GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
+	if (!table) {
+		table = vzalloc(table_size);
+		if (!table)
+			return -ENOMEM;
+	}
 
 	spin_lock_init(&table->cache_lock);
 	INIT_LIST_HEAD(&table->stripe_cache);
@@ -209,8 +221,12 @@ int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info)
 	}
 
 	x = cmpxchg(&info->stripe_hash_table, NULL, table);
-	if (x)
-		kfree(x);
+	if (x) {
+		if (is_vmalloc_addr(x))
+			vfree(x);
+		else
+			kfree(x);
+	}
 	return 0;
 }
 
@@ -420,7 +436,10 @@ void btrfs_free_stripe_hash_table(struct btrfs_fs_info *info)
 	if (!info->stripe_hash_table)
 		return;
 	btrfs_clear_rbio_cache(info);
-	kfree(info->stripe_hash_table);
+	if (is_vmalloc_addr(info->stripe_hash_table))
+		vfree(info->stripe_hash_table);
+	else
+		kfree(info->stripe_hash_table);
 	info->stripe_hash_table = NULL;
 }
 
-- 
1.7.9

