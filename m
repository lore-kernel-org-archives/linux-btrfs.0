Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:45312 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaANQ0x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 11:26:53 -0500
Received: by mail-pd0-f173.google.com with SMTP id p10so8986534pdj.32
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 08:26:53 -0800 (PST)
Received: from linux-b0ol.localdomain ([223.65.189.206])
        by mx.google.com with ESMTPSA id lh13sm2782922pab.4.2014.01.14.08.26.51
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2014 08:26:52 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix wrong search path initialization before searching tree root
Date: Wed, 15 Jan 2014 00:26:43 +0800
Message-Id: <1389716803-2415-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1389716803-2415-1-git-send-email-wangshilong1991@gmail.com>
References: <1389716803-2415-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

To search tree root without transaction protection, we should neither search commit
root nor skip locking here, fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 54665d4..14f9693 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2095,7 +2095,7 @@ static int send_subvol_begin(struct send_ctx *sctx)
 	char *name = NULL;
 	int namelen;
 
-	path = alloc_path_for_send();
+	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-- 
1.8.4

