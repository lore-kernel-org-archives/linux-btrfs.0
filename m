Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.manjaro.org ([176.9.38.148]:37905 "EHLO manjaro.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752003AbdHHNlJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Aug 2017 09:41:09 -0400
Subject: Re: how to benchmark schedulers
To: "Janos Toth F." <toth.f.janos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b5d1a891-efc0-e49e-ff91-4409c26491d2@manjaro.org>
 <751f296a-d26c-83a9-d105-e85f73fdcd06@manjaro.org>
 <CANznX5FDMU5z4bJEpBeF+WmknhHWpQNbSaa8okbJAZhKz71y5Q@mail.gmail.com>
From: Bernhard Landauer <oberon@manjaro.org>
Message-ID: <7b136c47-989b-1341-9f6d-6de52751085d@manjaro.org>
Date: Tue, 8 Aug 2017 15:41:01 +0200
MIME-Version: 1.0
In-Reply-To: <CANznX5FDMU5z4bJEpBeF+WmknhHWpQNbSaa8okbJAZhKz71y5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08.08.2017 15:19, Janos Toth F. wrote:

> I think you should consider using Linux 4.12 which has bfq (bfq-mq)
> for blk-mq. So, you don't need out-of-tree BFQ patches if you switch
> to blk-mq (but now you are free to do so even if you have HDDs or SSDs
> which benefit from software schedulers since you have some multi-queue
> schedulers for them). Just make sure to enable blk-mq (has to be a
> boot parameter or build-time choice) in order to gain access to
> bfq-mq. And remember that bfq-mq has to be activated manually (the
> build-time choice for a default scheduler is not valid for multi-queue
> schedulers, you will default to "none" which is effectively the new
> "no-op").
> Note: there is only one BFQ in 4.12 and it's bfq-mq which runs under
> the name of simply BFQ (not bfq-mq, I only used that name to make it
> clear that BFQ in 4.12 is a multi-queue version of BFQ).
>
> I always wondered if Btrfs makes any use of FUA if it's enabled for
> compatible SATA devices (it's disabled by default because there are
> some drives with faulty firmware).
>
> I also wonder if RAID10 is any better (or actually worse?) for
> metadata (and system) chunks than RAID1.
>
> On Tue, Aug 8, 2017 at 1:59 PM, Bernhard Landauer <oberon@manjaro.org> wrote:
>> Hello everyone
>>
>> I am looking for a way to test different available schedulers with Manjaro's
>> bfq-patched kernels on sytems with both SSD and spinning drives. Since
>> phoronix-test-suite apparently is currently useless for this task due to its
>> bad config for bfq I am looking for alternatives. Do you have any
>> suggestions for me?
>> Thank you.
>>
>> kind regards
>> Bernhard Landauer
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thank you for your reply, Janos!
In fact what I am trying to do is evaluating which kernel and which 
schedulers are delivering the best results for me and I would like to 
test/benchmark the differences.
So my question is about available tests I could run with different setups.
Please let me know if you know of any.

regards
Bernhard
