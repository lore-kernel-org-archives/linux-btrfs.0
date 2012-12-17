Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28348 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab2LQLfd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 06:35:33 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBHBZWjl019542
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 11:35:33 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBHBZVaR026850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 11:35:32 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBHBZVPL021942
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 05:35:31 -0600
Message-ID: <50CF037F.2010509@oracle.com>
Date: Mon, 17 Dec 2012 19:35:27 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com
Subject: [PATCH V5 3/4] Btrfs-progs: Fix set_label_unmounted() with label
 length validation
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50CF0053.4050906@oracle.com>

Currently, we keeping silent if the label length is exceeding BTRFS_LABEL_SIZE - 1, and just
truncating the characters beyond that.

This patch make it return error and exit in this situation.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>

---
 btrfslabel.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index 938e8b4..2826050 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -63,6 +63,12 @@ static int set_label_unmounted(const char *dev, const char *label)
 		return -1;
 	}
 
+	if (strlen(label) > BTRFS_LABEL_SIZE - 1) {
+		fprintf(stderr, "ERROR: Label %s is too long (max %d)\n",
+			label, BTRFS_LABEL_SIZE - 1);
+		return -1;
+	}
+
 	/* Open the super_block at the default location
 	 * and as read-write.
 	 */
@@ -71,8 +77,8 @@ static int set_label_unmounted(const char *dev, const char *label)
 		return -1;
 
 	trans = btrfs_start_transaction(root, 1);
-	strncpy(root->fs_info->super_copy.label, label, BTRFS_LABEL_SIZE);
-	root->fs_info->super_copy.label[BTRFS_LABEL_SIZE-1] = 0;
+	snprintf(root->fs_info->super_copy.label, BTRFS_LABEL_SIZE, "%s",
+		 label);
 	btrfs_commit_transaction(trans, root);
 
 	/* Now we close it since we are done. */
-- 
1.7.9.5
