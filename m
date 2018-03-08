Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60575 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935156AbeCHClC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:02 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CA57FAE90
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:00 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 05/20] btrfs-progs: btrfs-list: add btrfs_cleanup_root_info
Date: Wed,  7 Mar 2018 21:40:32 -0500
Message-Id: <20180308024047.10104-6-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Currently we can pass back root_info structures to callers but
have to free the strings manually.  This adds a helper to do it
and uses it in cmd_subvol_show.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 btrfs-list.c     | 18 +++++++++++++++---
 btrfs-list.h     |  1 +
 cmds-subvolume.c |  5 +----
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 90c98be1..2fe31e9c 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -533,15 +533,27 @@ static int add_root_backref(struct root_lookup *root_lookup, u64 root_id,
 			name_len, 0, 0, 0, NULL, NULL, NULL);
 }
 
+static void __btrfs_free_root_info_strings(struct root_info *ri)
+{
+	free(ri->name);
+	free(ri->path);
+	free(ri->full_path);
+}
+
+void btrfs_cleanup_root_info(struct root_info *ri)
+{
+	__btrfs_free_root_info_strings(ri);
+	ri->name = NULL;
+	ri->path = NULL;
+	ri->full_path = NULL;
+}
 
 static void free_root_info(struct rb_node *node)
 {
 	struct root_info *ri;
 
 	ri = to_root_info(node);
-	free(ri->name);
-	free(ri->path);
-	free(ri->full_path);
+	__btrfs_free_root_info_strings(ri);
 	free(ri);
 }
 
diff --git a/btrfs-list.h b/btrfs-list.h
index 6e5fc778..9d0478b8 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -176,5 +176,6 @@ char *btrfs_list_path_for_root(int fd, u64 root);
 int btrfs_list_get_path_rootid(int fd, u64 *treeid);
 int btrfs_get_subvol(int fd, struct root_info *the_ri);
 int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri);
+void btrfs_cleanup_root_info(struct root_info *ri);
 
 #endif
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 8a473f7a..769d2a76 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1113,10 +1113,7 @@ static int cmd_subvol_show(int argc, char **argv)
 			1, raw_prefix);
 
 out:
-	/* clean up */
-	free(get_ri.path);
-	free(get_ri.name);
-	free(get_ri.full_path);
+	btrfs_cleanup_root_info(&get_ri);
 	free(filter_set);
 
 	close_file_or_dir(fd, dirstream1);
-- 
2.12.3

