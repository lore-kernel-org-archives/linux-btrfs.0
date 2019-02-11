Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625CBC282CC
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 05:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3036420855
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 05:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfBKFRR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 00:17:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:49688 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726191AbfBKFRR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 00:17:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2EE84AD38
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 05:17:16 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 9/9] btrfs: qgroup: Don't scan leaf if we're modifying reloc tree
Date:   Mon, 11 Feb 2019 13:16:53 +0800
Message-Id: <20190211051653.3167-10-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211051653.3167-1-wqu@suse.com>
References: <20190211051653.3167-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since reloc tree doesn't contribute to qgroup numbers, just skip them.

This should catch the final cause of unnecessary data refs for qgroup +
metadata balance.

The 4G data 16 snapshots test (*) should explain it pretty well:

             | delayed subtree | refactor delayed ref | this patch
---------------------------------------------------------------------
relocated    |           22653 |                22673 |         22744
qgroup dirty |          122792 |                48360 |            70
time         |          24.494 |               11.606 |         3.944

Finally, we're at the stage where qgroup + metadata balance cost no
obvious overhead.

*: Test environment
Test VM:
- vRAM		8G
- vCPU		8
- block dev	vitrio-blk, 'unsafe' cache mode
- host block	850evo

Test workload
- Copy 4G data from /usr/ to one subvolume
- Create 16 snapshots of that subvolume, and modify 3 files in each
  snapshot
- Enable quota, rescan
- Time "btrfs balance start -m"

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2f34a8f5e91..0dde0cbc1622 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9188,11 +9188,13 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			else
 				ret = btrfs_dec_ref(trans, root, eb, 0);
 			BUG_ON(ret); /* -ENOMEM */
-			ret = btrfs_qgroup_trace_leaf_items(trans, eb);
-			if (ret) {
-				btrfs_err_rl(fs_info,
-					     "error %d accounting leaf items. Quota is out of sync, rescan required.",
+			if (is_fstree(root->root_key.objectid)) {
+				ret = btrfs_qgroup_trace_leaf_items(trans, eb);
+				if (ret) {
+					btrfs_err_rl(fs_info,
+"error %d accounting leaf items. Quota is out of sync, rescan required.",
 					     ret);
+				}
 			}
 		}
 		/* make block locked assertion in clean_tree_block happy */
-- 
2.20.1

