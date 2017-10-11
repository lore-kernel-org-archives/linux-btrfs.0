Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42460 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755556AbdJKHyP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 03:54:15 -0400
Date: Wed, 11 Oct 2017 09:54:13 +0200
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: jack@suse.cz, axboe@kernel.dk, clm@fb.com, jbacik@fb.com,
        kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] buffer_head: separate out create_bh_bio() from
 submit_bh_wbc()
Message-ID: <20171011075413.GI3667@quack2.suse.cz>
References: <20171010155441.753966-1-tj@kernel.org>
 <20171010155441.753966-4-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171010155441.753966-4-tj@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 10-10-17 08:54:39, Tejun Heo wrote:
> submit_bh_wbc() creates a bio matching the specific @bh and submits it
> at the end.  This patch separates out the bio creation part to its own
> function, create_bh_bio(), and reimplement submit_bh[_wbc]() using the
> function.
> 
> As bio can now be manipulated before submitted, we can move out @wbc
> handling into submit_bh_wbc() and similarly this will make adding more
> submit_bh variants straight-forward.
> 
> This patch is pure refactoring and doesn't cause any functional
> changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Suggested-by: Jan Kara <jack@suse.cz>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/buffer.c | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 170df85..b4b2169 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3086,8 +3086,8 @@ void guard_bio_eod(int op, struct bio *bio)
>  	}
>  }
>  
> -static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
> -			 enum rw_hint write_hint, struct writeback_control *wbc)
> +struct bio *create_bh_bio(int op, int op_flags, struct buffer_head *bh,
> +                          enum rw_hint write_hint)
>  {
>  	struct bio *bio;
>  
> @@ -3109,11 +3109,6 @@ static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
>  	 */
>  	bio = bio_alloc(GFP_NOIO, 1);
>  
> -	if (wbc) {
> -		wbc_init_bio(wbc, bio);
> -		wbc_account_io(wbc, bh->b_page, bh->b_size);
> -	}
> -
>  	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
>  	bio_set_dev(bio, bh->b_bdev);
>  	bio->bi_write_hint = write_hint;
> @@ -3133,13 +3128,32 @@ static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
>  		op_flags |= REQ_PRIO;
>  	bio_set_op_attrs(bio, op, op_flags);
>  
> +	return bio;
> +}
> +
> +static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
> +			 enum rw_hint write_hint, struct writeback_control *wbc)
> +{
> +	struct bio *bio;
> +
> +	bio = create_bh_bio(op, op_flags, bh, write_hint);
> +
> +	if (wbc) {
> +		wbc_init_bio(wbc, bio);
> +		wbc_account_io(wbc, bh->b_page, bh->b_size);
> +	}
> +
>  	submit_bio(bio);
>  	return 0;
>  }
>  
>  int submit_bh(int op, int op_flags, struct buffer_head *bh)
>  {
> -	return submit_bh_wbc(op, op_flags, bh, 0, NULL);
> +	struct bio *bio;
> +
> +	bio = create_bh_bio(op, op_flags, bh, 0);
> +	submit_bio(bio);
> +	return 0;
>  }
>  EXPORT_SYMBOL(submit_bh);
>  
> -- 
> 2.9.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
