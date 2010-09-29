From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix the df ioctl to report raid types
Date: Wed, 29 Sep 2010 11:24:09 -0400
Message-ID: <1285773849-3813-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The new ENOSPC stuff broke the df ioctl since we no longer create seperate space
info's for each RAID type.  So instead, loop through each space info's raid
lists so we can get the right RAID information which will allow the df ioctl to
tell us RAID types again.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ioctl.c |  100 +++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 76 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f59b0bc..e264072 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1879,6 +1879,22 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	return 0;
 }
 
+static void get_block_group_info(struct list_head *groups_list,
+				 struct btrfs_ioctl_space_info *space)
+{
+	struct btrfs_block_group_cache *block_group;
+
+	space->total_bytes = 0;
+	space->used_bytes = 0;
+	space->flags = 0;
+	list_for_each_entry(block_group, groups_list, list) {
+		space->flags = block_group->flags;
+		space->total_bytes += block_group->key.offset;
+		space->used_bytes +=
+			btrfs_block_group_used(&block_group->item);
+	}
+}
+
 long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 {
 	struct btrfs_ioctl_space_args space_args;
@@ -1887,27 +1903,56 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 	struct btrfs_ioctl_space_info *dest_orig;
 	struct btrfs_ioctl_space_info *user_dest;
 	struct btrfs_space_info *info;
+	u64 types[] = {BTRFS_BLOCK_GROUP_DATA,
+		       BTRFS_BLOCK_GROUP_SYSTEM,
+		       BTRFS_BLOCK_GROUP_METADATA,
+		       BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA};
+	int num_types = 4;
 	int alloc_size;
 	int ret = 0;
 	int slot_count = 0;
+	int i, c;
 
 	if (copy_from_user(&space_args,
 			   (struct btrfs_ioctl_space_args __user *)arg,
 			   sizeof(space_args)))
 		return -EFAULT;
 
-	/* first we count slots */
-	rcu_read_lock();
-	list_for_each_entry_rcu(info, &root->fs_info->space_info, list)
-		slot_count++;
-	rcu_read_unlock();
+	for (i = 0; i < num_types; i++) {
+		struct btrfs_space_info *tmp;
+
+		info = NULL;
+		rcu_read_lock();
+		list_for_each_entry_rcu(tmp, &root->fs_info->space_info,
+					list) {
+			if (tmp->flags == types[i]) {
+				info = tmp;
+				break;
+			}
+		}
+		rcu_read_unlock();
+
+		if (!info)
+			continue;
+
+		down_read(&info->groups_sem);
+		for (c = 0; c < BTRFS_NR_RAID_TYPES; c++) {
+			if (!list_empty(&info->block_groups[c]))
+				slot_count++;
+		}
+		up_read(&info->groups_sem);
+	}
 
 	/* space_slots == 0 means they are asking for a count */
 	if (space_args.space_slots == 0) {
 		space_args.total_spaces = slot_count;
 		goto out;
 	}
+
+	slot_count = min_t(int, space_args.space_slots, slot_count);
+
 	alloc_size = sizeof(*dest) * slot_count;
+
 	/* we generally have at most 6 or so space infos, one for each raid
 	 * level.  So, a whole page should be more than enough for everyone
 	 */
@@ -1921,27 +1966,34 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 	dest_orig = dest;
 
 	/* now we have a buffer to copy into */
-	rcu_read_lock();
-	list_for_each_entry_rcu(info, &root->fs_info->space_info, list) {
-		/* make sure we don't copy more than we allocated
-		 * in our buffer
-		 */
-		if (slot_count == 0)
-			break;
-		slot_count--;
-
-		/* make sure userland has enough room in their buffer */
-		if (space_args.total_spaces >= space_args.space_slots)
-			break;
+	for (i = 0; i < num_types; i++) {
+		struct btrfs_space_info *tmp;
+
+		info = NULL;
+		rcu_read_lock();
+		list_for_each_entry_rcu(tmp, &root->fs_info->space_info,
+					list) {
+			if (tmp->flags == types[i]) {
+				info = tmp;
+				break;
+			}
+		}
+		rcu_read_unlock();
 
-		space.flags = info->flags;
-		space.total_bytes = info->total_bytes;
-		space.used_bytes = info->bytes_used;
-		memcpy(dest, &space, sizeof(space));
-		dest++;
-		space_args.total_spaces++;
+		if (!info)
+			continue;
+		down_read(&info->groups_sem);
+		for (c = 0; c < BTRFS_NR_RAID_TYPES; c++) {
+			if (!list_empty(&info->block_groups[c])) {
+				get_block_group_info(&info->block_groups[c],
+						     &space);
+				memcpy(dest, &space, sizeof(space));
+				dest++;
+				space_args.total_spaces++;
+			}
+		}
+		up_read(&info->groups_sem);
 	}
-	rcu_read_unlock();
 
 	user_dest = (struct btrfs_ioctl_space_info *)
 		(arg + sizeof(struct btrfs_ioctl_space_args));
-- 
1.6.6.1

