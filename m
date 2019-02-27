Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF87C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 21:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BAE22083D
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 21:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551302579;
	bh=6dY+ub8recU3tRwJYm/SQGJM5gm0+DCz7fncW84b3uI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=VOsI589D5sGVN4QBLKim2wqE7AZVeDut4fBvMho1C40xVo9Aol7DHFKUmjl24CoaR
	 ujeKGAgKho036MqoSP6kghrjlmRR2myL4oMCf736afNc/+1Q4znCtpu6wO7bgJV4uz
	 H9TPT7UFLSanCec+Ff2IcZz4cO7vBXyBV02KGTgg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbfB0VWy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 16:22:54 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:39498 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729412AbfB0VWy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 16:22:54 -0500
Received: by mail-yw1-f68.google.com with SMTP id z191so8720818ywa.6;
        Wed, 27 Feb 2019 13:22:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Bw7SPCNkvP8Cy2xjgdDrHGkBpnkIyNcOhTzkkyC5wig=;
        b=FlvfubP7PYTiXRpkozCgSPKVyD57wPVydm4PTIJzzRF7sKO+vyJxHqZHxdxbP7Saq4
         O3zDXi9BOHdOdRqy5vLFyuHs5KXvX9DiZchgVuKw933aGY7U55KWBKmaUMZyLWFnd9sH
         bdwUi+JfqqrvSBRwUK/F+/nhYNAwqPNf1wCxf7crbVUhGFTiHbFBJOstP+wFLztvXy3A
         ql7GO4O+H44XfVdKC68ay7M8WLzcGze6J/GeR6RbQZuYPW968GUUEii6lnbYZ+AcU9gC
         3ROMFq6ayohdnjPJ495gHmLPWvTaNdAiw/ZQo3xuQEFSUm5D44GpLkRMoZNk+vs9PPoj
         jjsg==
X-Gm-Message-State: AHQUAubI6hceSBMKiAbk6aJpjqucUez0lyhhE9teoe6MmbJc8KzZGEUK
        MyLy/nuU0ZUML43Hnp9GGnI=
X-Google-Smtp-Source: AHgI3IYXpEGSp1GlwEGCqPYL/bFyUPVDw9y811gxjJKWcVi5rNZ9eJJ6gZrrw0MGmF4f9bwBArRzcg==
X-Received: by 2002:a25:3403:: with SMTP id b3mr3852646yba.164.1551302572773;
        Wed, 27 Feb 2019 13:22:52 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.133])
        by smtp.gmail.com with ESMTPSA id f185sm7872558ywf.18.2019.02.27.13.22.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 27 Feb 2019 13:22:51 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH] btrfs: remove indirect function calls from zstd
Date:   Wed, 27 Feb 2019 16:21:28 -0500
Message-Id: <20190227212128.38491-1-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

While calling functions inside zstd, we don't need to use the
indirection provided by the workspace_manager. Forward declarations are
added to maintain the function order of btrfs_compress_op.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 fs/btrfs/zstd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 6b9e29d050f3..a6ff07cf11d5 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -90,6 +90,9 @@ static inline struct workspace *list_to_workspace(struct list_head *list)
 	return container_of(list, struct workspace, list);
 }
 
+static void zstd_free_workspace(struct list_head *ws);
+static struct list_head *zstd_alloc_workspace(unsigned int level);
+
 /*
  * zstd_reclaim_timer_fn - reclaim timer
  * @t: timer
@@ -124,7 +127,7 @@ static void zstd_reclaim_timer_fn(struct timer_list *timer)
 		level = victim->level;
 		list_del(&victim->lru_list);
 		list_del(&victim->list);
-		wsm.ops->free_workspace(&victim->list);
+		zstd_free_workspace(&victim->list);
 
 		if (list_empty(&wsm.idle_ws[level - 1]))
 			clear_bit(level - 1, &wsm.active_map);
@@ -180,7 +183,7 @@ static void zstd_init_workspace_manager(void)
 	for (i = 0; i < ZSTD_BTRFS_MAX_LEVEL; i++)
 		INIT_LIST_HEAD(&wsm.idle_ws[i]);
 
-	ws = wsm.ops->alloc_workspace(ZSTD_BTRFS_MAX_LEVEL);
+	ws = zstd_alloc_workspace(ZSTD_BTRFS_MAX_LEVEL);
 	if (IS_ERR(ws)) {
 		pr_warn(
 		"BTRFS: cannot preallocate zstd compression workspace\n");
@@ -202,7 +205,7 @@ static void zstd_cleanup_workspace_manager(void)
 						 struct workspace, list);
 			list_del(&workspace->list);
 			list_del(&workspace->lru_list);
-			wsm.ops->free_workspace(&workspace->list);
+			zstd_free_workspace(&workspace->list);
 		}
 	}
 	spin_unlock(&wsm.lock);
@@ -272,7 +275,7 @@ static struct list_head *zstd_get_workspace(unsigned int level)
 		return ws;
 
 	nofs_flag = memalloc_nofs_save();
-	ws = wsm.ops->alloc_workspace(level);
+	ws = zstd_alloc_workspace(level);
 	memalloc_nofs_restore(nofs_flag);
 
 	if (IS_ERR(ws)) {
-- 
2.17.1

