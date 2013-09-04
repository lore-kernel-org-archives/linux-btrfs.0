Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37997 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762898Ab3IDPXb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:23:31 -0400
Received: by mail-pa0-f42.google.com with SMTP id lj1so580996pab.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:23:31 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 15/20] Btrfs-progs: fix magic return value in send-test.c
Date: Wed,  4 Sep 2013 23:22:32 +0800
Message-Id: <1378308157-4621-16-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 send-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/send-test.c b/send-test.c
index cb1f57d..3775f5f 100644
--- a/send-test.c
+++ b/send-test.c
@@ -454,5 +454,5 @@ int main(int argc, char **argv)
 
 	pthread_attr_destroy(&t_attr);
 out:
-	return ret;
+	return !!ret;
 }
-- 
1.7.11.7

