Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45129 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2KKRiB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Nov 2012 12:38:01 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so2972758eek.19
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2012 09:37:59 -0800 (PST)
Message-ID: <509FE273.3040902@gmail.com>
Date: Sun, 11 Nov 2012 18:37:55 +0100
From: Ulrik <ulrik.sverdrup@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: correct btrfs receive usage string
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix the usage string to specify the correct '-f' option for input file,
not '-i'.

Signed-off-by: Ulrik Sverdrup <ulrik.sverdrup@gmail.com>
---
 cmds-receive.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index a8be6fa..c182175 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -880,7 +880,7 @@ static const char * const receive_cmd_group_usage[] = {
 };

 static const char * const cmd_receive_usage[] = {
-	"btrfs receive [-v] [-i <infile>] <mount>",
+	"btrfs receive [-v] [-f <infile>] <mount>",
 	"Receive subvolumes from stdin.",
 	"Receives one or more subvolumes that were previously ",
 	"sent with btrfs send. The received subvolumes are stored",
-- 
1.7.10.4

