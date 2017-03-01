Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57673 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751468AbdCADSE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:18:04 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id DB4FF48A2943
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:19 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 17/20] btrfs-progs: cmds-check.c: repair inode ref
Date: Wed, 1 Mar 2017 11:14:00 +0800
Message-ID: <20170301031403.23902-18-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Call repair_ternary_lowmem while checking inode ref.

Introduce 'repair_dir_item' calls above function to repair dir_item.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 1b35a5fd..9ac08dfd 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4445,6 +4445,8 @@ out:
 	return ret;
 }
 
+static int research_path(struct btrfs_root *root, struct btrfs_path *path,
+			 struct btrfs_key *key);
 /*
  * Traverse the given INODE_REF and call find_dir_item() to find related
  * DIR_ITEM/DIR_INDEX.If repair is enable, research @ref_key and
@@ -4475,26 +4477,39 @@ static int check_inode_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
 	u32 cur = 0;
 	long len;
 	u64 index;
-	int err = 0;
+	int ret, err = 0;
 	int tmp_err;
 	int slot;
+	int need_research = 0;
+
+research:
+	if (need_research) {
+		ret = research_path(root, path, ref_key);
+		need_research = 1;
+		if (ret)
+			return ret > 0 ? 0 : ret;
+	}
 
+	err = 0;
+	cur = 0;
+	*refs = 0;
 	location.objectid = ref_key->objectid;
 	location.type = BTRFS_INODE_ITEM_KEY;
 	location.offset = 0;
 	node = path->nodes[0];
 	slot = path->slots[0];
 
+	memset(namebuf, 0, sizeof(namebuf) / sizeof(*namebuf));
 	ref = btrfs_item_ptr(node, slot, struct btrfs_inode_ref);
 	total = btrfs_item_size_nr(node, slot);
 
 next:
 	/* Update inode ref count */
 	(*refs)++;
-
 	tmp_err = 0;
 	index = btrfs_inode_ref_index(node, ref);
 	name_len = btrfs_inode_ref_name_len(node, ref);
+
 	if (name_len <= BTRFS_NAME_LEN) {
 		len = name_len;
 	} else {
@@ -4536,6 +4551,16 @@ next:
 	tmp_err |= find_dir_item(root, &key, &location, namebuf, len,
 			    imode_to_type(mode));
 end:
+	if (tmp_err && repair) {
+		ret = repair_ternary_lowmem(root, ref_key->offset,
+					    ref_key->objectid, index, namebuf,
+					    name_len, imode_to_type(mode),
+					    tmp_err);
+		if (!ret) {
+			need_research = true;
+			goto research;
+		}
+	}
 	print_inode_ref_err(root, ref_key, index, namebuf, name_len,
 			    imode_to_type(mode), tmp_err);
 	err |= tmp_err;
-- 
2.11.1



