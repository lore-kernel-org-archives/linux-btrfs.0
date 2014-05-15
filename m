Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40341 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752005AbaEOBdw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 21:33:52 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4F1Xogh007580
	for <linux-btrfs@vger.kernel.org>; Thu, 15 May 2014 09:33:50 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: add missing help option for rescue super-recover
Date: Thu, 15 May 2014 09:29:08 +0800
Message-ID: <1400117349-2851-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1400117349-2851-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1400117349-2851-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add '-h' option for help for super-recover,
update the manpage at the same time.
---
 Documentation/btrfs-rescue.txt | 2 ++
 cmds-rescue.c                  | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-rescue.txt b/Documentation/btrfs-rescue.txt
index f66ca85..f64d78b 100644
--- a/Documentation/btrfs-rescue.txt
+++ b/Documentation/btrfs-rescue.txt
@@ -39,6 +39,8 @@ Recover bad superblocks from good copies.
 assume an answer of 'yes' to all questions.
 -v::::
 verbose mode.
+-h::::
+help.
 
 EXIT STATUS
 -----------
diff --git a/cmds-rescue.c b/cmds-rescue.c
index 7e0687e..9491d0c 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -49,6 +49,7 @@ const char * const cmd_super_recover_usage[] = {
 	"",
 	"-y	Assume an answer of `yes' to all questions",
 	"-v	Verbose mode",
+	"-h	Help",
 	NULL
 };
 
@@ -124,7 +125,7 @@ int cmd_super_recover(int argc, char **argv)
 	char *dname;
 
 	while (1) {
-		int c = getopt(argc, argv, "vy");
+		int c = getopt(argc, argv, "vyh");
 		if (c < 0)
 			break;
 		switch (c) {
@@ -134,6 +135,7 @@ int cmd_super_recover(int argc, char **argv)
 		case 'y':
 			yes = 1;
 			break;
+		case 'h':
 		default:
 			usage(cmd_super_recover_usage);
 		}
-- 
1.8.1.4

