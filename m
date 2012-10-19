Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51518 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab2JSGU3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 02:20:29 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9J6KQQL011468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 06:20:27 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9J6KPQO029229
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 06:20:26 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9J6KPmK012326
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 01:20:25 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] Btrfs-progs: list only snapshots of the given subvol
Date: Fri, 19 Oct 2012 14:23:57 +0800
Message-Id: <1350627837-27639-5-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com>
References: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

btrfs su list -s /btrfs
ID 258 gen 6 cgen 6 top level 5 otime 2012-10-18 17:01:56 uuid f648cdda-4efa-6f45-bd6b-041a8ae1538e path ss1
ID 260 gen 8 cgen 8 top level 5 otime 2012-10-18 17:02:20 uuid ea8fdf85-8d3f-8946-b3af-ede510cdcf19 path ss2
ID 261 gen 9 cgen 9 top level 5 otime 2012-10-19 13:37:42 uuid 44560e56-3879-2146-8b24-e9048871892f path ss3

btrfs su list -s /btrfs/sv1
ID 258 gen 6 cgen 6 top level 5 otime 2012-10-18 17:01:56 uuid f648cdda-4efa-6f45-bd6b-041a8ae1538e path ss1
ID 261 gen 9 cgen 9 top level 5 otime 2012-10-19 13:37:42 uuid 44560e56-3879-2146-8b24-e9048871892f path ss3

btrfs su list -s /btrfs/sv2
ID 260 gen 8 cgen 8 top level 5 otime 2012-10-18 17:02:20 uuid ea8fdf85-8d3f-8946-b3af-ede510cdcf19 path ss2

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f8beecc..c575720 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -307,6 +307,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	int ret;
 	int c;
 	char *subvol, *mnt = NULL;
+	struct root_info ri;
 	int is_tab_result = 0;
 	int is_list_all = 0;
 	struct option long_options[] = {
@@ -314,6 +315,7 @@ static int cmd_subvol_list(int argc, char **argv)
 		{0, 0, 0, 0}
 	};
 
+	memset(&ri,'\0',sizeof(ri));
 	filter_set = btrfs_list_alloc_filter_set();
 	comparer_set = btrfs_list_alloc_comparer_set();
 
@@ -419,10 +421,32 @@ static int cmd_subvol_list(int argc, char **argv)
 					BTRFS_LIST_FILTER_TOPID_EQUAL,
 					top_id);
 
+	if (strcmp(subvol, mnt) != 0) {
+		if (btrfs_list_is_filter_set(filter_set, BTRFS_LIST_FILTER_SNAPSHOT_ONLY) >= 0) {
+			ri.full_path = subvol+strlen(mnt)+1;
+			if (btrfs_get_a_subvol(fd, &ri)) {
+				fprintf(stderr, "ERROR: can't find '%s'\n",
+					ri.full_path);
+				close(fd);
+				free(mnt);
+				return 13;
+			}
+			btrfs_list_setup_filter(&filter_set,
+				BTRFS_LIST_FILTER_BY_PARENT, (u64)&ri.uuid);
+		}
+	}
+
 	ret = btrfs_list_subvols(fd, filter_set, comparer_set,
 				is_tab_result);
 
 	free(mnt);
+	if (ri.path)
+		free(ri.path);
+	if (ri.name)
+		free(ri.name);
+	if (ri.full_path)
+		free(ri.full_path);
+
 	if (ret)
 		return 19;
 	return 0;
-- 
1.7.1

