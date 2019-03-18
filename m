Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BA9C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 15:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C2A620872
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 15:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfCRPpZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:45:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:44288 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727093AbfCRPpZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 11:45:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 635AEAED7
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 15:45:24 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs: Fix bound checking in qgroup_trace_new_subtree_blocks
Date:   Mon, 18 Mar 2019 17:45:19 +0200
Message-Id: <20190318154520.4086-3-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190318154520.4086-1-nborisov@suse.com>
References: <20190318154520.4086-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If 'cur_level' is 7  then the bound checking at the top of the function
will actually pass. Later on, it's possible to dereference
ds_path->nodes[cur_level+1] which will be an out of bounds.

The correct check will be cur_level >= BTRFS_MAX_LEVEL - 1 .

Fixes-coverty-id: 1440918
Fixes-coverty-id: 1440911
Fixes: ea49f3e73c4b ("btrfs: qgroup: Introduce function to find all new tree blocks of reloc tree")
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/qgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index eb680b715dd6..7019edf5625c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1922,8 +1922,8 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 	int i;
 
 	/* Level sanity check */
-	if (cur_level < 0 || cur_level >= BTRFS_MAX_LEVEL ||
-	    root_level < 0 || root_level >= BTRFS_MAX_LEVEL ||
+	if (cur_level < 0 || cur_level >= BTRFS_MAX_LEVEL - 1 ||
+	    root_level < 0 || root_level >= BTRFS_MAX_LEVEL - 1 ||
 	    root_level < cur_level) {
 		btrfs_err_rl(fs_info,
 			"%s: bad levels, cur_level=%d root_level=%d",
@@ -3482,7 +3482,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
 	if (free && reserved)
 		return qgroup_free_reserved_data(inode, reserved, start, len);
 	extent_changeset_init(&changeset);
-	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start, 
+	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
 			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
 	if (ret < 0)
 		goto out;
-- 
2.17.1

