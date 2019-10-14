Return-Path: <SRS0=w+x4=YH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5EFECE58E
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Oct 2019 12:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C5D6217D9
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Oct 2019 12:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731996AbfJNMWl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:22:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:37588 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731987AbfJNMWk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Oct 2019 08:22:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9C2E3BE8D;
        Mon, 14 Oct 2019 12:22:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 36C29DA7E3; Mon, 14 Oct 2019 14:22:52 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 13/15] btrfs: compression: pass type to btrfs_put_workspace
Date:   Mon, 14 Oct 2019 14:22:52 +0200
Message-Id: <2f1a94f4a4ef70a4bee360c86175a8e22e5712e1.1571054758.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1571054758.git.dsterba@suse.com>
References: <cover.1571054758.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can infer the workspace_manager from type and the type will be used
in the following patch to call a common helper for free_workspace.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 13 ++++++-------
 fs/btrfs/compression.h |  2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 4a8dab961f88..2a77c91c194b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1086,14 +1086,16 @@ static struct list_head *get_workspace(int type, int level)
  * put a workspace struct back on the list or free it if we have enough
  * idle ones sitting around
  */
-void btrfs_put_workspace(struct workspace_manager *wsm, struct list_head *ws)
+void btrfs_put_workspace(int type, struct list_head *ws)
 {
+	struct workspace_manager *wsm;
 	struct list_head *idle_ws;
 	spinlock_t *ws_lock;
 	atomic_t *total_ws;
 	wait_queue_head_t *ws_wait;
 	int *free_ws;
 
+	wsm = btrfs_compress_op[type]->workspace_manager;
 	idle_ws	 = &wsm->idle_ws;
 	ws_lock	 = &wsm->ws_lock;
 	total_ws = &wsm->total_ws;
@@ -1117,13 +1119,10 @@ void btrfs_put_workspace(struct workspace_manager *wsm, struct list_head *ws)
 
 static void put_workspace(int type, struct list_head *ws)
 {
-	struct workspace_manager *wsm;
-
-	wsm = btrfs_compress_op[type]->workspace_manager;
 	switch (type) {
-	case BTRFS_COMPRESS_NONE: return btrfs_put_workspace(wsm, ws);
-	case BTRFS_COMPRESS_ZLIB: return btrfs_put_workspace(wsm, ws);
-	case BTRFS_COMPRESS_LZO:  return btrfs_put_workspace(wsm, ws);
+	case BTRFS_COMPRESS_NONE: return btrfs_put_workspace(type, ws);
+	case BTRFS_COMPRESS_ZLIB: return btrfs_put_workspace(type, ws);
+	case BTRFS_COMPRESS_LZO:  return btrfs_put_workspace(type, ws);
 	case BTRFS_COMPRESS_ZSTD: return zstd_put_workspace(ws);
 	default:
 		/*
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 8336c2ef6b5a..664b029cd5e4 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -121,7 +121,7 @@ struct workspace_manager {
 };
 
 struct list_head *btrfs_get_workspace(int type, unsigned int level);
-void btrfs_put_workspace(struct workspace_manager *wsm, struct list_head *ws);
+void btrfs_put_workspace(int type, struct list_head *ws);
 
 struct btrfs_compress_op {
 	void (*free_workspace)(struct list_head *workspace);
-- 
2.23.0

