Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45161 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752539AbdECIm5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 04:42:57 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 2/2] btrfs-progs: check: Avoid reading beyond item boundary for dir_item and dir_index
Date: Wed, 3 May 2017 16:42:40 +0800
Message-ID: <20170503084240.17499-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170503084240.17499-1-quwenruo@cn.fujitsu.com>
References: <20170503084240.17499-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When reading out name from inode_ref, it's possible that corrupted
name_len can lead to read beyond boundary of item or even extent buffer.

This happens when checking fuzzed image /tmp/bko-161811.raw, for both
lowmem mode and original mode.

Below is the example from lowmem mode.

ERROR: root 5 INODE REF[256 256] doesn't have related DIR_INDEX[256 216172782113783808] namelen 255 filename bar filetype 0
ERROR: root 5 INODE REF[256 256] doesn't have related DIR_ITEM[256 1306590535] namelen 255 filename bar filetype 0
WARNING: root 5 INODE[256] mode 0 shouldn't have DIR_INDEX[256 1167283096]
WARNING: root 5 DIR_ITEM[256 1167283096] name too long
==13013== Invalid read of size 1
==13013==    at 0x4C31A38: memmove (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==13013==    by 0x431518: read_extent_buffer (extent_io.c:863)
==13013==    by 0x4752AB: check_dir_item (cmds-check.c:4627)
==13013==    by 0x475E5C: check_inode_item (cmds-check.c:4911)
==13013==    by 0x476200: check_fs_first_inode (cmds-check.c:5011)
==13013==    by 0x476276: check_fs_root_v2 (cmds-check.c:5044)
==13013==    by 0x4769FB: check_fs_roots_v2 (cmds-check.c:5242)
==13013==    by 0x488B5B: cmd_check (cmds-check.c:13033)
==13013==    by 0x40A8C5: main (btrfs.c:246)
==13013==  Address 0x5c95b80 is 0 bytes after a block of size 4,224 alloc'd
==13013==    at 0x4C2CF35: calloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==13013==    by 0x4307E0: __alloc_extent_buffer (extent_io.c:538)
==13013==    by 0x430C37: alloc_extent_buffer (extent_io.c:642)
==13013==    by 0x413DFE: btrfs_find_create_tree_block (disk-io.c:193)
==13013==    by 0x414370: read_tree_block_fs_info (disk-io.c:340)
==13013==    by 0x40B5D5: read_tree_block (disk-io.h:125)
==13013==    by 0x40CFD2: read_node_slot (ctree.c:652)
==13013==    by 0x40E5EB: btrfs_search_slot (ctree.c:1172)
==13013==    by 0x4761A8: check_fs_first_inode (cmds-check.c:5001)
==13013==    by 0x476276: check_fs_root_v2 (cmds-check.c:5044)
==13013==    by 0x4769FB: check_fs_roots_v2 (cmds-check.c:5242)
==13013==    by 0x488B5B: cmd_check (cmds-check.c:13033)

Fix it by double checking dir_item, name_len against item boundary
before trying to read out name from extent buffer, for both original
mode and lowmem mode.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 3e952742..520d3bff 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1512,13 +1512,19 @@ static int process_dir_item(struct extent_buffer *eb,
 		filetype = btrfs_dir_type(eb, di);
 
 		rec->found_size += name_len;
-		if (name_len <= BTRFS_NAME_LEN) {
+		if (cur + sizeof(*di) + name_len > total ||
+		    name_len > BTRFS_NAME_LEN) {
+			error = REF_ERR_NAME_TOO_LONG;
+
+			if (cur + sizeof(*di) > total)
+				break;
+			len = min_t(u32, total - cur - sizeof(*di),
+				    BTRFS_NAME_LEN);
+		} else {
 			len = name_len;
 			error = 0;
-		} else {
-			len = BTRFS_NAME_LEN;
-			error = REF_ERR_NAME_TOO_LONG;
 		}
+
 		read_extent_buffer(eb, namebuf, (unsigned long)(di + 1), len);
 
 		if (location.type == BTRFS_INODE_ITEM_KEY) {
@@ -4235,16 +4241,22 @@ static int find_dir_item(struct btrfs_root *root, struct btrfs_key *ref_key,
 		if (imode_to_type(mode) != filetype)
 			goto next;
 
-		if (name_len <= BTRFS_NAME_LEN) {
-			len = name_len;
-		} else {
-			len = BTRFS_NAME_LEN;
+		if (cur + sizeof(*di) + name_len > total ||
+		    name_len > BTRFS_NAME_LEN) {
 			warning("root %llu %s[%llu %llu] name too long %u, trimmed",
-			root->objectid,
-			key->type == BTRFS_DIR_ITEM_KEY ?
-			"DIR_ITEM" : "DIR_INDEX",
-			key->objectid, key->offset, name_len);
+				root->objectid,
+				key->type == BTRFS_DIR_ITEM_KEY ?
+				"DIR_ITEM" : "DIR_INDEX",
+				key->objectid, key->offset, name_len);
+
+			if (cur + sizeof(*di) > total)
+				break;
+			len = min_t(u32, total - cur - sizeof(*di),
+				    BTRFS_NAME_LEN);
+		} else {
+			len = name_len;
 		}
+
 		read_extent_buffer(node, namebuf, (unsigned long)(di + 1), len);
 		if (len != namelen || strncmp(namebuf, name, len))
 			goto next;
@@ -4632,15 +4644,20 @@ static int check_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 			      key->objectid, key->offset, data_len);
 
 		name_len = btrfs_dir_name_len(node, di);
-		if (name_len <= BTRFS_NAME_LEN) {
-			len = name_len;
-		} else {
-			len = BTRFS_NAME_LEN;
+		if (cur + sizeof(*di) + name_len > total ||
+		    name_len > BTRFS_NAME_LEN) {
 			warning("root %llu %s[%llu %llu] name too long",
 				root->objectid,
 				key->type == BTRFS_DIR_ITEM_KEY ?
 				"DIR_ITEM" : "DIR_INDEX",
 				key->objectid, key->offset);
+
+			if (cur + sizeof(*di) > total)
+				break;
+			len = min_t(u32, total - cur - sizeof(*di),
+				    BTRFS_NAME_LEN);
+		} else {
+			len = name_len;
 		}
 		(*size) += name_len;
 
-- 
2.12.2



