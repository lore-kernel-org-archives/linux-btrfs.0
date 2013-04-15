Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50451 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3DOGh1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:37:27 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 01/11, RESEND] btrfs-progs: root_item generation_v2 is out of sync after btrfsck
Date: Mon, 15 Apr 2013 14:38:07 +0800
Message-Id: <1366007897-26567-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

reproducing steps:
mkfs.btrfs /dev/dm-2 -f
mount /dev/dm-2 /btrfs
umount /btrfs
btrfs check /dev/dm-2 --repair
mount /dev/dm-2 /btrfs

----
btrfs: mismatching generation and generation_v2 found in root item. This root was probably mounted with an older kernel. Resetting all new fields.
----

btrfs-debug-tree shows change in uuid

< 		root data bytenr 29425664 level 0 dirid 0 refs 1 gen 43
< 		uuid 293596e8-7888-eb4c-9134-6df9db996fe5

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 root-tree.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/root-tree.c b/root-tree.c
index c10d068..4454147 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -69,6 +69,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	int ret;
 	int slot;
 	unsigned long ptr;
+	u32 old_size;
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
@@ -79,6 +80,18 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	l = path->nodes[0];
 	slot = path->slots[0];
 	ptr = btrfs_item_ptr_offset(l, slot);
+	/*
+	* If the btrfs-progs is newer and kernel is at
+	* generation_v1 then we don't touch v2 items
+	* otherwise when kernel is at same or greater
+	* version compared with btrfs-progs then update
+	* the needed
+	*/
+	old_size = btrfs_item_size_nr(l, slot);
+	if (old_size >= sizeof(*item)) {
+		btrfs_set_root_generation_v2(item,
+			btrfs_root_generation(item));
+	}
 	write_extent_buffer(l, item, ptr, sizeof(*item));
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 out:
-- 
1.8.1.227.g44fe835

