Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58914 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751718AbdLFPuT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Dec 2017 10:50:19 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5F571AE0F
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Dec 2017 15:50:18 +0000 (UTC)
Date: Wed, 6 Dec 2017 16:48:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] btrfs: Fix possible off-by-one in
 btrfs_search_path_in_tree
Message-ID: <20171206154818.GB3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
 <1512119984-12708-4-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512119984-12708-4-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 01, 2017 at 11:19:42AM +0200, Nikolay Borisov wrote:
> The name char array passed to btrfs_search_path_in_tree is of size
> BTRFS_INO_LOOKUP_PATH_MAX (4080). So the actual accessible char indexes
> are in the range of [0, 4079]. Currently the code uses the define but this
> represents an off-by-one.

For such fixes it's good to think about and document potential
implications, like where could the extra byte end be written, and if this
is a patch stable.

Size of btrfs_ioctl_ino_lookup_args is 4096, so the new byte will be
written to extra space, not some padding that could be provided by the
allocator.

btrfs-progs store the arguments on stack, but kernel does own copy of
the ioctl buffer and the off-by-one overwrite does not affect userspace,
but the ending 0 might be lost.

kernel ioctl buffer is allocated dynamically so we're overwriting
somebody else's memory, and the ioctl is privileged if args.objectid is
not 256. Which is in most cases, but resolving a subvolume stored in
another directory will trigger that path.

Fixes: ac8e9819d71f907 ("Btrfs: add search and inode lookup ioctls")

Before this patch the buffer was one byte larger, but then the -1 was
not added.

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ioctl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e8adebc8c1b0..fc148b7c4265 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2206,7 +2206,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
>  	if (!path)
>  		return -ENOMEM;
>  
> -	ptr = &name[BTRFS_INO_LOOKUP_PATH_MAX];
> +	ptr = &name[BTRFS_INO_LOOKUP_PATH_MAX - 1];
>  
>  	key.objectid = tree_id;
>  	key.type = BTRFS_ROOT_ITEM_KEY;
> @@ -2272,8 +2272,8 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
>  static noinline int btrfs_ioctl_ino_lookup(struct file *file,
>  					   void __user *argp)
>  {
> -	 struct btrfs_ioctl_ino_lookup_args *args;
> -	 struct inode *inode;
> +	struct btrfs_ioctl_ino_lookup_args *args;
> +	struct inode *inode;

Unrelated change.

>  	int ret = 0;
>  
>  	args = memdup_user(argp, sizeof(*args));
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
