Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55575 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbcEBOuE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 10:50:04 -0400
Date: Mon, 2 May 2016 07:50:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-btrfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        "open list:FILESYSTEMS (VFS and infrastructure)"
	<linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] fs: direct-io: call .bi_end_io via bio_endio()
Message-ID: <20160502145002.GB20589@infradead.org>
References: <1461805789-3632-1-git-send-email-ming.lei@canonical.com>
 <1461805789-3632-2-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461805789-3632-2-git-send-email-ming.lei@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 28, 2016 at 09:09:48AM +0800, Ming Lei wrote:
> bio_endio() is the graceful way to complete one bio.



> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  fs/direct-io.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index a8dd60a..0a35e51 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -350,15 +350,10 @@ static void dio_bio_end_io(struct bio *bio)
>   */
>  void dio_end_io(struct bio *bio, int error)
>  {
> -	struct dio *dio = bio->bi_private;
> -
>  	if (!bio->bi_error)
>  		bio->bi_error = error;
>  
> -	if (dio->is_async)
> -		dio_bio_end_aio(bio);
> -	else
> -		dio_bio_end_io(bio);
> +	bio_endio(bio);
>  }
>  EXPORT_SYMBOL_GPL(dio_end_io);

dio_end_io is only used by btrfs.  So instead of this and the previous
patch you should just open code the error assignment and call to
bio_endio in btrfs.
