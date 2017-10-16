Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752575AbdJPNpw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 09:45:52 -0400
Date: Mon, 16 Oct 2017 15:44:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use BLK_STS defines where needed
Message-ID: <20171016134405.GL3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171014003556.8038-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171014003556.8038-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 14, 2017 at 08:35:56AM +0800, Anand Jain wrote:
> At few places we could use BLK_STS_OK and BLK_STS_NOSUPP.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/compression.c | 3 ++-
>  fs/btrfs/inode.c       | 4 ++--
>  fs/btrfs/volumes.c     | 2 +-
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index b51d23f5cafa..43d4b51556ec 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -239,7 +239,8 @@ static void end_compressed_bio_write(struct bio *bio)
>  					 cb->start,
>  					 cb->start + cb->len - 1,
>  					 NULL,
> -					 bio->bi_status ? 0 : 1);
> +					 bio->bi_status ?
> +					 BLK_STS_OK : BLK_STS_NOTSUPP);
>  	cb->compressed_pages[0]->mapping = NULL;
>  
>  	end_compressed_writeback(inode, cb);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 128f3e58634f..9aa03c89ad86 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8360,7 +8360,7 @@ static void btrfs_endio_direct_read(struct bio *bio)
>  	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED) {
>  		err = btrfs_subio_endio_read(inode, io_bio, err);
>  		if (!err)
> -			bio->bi_status = 0;
> +			bio->bi_status = BLK_STS_OK;

This hunk does not apply to current devel queue (ie. something close to
for-next), dropped and applied.
