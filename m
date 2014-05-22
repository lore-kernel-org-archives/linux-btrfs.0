Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13907 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbaEVAJV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 20:09:21 -0400
Message-ID: <537D40EB.60906@fb.com>
Date: Wed, 21 May 2014 20:12:27 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] Btrfs: don't remove raid type sysfs entries until unmount
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


The Btrfs sysfs code removes entries for raid types that are no
longer in use.  This means that if you have a raid0 FS and use balance
to turn it into a raid1 FS, the raid0 sysfs entries will go away.

The rough chain of events is:

__link_block_group() -> see we're the first RAIDX, add sysfs entry

btrfs_remove_block_group() -> notice we're removing the last RAIDX
remove sysfs entry

This all makes sense until we try to add RAIDX back into the FS again.
The problem is that our RAID kobjects are just in an array that gets
freed at unmount time, instead of an array of pointers to kobjects that
get freed when the great sysfs in the sky is done with them.

When we remove the sysfs entry for a given raid level, the syfs code
free's the name.  When we use the same kobject to add back the RAIDX
entry again, sysfs sees the old name pointer and tries to free it again.

All of which is a long way of saying we're using sysfs wrong.  For now,
just don't remove entries for raid levels that we're no longer using.

Signed-off-by: Chris Mason <clm@fb.com>
Reported-by: Dave Sterba <dsterba@suse.cz>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ddf16bf..acdc7ed 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8535,12 +8535,14 @@ static void __link_block_group(struct btrfs_space_info *space_info,
 		struct kobject *kobj = &space_info->block_group_kobjs[index];
 		int ret;
 
-		kobject_get(&space_info->kobj); /* put in release */
-		ret = kobject_add(kobj, &space_info->kobj, "%s",
-				  get_raid_name(index));
-		if (ret) {
-			pr_warn("BTRFS: failed to add kobject for block cache. ignoring.\n");
-			kobject_put(&space_info->kobj);
+		if (!kobj->name) {
+			kobject_get(&space_info->kobj); /* put in release */
+			ret = kobject_add(kobj, &space_info->kobj, "%s",
+					  get_raid_name(index));
+			if (ret) {
+				pr_warn("BTRFS: failed to add kobject for block cache. ignoring.\n");
+				kobject_put(&space_info->kobj);
+			}
 		}
 	}
 }
@@ -8976,8 +8978,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	 */
 	list_del_init(&block_group->list);
 	if (list_empty(&block_group->space_info->block_groups[index])) {
-		kobject_del(&block_group->space_info->block_group_kobjs[index]);
-		kobject_put(&block_group->space_info->block_group_kobjs[index]);
 		clear_avail_alloc_bits(root->fs_info, block_group->flags);
 	}
 	up_write(&block_group->space_info->groups_sem);
