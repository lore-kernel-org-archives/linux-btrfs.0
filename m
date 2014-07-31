Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42243 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756099AbaGaD3n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 23:29:43 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6V3Te2o008703
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 11:29:40 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: init variables which are checked later in btrfs-property
Date: Thu, 31 Jul 2014 11:23:42 +0800
Message-ID: <1406777024-7647-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The local variable @object etc. in btrfs-property get/set functions
are to be checked whether to be NULL or not, but the @parse_args()
don't guarantee to assign a value to it, so it is better to init
it to NULL.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-property.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/cmds-property.c b/cmds-property.c
index 9c4eb92..90c7603 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -389,7 +389,7 @@ static void parse_args(int argc, char **argv,
 static int cmd_get(int argc, char **argv)
 {
 	int ret;
-	char *object;
+	char *object = NULL;
 	char *name = NULL;
 	int types = 0;
 
@@ -413,9 +413,9 @@ static int cmd_get(int argc, char **argv)
 static int cmd_set(int argc, char **argv)
 {
 	int ret;
-	char *object;
-	char *name;
-	char *value;
+	char *object = NULL;
+	char *name = NULL;
+	char *value = NULL;
 	int types = 0;
 
 	if (check_argc_min(argc, 4) || check_argc_max(argc, 6))
-- 
1.8.1.4

