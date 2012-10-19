Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20882 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab2JSGUX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 02:20:23 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9J6KMhl006229
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 06:20:23 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9J6KLL6023339
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 06:20:22 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9J6KLbc012296
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 01:20:21 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] Btrfs-progs: provide method to check if filter is set
Date: Fri, 19 Oct 2012 14:23:54 +0800
Message-Id: <1350627837-27639-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com>
References: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |   11 +++++++++++
 btrfs-list.h |    2 ++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 9cfdb35..462e049 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1181,6 +1181,17 @@ void btrfs_list_free_filter_set(struct btrfs_list_filter_set *filter_set)
 	free(filter_set);
 }
 
+int btrfs_list_is_filter_set(struct btrfs_list_filter_set *fset,
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
index fc04f05..64d89e1 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -153,3 +153,5 @@ int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
 char *btrfs_list_path_for_root(int fd, u64 root);
 u64 btrfs_list_get_path_rootid(int fd);
 int btrfs_get_a_subvol(int fd, struct root_info *the_ri);
+int btrfs_list_is_filter_set(struct btrfs_list_filter_set *fset,
+			enum btrfs_list_filter_enum filter);
-- 
1.7.1

