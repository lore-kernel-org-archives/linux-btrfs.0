Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39951 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758700Ab3BYODL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 09:03:11 -0500
Received: by mail-pb0-f48.google.com with SMTP id wy12so1677342pbc.21
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 06:03:11 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com
Subject: [PATCH 3/4] Btrfs-progs: let the error messages more precise
Date: Mon, 25 Feb 2013 22:03:06 +0800
Message-Id: <1361800986-2009-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Not only the operation 'create/assign' may fail but also
'destroy/remove' operation, so add those operations in
error messages.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 cmds-qgroup.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 06505fa..e39ffac 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -65,8 +65,8 @@ static int qgroup_assign(int assign, int argc, char **argv)
 	e = errno;
 	close(fd);
 	if (ret < 0) {
-		fprintf(stderr, "ERROR: unable to assign quota group: %s\n",
-			strerror(e));
+		fprintf(stderr, "ERROR: unable to assign/remove "
+				"quota group: %s\n", strerror(e));
 		return 30;
 	}
 	return 0;
@@ -102,8 +102,8 @@ static int qgroup_create(int create, int argc, char **argv)
 	e = errno;
 	close(fd);
 	if (ret < 0) {
-		fprintf(stderr, "ERROR: unable to create quota group: %s\n",
-			strerror(e));
+		fprintf(stderr, "ERROR: unable to create/destroy "
+				"quota group: %s\n", strerror(e));
 		return 30;
 	}
 	return 0;
-- 
1.7.7.6

