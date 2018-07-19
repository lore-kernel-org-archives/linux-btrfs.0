Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50396 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731477AbeGSQTT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 12:19:19 -0400
Subject: Re: [PATCH 10/22] btrfs: alloc space cache inode with GFP_NOFS
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20180719145006.17532-1-josef@toxicpanda.com>
 <20180719145006.17532-10-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3e617a5c-03d7-5937-fbe1-e067c5b8d5ee@suse.com>
Date: Thu, 19 Jul 2018 18:35:33 +0300
MIME-Version: 1.0
In-Reply-To: <20180719145006.17532-10-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.07.2018 17:49, Josef Bacik wrote:
> If we're allocating a new space cache inode it's likely going to be
> under a transaction handle, so we need to use GFP_NOFS to keep from
> deadlocking.  Otherwise GFP_KERNEL is fine.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/free-space-cache.c | 5 +++++
>  fs/btrfs/inode.c            | 3 ++-
>  fs/btrfs/transaction.h      | 1 +
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index d5f80cb300be..13bc514e4e16 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -68,7 +68,12 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
>  	btrfs_disk_key_to_cpu(&location, &disk_key);
>  	btrfs_release_path(path);
>  
> +	/* We need this set so that we use GFP_NOFS when allocating our inode. */
> +	if (current->journal_info == NULL)
> +		current->journal_info = BTRFS_TRANS_STUB;
>  	inode = btrfs_iget(fs_info->sb, &location, root, NULL);
> +	if (current->journal_info == BTRFS_TRANS_STUB)
> +		current->journal_info = NULL;
This is not safe in the face of stacked filesystem, i.e ext4 uses the
journal_info.

>  	if (IS_ERR(inode))
>  		return inode;
>  	if (is_bad_inode(inode)) {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index eba61bcb9bb3..14ecfe5d6110 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9211,8 +9211,9 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
>  	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>  	struct btrfs_inode *ei;
>  	struct inode *inode;
> +	gfp_t flags = (current->journal_info) ? GFP_NOFS : GFP_KERNEL;
>  
> -	ei = kmem_cache_alloc(btrfs_inode_cachep, GFP_KERNEL);
> +	ei = kmem_cache_alloc(btrfs_inode_cachep, flags);

Why don't you just hardcode GFP_NOFS? We should be striving at removing
abuse of ->journal_info than proliferating it.

>  	if (!ei)
>  		return NULL;
>  
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 94439482a0ec..172ff923bf15 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -106,6 +106,7 @@ struct btrfs_transaction {
>  #define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)
>  
>  #define BTRFS_SEND_TRANS_STUB	((void *)1)
> +#define BTRFS_TRANS_STUB	((void *)2)
>  
>  struct btrfs_trans_handle {
>  	u64 transid;
> 
