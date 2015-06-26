Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35914 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbbFZIpP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jun 2015 04:45:15 -0400
Received: by lbbpo10 with SMTP id po10so60224572lbb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2015 01:45:14 -0700 (PDT)
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>
Subject: [PATCH] btrfs-progs: inspect: Fix out of bounds string termination.
Date: Fri, 26 Jun 2015 10:43:56 +0200
Message-Id: <1435308236-7931-1-git-send-email-patrik.lundquist@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Patrik Lundquist <patrik.lundquist@gmail.com>
---
 cmds-inspect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index 053cf8e..aafe37d 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -293,7 +293,7 @@ static int cmd_subvolid_resolve(int argc, char **argv)
 		goto out;
 	}
 
-	path[PATH_MAX] = '\0';
+	path[PATH_MAX-1] = '\0';
 	printf("%s\n", path);
 
 out:
-- 
2.1.4

