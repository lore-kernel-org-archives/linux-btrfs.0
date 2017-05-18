Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46077 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932097AbdERDjT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:19 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 14/32] btrfs-progs: Refactor nodesize users in utils.c
Date: Thu, 18 May 2017 11:38:39 +0800
Message-ID: <20170518033857.15002-15-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index d2489e70..823b7f3d 100644
--- a/utils.c
+++ b/utils.c
@@ -378,7 +378,7 @@ int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_inode_generation(&inode_item, trans->transid);
 	btrfs_set_stack_inode_size(&inode_item, 0);
 	btrfs_set_stack_inode_nlink(&inode_item, 1);
-	btrfs_set_stack_inode_nbytes(&inode_item, root->nodesize);
+	btrfs_set_stack_inode_nbytes(&inode_item, root->fs_info->nodesize);
 	btrfs_set_stack_inode_mode(&inode_item, S_IFDIR | 0755);
 	btrfs_set_stack_timespec_sec(&inode_item.atime, now);
 	btrfs_set_stack_timespec_nsec(&inode_item.atime, 0);
-- 
2.13.0



