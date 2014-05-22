Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaEVBWG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 21:22:06 -0400
Message-ID: <537D5136.4050007@suse.com>
Date: Wed, 21 May 2014 21:21:58 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: don't remove raid type sysfs entries until unmount
References: <537D40EB.60906@fb.com>
In-Reply-To: <537D40EB.60906@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/21/2014 08:12 PM, Chris Mason wrote:
> 
> The Btrfs sysfs code removes entries for raid types that are no
> longer in use.  This means that if you have a raid0 FS and use balance
> to turn it into a raid1 FS, the raid0 sysfs entries will go away.
> 
> The rough chain of events is:
> 
> __link_block_group() -> see we're the first RAIDX, add sysfs entry
> 
> btrfs_remove_block_group() -> notice we're removing the last RAIDX
> remove sysfs entry
> 
> This all makes sense until we try to add RAIDX back into the FS again.
> The problem is that our RAID kobjects are just in an array that gets
> freed at unmount time, instead of an array of pointers to kobjects that
> get freed when the great sysfs in the sky is done with them.
> 
> When we remove the sysfs entry for a given raid level, the syfs code
> free's the name.  When we use the same kobject to add back the RAIDX
> entry again, sysfs sees the old name pointer and tries to free it again.
> 
> All of which is a long way of saying we're using sysfs wrong.  For now,
> just don't remove entries for raid levels that we're no longer using.

Hi Chris -

Thanks for posting the problem. I disagree that sysfs is being used
wrong here - or well, not on purpose. The problem is only that I didn't
anticipate raid levels going away and only initialize the kobjects i
update_space_info.

The name being double-freed is only part of the problem. The kobject
isn't reinitialized at all. Clearing ->name and re-calling kobject_init
would fix it - but I think we can do one better.

kobject_cleanup's comment for freeing ->name claims that ->name being
set means that it was allocated by the kobject infrastructure. The raid
names come directly out of an array anyway, so we don't even need to
copy it. We can avoid the string allocation entirely and handle the
reuse properly.

The following (untested, tonight anyway) patch should fix it.

-Jeff

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3401,10 +3401,8 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 		return ret;
 	}
 
-	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
+	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
 		INIT_LIST_HEAD(&found->block_groups[i]);
-		kobject_init(&found->block_group_kobjs[i], &btrfs_raid_ktype);
-	}
 	init_rwsem(&found->groups_sem);
 	spin_lock_init(&found->lock);
 	found->flags = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
@@ -8356,8 +8354,9 @@ static void __link_block_group(struct btrfs_space_info *space_info,
 		int ret;
 
 		kobject_get(&space_info->kobj); /* put in release */
-		ret = kobject_add(kobj, &space_info->kobj, "%s",
-				  get_raid_name(index));
+		kobject->name = get_raid_name(index);
+		ret = kobject_init_and_add(kobj, &btrfs_raid_ktype,
+					   &space_info->kobj, NULL);
 		if (ret) {
 			pr_warn("BTRFS: failed to add kobject for block cache. ignoring.\n");
 			kobject_put(&space_info->kobj);
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index c5eb214..d742d79 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -288,6 +288,7 @@ static struct attribute *raid_attributes[] = {
 
 static void release_raid_kobj(struct kobject *kobj)
 {
+	kobj->name = NULL;
 	kobject_put(kobj->parent);
 }
 


-Jeff


> Signed-off-by: Chris Mason <clm@fb.com>
> Reported-by: Dave Sterba <dsterba@suse.cz>
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index ddf16bf..acdc7ed 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8535,12 +8535,14 @@ static void __link_block_group(struct btrfs_space_info *space_info,
>  		struct kobject *kobj = &space_info->block_group_kobjs[index];
>  		int ret;
>  
> -		kobject_get(&space_info->kobj); /* put in release */
> -		ret = kobject_add(kobj, &space_info->kobj, "%s",
> -				  get_raid_name(index));
> -		if (ret) {
> -			pr_warn("BTRFS: failed to add kobject for block cache. ignoring.\n");
> -			kobject_put(&space_info->kobj);
> +		if (!kobj->name) {
> +			kobject_get(&space_info->kobj); /* put in release */
> +			ret = kobject_add(kobj, &space_info->kobj, "%s",
> +					  get_raid_name(index));
> +			if (ret) {
> +				pr_warn("BTRFS: failed to add kobject for block cache. ignoring.\n");
> +				kobject_put(&space_info->kobj);
> +			}
>  		}
>  	}
>  }
> @@ -8976,8 +8978,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>  	 */
>  	list_del_init(&block_group->list);
>  	if (list_empty(&block_group->space_info->block_groups[index])) {
> -		kobject_del(&block_group->space_info->block_group_kobjs[index]);
> -		kobject_put(&block_group->space_info->block_group_kobjs[index]);
>  		clear_avail_alloc_bits(root->fs_info, block_group->flags);
>  	}
>  	up_write(&block_group->space_info->groups_sem);
> 



