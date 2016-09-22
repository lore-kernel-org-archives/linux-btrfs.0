Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21507 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933184AbcIVDTG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 23:19:06 -0400
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Chris Murphy <lists@colorremedies.com>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <09b358f4-4564-e885-411a-27020a496755@cn.fujitsu.com>
 <20160921073502.GB357701@mother.pipebreaker.pl>
 <4a021bc5-8695-1f8e-ec97-6414b91796a6@cn.fujitsu.com>
 <CAJCQCtS+g_FQpMUh+c+ccK4XAu72O4FQXtnXjOHL32t-M2VcVA@mail.gmail.com>
 <ac57e4db-dc9f-938f-9711-0c6d44d66d67@cn.fujitsu.com>
 <1474513627.1398.59.camel@scientia.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5462c897-38ef-f2b1-4f47-d27efc9bfabc@cn.fujitsu.com>
Date: Thu, 22 Sep 2016 11:18:50 +0800
MIME-Version: 1.0
In-Reply-To: <1474513627.1398.59.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/22/2016 11:07 AM, Christoph Anton Mitterer wrote:
> On Thu, 2016-09-22 at 10:08 +0800, Qu Wenruo wrote:
>> And I don't see the necessary to csum the parity.
>> Why csum a csum again?
>
> I'd say simply for the following reason:
> Imagine the smallest RAID5: 2x data D1 D2, 1x parity P
> If D2 is lost it could be recalculated via D1 and P.
>
> What if only (all) the checksum information for D2 is lost (e.g.
> because of further silent data corruption on the blocks of these
> csums)?

First thing first, csum is metadata, which is normally protected by 
metadata profile.

So, you are saying the csum tree is corrupted.
Wow, that's protected by RAID5(assume you're using RAID5 for both 
metadata and data) and tree leaf csum.
If that happens, which means at least 2 devices are already corrupted.

Your data is doomed anyway.

> Then we'd only know D1 is valid (which still has working csums).

If that really happens, csum tree leaf is corrupted, and your D1 csum 
will be corrupted too, considering how close they are.

No means to recover anyway.

> But we
> wouldn't know whether D2 is (because gone) neither whether P is
> (because not csummed).
> And next imagine silent data corruption in either D2 or P => we cannot
> tell which of them is valid, no repair possible... or do I miss
> something?

Stated above, your fs is already screwed up in that case.

The biggest problem is, parity is a block level thing (its bytenr are 
dev bytenr, not logical bytenr), and csum is logical level thing.

Screwing these things up will cause more problem and more time to 
maintain than the benefit.

>
>
>> Just as you expected, it doesn't check parity.
>> Even for RAID1/DUP, it won't check the backup if it succeeded
>> reading
>> the first stripe.
> That would IMO be really a highly severe bug... making scrubbing close
> to completely useless for multi-device fs.
> I mean the whole reason for doing it is to find [silently] corrupted
> blocks... in order to be able to do something about it.
> If on would only notice if the read actually fails because the one
> working block is also gone.. then why having a RAID in the first place?

That's "--check-data-csum", not in-kernel scrub.

Thanks,
Qu

>
>> Current implement doesn't really care if it's the data or the copy
>> corrupted, any data can be read out, then there is no problem.
> Except it makes RAID practically useless... => problem
>
>
> Cheers,
> Chris.
>
>


