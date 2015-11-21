Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21243 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759664AbbKUD3M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 22:29:12 -0500
Subject: Re: [PATCH] Btrfs: fix a bug of sleeping in atomic context
To: <bo.li.liu@oracle.com>
References: <1447984177-26795-1-git-send-email-bo.li.liu@oracle.com>
 <20151120131358.GC9887@ret.masoncoding.com> <564F9103.7060301@fb.com>
 <20151120230829.GB8096@localhost.localdomain> <564FD665.90603@fb.com>
 <20151121031421.GC8096@localhost.localdomain>
CC: Chris Mason <clm@fb.com>, <linux-btrfs@vger.kernel.org>
From: Jens Axboe <axboe@fb.com>
Message-ID: <564FE502.2050808@fb.com>
Date: Fri, 20 Nov 2015 20:29:06 -0700
MIME-Version: 1.0
In-Reply-To: <20151121031421.GC8096@localhost.localdomain>
Content-Type: multipart/mixed;
	boundary="------------020305060909060106010606"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------020305060909060106010606
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/2015 08:14 PM, Liu Bo wrote:
> On Fri, Nov 20, 2015 at 07:26:45PM -0700, Jens Axboe wrote:
>> On 11/20/2015 04:08 PM, Liu Bo wrote:
>>> On Fri, Nov 20, 2015 at 02:30:43PM -0700, Jens Axboe wrote:
>>>> On 11/20/2015 06:13 AM, Chris Mason wrote:
>>>>> On Thu, Nov 19, 2015 at 05:49:37PM -0800, Liu Bo wrote:
>>>>>> while xfstesting, this bug[1] is spotted by both btrfs/061 and btrfs/063,
>>>>>> so those sub-stripe writes are gatherred into plug callback list and
>>>>>> hopefully we can have a full stripe writes.
>>>>>>
>>>>>> However, while processing these plugged callbacks, it's within an atomic
>>>>>> context which is provided by blk_sq_make_request() because of a get_cpu()
>>>>>> in blk_mq_get_ctx().
>>>>>>
>>>>>> This changes to always use btrfs_rmw_helper to complete the pending writes.
>>>>>>
>>>>>
>>>>> Thanks Liu, but MD raid has the same troubles, we're not atomic in our unplugs.
>>>>>
>>>>> Jens?
>>>>
>>>> Yeah, blk-mq does have preemption disabled when it flushes, for the single
>>>> queue setup. That's a bug. Attached is an untested patch that should fix it,
>>>> can you try it?
>>>>
>>>
>>> Although it runs into a warning one time of 50 tries, that was not atomic warning but another racy issue.
>>>
>>> WARNING: CPU: 2 PID: 8531 at fs/btrfs/ctree.c:1162 __btrfs_cow_block+0x431/0x610 [btrfs]()
>>>
>>> So overall the patch is good.
>>>
>>>> I'll rework this to be a proper patch, not convinced we want to add the new
>>>> request before flush, that might destroy merging opportunities. I'll unify
>>>> the mq/sq parts.
>>>
>>> That's true, xfstests didn't notice any performance difference but that cannot prove anything.
>>>
>>> I'll test the new patch when you send it out.
>>
>> Try this one, that should retain the plug issue characteristics we care
>> about as well.
>
> The test does not complain any more, thank for the quick patch.
>
> Tested-by: Liu Bo <bo.li.liu@oracle.com>

Can I talk you into trying this one? It's simpler, does the same thing. 
We don't need to overcomplicate it, it's fine not having preempt 
disabled for adding to the list.

-- 
Jens Axboe


--------------020305060909060106010606
Content-Type: text/x-patch; name="blk-mq-preempt-plug-flush-v3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="blk-mq-preempt-plug-flush-v3.patch"

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3ae09de62f19..6d6f8feb48c0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1291,15 +1291,16 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_bio_to_request(rq, bio);
 
 		/*
-		 * we do limited pluging. If bio can be merged, do merge.
+		 * We do limited pluging. If the bio can be merged, do that.
 		 * Otherwise the existing request in the plug list will be
 		 * issued. So the plug list will have one request at most
 		 */
 		if (plug) {
 			/*
 			 * The plug list might get flushed before this. If that
-			 * happens, same_queue_rq is invalid and plug list is empty
-			 **/
+			 * happens, same_queue_rq is invalid and plug list is
+			 * empty
+			 */
 			if (same_queue_rq && !list_empty(&plug->mq_list)) {
 				old_rq = same_queue_rq;
 				list_del_init(&old_rq->queuelist);
@@ -1380,12 +1381,15 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_bio_to_request(rq, bio);
 		if (!request_count)
 			trace_block_plug(q);
-		else if (request_count >= BLK_MAX_REQUEST_COUNT) {
+
+		blk_mq_put_ctx(data.ctx);
+
+		if (request_count >= BLK_MAX_REQUEST_COUNT) {
 			blk_flush_plug_list(plug, false);
 			trace_block_plug(q);
 		}
+
 		list_add_tail(&rq->queuelist, &plug->mq_list);
-		blk_mq_put_ctx(data.ctx);
 		return cookie;
 	}
 

--------------020305060909060106010606--
