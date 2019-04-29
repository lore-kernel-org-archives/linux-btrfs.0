Return-Path: <SRS0=9FC1=S7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC476C43219
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Apr 2019 06:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2DDD2075E
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Apr 2019 06:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfD2GDj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Apr 2019 02:03:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:46934 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726566AbfD2GDj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Apr 2019 02:03:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 307C3AF40
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Apr 2019 06:03:38 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: extent-tree: Add lockdep assert when updating space info
Date:   Mon, 29 Apr 2019 14:03:32 +0800
Message-Id: <20190429060333.24172-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just add a safe net for btrfs_space_info member updating.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7a924eac3bd3..54c853ea0585 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -58,6 +58,7 @@ enum {
 static inline void update_##name(struct btrfs_space_info *sinfo,	\
 				 s64 bytes)				\
 {									\
+	lockdep_assert_held(&sinfo->lock);				\
 	if (bytes < 0 && sinfo->name < -bytes) {			\
 		WARN_ON(1);						\
 		sinfo->name = 0;					\
-- 
2.21.0

