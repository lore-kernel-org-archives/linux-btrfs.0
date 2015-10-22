Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38685 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750732AbbJVAod (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 20:44:33 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 RESENT 1/2] btrfs: Add support to do stack item key operation
Date: Thu, 22 Oct 2015 08:42:27 +0800
Message-ID: <1445474548-9243-1-git-send-email-quwenruo@cn.fujitsu.com>
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
v2:
  Change the char* parameter to struct btrfs_header *, as a leaf always
  has a header.
v3:
  Fix a bug caused in type change of stack_leaf.
---
 fs/btrfs/ctree.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 938efe3..b824fe2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2683,6 +2683,17 @@ static inline void btrfs_item_key(struct extent_buffer *eb,
 	read_eb_member(eb, item, struct btrfs_item, key, disk_key);
 }
 
+static inline void btrfs_stack_item_key(struct btrfs_header *stack_leaf,
+					struct btrfs_disk_key *disk_key,
+					int nr)
+{
+	unsigned long item_offset = btrfs_item_nr_offset(nr);
+	struct btrfs_item *item;
+
+	item = (struct btrfs_item *)((char *)(stack_leaf) + item_offset);
+	memcpy(disk_key, &item->key, sizeof(*disk_key));
+}
+
 static inline void btrfs_set_item_key(struct extent_buffer *eb,
 			       struct btrfs_disk_key *disk_key, int nr)
 {
@@ -2785,6 +2796,15 @@ static inline void btrfs_item_key_to_cpu(struct extent_buffer *eb,
 	btrfs_disk_key_to_cpu(key, &disk_key);
 }
 
+static inline void btrfs_stack_item_key_to_cpu(struct btrfs_header *stack_leaf,
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
2.6.1

