Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27576 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab3AYJOX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 04:14:23 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 05/10] Btrfs-progs: add function btrfs_get_subvol to get root_info of a subvol
Date: Fri, 25 Jan 2013 17:19:28 +0800
Message-Id: <1359105573-20726-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1359105573-20726-1-git-send-email-anand.jain@oracle.com>
References: <1359105573-20726-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need a function which can get the root_info of a given
subvol. This is in preparation to add support for the show
sub-cli.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c | 38 ++++++++++++++++++++++++++++++++++++++
 btrfs-list.h |  1 +
 2 files changed, 39 insertions(+)

diff --git a/btrfs-list.c b/btrfs-list.c
index 909d814..0ee13b6 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1453,6 +1453,44 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	return 0;
 }
 
+int btrfs_get_subvol(int fd, struct root_info *the_ri)
+{
+	int ret = -1;
+	struct root_lookup rl;
+	struct rb_node *rbn;
+	struct root_info *ri;
+	u64 root_id = btrfs_list_get_path_rootid(fd);
+
+	if (btrfs_list_subvols(fd, &rl))
+		return 1;
+
+	rbn = rb_first(&rl.root);
+	while(rbn) {
+		ri = rb_entry(rbn, struct root_info, rb_node);
+		resolve_root(&rl, ri, root_id);
+		if (!comp_entry_with_rootid(the_ri, ri, 0)) {
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
+			break;
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
1.8.1.227.g44fe835

