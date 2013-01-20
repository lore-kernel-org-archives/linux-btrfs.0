Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo103.cox.net ([68.230.241.215]:43635 "EHLO
	eastrmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3ATVEj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 16:04:39 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo103.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130120210438.HSGG23841.eastrmfepo103.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 16:04:38 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Ulrik <ulrik.sverdrup@gmail.com>, Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 03/13] Btrfs-progs: correct btrfs receive usage string
Date: Sun, 20 Jan 2013 16:04:08 -0500
Message-Id: <1358715858-4469-4-git-send-email-gene@czarc.net>
In-Reply-To: <1358715858-4469-1-git-send-email-gene@czarc.net>
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Ulrik <ulrik.sverdrup@gmail.com>

Fix the usage string to specify the correct '-f' option for input file,
not '-i'.

Signed-off-by: Ulrik Sverdrup <ulrik.sverdrup@gmail.com>
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 cmds-receive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 37d07db..2fae299 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -882,7 +882,7 @@ static const char * const receive_cmd_group_usage[] = {
 };
 
 static const char * const cmd_receive_usage[] = {
-	"btrfs receive [-v] [-i <infile>] <mount>",
+	"btrfs receive [-v] [-f <infile>] <mount>",
 	"Receive subvolumes from stdin.",
 	"Receives one or more subvolumes that were previously ",
 	"sent with btrfs send. The received subvolumes are stored",
-- 
1.8.1

