Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39145 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbbHNKhI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:37:08 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 1/2] btrfs-progs: move is_numerical to utils-lib.h and make it non static
Date: Fri, 14 Aug 2015 18:36:50 +0800
Message-Id: <1439548611-29730-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548611-29730-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1439548611-29730-1-git-send-email-anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-replace.c | 11 -----------
 utils-lib.c    | 11 +++++++++++
 utils.h        |  1 +
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 85365e3..e6a27e3 100644
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
diff --git a/utils-lib.c b/utils-lib.c
index 79ef35e..9ac0b7b 100644
--- a/utils-lib.c
+++ b/utils-lib.c
@@ -38,3 +38,14 @@ u64 arg_strtou64(const char *str)
 	}
 	return value;
 }
+
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
diff --git a/utils.h b/utils.h
index 94606ed..0975301 100644
--- a/utils.h
+++ b/utils.h
@@ -243,5 +243,6 @@ int btrfs_tree_search2_ioctl_supported(int fd);
 int btrfs_check_nodesize(u32 nodesize, u32 sectorsize);
 
 const char *get_argv0_buf(void);
+int is_numerical(const char *str);
 
 #endif
-- 
2.4.1

