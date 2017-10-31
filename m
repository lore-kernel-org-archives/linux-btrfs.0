Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:48410 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbdJaEEF (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 31 Oct 2017 00:04:05 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: print-tree: Enehance uuid item print
Date: Tue, 31 Oct 2017 12:03:41 +0800
Message-Id: <20171031040341.18840-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For key type BTRFS_UUID_KEY_SUBVOL or BTRFS_UUID_KEY_RECEIVED_SUBVOL the
key objectid and key offset are just half of the UUID.

However we just print the key as %llu, which is converted from little
endian, not byte order for UUID, nor the traditional 36 bytes human
readable uuid format.

Although true engineer can easily convert it in their brain, but to
make it easier for search, output the result UUID using the 36 chars format.

Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Inspired by UUID related work from Misono.
---
 print-tree.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 3c585e31f1fc..687f871db302 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -803,14 +803,25 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 	}
 }
 
-static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
-			    u32 item_size)
+static void print_uuid_item(struct extent_buffer *l, int slot,
+			    unsigned long offset, u32 item_size)
 {
+	struct btrfs_key key;
+	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
+	u8 uuid[BTRFS_UUID_SIZE];
+
+	/* Reassemble the uuid from key.objecitd and key.offset */
+	btrfs_item_key_to_cpu(l, &key, slot);
+	put_unaligned_le64(key.objectid, uuid);
+	put_unaligned_le64(key.offset, uuid + sizeof(u64));
+	uuid_unparse(uuid, uuid_str);
+
 	if (item_size & (sizeof(u64) - 1)) {
 		printf("btrfs: uuid item with illegal size %lu!\n",
 		       (unsigned long)item_size);
 		return;
 	}
+	printf("\t\tuuid %s\n", uuid_str);
 	while (item_size) {
 		__le64 subvol_id;
 
@@ -1297,7 +1308,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 			break;
 		case BTRFS_UUID_KEY_SUBVOL:
 		case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
-			print_uuid_item(eb, btrfs_item_ptr_offset(eb, i),
+			print_uuid_item(eb, i, btrfs_item_ptr_offset(eb, i),
 					btrfs_item_size_nr(eb, i));
 			break;
 		case BTRFS_STRING_ITEM_KEY: {
-- 
2.14.3

