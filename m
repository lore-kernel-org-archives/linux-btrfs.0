Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29898 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3BAH6f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Feb 2013 02:58:35 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 11/13] Btrfs-progs: update btrfs_get_subvol to be inline with resolve_root ret changes
Date: Fri,  1 Feb 2013 15:56:30 +0800
Message-Id: <1359705392-7485-12-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1359705392-7485-1-git-send-email-anand.jain@oracle.com>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1359705392-7485-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 69ee3e7..eadfba4 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1503,19 +1503,24 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 
 int btrfs_get_subvol(int fd, struct root_info *the_ri)
 {
-	int ret = -1;
+	int ret = 1, rr;
 	struct root_lookup rl;
 	struct rb_node *rbn;
 	struct root_info *ri;
 	u64 root_id = btrfs_list_get_path_rootid(fd);
 
 	if (btrfs_list_subvols(fd, &rl))
-		return 1;
+		return ret;
 
 	rbn = rb_first(&rl.root);
 	while(rbn) {
 		ri = rb_entry(rbn, struct root_info, rb_node);
-		resolve_root(&rl, ri, root_id);
+		rr = resolve_root(&rl, ri, root_id);
+		if (rr == -ENOENT) {
+			ret = -ENOENT;
+			rbn = rb_next(rbn);
+			continue;
+		}
 		if (!comp_entry_with_rootid(the_ri, ri, 0)) {
 			memcpy(the_ri, ri, offsetof(struct root_info, path));
 			if (ri->path)
-- 
1.8.1.227.g44fe835

