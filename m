Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26D3C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 12:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9E722087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 12:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbfB0MMV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 07:12:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:60322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726062AbfB0MMV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 07:12:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 862BAAA71;
        Wed, 27 Feb 2019 12:12:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6FD23DA83C; Wed, 27 Feb 2019 13:13:41 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     fdmanana@gmail.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2] btrfs: move ulist allocation out of transaction in quota enable
Date:   Wed, 27 Feb 2019 13:13:24 +0100
Message-Id: <20190227121323.20498-1-dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190225185544.14516-1-dsterba@suse.com>
References: <20190225185544.14516-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The allocation happens with GFP_KERNEL after a transaction has been
started, this can potentially cause deadlock if reclaim tries to get the
memory by flushing filesystem data.

The fs_info::qgroup_ulist is not used during transaction start when
quotas are not enabled. The status bit BTRFS_FS_QUOTA_ENABLED is set
later in btrfs_quota_enable so it's safe to move it before the
transaction start.

Signed-off-by: David Sterba <dsterba@suse.com>

v2:
- use qgroup_ulist directly, drop the temporary variable
- update changelog
---
 fs/btrfs/qgroup.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c1cd5558a646..eb680b715dd6 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -894,6 +894,12 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 	if (fs_info->quota_root)
 		goto out;
 
+	fs_info->qgroup_ulist = ulist_alloc(GFP_KERNEL);
+	if (!fs_info->qgroup_ulist) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/*
 	 * 1 for quota root item
 	 * 1 for BTRFS_QGROUP_STATUS item
@@ -909,13 +915,6 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 		goto out;
 	}
 
-	fs_info->qgroup_ulist = ulist_alloc(GFP_KERNEL);
-	if (!fs_info->qgroup_ulist) {
-		ret = -ENOMEM;
-		btrfs_abort_transaction(trans, ret);
-		goto out;
-	}
-
 	/*
 	 * initially create the quota tree
 	 */
-- 
2.20.1

