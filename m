From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] direct-io: add a hook for the fs to provide its
	own submit_bio function V3
Date: Fri, 21 May 2010 11:20:06 -0400
Message-ID: <20100521152006.GA16049@infradead.org>
References: <1274300694-8976-1-git-send-email-josef@redhat.com> <1274300694-8976-2-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	akpm@linux-foundation.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1274300694-8976-2-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 19, 2010 at 04:24:50PM -0400, Josef Bacik wrote:
> V1->V2:
> -Changed dio_end_io to EXPORT_SYMBOL_GPL
> -Removed the own_submit blockdev dio helper
> -Removed the boundary change

patch version changelogs go below the --- header so they don't go into
the commit message.  Also makes reading the patch description a lot
easier.  Also applies to all the other patches in the series.

> +void dio_end_io(struct bio *bio, int error)
> +{
> +	struct dio *dio = bio->bi_private;
> +
> +	if (dio->is_async)
> +		dio_bio_end_aio(bio, error);
> +	else
> +		dio_bio_end_io(bio, error);
> +}
> +EXPORT_SYMBOL_GPL(dio_end_io);

This one needs a good kerneldoc comment.

> -	submit_bio(dio->rw, bio);
> +	if (!dio->submit_io)
> +		submit_bio(dio->rw, bio);
> +	else
> +		dio->submit_io(dio->rw, bio, dio->inode,
> +			       dio->logical_offset_in_bio);

'd reverse the if condition - no need for an inversion here.

	if (dio->submit_io) {
		dio->submit_io(dio->rw, bio, dio->inode,
			       dio->logical_offset_in_bio);
	} else {
		submit_bio(dio->rw, bio);
	}
