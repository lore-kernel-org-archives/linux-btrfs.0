Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:57186 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753691AbdIRN4a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 09:56:30 -0400
Subject: Re: [PATCH] Btrfs: fix unexpected result when dio reading corrupted
 blocks
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20170915210651.8385-1-bo.li.liu@oracle.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <1dc28ce4-219f-1d2b-10ae-423a8dc6bb2a@applied-asynchrony.com>
Date: Mon, 18 Sep 2017 15:49:34 +0200
MIME-Version: 1.0
In-Reply-To: <20170915210651.8385-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello, quick question for backporting..

On 09/15/17 23:06, Liu Bo wrote:
> commit 4246a0b63bd8 ("block: add a bi_error field to struct bio")
> changed the logic of how dio read endio reports errors.
[snip]

I've tried to merge this into my 4.9.x++ tree but have a question since
the DIO APIs changed recently and itt's hard to tell what is a bug
and what is a feature.. :-/

> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8267,11 +8267,8 @@ static void btrfs_endio_direct_read(struct bio *bio)
>  	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
>  	blk_status_t err = bio->bi_status;
>  
> -	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED) {
> +	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED)
>  		err = btrfs_subio_endio_read(inode, io_bio, err);
> -		if (!err)
> -			bio->bi_status = 0;
> -	}
>  
>  	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
>  		      dip->logical_offset + dip->bytes - 1);

This hunk is fairly easy, just reverse bi_status to bi->error.
However..

> @@ -8279,7 +8276,7 @@ static void btrfs_endio_direct_read(struct bio *bio)
>  
>  	kfree(dip);
>  
> -	dio_bio->bi_status = bio->bi_status;
> +	dio_bio->bi_status = err;
>  	dio_end_io(dio_bio);
        ^^^^^^^^^^^^^^^^^^^

Same here, except that the call to dio_end_io used to take a second parameter
(the error code, which has been moved into bi_status in 4.10+) and looked
like this:

    dio_end_io(dio_bio, bio->bi_error);

Given that "bio->bi_error" should have been "err" instead, I think err should
also be passed to dio_end_io(), so that the whole hunk would look like:

..
-    dio_bio->bi_error = bio->bi_error;
-    dio_end_io(dio_bio, bio->bi_error);
+    dio_bio->bi_error = err;
+    dio_end_io(dio_bio, err);
..

Would this be correct or did I misunderstand some subtle aspect about the
DIO error handling?

Thanks :)

Holger
