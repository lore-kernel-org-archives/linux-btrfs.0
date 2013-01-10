Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24864 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab3AJLfC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 06:35:02 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r0ABZ1fd030625
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 11:35:01 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r0ABZ0l1015798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 11:35:00 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r0ABZ0Jh022311
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 05:35:00 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/11] Btrfs-progs: function to get root_info of a subvol
Date: Thu, 10 Jan 2013 19:41:17 +0800
Message-Id: <1357818083-15531-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>

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

