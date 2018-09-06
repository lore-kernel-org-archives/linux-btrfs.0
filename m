Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38030 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727126AbeIFX1M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 19:27:12 -0400
Subject: Re: [PATCH] Btrfs: remove redundant btrfs_trans_release_metadata"
To: Liu Bo <obuil.liubo@gmail.com>, Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
References: <1536110090-100798-1-git-send-email-bo.liu@linux.alibaba.com>
 <CANQeFDBck+Yaqcv=ETS=YTmcWOZ5UAPDdMYUoV2Fb_WDKw2MNg@mail.gmail.com>
 <CANQeFDArmtTq567jR8zr4D7jTfzaPHfcrobpANt9v3YjEc7gQA@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e86c5784-e63e-f1b6-f019-6fcab7dda4c8@suse.com>
Date: Thu, 6 Sep 2018 21:50:25 +0300
MIME-Version: 1.0
In-Reply-To: <CANQeFDArmtTq567jR8zr4D7jTfzaPHfcrobpANt9v3YjEc7gQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  6.09.2018 09:47, Liu Bo wrote:
> On Wed, Sep 5, 2018 at 10:45 PM, Liu Bo <obuil.liubo@gmail.com> wrote:
>> Somehow this ends up with crash in btrfs/124, I'm trying to figure out
>> what went wrong.
>>
> 
> It revealed the problem addressed in Josef's patch[1], so with it,
> this patch works just fine.

What exactly was the crash ?

> 
> [1] btrfs: make sure we create all new bgs
> 
> thanks,
> liubo
> 
>>
>> On Tue, Sep 4, 2018 at 6:14 PM, Liu Bo <bo.liu@linux.alibaba.com> wrote:
>>> __btrfs_end_transaction() has done the metadata release twice,
>>> probably because it used to process delayed refs in between, but now
>>> that we don't process delayed refs any more, the 2nd release is always
>>> a noop.
>>>
>>> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
>>> ---
>>>  fs/btrfs/transaction.c | 6 ------
>>>  1 file changed, 6 deletions(-)
>>>
>>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>>> index bb1b9f526e98..94b036a74d11 100644
>>> --- a/fs/btrfs/transaction.c
>>> +++ b/fs/btrfs/transaction.c
>>> @@ -826,12 +826,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>>>                 return 0;
>>>         }
>>>
>>> -       btrfs_trans_release_metadata(trans);
>>> -       trans->block_rsv = NULL;
>>> -
>>> -       if (!list_empty(&trans->new_bgs))
>>> -               btrfs_create_pending_block_groups(trans);
>>> -
>>>         trans->delayed_ref_updates = 0;
>>>         if (!trans->sync) {
>>>                 must_run_delayed_refs =
>>> --
>>> 1.8.3.1
>>>
> 
