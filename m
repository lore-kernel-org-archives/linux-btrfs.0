Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46077 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932130AbdERDjP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:15 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 16/32] btrfs-progs: Refactor nodesize user in print-tree.c
Date: Thu, 18 May 2017 11:38:41 +0800
Message-ID: <20170518033857.15002-17-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 print-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/print-tree.c b/print-tree.c
index a0d33956..1b15640b 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1297,7 +1297,7 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 		(unsigned long long)btrfs_header_owner(eb));
 	print_uuids(eb);
 	fflush(stdout);
-	size = root->nodesize;
+	size = root->fs_info->nodesize;
 	for (i = 0; i < nr; i++) {
 		u64 blocknr = btrfs_node_blockptr(eb, i);
 		btrfs_node_key(eb, &disk_key, i);
-- 
2.13.0



