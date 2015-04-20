Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47645 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbbDTIT4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 04:19:56 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, m_btrfs@ml1.co.uk
Subject: [PATCH 1/2] btrfs-progs: move is_numerical to utils-lib.h and make it non static
Date: Mon, 20 Apr 2015 18:29:15 +0800
Message-Id: <1429525756-2727-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1429525756-2727-1-git-send-email-anand.jain@oracle.com>
References: <1429525756-2727-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-replace.c | 11 -----------
 utils-lib.c    | 11 +++++++++++
 utils.h        |  1 +
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 63d34f9..6ea7c61 100644
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
index 6a39ada..f734a57 100644
--- a/utils.h
+++ b/utils.h
@@ -211,5 +211,6 @@ static inline u64 div_factor(u64 num, int factor)
 
 int btrfs_tree_search2_ioctl_supported(int fd);
 int btrfs_check_node_or_leaf_size(u32 size, u32 sectorsize);
+int is_numerical(const char *str);
 
 #endif
-- 
2.0.0.153.g79dcccc

