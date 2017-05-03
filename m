Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45161 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752370AbdECIms (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 04:42:48 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 1/2] btrfs-progs: check: Avoid reading beyond item boundary for inode_ref
Date: Wed, 3 May 2017 16:42:39 +0800
Message-ID: <20170503084240.17499-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When reading out name from inode_ref, it's possible that corrupted
name_len can lead to read beyond boundary of item or even extent buffer.

This happens when checking fuzzed image /tmp/bko-161811.raw, for both
lowmem mode and original mode.

ERROR: root 5 INODE REF[256 256] doesn't have related DIR_INDEX[256 504403158265495680] namelen 0 filename  filetype 0
ERROR: root 5 INODE REF[256 256] doesn't have related DIR_ITEM[256 4294967294] namelen 0 filename  filetype 0
WARNING: root 5 INODE_REF[256 256] name too long
==13022== Invalid read of size 8
==13022==    at 0x4C319BE: memmove (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==13022==    by 0x431518: read_extent_buffer (extent_io.c:863)
==13022==    by 0x474730: check_inode_ref (cmds-check.c:4307)
==13022==    by 0x475D65: check_inode_item (cmds-check.c:4890)
==13022==    by 0x476200: check_fs_first_inode (cmds-check.c:5011)
==13022==    by 0x476276: check_fs_root_v2 (cmds-check.c:5044)
==13022==    by 0x4769FB: check_fs_roots_v2 (cmds-check.c:5242)
==13022==    by 0x488B5B: cmd_check (cmds-check.c:13033)
==13022==    by 0x40A8C5: main (btrfs.c:246)
==13022==  Address 0x5c96780 is 0 bytes after a block of size 4,224 alloc'd
==13022==    at 0x4C2CF35: calloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==13022==    by 0x4307E0: __alloc_extent_buffer (extent_io.c:538)
==13022==    by 0x430C37: alloc_extent_buffer (extent_io.c:642)
==13022==    by 0x413DFE: btrfs_find_create_tree_block (disk-io.c:193)
==13022==    by 0x414370: read_tree_block_fs_info (disk-io.c:340)
==13022==    by 0x40B5D5: read_tree_block (disk-io.h:125)
==13022==    by 0x40CFD2: read_node_slot (ctree.c:652)
==13022==    by 0x40E5EB: btrfs_search_slot (ctree.c:1172)
==13022==    by 0x4761A8: check_fs_first_inode (cmds-check.c:5001)
==13022==    by 0x476276: check_fs_root_v2 (cmds-check.c:5044)
==13022==    by 0x4769FB: check_fs_roots_v2 (cmds-check.c:5242)
==13022==    by 0x488B5B: cmd_check (cmds-check.c:13033)
=

Fix it by double checking inode_ref, name_len against item boundary
before trying to read out name from extent buffer, for both original
mode and lowmem mode.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index fb2502b0..3e952742 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1569,13 +1569,22 @@ static int process_inode_ref(struct extent_buffer *eb,
 	while (cur < total) {
 		name_len = btrfs_inode_ref_name_len(eb, ref);
 		index = btrfs_inode_ref_index(eb, ref);
-		if (name_len <= BTRFS_NAME_LEN) {
+
+		/* inode_ref + namelen should not cross item boundary */
+		if (cur + sizeof(*ref) + name_len > total ||
+		    name_len > BTRFS_NAME_LEN) {
+			if (total < cur + sizeof(*ref))
+				break;
+
+			/* Still try to read out the remaining part */
+			len = min_t(u32, total - cur - sizeof(*ref),
+				    BTRFS_NAME_LEN);
+			error = REF_ERR_NAME_TOO_LONG;
+		} else {
 			len = name_len;
 			error = 0;
-		} else {
-			len = BTRFS_NAME_LEN;
-			error = REF_ERR_NAME_TOO_LONG;
 		}
+
 		read_extent_buffer(eb, namebuf, (unsigned long)(ref + 1), len);
 		add_inode_backref(inode_cache, key->objectid, key->offset,
 				  index, namebuf, len, 0, key->type, error);
@@ -4296,12 +4305,16 @@ next:
 
 	index = btrfs_inode_ref_index(node, ref);
 	name_len = btrfs_inode_ref_name_len(node, ref);
-	if (name_len <= BTRFS_NAME_LEN) {
-		len = name_len;
-	} else {
-		len = BTRFS_NAME_LEN;
+	if (cur + sizeof(*ref) + name_len > total ||
+	    name_len > BTRFS_NAME_LEN) {
 		warning("root %llu INODE_REF[%llu %llu] name too long",
 			root->objectid, ref_key->objectid, ref_key->offset);
+
+		if (total < cur + sizeof(*ref))
+			goto out;
+		len = min_t(u32, total - cur - sizeof(*ref), BTRFS_NAME_LEN);
+	} else {
+		len = name_len;
 	}
 
 	read_extent_buffer(node, namebuf, (unsigned long)(ref + 1), len);
@@ -4334,6 +4347,7 @@ next:
 	if (cur < total)
 		goto next;
 
+out:
 	return err;
 }
 
@@ -4471,16 +4485,22 @@ static int find_inode_ref(struct btrfs_root *root, struct btrfs_key *key,
 		if (index != (u64)-1 && index != ref_index)
 			goto next_ref;
 
-		if (ref_namelen <= BTRFS_NAME_LEN) {
-			len = ref_namelen;
-		} else {
-			len = BTRFS_NAME_LEN;
+		if (cur + sizeof(*ref) +ref_namelen > total ||
+		    ref_namelen > BTRFS_NAME_LEN) {
 			warning("root %llu INODE %s[%llu %llu] name too long",
 				root->objectid,
 				key->type == BTRFS_INODE_REF_KEY ?
 					"REF" : "EXTREF",
 				key->objectid, key->offset);
+
+			if (cur + sizeof(*ref) > total)
+				break;
+			len = min_t(u32, total - cur - sizeof(*ref),
+				    BTRFS_NAME_LEN);
+		} else {
+			len = ref_namelen;
 		}
+
 		read_extent_buffer(node, ref_namebuf, (unsigned long)(ref + 1),
 				   len);
 
-- 
2.12.2



