Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57886 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab2IBNow (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Sep 2012 09:44:52 -0400
Received: by qcro28 with SMTP id o28so2957457qcr.19
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Sep 2012 06:44:51 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 2 Sep 2012 21:44:51 +0800
Message-ID: <CAPgLHd_8pn9p_U1ui4_rJixarTV7V7zoUOH_WFvx8oHrH9qpaQ@mail.gmail.com>
Subject: [PATCH] Btrfs: fix possible memory leak in scrub_setup_recheck_block()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: chris.mason@fusionio.com
Cc: yongjun_wei@trendmicro.com.cn, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

bbio has been malloced in btrfs_map_block() and should be
freed before leaving from the error handling cases.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/btrfs/scrub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b223620..4e9eafe 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1029,6 +1029,7 @@ static int scrub_setup_recheck_block(struct scrub_dev *sdev,
 				spin_lock(&sdev->stat_lock);
 				sdev->stat.malloc_errors++;
 				spin_unlock(&sdev->stat_lock);
+				kfree(bbio);
 				return -ENOMEM;
 			}
 			sblock->page_count++;


