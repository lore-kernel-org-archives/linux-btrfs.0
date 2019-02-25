Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C299BC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 18:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96A8E2087C
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 18:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfBYS4h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 13:56:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:37040 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725842AbfBYS4h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 13:56:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 78FE4ACCD
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 18:56:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CF312DA83C; Mon, 25 Feb 2019 19:57:57 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: move ulist allocation out of transaction in quota enable
Date:   Mon, 25 Feb 2019 19:55:44 +0100
Message-Id: <20190225185544.14516-1-dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The allocation happens with GFP_KERNEL after a transaction has been
started, this can potentially cause deadlock if reclaim tries to get the
memory by flushing filesystem data.

The qgroup_ulist is not used during transaction start as the quotas are
not yet enabled but to provide the same semantics, use a temporary
variable and assign fs_info::qgroup_ulist as before.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/qgroup.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c1cd5558a646..9e49d5e132b8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -887,6 +887,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 	struct btrfs_key found_key;
 	struct btrfs_qgroup *qgroup = NULL;
 	struct btrfs_trans_handle *trans = NULL;
+	struct ulist *tmp_ulist;
 	int ret = 0;
 	int slot;
 
@@ -894,6 +895,12 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 	if (fs_info->quota_root)
 		goto out;
 
+	tmp_ulist = ulist_alloc(GFP_KERNEL);
+	if (!tmp_ulist) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/*
 	 * 1 for quota root item
 	 * 1 for BTRFS_QGROUP_STATUS item
@@ -909,12 +916,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 		goto out;
 	}
 
-	fs_info->qgroup_ulist = ulist_alloc(GFP_KERNEL);
-	if (!fs_info->qgroup_ulist) {
-		ret = -ENOMEM;
-		btrfs_abort_transaction(trans, ret);
-		goto out;
-	}
+	fs_info->qgroup_ulist = tmp_ulist;
 
 	/*
 	 * initially create the quota tree
-- 
2.20.1

