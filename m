Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22355 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbaJaSCG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 14:02:06 -0400
From: Josef Bacik <jbacik@fb.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH 04/11] Btrfs-progs: don't fail on log tree opening with PARTIAL
Date: Fri, 31 Oct 2014 14:01:22 -0400
Message-ID: <1414778489-4049-5-git-send-email-jbacik@fb.com>
In-Reply-To: <1414778489-4049-1-git-send-email-jbacik@fb.com>
References: <1414778489-4049-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were failing to fsck a volume because we couldn't open the log tree, which is
not helpful.  Make us skip erroring out if we are using OPEN_CTREE_PARTIAL since
it isn't a mandatory tree.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index 77fc610..d2c18a8 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -930,7 +930,8 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 	ret = find_and_setup_log_root(root, fs_info, sb);
 	if (ret) {
 		printk("Couldn't setup log root tree\n");
-		return -EIO;
+		if (!(flags & OPEN_CTREE_PARTIAL))
+			return -EIO;
 	}
 
 	fs_info->generation = generation;
-- 
1.8.3.1

