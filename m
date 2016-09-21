Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18995 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932337AbcIUJPY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 05:15:24 -0400
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: Tomasz Torcz <tomek@pipebreaker.pl>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <09b358f4-4564-e885-411a-27020a496755@cn.fujitsu.com>
 <20160921073502.GB357701@mother.pipebreaker.pl>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <4a021bc5-8695-1f8e-ec97-6414b91796a6@cn.fujitsu.com>
Date: Wed, 21 Sep 2016 17:15:02 +0800
MIME-Version: 1.0
In-Reply-To: <20160921073502.GB357701@mother.pipebreaker.pl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/21/2016 03:35 PM, Tomasz Torcz wrote:
> On Wed, Sep 21, 2016 at 03:28:25PM +0800, Qu Wenruo wrote:
>> Hi,
>>
>> For this well-known bug, is there any one fixing it?
>>
>> It can't be more frustrating finding some one has already worked on it after
>> spending days digging.
>>
>> BTW, since kernel scrub is somewhat scrap for raid5/6, I'd like to implement
>> btrfsck scrub support, at least we can use btrfsck to fix bad stripes before
>> kernel fix.
>
>   Why wouldn't you fix in-kernel code?  Why implement duplicate functionality
> when you can fix the root cause?
>
We'll fix in-kernel code.

Fsck one is not duplicate, we need a better standard thing to compare 
with kernel behavior.

Just like qgroup fix in btrfsck, if kernel can't handle something well, 
we do need to fix kernel, but a good off-line fixer won't hurt.
(Btrfs-progs is much easier to implement, and get fast review/merge 
cycle, and it can help us to find better solution before screwing kernel 
up again)

Thanks,
Qu


