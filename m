Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:59084 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754075AbdKABuH (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 31 Oct 2017 21:50:07 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, nborisov@suse.com
Subject: [PATCH v3] btrfs-progs: print-tree: Enehance uuid item print
Date: Wed,  1 Nov 2017 09:50:01 +0800
Message-Id: <20171101015001.22101-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For key type BTRFS_UUID_KEY_SUBVOL or BTRFS_UUID_KEY_RECEIVED_SUBVOL the
key objectid and key offset is just half of the UUID.

However we just print the key as %llu, which is converted from little
endian, not byte order for UUID, nor the traditional 36 bytes human
readable uuid format.

Although true engineer can easily handle it by convert it in their
brain, but to make it easier for search, output the result UUID using
the 36 chars format.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Inspired by UUID related work from Misono-san.
v2:
  Add comment to explain the possible endian hassle, suggested by
  Nikolay.
  Extract the key to uuid convert into its own function
v3:
  Don't bother the whole endian hassle at all, by following the same
  method we handle normal uuid and csum to directly memcpy() data from
  btrfs_disk_key.
  As long as we treat on-disk data and uuid as array of btrfs, there is no
  need to bother endian hassle at all.
---
 print-tree.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 3c585e31f1fc..2e2a4d607b47 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -803,14 +803,38 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 	}
 }
 
-static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
-			    u32 item_size)
+static void btrfs_disk_key_to_uuid(struct btrfs_disk_key *disk_key, u8 *uuid)
 {
+	/*
+	 * Btrfs treats uuid as u8[16], and store them directly into disk_key,
+	 * where objectid is treated as u8[8] and stores uuid[0]~uuid[7].
+	 * And offset is also treated as u8[8] and stores uuid[8]~uuid[16].
+	 *
+	 * So here we only need to directly get byte array from disk_key, and
+	 * don't need to bother the endian hassle.
+	 * Just like what we do for normal uuid and csum[].
+	 */
+	memcpy(uuid, &disk_key->objectid, 8);
+	memcpy(uuid + 8, &disk_key->offset, 8);
+}
+
+static void print_uuid_item(struct extent_buffer *l, int slot,
+			    unsigned long offset, u32 item_size)
+{
+	struct btrfs_disk_key disk_key;
+	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
+	u8 uuid[BTRFS_UUID_SIZE];
+
+	btrfs_item_key(l, &disk_key, slot);
+	btrfs_disk_key_to_uuid(&disk_key, uuid);
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
 
@@ -1297,7 +1321,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
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

