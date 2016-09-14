Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48806 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753872AbcINJ6Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 05:58:16 -0400
Date: Wed, 14 Sep 2016 11:58:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <Damien.LeMoal@hgst.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: [PATCH 2/3] block, dm-crypt, btrfs: Introduce bio_flags()
Message-ID: <20160914095814.GB21938@lst.de>
References: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com> <144083a3-2d0a-00ff-add2-a2f6f3690528@sandisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <144083a3-2d0a-00ff-add2-a2f6f3690528@sandisk.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 14, 2016 at 10:45:36AM +0200, Bart Van Assche wrote:
> Introduce the bio_flags() macro. Ensure that the second argument of
> bio_set_op_attrs() only contains flags and no operation. This patch
> does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Chris Mason <clm@fb.com> (maintainer:BTRFS FILE SYSTEM)
> Cc: Josef Bacik <jbacik@fb.com> (maintainer:BTRFS FILE SYSTEM)
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Damien Le Moal <damien.lemoal@hgst.com>
> ---
>  drivers/md/dm-crypt.c     | 2 +-
>  fs/btrfs/inode.c          | 5 +++--
>  include/linux/blk_types.h | 3 ++-
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 8742957..0448e7e 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1136,7 +1136,7 @@ static void clone_init(struct dm_crypt_io *io, struct bio *clone)
>  	clone->bi_private = io;
>  	clone->bi_end_io  = crypt_endio;
>  	clone->bi_bdev    = cc->dev->bdev;
> -	bio_set_op_attrs(clone, bio_op(io->base_bio), io->base_bio->bi_opf);
> +	bio_set_op_attrs(clone, bio_op(io->base_bio), bio_flags(io->base_bio));

Given that bio_set_op_attrs calls bio_flags internall do we need
the call here as well?

The other option might be to check that we only get flags inside the
bio_flags space and let the caller sort it out, which sounds useful
to me.
