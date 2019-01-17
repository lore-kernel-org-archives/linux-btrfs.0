Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59703C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 16:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32C8B20855
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 16:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbfAQQP4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:15:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:48482 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728598AbfAQQPw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 11:15:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A796EACB1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 16:15:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5E734DA83D; Thu, 17 Jan 2019 17:15:22 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: simplify workqueue name when allocating
Date:   Thu, 17 Jan 2019 17:15:18 +0100
Message-Id: <20190117161518.24199-1-dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The workqueue name is constructed from a format string but the prefix
does not need to be set by %s.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/async-thread.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 44a7942f0457..92dfc70f9511 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -127,13 +127,11 @@ __btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info, const char *name,
 	}
 
 	if (flags & WQ_HIGHPRI)
-		ret->normal_wq = alloc_workqueue("%s-%s-high", flags,
-						 ret->current_active, "btrfs",
-						 name);
+		ret->normal_wq = alloc_workqueue("btrfs-%s-high", flags,
+						 ret->current_active, name);
 	else
-		ret->normal_wq = alloc_workqueue("%s-%s", flags,
-						 ret->current_active, "btrfs",
-						 name);
+		ret->normal_wq = alloc_workqueue("btrfs-%s", flags,
+						 ret->current_active, name);
 	if (!ret->normal_wq) {
 		kfree(ret);
 		return NULL;
-- 
2.20.1

