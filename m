Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB11C64E7C
	for <linux-btrfs@archiver.kernel.org>; Mon, 23 Nov 2020 18:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F454221EB
	for <linux-btrfs@archiver.kernel.org>; Mon, 23 Nov 2020 18:31:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="reJ47n2T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgKWSbB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 13:31:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729889AbgKWSa6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Nov 2020 13:30:58 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CAAF2078E
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2020 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606156257;
        bh=AXEZcmOvsAiarka9PIuWkZYfnrP1xJiubgHRHPwgAYk=;
        h=From:To:Subject:Date:From;
        b=reJ47n2TftEhnblFrQ5uD0LUwhJVclCE3/kdNrdphm2tBG1wqLikpwEJJIO7uifkq
         ySCuL6RaxHEtkHVm4gQjZ/16LUX0hLOk2GuzGwWgmrdZc8GIuXvL3YeaJYj3JX/BDH
         pupFVEBIr8er3U4PkuHaADcFohqnN074UHuWRYr0=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: do nofs allocations when adding and removing qgroup relations
Date:   Mon, 23 Nov 2020 18:30:54 +0000
Message-Id: <b3e4b5a1b95835d5309421349629cf36ffff9a7f.1606152412.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When adding or removing a qgroup relation we are doing a GFP_KERNEL
allocation which is not safe because we are holding a transaction
handle open and that can make us deadlock if the allocator needs to
recurse into the filesystem. So just surround those calls with a
nofs context.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cbc0266af001..af00003d9756 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/btrfs.h>
+#include <linux/sched/mm.h>
 
 #include "ctree.h"
 #include "transaction.h"
@@ -1363,13 +1364,17 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	struct btrfs_qgroup *member;
 	struct btrfs_qgroup_list *list;
 	struct ulist *tmp;
+	unsigned int nofs_flag;
 	int ret = 0;
 
 	/* Check the level of src and dst first */
 	if (btrfs_qgroup_level(src) >= btrfs_qgroup_level(dst))
 		return -EINVAL;
 
+	/* We hold a transaction handle open, must do a NOFS allocation. */
+	nofs_flag = memalloc_nofs_save();
 	tmp = ulist_alloc(GFP_KERNEL);
+	memalloc_nofs_restore(nofs_flag);
 	if (!tmp)
 		return -ENOMEM;
 
@@ -1426,10 +1431,14 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	struct btrfs_qgroup_list *list;
 	struct ulist *tmp;
 	bool found = false;
+	unsigned int nofs_flag;
 	int ret = 0;
 	int ret2;
 
+	/* We hold a transaction handle open, must do a NOFS allocation. */
+	nofs_flag = memalloc_nofs_save();
 	tmp = ulist_alloc(GFP_KERNEL);
+	memalloc_nofs_restore(nofs_flag);
 	if (!tmp)
 		return -ENOMEM;
 
-- 
2.28.0

