Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33342 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbeIFLU7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2018 07:20:59 -0400
Received: by mail-it0-f66.google.com with SMTP id j198-v6so18939857ita.0
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Sep 2018 23:47:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANQeFDBck+Yaqcv=ETS=YTmcWOZ5UAPDdMYUoV2Fb_WDKw2MNg@mail.gmail.com>
References: <1536110090-100798-1-git-send-email-bo.liu@linux.alibaba.com> <CANQeFDBck+Yaqcv=ETS=YTmcWOZ5UAPDdMYUoV2Fb_WDKw2MNg@mail.gmail.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Wed, 5 Sep 2018 23:47:02 -0700
Message-ID: <CANQeFDArmtTq567jR8zr4D7jTfzaPHfcrobpANt9v3YjEc7gQA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: remove redundant btrfs_trans_release_metadata"
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 5, 2018 at 10:45 PM, Liu Bo <obuil.liubo@gmail.com> wrote:
> Somehow this ends up with crash in btrfs/124, I'm trying to figure out
> what went wrong.
>

It revealed the problem addressed in Josef's patch[1], so with it,
this patch works just fine.

[1] btrfs: make sure we create all new bgs

thanks,
liubo

>
> On Tue, Sep 4, 2018 at 6:14 PM, Liu Bo <bo.liu@linux.alibaba.com> wrote:
>> __btrfs_end_transaction() has done the metadata release twice,
>> probably because it used to process delayed refs in between, but now
>> that we don't process delayed refs any more, the 2nd release is always
>> a noop.
>>
>> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
>> ---
>>  fs/btrfs/transaction.c | 6 ------
>>  1 file changed, 6 deletions(-)
>>
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index bb1b9f526e98..94b036a74d11 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -826,12 +826,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>>                 return 0;
>>         }
>>
>> -       btrfs_trans_release_metadata(trans);
>> -       trans->block_rsv = NULL;
>> -
>> -       if (!list_empty(&trans->new_bgs))
>> -               btrfs_create_pending_block_groups(trans);
>> -
>>         trans->delayed_ref_updates = 0;
>>         if (!trans->sync) {
>>                 must_run_delayed_refs =
>> --
>> 1.8.3.1
>>
