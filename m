Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:37706 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3IDPWy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:22:54 -0400
Received: by mail-pd0-f182.google.com with SMTP id r10so458895pdi.41
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:22:54 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 04/20] Btrfs-progs: fix magic return value in cmds-dedup.c
Date: Wed,  4 Sep 2013 23:22:21 +0800
Message-Id: <1378308157-4621-5-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-dedup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/cmds-dedup.c b/cmds-dedup.c
index eb43414..674952a 100644
--- a/cmds-dedup.c
+++ b/cmds-dedup.c
@@ -39,7 +39,7 @@ int dedup_ctl(int cmd, int argc, char **argv)
 	DIR *dirstream;
 
 	if (check_argc_exact(argc, 2))
-		return -1;
+		return -EINVAL;
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
@@ -71,7 +71,7 @@ static int cmd_dedup_enable(int argc, char **argv)
 	int ret = dedup_ctl(BTRFS_DEDUP_CTL_REG, argc, argv);
 	if (ret < 0)
 		usage(cmd_dedup_enable_usage);
-	return ret;
+	return !!ret;
 }
 
 static const char * const cmd_dedup_disable_usage[] = {
@@ -85,7 +85,7 @@ static int cmd_dedup_disable(int argc, char **argv)
 	int ret = dedup_ctl(BTRFS_DEDUP_CTL_UNREG, argc, argv);
 	if (ret < 0)
 		usage(cmd_dedup_disable_usage);
-	return ret;
+	return !!ret;
 }
 
 const struct cmd_group dedup_cmd_group = {
-- 
1.7.11.7

