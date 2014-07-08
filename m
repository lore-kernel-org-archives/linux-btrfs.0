Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbaGHUl6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jul 2014 16:41:58 -0400
Date: Tue, 8 Jul 2014 13:41:57 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: ignore orphaned qgroups by default
Message-ID: <20140708204157.GZ5484@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

qgroup items are not deleted by btrfs when the underlying subvolume goes
away. As a result, btrfsck will print those as inconsistent. This can
clutter up the printout so we ignore them by default. They are still printed
if a full report (via --qgroup-report) is requested.

This patch and the ones it depends on (to do qgroup verification) can be
found at:

https://github.com/markfasheh/btrfs-progs-patches/tree/qgroup-verify

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 qgroup-verify.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index 81a1651..2e1716d 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -38,6 +38,7 @@ static void add_bytes(u64 root_objectid, u64 num_bytes, int exclusive);
 
 struct qgroup_count {
 	u64				qgroupid;
+	int				subvol_exists;
 
 	struct btrfs_disk_key		key;
 	struct btrfs_qgroup_info_item	diskinfo;
@@ -697,8 +698,10 @@ static int load_quota_info(struct btrfs_fs_info *info)
 {
 	int ret;
 	struct btrfs_root *root = info->quota_root;
+	struct btrfs_root *tmproot;
 	struct btrfs_path path;
 	struct btrfs_key key;
+	struct btrfs_key root_key;
 	struct btrfs_disk_key disk_key;
 	struct extent_buffer *leaf;
 	struct btrfs_qgroup_info_item *item;
@@ -745,6 +748,15 @@ static int load_quota_info(struct btrfs_fs_info *info)
 				fprintf(stderr, "ERROR: out of memory\n");
 				goto out;
 			}
+
+			root_key.objectid = key.offset;
+			root_key.type = BTRFS_ROOT_ITEM_KEY;
+			root_key.offset = (u64)-1;
+			tmproot = btrfs_read_fs_root_no_cache(info, &root_key);
+			if (tmproot && !IS_ERR(tmproot)) {
+				count->subvol_exists = 1;
+				free(tmproot);
+			}
 		}
 
 		ret = btrfs_next_leaf(root, &path);
@@ -1008,7 +1020,7 @@ static void print_qgroup_difference(struct qgroup_count *count, int verbose)
 
 	is_different = excl_diff || ref_diff;
 
-	if (verbose || is_different) {
+	if (verbose || (is_different && count->subvol_exists)) {
 		printf("Counts for qgroup id: %llu %s\n",
 		       (unsigned long long)count->qgroupid,
 		       is_different ? "are different" : "");
-- 
1.8.4.5

