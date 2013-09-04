Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53921 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762944Ab3IDPXR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:23:17 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj1so579044pad.14
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:23:17 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 13/20] Btrfs-progs: fix magic return value in btrfs-imgae.c
Date: Wed,  4 Sep 2013 23:22:30 +0800
Message-Id: <1378308157-4621-14-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 btrfs-image.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 3ea3730..ab229f3 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2588,5 +2588,5 @@ out:
 	else
 		fclose(out);
 
-	return ret;
+	return !!ret;
 }
-- 
1.7.11.7

