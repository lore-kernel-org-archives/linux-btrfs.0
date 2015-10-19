Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36694 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbJSLqz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 07:46:55 -0400
Received: by pacfv9 with SMTP id fv9so93708317pac.3
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 04:46:55 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 07/10] btrfs-progs: fix memory leak on error path
Date: Mon, 19 Oct 2015 19:37:57 +0800
Message-Id: <1445254680-11102-8-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

dev_scans and t_scans should be freed on malloc error.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 chunk-recover.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 1fb04f7..c727f0f 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -847,11 +847,16 @@ static int scan_devices(struct recover_control *rc)
 	if (!dev_scans)
 		return -ENOMEM;
 	t_scans = (pthread_t *)malloc(sizeof(pthread_t) * devnr);
-	if (!t_scans)
+	if (!t_scans) {
+		free(dev_scans);
 		return -ENOMEM;
+	}
 	t_rets = (long *)malloc(sizeof(long) * devnr);
-	if (!t_rets)
+	if (!t_rets) {
+		free(dev_scans);
+		free(t_scans);
 		return -ENOMEM;
+	}
 
 	list_for_each_entry(dev, &rc->fs_devices->devices, dev_list) {
 		fd = open(dev->name, O_RDONLY);
-- 
2.4.3

