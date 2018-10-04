Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367A2C64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 05:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC8D2213A2
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 05:49:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC8D2213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbeJDMlc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 08:41:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:53126 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726438AbeJDMlc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Oct 2018 08:41:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5E0C3B063
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2018 05:49:56 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: Populate btrfs_super_block::log_root_transid
Date:   Thu,  4 Oct 2018 13:49:49 +0800
Message-Id: <20181004054950.11651-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181004054950.11651-1-wqu@suse.com>
References: <20181004054950.11651-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have btrfs_super_block::log_root_transid to record the transid of log
tree root.

However it's never populated and it's always 0, just as the following
dump-super:
 log_root                30572544
 log_root_transid        0
 log_root_level          0

This patch will populate it with log tree root correctly, so the result
will be:
 log_root                30572544
 log_root_transid        6
 log_root_level          0

This won't affect current kernel behavior or btrfs check result as we
already expect log tree root generation always to be super block
genration + 1.

But it could be later used to detect log tree corruption early.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/transaction.c | 1 +
 fs/btrfs/tree-log.c    | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3b84f5015029..9d4947079aa3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2211,6 +2211,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	btrfs_set_super_log_root(fs_info->super_copy, 0);
 	btrfs_set_super_log_root_level(fs_info->super_copy, 0);
+	btrfs_set_super_log_root_transid(fs_info->super_copy, 0);
 	memcpy(fs_info->super_for_commit, fs_info->super_copy,
 	       sizeof(*fs_info->super_copy));
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1650dc44a5e3..3e16e7b54922 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3131,6 +3131,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 				 log_root_tree->node->start);
 	btrfs_set_super_log_root_level(fs_info->super_for_commit,
 				       btrfs_header_level(log_root_tree->node));
+	btrfs_set_super_log_root_transid(fs_info->super_for_commit,
+				btrfs_header_generation(log_root_tree->node));
 
 	log_root_tree->log_transid++;
 	mutex_unlock(&log_root_tree->log_mutex);
-- 
2.19.0

