Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33128 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762944Ab3IDPXP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:23:15 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld10so572084pab.36
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:23:14 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 12/20] Btrfs-progs: fix magic return value in cmds-send.c
Date: Wed,  4 Sep 2013 23:22:29 +0800
Message-Id: <1378308157-4621-13-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

If btrfs send return failure, we return 1，otherwise 0 will be returned.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-send.c b/cmds-send.c
index f7f98bc..374d040 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -715,7 +715,7 @@ out:
 		close(send.mnt_fd);
 	free(send.root_path);
 	subvol_uuid_search_finit(&send.sus);
-	return ret;
+	return !!ret;
 }
 
 const char * const cmd_send_usage[] = {
-- 
1.7.11.7

