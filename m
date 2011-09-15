From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 03/20] btrfs: Don't BUG_ON kzalloc error in btrfs_lookup_csums_range()
Date: Thu, 15 Sep 2011 10:34:42 -0700
Message-ID: <1316108099-5099-4-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

Unfortunately it isn't enough to just exit here - the kzalloc() happens in a
loop and the allocated items are added to a linked list whose head is passed
in from the caller.

To fix the BUG_ON() and also provide the semantic that the list passed in is
only modified on success, I create function-local temporary list that we add
items too. If no error is met, that list is spliced to the callers at the
end of the function. Otherwise the list will be walked and all items freed
before the error value is returned.

I did a simple test on this patch by forcing an error at the kzalloc() point
and verifying that when this hits (git clone seemed to exercise this), the
function throws the proper error. Unfortunately but predictably, we later
hit a BUG_ON(ret) type line that still hasn't been fixed up ;)

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/file-item.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index b910694..679fbff 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -284,6 +284,7 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 	struct btrfs_ordered_sum *sums;
 	struct btrfs_sector_sum *sector_sum;
 	struct btrfs_csum_item *item;
+	LIST_HEAD(tmplist);
 	unsigned long offset;
 	int ret;
 	size_t size;
@@ -358,7 +359,10 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 					MAX_ORDERED_SUM_BYTES(root));
 			sums = kzalloc(btrfs_ordered_sum_size(root, size),
 					GFP_NOFS);
-			BUG_ON(!sums);
+			if (!sums) {
+				ret = -ENOMEM;
+				goto fail;
+			}
 
 			sector_sum = sums->sums;
 			sums->bytenr = start;
@@ -380,12 +384,19 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 				offset += csum_size;
 				sector_sum++;
 			}
-			list_add_tail(&sums->list, list);
+			list_add_tail(&sums->list, &tmplist);
 		}
 		path->slots[0]++;
 	}
 	ret = 0;
 fail:
+	while (ret < 0 && !list_empty(&tmplist)) {
+		sums = list_entry(&tmplist, struct btrfs_ordered_sum, list);
+		list_del(&sums->list);
+		kfree(sums);
+	}
+	list_splice_tail(&tmplist, list);
+
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.7.6

