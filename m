Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay0-omc1-s7.bay0.hotmail.com ([65.54.190.18]:46500 "EHLO
	bay0-omc1-s7.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951Ab3FFPl7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Jun 2013 11:41:59 -0400
Message-ID: <BAY172-DS9FD076B2A36E8DE54EB32B0980@phx.gbl>
From: "Kyle Gates" <kylegates@hotmail.com>
To: "Liu Bo" <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1370317203-31554-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1370317203-31554-1-git-send-email-bo.li.liu@oracle.com>
Subject: Re: [PATCH] Btrfs: fix broken nocow after balance
Date: Thu, 6 Jun 2013 10:42:31 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, June 03, 2013, Liu Bo wrote:
> Balance will create reloc_root for each fs root, and it's going to
> record last_snapshot to filter shared blocks.  The side effect of
> setting last_snapshot is to break nocow attributes of files.
>
> So it turns out that checking last_snapshot does not always ensure that
> a node/leaf/file_extent is shared.
>
> That's why shared node/leaf needs to search extent tree for number of 
> references
> even after having checked last_snapshot, and updating fs/file tree works
> top-down so the children will always know how many references parents put
> on them at the moment of checking shared status.
>
> However, our nocow path does something different, it'll firstly check
> if the file extent is shared, then update fs/file tree by updating inode.
> This ends up that the related extent record to the file extent may don't
> have actual multiple references when checking shared status.
>
> ------------------------------------------------
> fs_root snap
>   \    /
>    leaf ==> refs=2
>     |
>  file_extent ==> refs=1(but actually refs is 2)
>
> After updating fs tree(or snapshot if snapshot is not RO), it'll be
>
> fs root snap
>  \      /
>  cow  leaf
>    \  /
>  file_extent ==> refs=2(we do have two parents)
> ------------------------------------------------
>
> So it'll be confused by last_snapshot from balance to think that the file
> extent is now shared.
>
> There are actually a couple of ways to address it, but updating fs/file 
> tree
> firstly might be the easiest and cleanest one.  With this, updating 
> fs/file
> tree will at least make a delayed ref if the file extent is really shared 
> by
> several parents, we can make nocow happy again without having to check 
> confusing
> last_snapshot.

Works here. Extents are stable after a balance.
Thanks,
Kyle

Tested-by: Kyle Gates <kylegates@hotmail.com>

>
> Reported-by: Kyle Gates <kylegates@hotmail.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> fs/btrfs/extent-tree.c |    4 ----
> fs/btrfs/inode.c       |    2 +-
> 2 files changed, 1 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index df472ab..d24c26c 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2856,10 +2856,6 @@ static noinline int check_committed_ref(struct 
> btrfs_trans_handle *trans,
>      btrfs_extent_inline_ref_size(BTRFS_EXTENT_DATA_REF_KEY))
>  goto out;
>
> - if (btrfs_extent_generation(leaf, ei) <=
> -     btrfs_root_last_snapshot(&root->root_item))
> - goto out;
> -
>  iref = (struct btrfs_extent_inline_ref *)(ei + 1);
>  if (btrfs_extent_inline_ref_type(leaf, iref) !=
>      BTRFS_EXTENT_DATA_REF_KEY)
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 23c596c..0dc5c7d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1253,7 +1253,7 @@ static noinline int run_delalloc_nocow(struct inode 
> *inode,
>  cur_offset = start;
>  while (1) {
>  ret = btrfs_lookup_file_extent(trans, root, path, ino,
> -        cur_offset, 0);
> +        cur_offset, 1);
>  if (ret < 0) {
>  btrfs_abort_transaction(trans, root, ret);
>  goto error;
> -- 
> 1.7.7
>
> 
