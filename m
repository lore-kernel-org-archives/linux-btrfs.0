Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20889 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab2JSGUZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 02:20:25 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9J6KOX3006244
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 06:20:24 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9J6KNqh029157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 06:20:23 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9J6KNhr021470
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 01:20:23 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] Btrfs-progs: fix irrelevant string in the subvol path
Date: Fri, 19 Oct 2012 14:23:55 +0800
Message-Id: <1350627837-27639-3-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com>
References: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

btrfs su list -a /btrfs/sv1
ID 256 gen 6 top level 5 path <FS_TREE>/sv1
ID 258 gen 6 top level 5 path <FS_TREE>/ss1

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index a33c352..f8beecc 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -306,7 +306,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	u64 top_id;
 	int ret;
 	int c;
-	char *subvol;
+	char *subvol, *mnt = NULL;
 	int is_tab_result = 0;
 	int is_list_all = 0;
 	struct option long_options[] = {
@@ -398,9 +398,18 @@ static int cmd_subvol_list(int argc, char **argv)
 		return 13;
 	}
 
-	fd = open_file_or_dir(subvol);
+	ret = find_mount_root(subvol, &mnt);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: find_mount_root failed on %s: "
+				"%s\n", subvol,
+			strerror(-ret));
+		return 12;
+	}
+
+	fd = open_file_or_dir(mnt);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+		free(mnt);
 		return 12;
 	}
 
@@ -412,6 +421,8 @@ static int cmd_subvol_list(int argc, char **argv)
 
 	ret = btrfs_list_subvols(fd, filter_set, comparer_set,
 				is_tab_result);
+
+	free(mnt);
 	if (ret)
 		return 19;
 	return 0;
-- 
1.7.1

