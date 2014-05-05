Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43145 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaEERkV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 13:40:21 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hugo@carfax.org.uk>)
	id 1WhMMq-0007al-Gb
	for linux-btrfs@vger.kernel.org; Mon, 05 May 2014 17:07:52 +0000
Received: from [10.0.0.10] (helo=ruthven.carfax.org.uk)
	by ruthven.carfax.org.uk with esmtp (Exim 4.82)
	(envelope-from <hugo@carfax.org.uk>)
	id 1WhMMp-0002Pg-T1
	for linux-btrfs@vger.kernel.org; Mon, 05 May 2014 18:07:51 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs check: Attempt to fix misordered keys with bitflips in them
Date: Mon,  5 May 2014 18:07:51 +0100
Message-Id: <1399309671-9240-4-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1399309671-9240-1-git-send-email-hugo@carfax.org.uk>
References: <1399309671-9240-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If someone has had bad RAM which has been used to store a metadata block,
there's a chance that one or more of the keys has had a bit changed. The
block checksum doesn't help us here, because it's made on the bad data.

To fix this, if there's a block with a bad key order in it, we find out-of-
order keys by bracketing them between the good keys either side of them,
and then attempting to flip each bit of the key in turn.

If precisely one of those bitflips puts the broken key back into order
relative to its two neighbours, we probably have a fix for the bitflip,
and so we write it back to the FS.

This doesn't repair bitflipped keys at the start or end of a metadata
block, nor bitflips in any other data structure.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 cmds-check.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 99 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index b2e4a46..c93fea3 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2406,8 +2406,9 @@ static int swap_values(struct btrfs_root *root, struct btrfs_path *path,
 }
 
 /*
- * Attempt to fix basic block failures.  Currently we only handle bad key
- * orders, we will cycle through the keys and swap them if necessary.
+ * Attempt to fix basic block failures. Currently we only handle bad
+ * key orders, we will look for fixable bitflips, and also cycle
+ * through the keys and swap them if necessary.
  */
 static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
@@ -2416,8 +2417,9 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 				enum btrfs_tree_block_status status)
 {
 	struct btrfs_path *path;
-	struct btrfs_key k1, k2;
-	int i;
+	struct btrfs_key k1, k2, k3;
+	int i, j;
+	int bit, field;
 	int level;
 	int ret;
 
@@ -2452,6 +2454,99 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 	}
 
 	buf = path->nodes[level];
+
+	/* First, look for bitflips in keys: we identify these where k1 <
+	 * k3 but k1 >= k2 or k2 >= k3. We can fix a bitflip if there's
+	 * exactly one bit that we can flip that makes k1 < k2 < k3. */
+	for (i = 0; i < btrfs_header_nritems(buf) - 2; i++) {
+		if (level) {
+			btrfs_node_key_to_cpu(buf, &k1, i);
+			btrfs_node_key_to_cpu(buf, &k2, i+1);
+			btrfs_node_key_to_cpu(buf, &k3, i+2);
+		} else {
+			btrfs_item_key_to_cpu(buf, &k1, i);
+			btrfs_item_key_to_cpu(buf, &k2, i+1);
+			btrfs_item_key_to_cpu(buf, &k3, i+2);
+		}
+
+		if (btrfs_comp_cpu_keys(&k1, &k3) >= 0)
+			continue; /* Bracketing keys compare incorrectly:
+						 we can't fix this */
+		if (btrfs_comp_cpu_keys(&k1, &k2) <= 0
+			&& btrfs_comp_cpu_keys(&k2, &k3) <= 0)
+			continue; /* All three keys are in order: nothing to do */
+
+		bit = -1;
+		field = -1;
+		for(j = 0; j < 64; j++) {
+			/* Look for flipped/fixable bits in the objectid */
+			k2.objectid ^= 0x1ULL << j;
+			if (btrfs_comp_cpu_keys(&k1, &k2) <= 0
+				&& btrfs_comp_cpu_keys(&k2, &k3) <= 0) {
+				/* Do nothing if we've already found a flippable bit:
+				 * multiple solutions means we can't know what the
+				 * right thing to do is */
+				if (field != -1) {
+					field = -1;
+					break;
+				}
+				bit = j;
+				field = 0;
+			}
+			k2.objectid ^= 0x1ULL << j;
+
+			/* Look for flipped/fixable bits in the type */
+			if (j < 8) {
+				k2.type ^= 0x1ULL << j;
+				if (btrfs_comp_cpu_keys(&k1, &k2) <= 0
+					&& btrfs_comp_cpu_keys(&k2, &k3) <= 0) {
+					if (field != -1) {
+						field = -1;
+						break;
+					}
+					bit = j;
+					field = 1;
+				}
+				k2.type ^= 0x1ULL << j;
+			}
+
+			/* Look for flipped/fixable bits in the offset */
+			k2.offset ^= 0x1ULL << j;
+			if (btrfs_comp_cpu_keys(&k1, &k2) <= 0
+				&& btrfs_comp_cpu_keys(&k2, &k3) <= 0) {
+				if (field != -1) {
+					field = -1;
+					break;
+				}
+				bit = j;
+				field = 2;
+			}
+			k2.offset ^= 0x1ULL << j;
+		}
+
+		if (field != -1) {
+			fprintf(stderr, "Fixing bitflipped key (%llx, %d, %llx) ",
+					k2.objectid, k2.type, k2.offset);
+			if (field == 0)
+				k2.objectid ^= 0x1ULL << bit;
+			else if (field == 1)
+				k2.type ^= 0x1ULL << bit;
+			else if (field == 2)
+				k2.offset ^= 0x1ULL << bit;
+
+			fprintf(stderr, "to (%llx, %d, %llx)\n",
+					k2.objectid, k2.type, k2.offset);
+
+			/* Write the key back to disk */
+			path->slots[0] = i+1;
+			btrfs_set_item_key_unsafe(root, path, &k2);
+			btrfs_mark_buffer_dirty(buf);
+			/* Go back and test all the keys again */
+			i = 0;
+		}
+	}
+
+	/* Now simply swap keys to put them in order */
 	for (i = 0; i < btrfs_header_nritems(buf) - 1; i++) {
 		if (level) {
 			btrfs_node_key_to_cpu(buf, &k1, i);
-- 
1.9.2

