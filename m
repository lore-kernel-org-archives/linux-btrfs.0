Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35441 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754466AbcLAMab (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Dec 2016 07:30:31 -0500
Subject: Re: 4.8.8, bcache deadlock and hard lockup
To: Chris Murphy <lists@colorremedies.com>,
        Eric Wheeler <bcache@lists.ewheeler.net>
References: <20161118164643.g7ttuzgsj74d6fbz@merlins.org>
 <20161118184915.j6dlazbgminxnxzx@merlins.org>
 <b6c3daab-d990-e873-4d0f-0f0afe2259b1@coly.li>
 <alpine.LRH.2.11.1611291255350.1914@mail.ewheeler.net>
 <20161130164646.d6ejlv72hzellddd@merlins.org>
 <alpine.LRH.2.11.1611301553420.22682@mail.ewheeler.net>
 <CAJCQCtR40OdvGCwVUoE8SBgXALiWdZrm06b9EXG=tA+8NeKePA@mail.gmail.com>
Cc: Marc MERLIN <marc@merlins.org>, Coly Li <i@coly.li>,
        linux-bcache@vger.kernel.org,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <32b06150-a47b-5be1-b4f0-5da8641dba30@gmail.com>
Date: Thu, 1 Dec 2016 07:30:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR40OdvGCwVUoE8SBgXALiWdZrm06b9EXG=tA+8NeKePA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-30 19:48, Chris Murphy wrote:
> On Wed, Nov 30, 2016 at 4:57 PM, Eric Wheeler <bcache@lists.ewheeler.net> wrote:
>> On Wed, 30 Nov 2016, Marc MERLIN wrote:
>>> +btrfs mailing list, see below why
>>>
>>> On Tue, Nov 29, 2016 at 12:59:44PM -0800, Eric Wheeler wrote:
>>>> On Mon, 27 Nov 2016, Coly Li wrote:
>>>>>
>>>>> Yes, too many work queues... I guess the locking might be caused by some
>>>>> very obscure reference of closure code. I cannot have any clue if I
>>>>> cannot find a stable procedure to reproduce this issue.
>>>>>
>>>>> Hmm, if there is a tool to clone all the meta data of the back end cache
>>>>> and whole cached device, there might be a method to replay the oops much
>>>>> easier.
>>>>>
>>>>> Eric, do you have any hint ?
>>>>
>>>> Note that the backing device doesn't have any metadata, just a superblock.
>>>> You can easily dd that off onto some other volume without transferring the
>>>> data. By default, data starts at 8k, or whatever you used in `make-bcache
>>>> -w`.
>>>
>>> Ok, Linus helped me find a workaround for this problem:
>>> https://lkml.org/lkml/2016/11/29/667
>>> namely:
>>>    echo 2 > /proc/sys/vm/dirty_ratio
>>>    echo 1 > /proc/sys/vm/dirty_background_ratio
>>> (it's a 24GB system, so the defaults of 20 and 10 were creating too many
>>> requests in th buffers)
>>>
>>> Note that this is only a workaround, not a fix.
>>>
>>> When I did this and re tried my big copy again, I still got 100+ kernel
>>> work queues, but apparently the underlying swraid5 was able to unblock
>>> and satisfy the write requests before too many accumulated and crashed
>>> the kernel.
>>>
>>> I'm not a kernel coder, but seems to me that bcache needs a way to
>>> throttle incoming requests if there are too many so that it does not end
>>> up in a state where things blow up due to too many piled up requests.
>>>
>>> You should be able to reproduce this by taking 5 spinning rust drives,
>>> put raid5 on top, dmcrypt, bcache and hopefully any filesystem (although
>>> I used btrfs) and send lots of requests.
>>> Actually to be honest, the problems have mostly been happening when I do
>>> btrfs scrub and btrfs send/receive which both generate I/O from within
>>> the kernel instead of user space.
>>> So here, btrfs may be a contributor to the problem too, but while btrfs
>>> still trashes my system if I remove the caching device on bcache (and
>>> with the default dirty ratio values), it doesn't crash the kernel.
>>>
>>> I'll start another separate thread with the btrfs folks on how much
>>> pressure is put on the system, but on your side it would be good to help
>>> ensure that bcache doesn't crash the system altogether if too many
>>> requests are allowed to pile up.
>>
>>
>> Try BFQ.  It is AWESOME and helps reduce the congestion problem with bulk
>> writes at the request queue on its way to the spinning disk or SSD:
>>         http://algo.ing.unimo.it/people/paolo/disk_sched/
>>
>> use the latest BFQ git here, merge it into v4.8.y:
>>         https://github.com/linusw/linux-bfq/commits/bfq-v8
>>
>> This doesn't completely fix the dirty_ration problem, but it is far better
>> than CFQ or deadline in my opinion (and experience).
>
> There are several threads over the past year with users having
> problems no one else had previously reported, and they were using BFQ.
> But there's no evidence whether BFQ was the cause, or exposing some
> existing bug that another scheduler doesn't. Anyway, I'd say using an
> out of tree scheduler means higher burden of testing and skepticism.
Normally I'd agree on this, but BFQ is a bit of a different situation 
from usual because:
1. 90% of the reason that BFQ isn't in mainline is that the block 
maintainers have declared the legacy (non blk-mq) code deprecated and 
refuse to take anything new there despite having absolutely zero 
scheduling in blk-mq.
2. It's been around for years with hundreds of thousands of users over 
the years who have had no issues with it.
