Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58704 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760826AbbBIUDu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:50 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 12/16] Btrfs-progs: unpin excluded extents as we fix things
Date: Mon, 9 Feb 2015 15:03:15 -0500
Message-ID: <1423512199-16552-13-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't want to keep extent records pinned down if we fix stuff as we may need
the space and we can be pretty sure that these records are correct.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 5458c28..9c379e6 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7335,6 +7335,8 @@ static int check_extent_refs(struct btrfs_root *root,
 		return -EAGAIN;
 
 	while(1) {
+		int cur_err = 0;
+
 		fixed = 0;
 		recorded = 0;
 		cache = search_cache_extent(extent_cache, 0);
@@ -7345,6 +7347,7 @@ static int check_extent_refs(struct btrfs_root *root,
 			fprintf(stderr, "extent item %llu has multiple extent "
 				"items\n", (unsigned long long)rec->start);
 			err = 1;
+			cur_err = 1;
 		}
 
 		if (rec->refs != rec->extent_item_refs) {
@@ -7374,7 +7377,7 @@ static int check_extent_refs(struct btrfs_root *root,
 				}
 			}
 			err = 1;
-
+			cur_err = 1;
 		}
 		if (all_backpointers_checked(rec, 1)) {
 			fprintf(stderr, "backpointer mismatch on [%llu %llu]\n",
@@ -7388,6 +7391,7 @@ static int check_extent_refs(struct btrfs_root *root,
 					goto repair_abort;
 				fixed = 1;
 			}
+			cur_err = 1;
 			err = 1;
 		}
 		if (!rec->owner_ref_checked) {
@@ -7402,10 +7406,16 @@ static int check_extent_refs(struct btrfs_root *root,
 				fixed = 1;
 			}
 			err = 1;
+			cur_err = 1;
 		}
 
 		remove_cache_extent(extent_cache, cache);
 		free_all_extent_backrefs(rec);
+		if (!init_extent_tree && repair && (!cur_err || fixed))
+			clear_extent_dirty(root->fs_info->excluded_extents,
+					   rec->start,
+					   rec->start + rec->max_size - 1,
+					   GFP_NOFS);
 		free(rec);
 	}
 repair_abort:
-- 
1.8.3.1

