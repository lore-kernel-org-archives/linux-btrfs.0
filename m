Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1768C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 17:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AB612080F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 17:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbfBLRYO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:24:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:47232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730324AbfBLRYO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 12:24:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1CA1EAC98
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 17:24:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 63D17DA84E; Tue, 12 Feb 2019 18:23:31 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: scrub: remove unused nocow worker pointer
Date:   Tue, 12 Feb 2019 18:23:14 +0100
Message-Id: <20190212172314.15290-1-dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The member btrfs_fs_info::scrub_nocow_workers is unused since the nocow
optimization was removed from scrub in 9bebe665c3e4 ("btrfs: scrub:
Remove unused copy_nocow_pages and its callchain").

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9306925b6790..7f3826ca7c91 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1078,7 +1078,6 @@ struct btrfs_fs_info {
 	int scrub_workers_refcnt;
 	struct btrfs_workqueue *scrub_workers;
 	struct btrfs_workqueue *scrub_wr_completion_workers;
-	struct btrfs_workqueue *scrub_nocow_workers;
 	struct btrfs_workqueue *scrub_parity_workers;
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
-- 
2.20.1

