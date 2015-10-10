Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24819 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbbJJObZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Oct 2015 10:31:25 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH RESEND V2 1/3] btrfs-progs: Create is_numerical() helper function
Date: Sat, 10 Oct 2015 22:30:56 +0800
Message-Id: <1444487458-2988-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444487458-2988-1-git-send-email-anand.jain@oracle.com>
References: <1444487458-2988-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is done by moving existing is_numerical() to utils-lib.c

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
V2: Subject updated from
    btrfs-progs: move is_numerical to utils-lib.h and make it non static

 cmds-replace.c | 11 -----------
 utils-lib.c    | 11 +++++++++++
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
index 192f3d1..0a2130d 100644
--- a/utils.h
+++ b/utils.h
@@ -269,5 +269,6 @@ const char *get_argv0_buf(void);
 	"-t|--tbytes        show sizes in TiB, or TB with --si"
 
 unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode);
+int is_numerical(const char *str);
 
 #endif
-- 
2.4.1

