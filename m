Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20241 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbcCUHVU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 03:21:20 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/6] btrfs-progs: spatial rearrange subvolume functions together
Date: Mon, 21 Mar 2016 15:21:00 +0800
Message-Id: <1458544865-16467-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/utils.c b/utils.c
index c0c564e2f69b..fb549ee923c7 100644
--- a/utils.c
+++ b/utils.c
@@ -2784,17 +2784,6 @@ int test_minimum_size(const char *file, u32 nodesize)
 	return 0;
 }
 
-/*
- * test if name is a correct subvolume name
- * this function return
- * 0-> name is not a correct subvolume name
- * 1-> name is a correct subvolume name
- */
-int test_issubvolname(const char *name)
-{
-	return name[0] != '\0' && !strchr(name, '/') &&
-		strcmp(name, ".") && strcmp(name, "..");
-}
 
 /*
  * Test if path is a directory
@@ -3146,3 +3135,16 @@ void clean_args_no_options(int argc, char *argv[], const char * const *usagestr)
 		}
 	}
 }
+
+/* Subvolume helper functions */
+/*
+ * test if name is a correct subvolume name
+ * this function return
+ * 0-> name is not a correct subvolume name
+ * 1-> name is a correct subvolume name
+ */
+int test_issubvolname(const char *name)
+{
+	return name[0] != '\0' && !strchr(name, '/') &&
+		strcmp(name, ".") && strcmp(name, "..");
+}
-- 
2.7.0

