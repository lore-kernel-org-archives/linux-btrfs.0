Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60482 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731256AbeGTPsI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 11:48:08 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2A305ACF4
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 14:59:26 +0000 (UTC)
Date: Fri, 20 Jul 2018 16:59:19 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/7] btrfs: remove redundant member async_cow::root
Message-ID: <20180720145919.GD26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1531996240.git.dsterba@suse.com>
 <1c08372d35f29610eed55f77ddcfbe10c8a952f5.1531996240.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1c08372d35f29610eed55f77ddcfbe10c8a952f5.1531996240.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 01:05:14PM +0200, David Sterba wrote:
> The root is only used to get fs_info out of it, but the same can be
> retrieved from the inode that's in async_cow.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/inode.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 564ec00c765b..36b323b27dbf 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -358,7 +358,6 @@ struct async_extent {
>  
>  struct async_cow {
>  	struct inode *inode;
> -	struct btrfs_root *root;
>  	struct page *locked_page;
>  	u64 start;
>  	u64 end;
> @@ -1144,13 +1143,11 @@ static noinline void async_cow_submit(struct btrfs_work *work)
>  {
>  	struct btrfs_fs_info *fs_info;
>  	struct async_cow *async_cow;
> -	struct btrfs_root *root;
>  	unsigned long nr_pages;
>  
>  	async_cow = container_of(work, struct async_cow, work);
>  
> -	root = async_cow->root;
> -	fs_info = root->fs_info;
> +	fs_info = BTRFS_I(async_cow->inode)->root->fs_info;

This crashes if the inode is NULL, which can happen in async_cow_start
if compress_file_range returns 0 in num_added. The inode is moved to
delayed iputs and async_cow->inode zeroed.

Patch removed for now. We can reach the inode via the
async_cow::locked_page, but it's 5 pointers to chase and I want to have a
second thought on that if the 8 bytes in the structure is not cheaper.

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1143,11 +1143,13 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 {
        struct btrfs_fs_info *fs_info;
        struct async_cow *async_cow;
+       struct inode *inode;
        unsigned long nr_pages;
 
        async_cow = container_of(work, struct async_cow, work);
 
-       fs_info = BTRFS_I(async_cow->inode)->root->fs_info;
+       inode = async_cow->locked_page->mapping->host;
+       fs_info = BTRFS_I(inode)->root->fs_info;
        nr_pages = (async_cow->end - async_cow->start + PAGE_SIZE) >>
                PAGE_SHIFT;
 
---

