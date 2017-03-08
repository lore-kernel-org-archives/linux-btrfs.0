Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:36983 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbdCHQRH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Mar 2017 11:17:07 -0500
Received: by mail-it0-f46.google.com with SMTP id g138so40735598itb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Mar 2017 08:17:06 -0800 (PST)
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, Sagi Grimberg <sagi@grimberg.me>,
        jack@suse.com
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-6-rgoldwyn@suse.de>
 <0d1ba678-69c0-16ce-6c3e-475cd8da203c@grimberg.me>
 <44cc02b1-f7ac-cbc6-6f09-726ae8225358@suse.de>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a661cdc7-4859-4a39-3037-8036cc8c4712@kernel.dk>
Date: Wed, 8 Mar 2017 09:17:04 -0700
MIME-Version: 1.0
In-Reply-To: <44cc02b1-f7ac-cbc6-6f09-726ae8225358@suse.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/08/2017 08:00 AM, Goldwyn Rodrigues wrote:
> 
> 
> On 03/08/2017 01:03 AM, Sagi Grimberg wrote:
>>
>>> -        if (likely(blk_queue_enter(q, false) == 0)) {
>>> +        if (likely(blk_queue_enter(q, bio_flagged(bio, BIO_NOWAIT))
>>> == 0)) {
>>>              ret = q->make_request_fn(q, bio);
>>
>> I think that for ->make_request to not block we'd need to set
>> BLK_MQ_REQ_NOWAIT in blk_mq_alloc_data to avoid blocking on a tag
>> allocation.
>>
>> Something like the untested addition below:
> 
> I did that in the first series, but there are too many reasons to block
> in blk-mq [1]. I dropped blk-mq work in v2.

That's complete nonsense, there are no more places in blk-mq that will
block that in the legacy path. Most of the examples from your URL:

> [1] https://patchwork.kernel.org/patch/9571051/

are not blk-mq, but writeback throttling, and drivers that explicitly
hook into ->make_request_fn.

As others have mentioned, it's a total non-starter to focus on the
deprecated IO path and just ignore the new one. Back to the drawing
board.

-- 
Jens Axboe

