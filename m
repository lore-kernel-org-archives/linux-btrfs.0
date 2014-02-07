Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbaBGNeQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 08:34:16 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Jeff Mahoney <jeffm@suse.com>,
        Josef Bacik <jbacik@fb.com>
Subject: [PATCH 3/4][RFC] btrfs: export global block reserve size as space_info
Date: Fri,  7 Feb 2014 14:34:12 +0100
Message-Id: <21dfbfe3b1361092ad1dc286f636c1fff4a2a4f6.1391779611.git.dsterba@suse.cz>
In-Reply-To: <cover.1391779611.git.dsterba@suse.cz>
References: <cover.1391779611.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a block group type bit for a global reserve and fill the space
info for SPACE_INFO ioctl. This should replace the newly added ioctl
(01e219e8069516cdb98594d417b8bb8d906ed30d) to get just the 'size' part
of the global reserve, while the actual usage can be now visible in the
'btrfs fi df' output during ENOSPC stress.

The unpatched userspace tools will show the blockgroup as 'unknown'.

CC: Jeff Mahoney <jeffm@suse.com>
CC: Josef Bacik <jbacik@fb.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h |  9 ++++++++-
 fs/btrfs/ioctl.c | 20 ++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2c1a42ca519f..8bf1890ea21f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -985,7 +985,8 @@ struct btrfs_dev_replace_item {
 #define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
 #define BTRFS_BLOCK_GROUP_RAID5         (1ULL << 7)
 #define BTRFS_BLOCK_GROUP_RAID6         (1ULL << 8)
-#define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
+#define BTRFS_BLOCK_GROUP_RESERVED	(BTRFS_AVAIL_ALLOC_BIT_SINGLE | \
+					 BTRFS_SPACE_INFO_GLOBAL_RSV)
 
 enum btrfs_raid_types {
 	BTRFS_RAID_RAID10,
@@ -1017,6 +1018,12 @@ enum btrfs_raid_types {
  */
 #define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1ULL << 48)
 
+/*
+ * A fake block group type that is used to communicate global block reserve
+ * size to userspace via the SPACE_INFO ioctl.
+ */
+#define BTRFS_SPACE_INFO_GLOBAL_RSV	(1ULL << 49)
+
 #define BTRFS_EXTENDED_PROFILE_MASK	(BTRFS_BLOCK_GROUP_PROFILE_MASK | \
 					 BTRFS_AVAIL_ALLOC_BIT_SINGLE)
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 383ab455bfa7..0d938f8f173e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3465,6 +3465,11 @@ static long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 		up_read(&info->groups_sem);
 	}
 
+	/*
+	 * Global block reserve, exported as a space_info
+	 */
+	slot_count++;
+
 	/* space_slots == 0 means they are asking for a count */
 	if (space_args.space_slots == 0) {
 		space_args.total_spaces = slot_count;
@@ -3523,6 +3528,21 @@ static long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 		up_read(&info->groups_sem);
 	}
 
+	/*
+	 * Add global block reserve
+	 */
+	if (slot_count) {
+		struct btrfs_block_rsv *block_rsv = &root->fs_info->global_block_rsv;
+
+		spin_lock(&block_rsv->lock);
+		space.total_bytes = block_rsv->size;
+		space.used_bytes = block_rsv->size - block_rsv->reserved;
+		spin_unlock(&block_rsv->lock);
+		space.flags = BTRFS_SPACE_INFO_GLOBAL_RSV;
+		memcpy(dest, &space, sizeof(space));
+		space_args.total_spaces++;
+	}
+
 	user_dest = (struct btrfs_ioctl_space_info __user *)
 		(arg + sizeof(struct btrfs_ioctl_space_args));
 
-- 
1.8.5.2

