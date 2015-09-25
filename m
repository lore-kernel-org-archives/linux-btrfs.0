Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54197 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754177AbbIYCiU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 22:38:20 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <stephane_btrfs@lesimple.fr>
Subject: [PATCH 1/2] btrfs: Add support to do stack item key operation
Date: Fri, 25 Sep 2015 10:38:00 +0800
Message-ID: <1443148681-3015-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1443148681-3015-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1443148681-3015-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Normal btrfs_item_key_to_cpu() will need extent buffer to do it, and
there is not stack version to handle in memory leaf.

Add btrfs_stack_item_key_to_cpu() function for such operation, which
will provide the basis for later qgroup fix.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 938efe3..33e9d04 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2683,6 +2683,17 @@ static inline void btrfs_item_key(struct extent_buffer *eb,
 	read_eb_member(eb, item, struct btrfs_item, key, disk_key);
 }
 
+static inline void btrfs_stack_item_key(char *stack_leaf,
+					struct btrfs_disk_key *disk_key,
+					int nr)
+{
+	unsigned long item_offset = btrfs_item_nr_offset(nr);
+	struct btrfs_item *item;
+
+	item = (struct btrfs_item *)(stack_leaf + item_offset);
+	memcpy(disk_key, &item->key, sizeof(*disk_key));
+}
+
 static inline void btrfs_set_item_key(struct extent_buffer *eb,
 			       struct btrfs_disk_key *disk_key, int nr)
 {
@@ -2785,6 +2796,15 @@ static inline void btrfs_item_key_to_cpu(struct extent_buffer *eb,
 	btrfs_disk_key_to_cpu(key, &disk_key);
 }
 
+static inline void btrfs_stack_item_key_to_cpu(char *stack_leaf,
+					       struct btrfs_key *key,
+					       int nr)
+{
+	struct btrfs_disk_key disk_key;
+	btrfs_stack_item_key(stack_leaf, &disk_key, nr);
+	btrfs_disk_key_to_cpu(key, &disk_key);
+}
+
 static inline void btrfs_dir_item_key_to_cpu(struct extent_buffer *eb,
 				      struct btrfs_dir_item *item,
 				      struct btrfs_key *key)
-- 
2.5.3

