Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22480 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758669AbbKTVat (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 16:30:49 -0500
Subject: Re: [PATCH] Btrfs: fix a bug of sleeping in atomic context
To: Chris Mason <clm@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        <linux-btrfs@vger.kernel.org>
References: <1447984177-26795-1-git-send-email-bo.li.liu@oracle.com>
 <20151120131358.GC9887@ret.masoncoding.com>
From: Jens Axboe <axboe@fb.com>
Message-ID: <564F9103.7060301@fb.com>
Date: Fri, 20 Nov 2015 14:30:43 -0700
MIME-Version: 1.0
In-Reply-To: <20151120131358.GC9887@ret.masoncoding.com>
Content-Type: multipart/mixed;
	boundary="------------000609030009010007000401"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------000609030009010007000401
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/2015 06:13 AM, Chris Mason wrote:
> On Thu, Nov 19, 2015 at 05:49:37PM -0800, Liu Bo wrote:
>> while xfstesting, this bug[1] is spotted by both btrfs/061 and btrfs/063,
>> so those sub-stripe writes are gatherred into plug callback list and
>> hopefully we can have a full stripe writes.
>>
>> However, while processing these plugged callbacks, it's within an atomic
>> context which is provided by blk_sq_make_request() because of a get_cpu()
>> in blk_mq_get_ctx().
>>
>> This changes to always use btrfs_rmw_helper to complete the pending writes.
>>
>
> Thanks Liu, but MD raid has the same troubles, we're not atomic in our unplugs.
>
> Jens?

Yeah, blk-mq does have preemption disabled when it flushes, for the 
single queue setup. That's a bug. Attached is an untested patch that 
should fix it, can you try it?

I'll rework this to be a proper patch, not convinced we want to add the 
new request before flush, that might destroy merging opportunities. I'll 
unify the mq/sq parts.

-- 
Jens Axboe


--------------000609030009010007000401
Content-Type: text/x-patch; name="blk-mq-preempt-plug-flush.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="blk-mq-preempt-plug-flush.patch"

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3ae09de62f19..0325dcec8c74 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1380,12 +1391,15 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_bio_to_request(rq, bio);
 		if (!request_count)
 			trace_block_plug(q);
-		else if (request_count >= BLK_MAX_REQUEST_COUNT) {
+
+		list_add_tail(&rq->queuelist, &plug->mq_list);
+		blk_mq_put_ctx(data.ctx);
+
+		if (request_count + 1 >= BLK_MAX_REQUEST_COUNT) {
 			blk_flush_plug_list(plug, false);
 			trace_block_plug(q);
 		}
-		list_add_tail(&rq->queuelist, &plug->mq_list);
-		blk_mq_put_ctx(data.ctx);
+
 		return cookie;
 	}
 


--------------000609030009010007000401--
