Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbbFJCvE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jun 2015 22:51:04 -0400
Date: Wed, 10 Jun 2015 12:50:54 +1000
From: Neil Brown <neilb@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] block: add a bi_error field to struct bio
Message-ID: <20150610125054.3da2abcc@home.neil.brown.name>
In-Reply-To: <1433338959-24808-2-git-send-email-hch@lst.de>
References: <1433338959-24808-1-git-send-email-hch@lst.de>
	<1433338959-24808-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed,  3 Jun 2015 15:42:39 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Currently we have two different ways to signal an I/O error on a BIO:
> 
>  (1) by clearing the BIO_UPTODATE flag
>  (2) by returning a Linux errno value to the bi_end_io callback
> 
> The first one has the drawback of only communicating a single possible
> error (-EIO), and the second one has the drawback of not beeing persistent
> when bios are queued up, and are not passed along from child to parent
> bio in the ever more popular chaining scenario.  Having both mechanisms
> available has the additional drawback of utterly confusing driver authors
> and introducing bugs where various I/O submitters only deal with one of
> them, and the others have to add boilerplate code to deal with both kinds
> of error returns.
> 
> So add a new bi_error field to store an errno value directly in struct
> bio and remove the existing mechanisms to clean all this up.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I really like this clean up.
It is unfortunate that the patch is so big, but I guess it has to be.

It mostly looks good, but review is hard and testing is harder :-(

I found:

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f80f1af..1bad16f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
....
> @@ -1800,7 +1799,7 @@ static void end_sync_write(struct bio *bio, int error)
>  			reschedule_retry(r1_bio);
>  		else {
>  			put_buf(r1_bio);
> -			md_done_sync(mddev, s, uptodate);
> +			md_done_sync(mddev, s, !bio->bi_error);
>  		}
>  	}
>  }

This introduces a use-after-free.  put_buf(r1_bio) can  result in bio_put on
'bio'.
It is safe to move the put_buf call after the md_done_sync(), but it is
probably best to leave the 'update' variable as it.  i.e. Just change:

-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	int uptodate = !bio->bi_error;


I can't see any other problems with the md changes.

Reviewed-by: NeilBrown <neilb@suse.de> (md/raid parts)

Thanks,
NeilBrown
