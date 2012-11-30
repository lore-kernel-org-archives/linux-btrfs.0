Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39663 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030929Ab2K3Pmz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 10:42:55 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qAUFgsYH001920
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2012 15:42:55 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qAUFgruA015329
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2012 15:42:54 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qAUFgrD4030499
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2012 09:42:53 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs-progs: add attribute label for subvol and snapshot
Date: Fri, 30 Nov 2012 23:48:01 +0800
Message-Id: <1354290482-5324-3-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1354290482-5324-1-git-send-email-Anand.Jain@oracle.com>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
 <1354290482-5324-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfslabel.c |   38 ++++++++++++++++++++++++++++++++++++++
 btrfslabel.h |    4 +++-
 ctree.h      |    1 +
 3 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index cb142b0..8c424e5 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -34,6 +34,8 @@
 #include <linux/fs.h>
 #include <linux/limits.h>
 #include <ctype.h>
+#include <attr/xattr.h>
+#include <attr/attributes.h>
 #include "kerncompat.h"
 #include "ctree.h"
 #include "utils.h"
@@ -126,3 +128,39 @@ int set_label(char *btrfs_dev, char *nLabel)
 	change_label_unmounted(btrfs_dev, nLabel);
 	return 0;
 }
+
+int get_subvol_label(char *subvol, char *labelp)
+{
+	int ret;
+	ret = getxattr(subvol, "user.label", labelp, BTRFS_SUBVOL_LABEL_SIZE);
+	if(ret < 0) {
+		labelp = "";
+		fprintf(stderr, "ERROR: get subvol label failed, %s\n",
+			strerror(errno));
+		return -errno;
+	}
+	labelp[ret] = '\0';
+	return 0;
+}
+
+int set_subvol_label(char *subvol, char *labelp)
+{
+	int e=0;
+	char label[BTRFS_SUBVOL_LABEL_SIZE+1];
+
+	if (strlen(labelp) > BTRFS_SUBVOL_LABEL_SIZE) {
+		fprintf(stderr, "ERROR: Subvol label is more than max length %d\n",
+			BTRFS_SUBVOL_LABEL_SIZE);
+		return -1;
+	}
+	memset(label, 0, BTRFS_SUBVOL_LABEL_SIZE+1);
+	strcpy(label, labelp);
+	if(setxattr(subvol, "user.label", label, BTRFS_SUBVOL_LABEL_SIZE,
+		ATTR_ROOT) == -1) {
+		e = errno;
+		fprintf(stderr, "ERROR: set subvol label failed, %s\n",
+			strerror(e));
+		return -e;
+	}
+	return 0;
+}
diff --git a/btrfslabel.h b/btrfslabel.h
index abf43ad..1abc483 100644
--- a/btrfslabel.h
+++ b/btrfslabel.h
@@ -2,4 +2,6 @@
 
 
 int get_label(char *btrfs_dev);
-int set_label(char *btrfs_dev, char *nLabel);
\ No newline at end of file
+int set_label(char *btrfs_dev, char *nLabel);
+int get_subvol_label(char *subvol, char *labelp);
+int set_subvol_label(char *subvol, char *labelp);
diff --git a/ctree.h b/ctree.h
index 293b24f..993dbcf 100644
--- a/ctree.h
+++ b/ctree.h
@@ -325,6 +325,7 @@ struct btrfs_header {
  */
 #define BTRFS_SYSTEM_CHUNK_ARRAY_SIZE 2048
 #define BTRFS_LABEL_SIZE 256
+#define BTRFS_SUBVOL_LABEL_SIZE 32
 
 /*
  * just in case we somehow lose the roots and are not able to mount,
-- 
1.7.1

