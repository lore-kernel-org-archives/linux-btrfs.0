Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:44255 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727636AbeIGXch (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 19:32:37 -0400
Received: by mail-io1-f65.google.com with SMTP id 75-v6so2308303iou.11
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 11:50:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180907182119.GC29245@vader>
References: <1536343190-400-1-git-send-email-bo.liu@linux.alibaba.com> <20180907182119.GC29245@vader>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Fri, 7 Sep 2018 11:50:22 -0700
Message-ID: <CANQeFDCRk5+OPY9LCWUgDXEP-nb+EDUVFC7XD6SueTGXdYbg=g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: use correct args for kcalloc in btrfsic_read_block
To: Omar Sandoval <osandov@osandov.com>
Cc: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 7, 2018 at 11:21 AM, Omar Sandoval <osandov@osandov.com> wrote:
> On Sat, Sep 08, 2018 at 01:59:50AM +0800, Liu Bo wrote:
>> kcalloc is defined as
>> kcalloc(size_t n, size_t size, gfp_t flags)
>>
>> Although this won't cause problems in practice, btrfsic_read_block()
>> has switched n with size.
>>
>> This updates btrfsic_read_block() to be correct in using kcalloc.
>>
>> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
>> ---
>>  fs/btrfs/check-integrity.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
>> index 833cf3c35b4d..651b75939ce9 100644
>> --- a/fs/btrfs/check-integrity.c
>> +++ b/fs/btrfs/check-integrity.c
>> @@ -1594,6 +1594,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
>>  {
>>       unsigned int num_pages;
>>       unsigned int i;
>> +     u64 size;
>
> size_t?
>

oops, will update it.

thanks,
liubo

> Besides that, Reviewed-by: Omar Sandoval <osandov@fb.com>
>
>>       u64 dev_bytenr;
>>       int ret;
>>
>> @@ -1608,9 +1609,8 @@ static int btrfsic_read_block(struct btrfsic_state *state,
>>
>>       num_pages = (block_ctx->len + (u64)PAGE_SIZE - 1) >>
>>                   PAGE_SHIFT;
>> -     block_ctx->mem_to_free = kcalloc(sizeof(*block_ctx->datav) +
>> -                                             sizeof(*block_ctx->pagev),
>> -                                      num_pages, GFP_NOFS);
>> +     size = sizeof(*block_ctx->datav) + sizeof(*block_ctx->pagev);
>> +     block_ctx->mem_to_free = kcalloc(num_pages, size, GFP_NOFS);
>>       if (!block_ctx->mem_to_free)
>>               return -ENOMEM;
>>       block_ctx->datav = block_ctx->mem_to_free;
>> --
>> 1.8.3.1
>>
