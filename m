Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:19340 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab2JLFRj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 01:17:39 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9C5HbSU002059
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 05:17:38 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9C5HbMQ011116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 05:17:37 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9C5HbW2015328
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 00:17:37 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 3/4] Btrfs-progs: method to fetch root info for subvol
Date: Fri, 12 Oct 2012 13:20:53 +0800
Message-Id: <1350019254-22036-4-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350019254-22036-1-git-send-email-Anand.Jain@oracle.com>
References: <1350019254-22036-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |   37 +++++++++++++++++++++++++++++++++++++
 btrfs-list.h |    1 +
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index c0407c9..5eada92 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1296,6 +1296,43 @@ static int btrfs_get_subvols(int fd, struct root_lookup *root_lookup)
 	return ret;
 }
 
+int btrfs_get_a_subvol(int fd, struct root_info *the_ri)
+{
+	int ret = -1;
+	struct root_lookup rl;
+	struct rb_node *rbn;
+	struct root_info *ri;
+	u64 top_id = btrfs_list_get_path_rootid(fd);
+
+	if (btrfs_get_subvols(fd, &rl))
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
 static void print_subvolume_column(struct root_info *subv,
 				   enum btrfs_list_column_enum column)
 {
diff --git a/btrfs-list.h b/btrfs-list.h
index bd5e23a..fc04f05 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -152,3 +152,4 @@ int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
 char *btrfs_list_path_for_root(int fd, u64 root);
 u64 btrfs_list_get_path_rootid(int fd);
+int btrfs_get_a_subvol(int fd, struct root_info *the_ri);
-- 
1.7.1

