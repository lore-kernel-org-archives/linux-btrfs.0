Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20664 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbbKYMIy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 07:08:54 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
Subject: [PATCH 3/7] btrfs-progs: make is_numerical non static
Date: Wed, 25 Nov 2015 20:08:16 +0800
Message-Id: <1448453300-8449-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-replace.c | 11 -----------
 utils.c        | 11 +++++++++++
 utils.h        |  1 +
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 9ab8438..86162b6 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -65,17 +65,6 @@ static const char * const replace_cmd_group_usage[] = {
 	NULL
 };
 
-static int is_numerical(const char *str)
-{
-	if (!(*str >= '0' && *str <= '9'))
-		return 0;
-	while (*str >= '0' && *str <= '9')
-		str++;
-	if (*str != '\0')
-		return 0;
-	return 1;
-}
-
 static int dev_replace_cancel_fd = -1;
 static void dev_replace_sigint_handler(int signal)
 {
diff --git a/utils.c b/utils.c
index 6d2675d..0e66e2b 100644
--- a/utils.c
+++ b/utils.c
@@ -178,6 +178,17 @@ int test_uuid_unique(char *fs_uuid)
 	return unique;
 }
 
+int is_numerical(const char *str)
+{
+	if (!(*str >= '0' && *str <= '9'))
+		return 0;
+	while (*str >= '0' && *str <= '9')
+		str++;
+	if (*str != '\0')
+		return 0;
+	return 1;
+}
+
 /*
  * @fs_uuid - if NULL, generates a UUID, returns back the new filesystem UUID
  */
diff --git a/utils.h b/utils.h
index af0aa31..cb20d73 100644
--- a/utils.h
+++ b/utils.h
@@ -271,5 +271,6 @@ const char *get_argv0_buf(void);
 	"-t|--tbytes        show sizes in TiB, or TB with --si"
 
 unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode);
+int is_numerical(const char *str);
 
 #endif
-- 
2.6.2

