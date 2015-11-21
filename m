Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42117 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759577AbbKUDPF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 22:15:05 -0500
Date: Fri, 20 Nov 2015 19:14:22 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Jens Axboe <axboe@fb.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix a bug of sleeping in atomic context
Message-ID: <20151121031421.GC8096@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1447984177-26795-1-git-send-email-bo.li.liu@oracle.com>
 <20151120131358.GC9887@ret.masoncoding.com>
 <564F9103.7060301@fb.com>
 <20151120230829.GB8096@localhost.localdomain>
 <564FD665.90603@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <564FD665.90603@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 20, 2015 at 07:26:45PM -0700, Jens Axboe wrote:
> On 11/20/2015 04:08 PM, Liu Bo wrote:
> >On Fri, Nov 20, 2015 at 02:30:43PM -0700, Jens Axboe wrote:
> >>On 11/20/2015 06:13 AM, Chris Mason wrote:
> >>>On Thu, Nov 19, 2015 at 05:49:37PM -0800, Liu Bo wrote:
> >>>>while xfstesting, this bug[1] is spotted by both btrfs/061 and btrfs/063,
> >>>>so those sub-stripe writes are gatherred into plug callback list and
> >>>>hopefully we can have a full stripe writes.
> >>>>
> >>>>However, while processing these plugged callbacks, it's within an atomic
> >>>>context which is provided by blk_sq_make_request() because of a get_cpu()
> >>>>in blk_mq_get_ctx().
> >>>>
> >>>>This changes to always use btrfs_rmw_helper to complete the pending writes.
> >>>>
> >>>
> >>>Thanks Liu, but MD raid has the same troubles, we're not atomic in our unplugs.
> >>>
> >>>Jens?
> >>
> >>Yeah, blk-mq does have preemption disabled when it flushes, for the single
> >>queue setup. That's a bug. Attached is an untested patch that should fix it,
> >>can you try it?
> >>
> >
> >Although it runs into a warning one time of 50 tries, that was not atomic warning but another racy issue.
> >
> >WARNING: CPU: 2 PID: 8531 at fs/btrfs/ctree.c:1162 __btrfs_cow_block+0x431/0x610 [btrfs]()
> >
> >So overall the patch is good.
> >
> >>I'll rework this to be a proper patch, not convinced we want to add the new
> >>request before flush, that might destroy merging opportunities. I'll unify
> >>the mq/sq parts.
> >
> >That's true, xfstests didn't notice any performance difference but that cannot prove anything.
> >
> >I'll test the new patch when you send it out.
> 
> Try this one, that should retain the plug issue characteristics we care
> about as well.

The test does not complain any more, thank for the quick patch.

Tested-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> -- 
> Jens Axboe
> 

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 5131993b23a1..4237facaafa5 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -3192,7 +3192,7 @@ static void queue_unplugged(struct request_queue *q, unsigned int depth,
>  	spin_unlock(q->queue_lock);
>  }
>  
> -static void flush_plug_callbacks(struct blk_plug *plug, bool from_schedule)
> +void flush_plug_callbacks(struct blk_plug *plug, bool from_schedule)
>  {
>  	LIST_HEAD(callbacks);
>  
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 3ae09de62f19..e92f52462222 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1065,7 +1065,8 @@ static int plug_ctx_cmp(void *priv, struct list_head *a, struct list_head *b)
>  		  blk_rq_pos(rqa) < blk_rq_pos(rqb)));
>  }
>  
> -void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
> +static void __blk_mq_flush_plug_list(struct blk_plug *plug, bool from_sched,
> +				     bool skip_last)
>  {
>  	struct blk_mq_ctx *this_ctx;
>  	struct request_queue *this_q;
> @@ -1084,13 +1085,15 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
>  
>  	while (!list_empty(&list)) {
>  		rq = list_entry_rq(list.next);
> +		if (skip_last && list_is_last(&rq->queuelist, &list))
> +			break;
>  		list_del_init(&rq->queuelist);
>  		BUG_ON(!rq->q);
>  		if (rq->mq_ctx != this_ctx) {
>  			if (this_ctx) {
>  				blk_mq_insert_requests(this_q, this_ctx,
>  							&ctx_list, depth,
> -							from_schedule);
> +							from_sched);
>  			}
>  
>  			this_ctx = rq->mq_ctx;
> @@ -1108,8 +1111,14 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
>  	 */
>  	if (this_ctx) {
>  		blk_mq_insert_requests(this_q, this_ctx, &ctx_list, depth,
> -				       from_schedule);
> +				       from_sched);
>  	}
> +
> +}
> +
> +void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
> +{
> +	__blk_mq_flush_plug_list(plug, from_schedule, false);
>  }
>  
>  static void blk_mq_bio_to_request(struct request *rq, struct bio *bio)
> @@ -1291,15 +1300,16 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
>  		blk_mq_bio_to_request(rq, bio);
>  
>  		/*
> -		 * we do limited pluging. If bio can be merged, do merge.
> +		 * We do limited pluging. If the bio can be merged, do that.
>  		 * Otherwise the existing request in the plug list will be
>  		 * issued. So the plug list will have one request at most
>  		 */
>  		if (plug) {
>  			/*
>  			 * The plug list might get flushed before this. If that
> -			 * happens, same_queue_rq is invalid and plug list is empty
> -			 **/
> +			 * happens, same_queue_rq is invalid and plug list is
> +			 * empty
> +			 */
>  			if (same_queue_rq && !list_empty(&plug->mq_list)) {
>  				old_rq = same_queue_rq;
>  				list_del_init(&old_rq->queuelist);
> @@ -1380,12 +1390,24 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
>  		blk_mq_bio_to_request(rq, bio);
>  		if (!request_count)
>  			trace_block_plug(q);
> -		else if (request_count >= BLK_MAX_REQUEST_COUNT) {
> -			blk_flush_plug_list(plug, false);
> -			trace_block_plug(q);
> -		}
> +
>  		list_add_tail(&rq->queuelist, &plug->mq_list);
>  		blk_mq_put_ctx(data.ctx);
> +
> +		/*
> +		 * We unplug manually here, flushing both callbacks and
> +		 * potentially queued up IO - except the one we just added.
> +		 * That one did not merge with existing requests, so could
> +		 * be a candidate for new incoming merges. Tell
> +		 * __blk_mq_flush_plug_list() to skip issuing the last
> +		 * request in the list, which is the 'rq' from above.
> +		 */
> +		if (request_count >= BLK_MAX_REQUEST_COUNT) {
> +			flush_plug_callbacks(plug, false);
> +			__blk_mq_flush_plug_list(plug, false, true);
> +			trace_block_plug(q);
> +		}
> +
>  		return cookie;
>  	}
>  
> diff --git a/block/blk.h b/block/blk.h
> index c43926d3d74d..3e0ae1562b85 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -107,6 +107,7 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
>  			    unsigned int *request_count,
>  			    struct request **same_queue_rq);
>  unsigned int blk_plug_queued_count(struct request_queue *q);
> +void flush_plug_callbacks(struct blk_plug *plug, bool from_schedule);
>  
>  void blk_account_io_start(struct request *req, bool new_io);
>  void blk_account_io_completion(struct request *req, unsigned int bytes);

