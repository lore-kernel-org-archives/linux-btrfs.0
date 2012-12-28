Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37558 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2L1DG6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 22:06:58 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBS36upg010138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:57 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBS36uYJ013320
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:56 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBS36tHM023106
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 21:06:55 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/8] Btrfs-progs: function to get root_info of a subvol
Date: Fri, 28 Dec 2012 11:12:59 +0800
Message-Id: <1356664382-24423-6-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
References: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |   37 +++++++++++++++++++++++++++++++++++++
 btrfs-list.h |    1 +
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 1851f3e..cb458f1 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1455,6 +1455,43 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	return 0;
 }
 
+int btrfs_get_subvol(int fd, struct root_info *the_ri)
+{
+	int ret = -1;
+	struct root_lookup rl;
+	struct rb_node *rbn;
+	struct root_info *ri;
+	u64 top_id = btrfs_list_get_path_rootid(fd);
+
+	if (btrfs_list_subvols(fd, &rl))
+		return 13;
+
+	rbn = rb_first(&rl.root);
+	while(rbn) {
+		ri = rb_entry(rbn, struct root_info, rb_node);
+		resolve_root(&rl, ri, top_id);
+		if (!comp_entry_with_path(the_ri, ri, 0)) {
+			memcpy(the_ri, ri, offsetof(struct root_info, path));
+			if (ri->path)
+				the_ri->path = strdup(ri->path);
+			else
+				the_ri->path = NULL;
+			if (ri->name)
+				the_ri->name = strdup(ri->name);
+			else
+				the_ri->name = NULL;
+			if (ri->full_path)
+				the_ri->full_path = strdup(ri->full_path);
+			else
+				the_ri->name = NULL;
+			ret = 0;
+		}
+		rbn = rb_next(rbn);
+	}
+	__free_all_subvolumn(&rl);
+	return ret;
+}
+
 static int print_one_extent(int fd, struct btrfs_ioctl_search_header *sh,
 			    struct btrfs_file_extent_item *item,
 			    u64 found_gen, u64 *cache_dirid,
diff --git a/btrfs-list.h b/btrfs-list.h
index 3b7b680..580d4d1 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -151,3 +151,4 @@ int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
 char *btrfs_list_path_for_root(int fd, u64 root);
 u64 btrfs_list_get_path_rootid(int fd);
+int btrfs_get_subvol(int fd, struct root_info *the_ri);
-- 
1.7.1

