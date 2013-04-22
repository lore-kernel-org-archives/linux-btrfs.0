Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab3DVFNo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 01:13:44 -0400
Message-ID: <5174C704.7040603@redhat.com>
Date: Mon, 22 Apr 2013 00:13:40 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Anand Jain <anand.jain@oracle.com>,
        Alexander Block <ablock84@googlemail.com>
Subject: [PATCH 2/2] btrfs-progs: enlarge root item if needed in btrfs_update_root
In-Reply-To: <5174C426.3030204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <5174C426.3030204@redhat.com>

This addresses the same issue as did:

2bd1169 btrfs-progs: root_item generation_v2 is out of sync after btrfsck

but rather than optionally updating generation_v2 based
on the size of the existing item, increase the size of the
item as needed, and unconditionally set generation_v2.
This matches the kernel code, and keeping things in sync is a
Good Thing.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

kdave - since you already had Anand's patch on the integration
branch, I dunno if you want to add this on top, or just replace
it with a similar patch to this, up to you.

Thanks!
-Eric

diff --git a/root-tree.c b/root-tree.c
index 1823918..902d75d 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -69,7 +69,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	int ret;
 	int slot;
 	unsigned long ptr;
-	u32 old_size;
+	u32 old_len;
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
@@ -80,18 +80,42 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	l = path->nodes[0];
 	slot = path->slots[0];
 	ptr = btrfs_item_ptr_offset(l, slot);
+	old_len = btrfs_item_size_nr(l, slot);
+
 	/*
-	* If the btrfs-progs is newer and kernel is at
-	* generation_v1 then we don't touch v2 items
-	* otherwise when kernel is at same or greater
-	* version compared with btrfs-progs then update
-	* the needed
-	*/
-	old_size = btrfs_item_size_nr(l, slot);
-	if (old_size >= sizeof(*item)) {
-		btrfs_set_root_generation_v2(item,
-			btrfs_root_generation(item));
+	 * If this is the first time we update the root item which originated
+	 * from an older kernel, we need to enlarge the item size to make room
+	 * for the added fields.
+	 */
+	if (old_len < sizeof(*item)) {
+		btrfs_release_path(root, path);
+		ret = btrfs_search_slot(trans, root, key, path,
+				-1, 1);
+		if (ret < 0) {
+			goto out;
+		}
+
+		ret = btrfs_del_item(trans, root, path);
+		if (ret < 0) {
+			goto out;
+		}
+		btrfs_release_path(root, path);
+		ret = btrfs_insert_empty_item(trans, root, path,
+				key, sizeof(*item));
+		if (ret < 0) {
+			goto out;
+		}
+		l = path->nodes[0];
+		slot = path->slots[0];
+		ptr = btrfs_item_ptr_offset(l, slot);
 	}
+
+	/*
+	 * Update generation_v2 so at the next mount we know the new root
+	 * fields are valid.
+	 */
+	btrfs_set_root_generation_v2(item, btrfs_root_generation(item));
+
 	write_extent_buffer(l, item, ptr, sizeof(*item));
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 out:

