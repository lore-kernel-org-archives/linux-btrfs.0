Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:63203 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab3EUCjX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 May 2013 22:39:23 -0400
Received: by mail-bk0-f51.google.com with SMTP id ji2so58866bkc.10
        for <linux-btrfs@vger.kernel.org>; Mon, 20 May 2013 19:39:21 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 21 May 2013 10:39:21 +0800
Message-ID: <CAPgLHd99KGnuvOqOzKHveWLg1huNK1b9=PbC331nKrGXrGF54w@mail.gmail.com>
Subject: [PATCH -next] Btrfs: return error code in btrfs_check_trunc_cache_free_space()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: chris.mason@fusionio.com, miaox@cn.fujitsu.com
Cc: yongjun_wei@trendmicro.com.cn, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return error code instead always return 0 from function
btrfs_check_trunc_cache_free_space().
Introduced by commit 7b61cd92242542944fc27024900c495a6a7b3396
(Btrfs: don't use global block reservation for inode cache truncation)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/btrfs/free-space-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e530096..73577f4 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -213,7 +213,7 @@ int btrfs_check_trunc_cache_free_space(struct btrfs_root *root,
 	else
 		ret = 0;
 	spin_unlock(&rsv->lock);
-	return 0;
+	return ret;
 }
 
 int btrfs_truncate_free_space_cache(struct btrfs_root *root,

