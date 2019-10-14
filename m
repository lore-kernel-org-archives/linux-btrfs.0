Return-Path: <SRS0=w+x4=YH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B08ECE58E
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Oct 2019 12:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D414D217D9
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Oct 2019 12:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbfJNMWZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:22:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:37454 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731938AbfJNMWY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Oct 2019 08:22:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5BC7FBE79;
        Mon, 14 Oct 2019 12:22:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EFB2DDA7E3; Mon, 14 Oct 2019 14:22:35 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 06/15] btrfs: compression: let workspace manager cleanup take only the type
Date:   Mon, 14 Oct 2019 14:22:35 +0200
Message-Id: <bcb19c6cd3991c504f2ed7ef35d708300be0589b.1571054758.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1571054758.git.dsterba@suse.com>
References: <cover.1571054758.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

With the access to the workspace structures, we can look it up together
with the compression ops inside the workspace manager cleanup helper.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 6 ++++--
 fs/btrfs/compression.h | 2 +-
 fs/btrfs/lzo.c         | 2 +-
 fs/btrfs/zlib.c        | 2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 61b9cf095ee5..6c4dc62b9ab0 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -863,7 +863,7 @@ static struct workspace_manager heuristic_wsm;
 
 static void heuristic_cleanup_workspace_manager(void)
 {
-	btrfs_cleanup_workspace_manager(&heuristic_wsm);
+	btrfs_cleanup_workspace_manager(BTRFS_COMPRESS_NONE);
 }
 
 static struct list_head *heuristic_get_workspace(unsigned int level)
@@ -960,10 +960,12 @@ static void btrfs_init_workspace_manager(int type)
 	}
 }
 
-void btrfs_cleanup_workspace_manager(struct workspace_manager *wsman)
+void btrfs_cleanup_workspace_manager(int type)
 {
+	struct workspace_manager *wsman;
 	struct list_head *ws;
 
+	wsman = btrfs_compress_op[type]->workspace_manager;
 	while (!list_empty(&wsman->idle_ws)) {
 		ws = wsman->idle_ws.next;
 		list_del(ws);
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 12a46139c389..0deaa8e03836 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -123,7 +123,7 @@ struct workspace_manager {
 struct list_head *btrfs_get_workspace(struct workspace_manager *wsm,
 				      unsigned int level);
 void btrfs_put_workspace(struct workspace_manager *wsm, struct list_head *ws);
-void btrfs_cleanup_workspace_manager(struct workspace_manager *wsm);
+void btrfs_cleanup_workspace_manager(int type);
 
 struct btrfs_compress_op {
 	void (*cleanup_workspace_manager)(void);
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index a55079477edf..6aa602040506 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -65,7 +65,7 @@ static struct workspace_manager wsm;
 
 static void lzo_cleanup_workspace_manager(void)
 {
-	btrfs_cleanup_workspace_manager(&wsm);
+	btrfs_cleanup_workspace_manager(BTRFS_COMPRESS_LZO);
 }
 
 static struct list_head *lzo_get_workspace(unsigned int level)
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 39f1d0f1b286..7319e9f3d484 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -31,7 +31,7 @@ static struct workspace_manager wsm;
 
 static void zlib_cleanup_workspace_manager(void)
 {
-	btrfs_cleanup_workspace_manager(&wsm);
+	btrfs_cleanup_workspace_manager(BTRFS_COMPRESS_ZLIB);
 }
 
 static struct list_head *zlib_get_workspace(unsigned int level)
-- 
2.23.0

