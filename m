Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35672 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3A2Gm6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:42:58 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 12/12] Btrfs-progs: update btrfs_get_subvol to be inline with resolve_root ret changes
Date: Tue, 29 Jan 2013 14:49:01 +0800
Message-Id: <1359442141-25498-13-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1359442141-25498-1-git-send-email-anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index db3665c..0cc368c 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1502,19 +1502,24 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 
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

