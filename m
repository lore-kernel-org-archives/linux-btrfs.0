Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45279 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750924AbdEPOhi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 10:37:38 -0400
Date: Tue, 16 May 2017 07:37:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] Btrfs: use bio_clone_bioset_partial to simplify DIO
 submit
Message-ID: <20170516143737.GA24541@infradead.org>
References: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
 <1492478187-24875-3-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1492478187-24875-3-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>  }
>  
> +struct bio *btrfs_bio_clone_partial(struct bio *orig, gfp_t gfp_mask, int offset, int size)
> +{
> +	struct bio *bio;
> +
> +	bio = bio_clone_fast(orig, gfp_mask, btrfs_bioset);
> +	if (bio) {

bio_clone_fast will never fail when backed by a bioset, which this
one always is.  Also you always pass GFP_NPFS as the gfp_mask argument,
it might make sense to hardcode that here.

> +		struct btrfs_io_bio *btrfs_bio = btrfs_io_bio(bio);
> +		btrfs_bio->csum = NULL;
> +		btrfs_bio->csum_allocated = NULL;
> +		btrfs_bio->end_io = NULL;
> +
> +		bio_trim(bio, (offset >> 9), (size >> 9));

No need for the inner braces here.

Last but not least do you even need this as a separate helper?

> +struct bio *btrfs_bio_clone_partial(struct bio *orig, gfp_t gfp_mask, int offset, int size);

Over long line, please trim to 80 characters
