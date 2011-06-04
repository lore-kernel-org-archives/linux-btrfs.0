From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 4/9] mkfs.btrfs: return some defined value instead of garbage when lookup checksum
Date: Sat,  4 Jun 2011 11:19:19 +0300
Message-ID: <1307175564-25355-5-git-send-email-slyfox@gentoo.org>
References: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

==31873== Command: ./mkfs.btrfs -r /some/root/
==31873== Parent PID: 31872
==31873==
==31873== Conditional jump or move depends on uninitialised value(s)
==31873==    at 0x42C3D0: add_file_items (mkfs.c:792)
==31873==    by 0x42CAB3: traverse_directory (mkfs.c:948)
==31873==    by 0x42CF11: make_image (mkfs.c:1047)
==31873==    by 0x42DE53: main (mkfs.c:1401)
==31873==  Uninitialised value was created by a stack allocation
==31873==    at 0x41B1B1: btrfs_csum_file_block (file-item.c:195)

'ret' value was not initialized for 'found' branch.

The same fix sits in kernel:
> commit 639cb58675ce9b507eed9c3d6b3335488079b21a
> Author: Chris Mason <chris.mason@oracle.com>
> Date:   Thu Aug 28 06:15:25 2008 -0400
>
>     Btrfs: Fix variable init during csum creation
>
>     Signed-off-by: Chris Mason <chris.mason@oracle.com>

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 file-item.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/file-item.c b/file-item.c
index 9732282..47f6ad2 100644
--- a/file-item.c
+++ b/file-item.c
@@ -201,40 +201,41 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct btrfs_csum_item *item;
 	struct extent_buffer *leaf = NULL;
 	u64 csum_offset;
 	u32 csum_result = ~(u32)0;
 	u32 nritems;
 	u32 ins_size;
 	u16 csum_size =
 		btrfs_super_csum_size(&root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
 	file_key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
 	file_key.offset = bytenr;
 	file_key.type = BTRFS_EXTENT_CSUM_KEY;
 
 	item = btrfs_lookup_csum(trans, root, path, bytenr, 1);
 	if (!IS_ERR(item)) {
 		leaf = path->nodes[0];
+		ret = 0;
 		goto found;
 	}
 	ret = PTR_ERR(item);
 	if (ret == -EFBIG) {
 		u32 item_size;
 		/* we found one, but it isn't big enough yet */
 		leaf = path->nodes[0];
 		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
 		if ((item_size / csum_size) >= MAX_CSUM_ITEMS(root, csum_size)) {
 			/* already at max size, make a new one */
 			goto insert;
 		}
 	} else {
 		int slot = path->slots[0] + 1;
 		/* we didn't find a csum item, insert one */
 		nritems = btrfs_header_nritems(path->nodes[0]);
 		if (path->slots[0] >= nritems - 1) {
 			ret = btrfs_next_leaf(root, path);
 			if (ret == 1)
 				found_next = 1;
-- 
1.7.3.4

