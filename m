Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28786 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbaAWVGW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 16:06:22 -0500
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s0NL2Yfv026424
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jan 2014 13:06:21 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1hk62p127q-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jan 2014 13:06:20 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix extent_from_logical to deal with skinny metadata
Date: Thu, 23 Jan 2014 16:06:17 -0500
Message-ID: <1390511177-3395-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't think this is an issue and I've not seen it in practice but
extent_from_logical will fail to find a skinny extent because it uses
btrfs_previous_item and gives it the normal extent item type.  This is just not
a place to use btrfs_previous_item since we care about either normal extents or
skinny extents, so open code btrfs_previous_item to properly check.  This would
only affect metadata and the only place this is used for metadata is scrub and
I'm pretty sure it's just for printing stuff out, not actually doing any work so
hopefully it was never a problem other than a cosmetic one.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/backref.c | 41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 34a8952..dcf2448 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1302,20 +1302,45 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 	ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		return ret;
-	ret = btrfs_previous_item(fs_info->extent_root, path,
-					0, BTRFS_EXTENT_ITEM_KEY);
-	if (ret < 0)
-		return ret;
 
-	btrfs_item_key_to_cpu(path->nodes[0], found_key, path->slots[0]);
+	while (1) {
+		u32 nritems;
+		if (path->slots[0] == 0) {
+			btrfs_set_path_blocking(path);
+			ret = btrfs_prev_leaf(fs_info->extent_root, path);
+			if (ret != 0) {
+				if (ret > 0) {
+					pr_debug("logical %llu is not within "
+						 "any extent\n", logical);
+					ret = -ENOENT;
+				}
+				return ret;
+			}
+		} else {
+			path->slots[0]--;
+		}
+		nritems = btrfs_header_nritems(path->nodes[0]);
+		if (nritems == 0) {
+			pr_debug("logical %llu is not within any extent\n",
+				 logical);
+			return -ENOENT;
+		}
+		if (path->slots[0] == nritems)
+			path->slots[0]--;
+
+		btrfs_item_key_to_cpu(path->nodes[0], found_key,
+				      path->slots[0]);
+		if (found_key->type == BTRFS_EXTENT_ITEM_KEY ||
+		    found_key->type == BTRFS_METADATA_ITEM_KEY)
+			break;
+	}
+
 	if (found_key->type == BTRFS_METADATA_ITEM_KEY)
 		size = fs_info->extent_root->leafsize;
 	else if (found_key->type == BTRFS_EXTENT_ITEM_KEY)
 		size = found_key->offset;
 
-	if ((found_key->type != BTRFS_EXTENT_ITEM_KEY &&
-	     found_key->type != BTRFS_METADATA_ITEM_KEY) ||
-	    found_key->objectid > logical ||
+	if (found_key->objectid > logical ||
 	    found_key->objectid + size <= logical) {
 		pr_debug("logical %llu is not within any extent\n", logical);
 		return -ENOENT;
-- 
1.8.3.1

