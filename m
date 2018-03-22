Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53505 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751464AbeCVPy7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 11:54:59 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C89A7AF52
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 15:54:57 +0000 (UTC)
Date: Thu, 22 Mar 2018 16:52:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: jeffm@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: defer adding raid type kobject until after
 chunk relocation
Message-ID: <20180322155232.GE6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180320192526.4629-1-jeffm@suse.com>
 <20180320192526.4629-2-jeffm@suse.com>
 <388c9c1f-b244-b100-5ad3-985d980a1deb@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <388c9c1f-b244-b100-5ad3-985d980a1deb@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 21, 2018 at 08:44:58AM +0200, Nikolay Borisov wrote:
> 
> 
> On 20.03.2018 21:25, jeffm@suse.com wrote:
> > From: Jeff Mahoney <jeffm@suse.com>
> > 
> > Any time the first block group of a new type is created, we add a new
> > kobject to sysfs to hold the attributes for that type.  Kobject-internal
> > allocations always use GFP_KERNEL, making them prone to fs-reclaim races.
> > While it appears as if this can occur any time a block group is created,
> > the only times the first block group of a new type can be created in
> > memory is at mount and when we create the first new block group during
> > raid conversion.
> > 
> > This patch adds a new list to track pending kobject additions and then
> > handles them after we do chunk relocation.  Between relocating the
> > target chunk (or forcing allocation of a new chunk in the case of data)
> > and removing the old chunk, we're in a safe place for fs-reclaim to
> > occur.  We're holding the volume mutex, which is already held across
> > page faults, and the delete_unused_bgs_mutex, which will only stall
> > the cleaner thread.
> > 
> > Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> > ---
> >  fs/btrfs/ctree.h       |  6 ++++-
> >  fs/btrfs/disk-io.c     |  2 ++
> >  fs/btrfs/extent-tree.c | 59 +++++++++++++++++++++++++++++++++++---------------
> >  fs/btrfs/sysfs.c       |  2 +-
> >  fs/btrfs/volumes.c     | 12 ++++++++++
> >  5 files changed, 61 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index ffbb05aa66fa..75dbdf1bbead 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -381,8 +381,9 @@ struct btrfs_dev_replace {
> >  
> >  /* For raid type sysfs entries */
> >  struct raid_kobject {
> > -	int raid_type;
> > +	u64 flags;
> >  	struct kobject kobj;
> > +	struct list_head list;
> >  };
> >  
> >  struct btrfs_space_info {
> > @@ -938,6 +939,8 @@ struct btrfs_fs_info {
> >  	int thread_pool_size;
> >  
> >  	struct kobject *space_info_kobj;
> > +	struct list_head pending_raid_kobjs;
> > +	spinlock_t pending_raid_kobjs_lock; /* uncontended */
> >  
> >  	u64 total_pinned;
> >  
> > @@ -2688,6 +2691,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr);
> >  int btrfs_make_block_group(struct btrfs_trans_handle *trans,
> >  			   struct btrfs_fs_info *fs_info, u64 bytes_used,
> >  			   u64 type, u64 chunk_offset, u64 size);
> > +void btrfs_add_raid_kobjects(struct btrfs_fs_info *fs_info);
> >  struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
> >  				struct btrfs_fs_info *fs_info,
> >  				const u64 chunk_offset);
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index eb6bb3169a9e..d5e1c2ff71ff 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -2447,6 +2447,8 @@ int open_ctree(struct super_block *sb,
> >  	INIT_LIST_HEAD(&fs_info->delayed_iputs);
> >  	INIT_LIST_HEAD(&fs_info->delalloc_roots);
> >  	INIT_LIST_HEAD(&fs_info->caching_block_groups);
> > +	INIT_LIST_HEAD(&fs_info->pending_raid_kobjs);
> > +	spin_lock_init(&fs_info->pending_raid_kobjs_lock);
> >  	spin_lock_init(&fs_info->delalloc_root_lock);
> >  	spin_lock_init(&fs_info->trans_lock);
> >  	spin_lock_init(&fs_info->fs_roots_radix_lock);
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 0e9a21230217..bb5368faa937 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -9908,9 +9908,39 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
> >  	return 0;
> >  }
> >  
> > +/* link_block_group will queue up kobjects to add when we're reclaim-safe */
> > +void btrfs_add_raid_kobjects(struct btrfs_fs_info *fs_info)
> > +{
> > +	struct btrfs_space_info *space_info;
> > +	struct raid_kobject *rkobj;
> > +	LIST_HEAD(list);
> > +	int index;
> > +	int ret = 0;
> > +
> > +	spin_lock(&fs_info->pending_raid_kobjs_lock);
> > +	list_splice_init(&fs_info->pending_raid_kobjs, &list);
> > +	spin_unlock(&fs_info->pending_raid_kobjs_lock);
> > +
> > +	list_for_each_entry(rkobj, &list, list) {
> > +		space_info = __find_space_info(fs_info, rkobj->flags);
> > +		index = __get_raid_index(rkobj->flags);
> 
> This function is no more. It was refactored in 24bc2843edd5 ("btrfs:
> Refactor __get_raid_index() to btrfs_bg_flags_to_raid_index()")
> 
> 
> So I guess you should use btrfs_bg_flags_to_raid_index instead.

Fixed and patches added to next, thanks.
