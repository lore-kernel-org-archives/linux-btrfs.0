Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:39308 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268Ab3BLTj0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 14:39:26 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so237978eek.29
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 11:39:24 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: idryomov@gmail.com
Subject: [PATCH] Btrfs-progs: move crc32c optimization init
Date: Tue, 12 Feb 2013 21:39:17 +0200
Message-Id: <1360697957-27461-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Don't call crc32c_optimization_init() until we know that a command is
actually going to be invoked.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 btrfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 687acec..7752bd6 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -261,8 +261,6 @@ int main(int argc, char **argv)
 {
 	const struct cmd_struct *cmd;
 
-	crc32c_optimization_init();
-
 	argc--;
 	argv++;
 	handle_options(&argc, &argv);
@@ -278,6 +276,8 @@ int main(int argc, char **argv)
 
 	handle_help_options_next_level(cmd, argc, argv);
 
+	crc32c_optimization_init();
+
 	fixup_argv0(argv, cmd->token);
 	exit(cmd->fn(argc, argv));
 }
-- 
1.7.9.1

