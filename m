Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36822 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753948AbeAKG7M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 01:59:12 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] btrfs: use enum instead of constant value
Date: Thu, 11 Jan 2018 14:59:01 +0800
Message-ID: <1515653941-6378-1-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <20171205173546.GL3553@twin.jikos.cz>
References: <20171205173546.GL3553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use enum READA_FORWARD instead of integers value to keep source robust.

Changelog:
v2->v1: change enum from READA_BACK to READA_FORWARD, since according
to the logic of the source, it should reada_for_search forward, not
backward.
And, Reference:
commit e4058b54d1e4 ("btrfs: cleanup, use enum values for btrfs_path reada")

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/free-space-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index fe5e0324dca9..af36a6a971fe 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1071,7 +1071,7 @@ static int populate_free_space_tree(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->reada = 1;
+	path->reada = READA_FORWARD;
 
 	path2 = btrfs_alloc_path();
 	if (!path2) {
@@ -1573,7 +1573,7 @@ int load_free_space_tree(struct btrfs_caching_control *caching_ctl)
 	 */
 	path->skip_locking = 1;
 	path->search_commit_root = 1;
-	path->reada = 1;
+	path->reada = READA_FORWARD;
 
 	info = search_free_space_info(NULL, fs_info, block_group, path, 0);
 	if (IS_ERR(info)) {
-- 
2.14.3



