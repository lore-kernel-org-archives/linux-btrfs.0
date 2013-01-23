Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62251 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab3AWHZu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 02:25:50 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so7215320iea.5
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 23:25:50 -0800 (PST)
Message-ID: <50FF905D.80805@gmail.com>
Date: Wed, 23 Jan 2013 15:25:17 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup for btrfs_extend_item
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Two cleanups:
	* The data_size is the new added size, not the new size after extend.
	  Make the description more clear.
	* The var data_end is not used anymore after the data shift.
	  Remove the useless assignment.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  fs/btrfs/ctree.c |    4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index eea5da7..c4f295e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4376,7 +4376,8 @@ void btrfs_truncate_item(struct btrfs_trans_handle *trans,
  }

  /*
- * make the item pointed to by the path bigger, data_size is the new size.
+ * make the item pointed to by the path bigger.
+ * data_size is the to be extended size.
   */
  void btrfs_extend_item(struct btrfs_trans_handle *trans,
  		       struct btrfs_root *root, struct btrfs_path *path,
@@ -4432,7 +4433,6 @@ void btrfs_extend_item(struct btrfs_trans_handle *trans,
  		      data_end - data_size, btrfs_leaf_data(leaf) +
  		      data_end, old_data - data_end);

-	data_end = old_data;
  	old_size = btrfs_item_size_nr(leaf, slot);
  	item = btrfs_item_nr(leaf, slot);
  	btrfs_set_item_size(leaf, item, old_size + data_size);
-- 
1.7.10.4

