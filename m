Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53930 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725843AbeIGOM7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 10:12:59 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0DFA6AFE1
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 09:32:53 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/5] btrfs: qgroup: Don't trace subtree if we're dropping reloc tree
Date: Fri,  7 Sep 2018 17:32:35 +0800
Message-Id: <20180907093235.28254-6-wqu@suse.com>
In-Reply-To: <20180907093235.28254-1-wqu@suse.com>
References: <20180907093235.28254-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reloc tree doesn't contribute to qgroup numbers, as we have
accounted them at balance time (check replace_path()).

Skip such unneeded subtree trace should reduce some performance
overhead.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index de6f75f5547b..4588153f414c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8643,7 +8643,13 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 			parent = 0;
 		}
 
-		if (need_account) {
+		/*
+		 * Tree reloc tree doesn't contribute to qgroup numbers, and
+		 * we have already accounted them at merge time (replace_path),
+		 * thus we could skip expensive subtree trace here.
+		 */
+		if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID &&
+		    need_account) {
 			ret = btrfs_qgroup_trace_subtree(trans, next,
 							 generation, level - 1);
 			if (ret) {
-- 
2.18.0
