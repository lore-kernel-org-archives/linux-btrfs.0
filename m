Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49072 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752522AbdFLOdV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 10:33:21 -0400
Date: Mon, 12 Jun 2017 16:32:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix Null pointer dereference in dio read endio
Message-ID: <20170612143216.GO25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170606195252.17563-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170606195252.17563-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 01:52:52PM -0600, Liu Bo wrote:
> With switching to use btrfs_bio_clone_partial() to split bio in
> directIO path, read endio is also adapted to that by recording a
> iterator in btrfs_bio, however, it breaks those bios which are less
> than stripe length thus no need to be split and results in NULL
> pointer dereference.
> 
> This fixes the issue by recording the required bio iterator in
> btrfs_bio_clone() which is used to clone non-split bio in directIO
> path.  It doesn't affect other calls of btrfs_bio_clone() because they
> don't need to use this iterator.
> 
> This bug was caught by fstests/generic/091.
> 
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> Based on David's for-next.
> Fixes: commit "Btrfs: change how we iterate bios in endio"
> 
> Have run through fstests without introducing new problems.
> 
>  fs/btrfs/extent_io.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 806e8d6..a91c3a1 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2719,6 +2719,7 @@ struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask)
>  		btrfs_bio->csum = NULL;
>  		btrfs_bio->csum_allocated = NULL;
>  		btrfs_bio->end_io = NULL;
> +		btrfs_bio->iter = bio->bi_iter;

Actually this points to a problem with initialization of the
btrfs_io_bio in general. They have embedded struct bio and the bioset
allocation will increase the size to cover btrfs_io_bio (although only
bio is handled). But, there's no kzalloc or memset anywhere, so it's
completely up to the caller to sanitize the fresh structure. Which we
only do partially (csum, csum_allocated, end_io). In that case 'iter'
could contain garbage and who knows what could happen.

So my suggestion: fold this patch to the one you refrence (ie. that
the behaviour is same before and after), and we'll fix the
initialization of btrfs_io_bio after the various bio clone/alloc calls.
