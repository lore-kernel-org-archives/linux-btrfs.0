Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27347 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbbLFS7m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Dec 2015 13:59:42 -0500
Date: Sun, 6 Dec 2015 10:59:39 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Alex Lyakas <alex@zadarastorage.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] btrfs: flush_space: treat return value of
 do_chunk_alloc properly
Message-ID: <20151206185939.GC3005@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAOcd+r3DHGSu5017ha+m1E9bv2YD4v-LCMBxYywNA9BaLK-DQg@mail.gmail.com>
 <20151203181428.GA19589@localhost.localdomain>
 <CAOcd+r2h4YH5duP85z7riwqe8BePHDhL3j35-natP=uNhhTz7A@mail.gmail.com>
 <CAOcd+r0OS6mdKxhhEoMUt5r9p7mDqDaCWPbcCJydizw4QbeRBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOcd+r0OS6mdKxhhEoMUt5r9p7mDqDaCWPbcCJydizw4QbeRBA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 06, 2015 at 12:32:31PM +0200, Alex Lyakas wrote:
> do_chunk_alloc returns 1 when it succeeds to allocate a new chunk.
> But flush_space will not convert this to 0, and will also return 1.
> As a result, reserve_metadata_bytes will think that flush_space failed,
> and may potentially return this value "1" to the caller (depends how
> reserve_metadata_bytes was called). The caller will also treat this as an error.
> For example, btrfs_block_rsv_refill does:
> 
> int ret = -ENOSPC;
> ...
> ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
> if (!ret) {
>         block_rsv_add_bytes(block_rsv, num_bytes, 0);
>         return 0;
> }
> 
> return ret;
> 
> So it will return -ENOSPC.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
> Reviewed-by: Josef Bacik <jbacik@fb.com>
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 4b89680..1ba3f0d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4727,7 +4727,7 @@ static int flush_space(struct btrfs_root *root,
>                                      btrfs_get_alloc_profile(root, 0),
>                                      CHUNK_ALLOC_NO_FORCE);
>                 btrfs_end_transaction(trans, root);
> -               if (ret == -ENOSPC)
> +               if (ret > 0 || ret == -ENOSPC)
>                         ret = 0;
>                 break;
>         case COMMIT_TRANS:
> 
> On Sun, Dec 6, 2015 at 12:19 PM, Alex Lyakas <alex@zadarastorage.com> wrote:
> > Hi Liu,
> > I was studying on how block reservation works, and making some
> > modifications in reserve_metadata_bytes to understand better what it
> > does. Then suddenly I saw this problem. I guess it depends on which
> > value of "flush" parameter is passed to reserve_metadata_bytes.
> >
> > Alex.
> >
> >
> > On Thu, Dec 3, 2015 at 8:14 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >> On Thu, Dec 03, 2015 at 06:51:03PM +0200, Alex Lyakas wrote:
> >>> do_chunk_alloc returns 1 when it succeeds to allocate a new chunk.
> >>> But flush_space will not convert this to 0, and will also return 1.
> >>> As a result, reserve_metadata_bytes will think that flush_space failed,
> >>> and may potentially return this value "1" to the caller (depends how
> >>> reserve_metadata_bytes was called). The caller will also treat this as an error.
> >>> For example, btrfs_block_rsv_refill does:
> >>>
> >>> int ret = -ENOSPC;
> >>> ...
> >>> ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
> >>> if (!ret) {
> >>>         block_rsv_add_bytes(block_rsv, num_bytes, 0);
> >>>         return 0;
> >>> }
> >>>
> >>> return ret;
> >>>
> >>> So it will return -ENOSPC.
> >>
> >> It will return 1 instead of -ENOSPC.
> >>
> >> The patch looks good, I noticed this before, but I didn't manage to trigger a error for this, did you catch a error like that?
> >>
> >> Thanks,
> >>
> >> -liubo
> >>
> >>>
> >>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> >>> index 4b89680..1ba3f0d 100644
> >>> --- a/fs/btrfs/extent-tree.c
> >>> +++ b/fs/btrfs/extent-tree.c
> >>> @@ -4727,7 +4727,7 @@ static int flush_space(struct btrfs_root *root,
> >>>                                      btrfs_get_alloc_profile(root, 0),
> >>>                                      CHUNK_ALLOC_NO_FORCE);
> >>>                 btrfs_end_transaction(trans, root);
> >>> -               if (ret == -ENOSPC)
> >>> +               if (ret > 0 || ret == -ENOSPC)
> >>>                         ret = 0;
> >>>                 break;
> >>>         case COMMIT_TRANS:
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
