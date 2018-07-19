Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33314 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731893AbeGSQjp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 12:39:45 -0400
Received: by mail-qt0-f196.google.com with SMTP id c15-v6so7632252qtp.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 08:55:57 -0700 (PDT)
Date: Thu, 19 Jul 2018 11:55:55 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 10/22] btrfs: alloc space cache inode with GFP_NOFS
Message-ID: <20180719155554.rdy5hfakrq3irtnw@destiny>
References: <20180719145006.17532-1-josef@toxicpanda.com>
 <20180719145006.17532-10-josef@toxicpanda.com>
 <3e617a5c-03d7-5937-fbe1-e067c5b8d5ee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3e617a5c-03d7-5937-fbe1-e067c5b8d5ee@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 06:35:33PM +0300, Nikolay Borisov wrote:
> 
> 
> On 19.07.2018 17:49, Josef Bacik wrote:
> > If we're allocating a new space cache inode it's likely going to be
> > under a transaction handle, so we need to use GFP_NOFS to keep from
> > deadlocking.  Otherwise GFP_KERNEL is fine.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/btrfs/free-space-cache.c | 5 +++++
> >  fs/btrfs/inode.c            | 3 ++-
> >  fs/btrfs/transaction.h      | 1 +
> >  3 files changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> > index d5f80cb300be..13bc514e4e16 100644
> > --- a/fs/btrfs/free-space-cache.c
> > +++ b/fs/btrfs/free-space-cache.c
> > @@ -68,7 +68,12 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
> >  	btrfs_disk_key_to_cpu(&location, &disk_key);
> >  	btrfs_release_path(path);
> >  
> > +	/* We need this set so that we use GFP_NOFS when allocating our inode. */
> > +	if (current->journal_info == NULL)
> > +		current->journal_info = BTRFS_TRANS_STUB;
> >  	inode = btrfs_iget(fs_info->sb, &location, root, NULL);
> > +	if (current->journal_info == BTRFS_TRANS_STUB)
> > +		current->journal_info = NULL;
> This is not safe in the face of stacked filesystem, i.e ext4 uses the
> journal_info.

Stacked file systems arent safe at all because we all use journal_info, this
doesn't change that.

> 
> >  	if (IS_ERR(inode))
> >  		return inode;
> >  	if (is_bad_inode(inode)) {
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index eba61bcb9bb3..14ecfe5d6110 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -9211,8 +9211,9 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
> >  	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
> >  	struct btrfs_inode *ei;
> >  	struct inode *inode;
> > +	gfp_t flags = (current->journal_info) ? GFP_NOFS : GFP_KERNEL;
> >  
> > -	ei = kmem_cache_alloc(btrfs_inode_cachep, GFP_KERNEL);
> > +	ei = kmem_cache_alloc(btrfs_inode_cachep, flags);
> 
> Why don't you just hardcode GFP_NOFS? We should be striving at removing
> abuse of ->journal_info than proliferating it.
> 

Because every time I use GFP_NOFS some mm guy shows up and complains.  I'm fine
with doing GFP_NOFS, but the vast majority of allocations are in paths that
GFP_KERNEL is fine.  Thanks,

Josef
