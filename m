Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12967C65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 05:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3FCE20870
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 05:49:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3FCE20870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbeLMFtC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 00:49:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:47536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726226AbeLMFtC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 00:49:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5D6BAAEBD
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Dec 2018 05:49:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: Don't scan leaf if we're modifying reloc tree
Date:   Thu, 13 Dec 2018 13:48:56 +0800
Message-Id: <20181213054856.22340-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since reloc tree doesn't contribute to qgroup numbers, just skip them.

This should catch the final leakage of unnecessary data refs for qgroup.
The 4G data 16 snapshots test should explain it pretty well:

             | delayed subtree | refactor delayed ref | this patch (*)
---------------------------------------------------------------------
relocated    |           22653 |                22673 |         22744
qgroup dirty |          122792 |                48360 |            70
time         |          24.494 |               11.606 |         3.944

*: Needs to be applied upon delayed subtree scan and delayed ref
refactor patchsets.

Finally, we're at the stage where qgroup + metadata balance cost no
obvious overhead.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 26afed91bfb2..11d70de16bb7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8773,11 +8773,13 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
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
2.19.2

