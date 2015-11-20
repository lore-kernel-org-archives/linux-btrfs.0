Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43835 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbbKTXJK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 18:09:10 -0500
Date: Fri, 20 Nov 2015 15:08:30 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Jens Axboe <axboe@fb.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix a bug of sleeping in atomic context
Message-ID: <20151120230829.GB8096@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1447984177-26795-1-git-send-email-bo.li.liu@oracle.com>
 <20151120131358.GC9887@ret.masoncoding.com>
 <564F9103.7060301@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <564F9103.7060301@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 20, 2015 at 02:30:43PM -0700, Jens Axboe wrote:
> On 11/20/2015 06:13 AM, Chris Mason wrote:
> >On Thu, Nov 19, 2015 at 05:49:37PM -0800, Liu Bo wrote:
> >>while xfstesting, this bug[1] is spotted by both btrfs/061 and btrfs/063,
> >>so those sub-stripe writes are gatherred into plug callback list and
> >>hopefully we can have a full stripe writes.
> >>
> >>However, while processing these plugged callbacks, it's within an atomic
> >>context which is provided by blk_sq_make_request() because of a get_cpu()
> >>in blk_mq_get_ctx().
> >>
> >>This changes to always use btrfs_rmw_helper to complete the pending writes.
> >>
> >
> >Thanks Liu, but MD raid has the same troubles, we're not atomic in our unplugs.
> >
> >Jens?
> 
> Yeah, blk-mq does have preemption disabled when it flushes, for the single
> queue setup. That's a bug. Attached is an untested patch that should fix it,
> can you try it?
> 

Although it runs into a warning one time of 50 tries, that was not atomic warning but another racy issue.

WARNING: CPU: 2 PID: 8531 at fs/btrfs/ctree.c:1162 __btrfs_cow_block+0x431/0x610 [btrfs]()

So overall the patch is good.

> I'll rework this to be a proper patch, not convinced we want to add the new
> request before flush, that might destroy merging opportunities. I'll unify
> the mq/sq parts.

That's true, xfstests didn't notice any performance difference but that cannot prove anything.

I'll test the new patch when you send it out.

Thanks,

-liubo

> 
> -- 
> Jens Axboe
> 

> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 3ae09de62f19..0325dcec8c74 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1380,12 +1391,15 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
>  		blk_mq_bio_to_request(rq, bio);
>  		if (!request_count)
>  			trace_block_plug(q);
> -		else if (request_count >= BLK_MAX_REQUEST_COUNT) {
> +
> +		list_add_tail(&rq->queuelist, &plug->mq_list);
> +		blk_mq_put_ctx(data.ctx);
> +
> +		if (request_count + 1 >= BLK_MAX_REQUEST_COUNT) {
>  			blk_flush_plug_list(plug, false);
>  			trace_block_plug(q);
>  		}
> -		list_add_tail(&rq->queuelist, &plug->mq_list);
> -		blk_mq_put_ctx(data.ctx);
> +
>  		return cookie;
>  	}
>  
> 

