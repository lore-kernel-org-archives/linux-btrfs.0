Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15937 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932684AbeAKKLS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 05:11:18 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, Gu JinXiang <gujx@cn.fujitsu.com>
Subject: [PATCH v2 1/2] btrfs-progs: do less aggressive btree readahead
Date: Thu, 11 Jan 2018 18:11:07 +0800
Message-ID: <1515665468-7450-2-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1515665468-7450-1-git-send-email-gujx@cn.fujitsu.com>
References: <1512471667-8555-1-git-send-email-gujx@cn.fujitsu.com>
 <1515665468-7450-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update btrfs-progs to match kernel sources.
Reference:
commit a717531942f4 ("Btrfs: do less aggressive btree readahead")

Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>
---
 ctree.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/ctree.c b/ctree.c
index 4fc33b14..361e53a8 100644
--- a/ctree.c
+++ b/ctree.c
@@ -972,8 +972,7 @@ void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 	struct btrfs_disk_key disk_key;
 	u32 nritems;
 	u64 search;
-	u64 lowest_read;
-	u64 highest_read;
+	u64 target;
 	u64 nread = 0;
 	int direction = path->reada;
 	struct extent_buffer *eb;
@@ -994,8 +993,7 @@ void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 		return;
 	}
 
-	highest_read = search;
-	lowest_read = search;
+	target = search;
 
 	nritems = btrfs_header_nritems(node);
 	nr = slot;
@@ -1015,23 +1013,15 @@ void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 				break;
 		}
 		search = btrfs_node_blockptr(node, nr);
-		if ((search >= lowest_read && search <= highest_read) ||
-		    (search < lowest_read && lowest_read - search <= 32768) ||
-		    (search > highest_read && search - highest_read <= 32768)) {
+		if ((search <= target && target - search <= 65536) ||
+		    (search > target && search - target <= 65536)) {
 			readahead_tree_block(fs_info, search,
 				     btrfs_node_ptr_generation(node, nr));
 			nread += fs_info->nodesize;
 		}
 		nscan++;
-		if (path->reada < 2 && (nread > SZ_256K || nscan > 32))
+		if ((nread > 65536 || nscan > 32))
 			break;
-		if(nread > SZ_1M || nscan > 128)
-			break;
-
-		if (search < lowest_read)
-			lowest_read = search;
-		if (search > highest_read)
-			highest_read = search;
 	}
 }
 
-- 
2.14.3



