Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39715 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2IEGiu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2012 02:38:50 -0400
Received: by qaas11 with SMTP id s11so4194167qaa.19
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2012 23:38:50 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 14:38:49 +0800
Message-ID: <CAPgLHd_OU1_aJPO-nt6ZtHjCDH77vyvEeeXjQ7AcTypH_3bH1Q@mail.gmail.com>
Subject: [PATCH] Btrfs: use list_move_tail instead of list_del/list_add_tail
From: Wei Yongjun <weiyj.lk@gmail.com>
To: chris.mason@fusionio.com
Cc: yongjun_wei@trendmicro.com.cn, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/btrfs/send.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index fb5ffe9..fbea0de 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1792,8 +1792,7 @@ static struct name_cache_entry *name_cache_search(struct send_ctx *sctx,
 
 static void name_cache_used(struct send_ctx *sctx, struct name_cache_entry *nce)
 {
-	list_del(&nce->list);
-	list_add_tail(&nce->list, &sctx->name_cache_list);
+	list_move_tail(&nce->list, &sctx->name_cache_list);
 }
 
 static void name_cache_clean_unused(struct send_ctx *sctx)


