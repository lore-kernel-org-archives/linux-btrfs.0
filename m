Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:41592 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751883AbdI0Gbx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 02:31:53 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 2146847CAAD5
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 14:31:42 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] btrfs-progs: check: check extent_inline_ref in lowmem
Date: Wed, 27 Sep 2017 14:34:39 +0800
Message-ID: <20170927063440.25961-5-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
References: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lowmem check does not skip invalid type in extent_inline_ref then
calls btrfs_extent_inline_ref_size(type) which causes crash.

Error:
$ btrfs check --mode=lowmem  /tmp/data_small
Checking filesystem on /tmp/data_small
UUID: ee205d69-8724-4aa2-a4f5-bc8558a62169
checking extents
ERROR: extent[20971520 16384] backref type mismatch, missing bit: 2
ERROR: extent[20971520 16384] backref generation mismatch,
wanted: 7, have: 0
ERROR: extent[20971520 16384] is referred by other roots than 3
ctree.h:1754: btrfs_extent_inline_ref_size: BUG_ON `1` triggered,
value 1
btrfs(+0x543db)[0x55fabc2ab3db]
btrfs(+0x587f7)[0x55fabc2af7f7]
btrfs(+0x5fa44)[0x55fabc2b6a44]
btrfs(cmd_check+0x194a)[0x55fabc2bd717]
btrfs(main+0x88)[0x55fabc2682e0]
/usr/lib/libc.so.6(__libc_start_main+0xea)[0x7f021c3824ca]
btrfs(_start+0x2a)[0x55fabc267e7a]
[1] 5188 abort (core dumped)  btrfs check --mode=lowmem /tmp/data_small

Solve it by introducing check_extent_inline_ref() to check type.
If the checker returns a nonzero value, we should not check the
corrupted extent item anymore.

Suggested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index adc4a934..aa054a19 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11415,6 +11415,29 @@ loop:
 	goto again;
 }
 
+static int check_extent_inline_ref(struct extent_buffer *eb,
+		   struct btrfs_key *key, struct btrfs_extent_inline_ref *iref)
+{
+	int ret;
+	u8 type = btrfs_extent_inline_ref_type(eb, iref);
+
+	switch (type) {
+	case BTRFS_TREE_BLOCK_REF_KEY:
+	case BTRFS_EXTENT_DATA_REF_KEY:
+	case BTRFS_SHARED_BLOCK_REF_KEY:
+	case BTRFS_SHARED_DATA_REF_KEY:
+		ret = 0;
+		break;
+	default:
+		error("extent[%llu %u %llu] has unknown ref type: %d",
+		      key->objectid, key->type, key->offset, type);
+		ret = UNKNOWN_TYPE;
+		break;
+	}
+
+	return ret;
+}
+
 /*
  * Check backrefs of a tree block given by @bytenr or @eb.
  *
@@ -11549,6 +11572,11 @@ static int check_tree_block_ref(struct btrfs_root *root,
 		type = btrfs_extent_inline_ref_type(leaf, iref);
 		offset = btrfs_extent_inline_ref_offset(leaf, iref);
 
+		ret = check_extent_inline_ref(leaf, &key, iref);
+		if (ret) {
+			err |= ret;
+			break;
+		}
 		if (type == BTRFS_TREE_BLOCK_REF_KEY) {
 			if (offset == root->objectid)
 				found_ref = 1;
@@ -11826,6 +11854,11 @@ static int check_extent_data_item(struct btrfs_root *root,
 		type = btrfs_extent_inline_ref_type(leaf, iref);
 		dref = (struct btrfs_extent_data_ref *)(&iref->offset);
 
+		ret = check_extent_inline_ref(leaf, &dbref_key, iref);
+		if (ret) {
+			err |= ret;
+			break;
+		}
 		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
 			ref_root = btrfs_extent_data_ref_root(leaf, dref);
 			if (ref_root == root->objectid)
-- 
2.14.1



