Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47529 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762919Ab3IDPXK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:23:10 -0400
Received: by mail-pd0-f169.google.com with SMTP id r10so463836pdi.14
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:23:09 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 10/20] Btrfs-progs: fix magic return value in cmds-receive.c
Date: Wed,  4 Sep 2013 23:22:27 +0800
Message-Id: <1378308157-4621-11-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-receive.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 1630f64..2b880c0 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -951,13 +951,13 @@ int cmd_receive(int argc, char **argv)
 		receive_fd = open(fromfile, O_RDONLY | O_NOATIME);
 		if (receive_fd < 0) {
 			fprintf(stderr, "ERROR: failed to open %s\n", fromfile);
-			return -errno;
+			return 1;
 		}
 	}
 
 	ret = do_receive(&r, tomnt, receive_fd);
 
-	return ret;
+	return !!ret;
 }
 
 const char * const cmd_receive_usage[] = {
-- 
1.7.11.7

