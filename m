Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:48788 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756812AbeAHT54 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 14:57:56 -0500
Subject: Re: [PATCH 2/8] blk-mq: protect completion path with RCU
To: Tejun Heo <tj@kernel.org>, jack@suse.cz, axboe@kernel.dk, clm@fb.com,
        jbacik@fb.com
Cc: kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, peterz@infradead.org,
        jianchao.w.wang@oracle.com, Bart.VanAssche@wdc.com,
        linux-block@vger.kernel.org
References: <20180108191542.379478-1-tj@kernel.org>
 <20180108191542.379478-3-tj@kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <774b9fa0-c1f9-f528-09c3-2f3bd67e0fd5@applied-asynchrony.com>
Date: Mon, 8 Jan 2018 20:57:53 +0100
MIME-Version: 1.0
In-Reply-To: <20180108191542.379478-3-tj@kernel.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/08/18 20:15, Tejun Heo wrote:
> Currently, blk-mq protects only the issue path with RCU.  This patch
> puts the completion path under the same RCU protection.  This will be
> used to synchronize issue/completion against timeout by later patches,
> which will also add the comments.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  block/blk-mq.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index ddc9261..6741c3e 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -584,11 +584,16 @@ static void hctx_lock(struct blk_mq_hw_ctx *hctx, int *srcu_idx)
>  void blk_mq_complete_request(struct request *rq)
>  {
>  	struct request_queue *q = rq->q;
> +	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, rq->mq_ctx->cpu);
> +	int srcu_idx;
>  
>  	if (unlikely(blk_should_fake_timeout(q)))
>  		return;
> +
> +	hctx_lock(hctx, &srcu_idx);
>  	if (!blk_mark_rq_complete(rq))
>  		__blk_mq_complete_request(rq);
> +	hctx_unlock(hctx, srcu_idx);
>  }
>  EXPORT_SYMBOL(blk_mq_complete_request);

So I've had v3 running fine with 4.14++ and when I first tried Jens'
additional helpers on top, I got a bunch of warnings which I didn't
investigate further at the time. Now they are back since the helpers
moved into patch #1 and #2 correctly says:

..
block/blk-mq.c: In function ‘blk_mq_complete_request’:
./include/linux/srcu.h:175:2: warning: ‘srcu_idx’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  __srcu_read_unlock(sp, idx);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~
block/blk-mq.c:587:6: note: ‘srcu_idx’ was declared here
  int srcu_idx;
      ^~~~~~~~
..etc.

This is with gcc 7.2.0.

I understand that this is a somewhat-false positive since the lock always
precedes the unlock & writes to the value, but can we properly initialize
or annotate this?

cheers
Holger
