Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53632 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727025AbeHGKc4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 06:32:56 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 352EAADB9
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Aug 2018 08:19:43 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/11] btrfs-progs: qgroup-verify: Avoid NULL pointer dereference for later silent qgroup repair
Date: Tue,  7 Aug 2018 16:19:28 +0800
Message-Id: <20180807081938.21348-2-wqu@suse.com>
In-Reply-To: <20180807081938.21348-1-wqu@suse.com>
References: <20180807081938.21348-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 078e9a1cc973 ("btrfs-progs: check: enhanced progress indicator")
introduced @qgroup_item_count for progress indicator.

However since we will later introduce silent qgroup rescan
functionality, the @qgroup_item_count pointer can be NULL.

So check if @qgroup_item_count is NULL before accessing it.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 qgroup-verify.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index f5885589f02c..9b509abb78fd 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -743,7 +743,8 @@ static int travel_tree(struct btrfs_fs_info *info, struct btrfs_root *root,
 	 */
 	nr = btrfs_header_nritems(eb);
 	for (i = 0; i < nr; i++) {
-		(*qgroup_item_count)++;
+		if (qgroup_item_count)
+			(*qgroup_item_count)++;
 		new_bytenr = btrfs_node_blockptr(eb, i);
 		new_num_bytes = info->nodesize;
 
-- 
2.18.0

