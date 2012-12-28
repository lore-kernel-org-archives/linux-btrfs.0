Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21171 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2L1DG7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 22:06:59 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBS36vI5021129
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:58 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBS36via005940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:57 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBS36vZg027293
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 21:06:57 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/8] Btrfs-progs: provide method to check if filter is set
Date: Fri, 28 Dec 2012 11:13:00 +0800
Message-Id: <1356664382-24423-7-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
References: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |   11 +++++++++++
 btrfs-list.h |    2 ++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index cb458f1..308b54c 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1181,6 +1181,17 @@ void btrfs_list_free_filter_set(struct btrfs_list_filter_set *filter_set)
 	free(filter_set);
 }
 
+int btrfs_list_check_filter_set(struct btrfs_list_filter_set *fset,
+			enum btrfs_list_filter_enum filter)
+{
+	int i;
+	for (i=0; i < fset->nfilters; i++) {
+		if (fset->filters[i].filter_func == all_filter_funcs[filter])
+			return i;
+	}
+	return -1;
+}
+
 int btrfs_list_setup_filter(struct btrfs_list_filter_set **filter_set,
 			    enum btrfs_list_filter_enum filter, u64 data)
 {
diff --git a/btrfs-list.h b/btrfs-list.h
index 580d4d1..f5dbd47 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -152,3 +152,5 @@ int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
 char *btrfs_list_path_for_root(int fd, u64 root);
 u64 btrfs_list_get_path_rootid(int fd);
 int btrfs_get_subvol(int fd, struct root_info *the_ri);
+int btrfs_list_check_filter_set(struct btrfs_list_filter_set *fset,
+			enum btrfs_list_filter_enum filter);
-- 
1.7.1

