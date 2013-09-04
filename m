Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48777 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3IDPWr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:22:47 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl13so574301pab.34
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:22:46 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 01/20] Btrfs-progs: return 1 rather than 129 in usage()
Date: Wed,  4 Sep 2013 23:22:18 +0800
Message-Id: <1378308157-4621-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

if usage or syntax error happens, we return 1.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 help.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/help.c b/help.c
index d429a6b..09dc706 100644
--- a/help.c
+++ b/help.c
@@ -121,7 +121,7 @@ void usage_command(const struct cmd_struct *cmd, int full, int err)
 void usage(const char * const *usagestr)
 {
 	usage_command_usagestr(usagestr, NULL, 1, 1);
-	exit(129);
+	exit(1);
 }
 
 static void usage_command_group_internal(const struct cmd_group *grp, int full,
-- 
1.7.11.7

