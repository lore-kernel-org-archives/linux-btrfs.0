Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918AAC5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 11:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 570212087A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 11:17:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 570212087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbeJRTSM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 15:18:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:42894 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727470AbeJRTSL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 15:18:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9DF5AAE66
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 11:17:38 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: relocation: Commit transaction before dropping btrfs_root::reloc_root
Date:   Thu, 18 Oct 2018 19:17:25 +0800
Message-Id: <20181018111729.11128-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181018111729.11128-1-wqu@suse.com>
References: <20181018111729.11128-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently only relocation code cares about btrfs_root::reloc_root, and
they have the method to sync btrfs_root::reloc_root without screwing
things up.

However qgroup code doesn't really have the ability to keep
btrfs_root::reloc_root reliable.

Currently if someone outside of relocation code want to access
btrfs_root::reloc_root, it's highly possible some race could make
@reloc_root unreliable.

Thankfully, we only need to make qgroup code access
btrfs_root::reloc_root, and due to the nature of qgroup, it only needs
it before committing a transaction.

So alter the timming of transaction commit for merge_reloc_root(). For
every successful root merge, commit transaction before dropping
btrfs_root::reloc_root, making qgroup code happy with it.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 44efde9886fc..a8b62323f60b 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2251,6 +2251,17 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 	btrfs_free_path(path);
 
 	if (err == 0) {
+		/*
+		 * Commit current trans before we reset root->reloc_root
+		 * pointer, since qgroup code still needs root->reloc_root
+		 * to trace post-swap CoWs until we commit transaction.
+		 */
+		err = btrfs_commit_transaction(trans);
+		if (err < 0)
+			return err;
+		trans = btrfs_start_transaction(root, 0);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
 		memset(&root_item->drop_progress, 0,
 		       sizeof(root_item->drop_progress));
 		root_item->drop_level = 0;
-- 
2.19.1

