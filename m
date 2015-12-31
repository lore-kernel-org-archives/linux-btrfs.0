Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21882 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751126AbbLaArJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 19:47:09 -0500
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Sanidhya Solanki <jpage.lkml@gmail.com>, <calestyo@scientia.net>,
        <clm@fb.com>, <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
 <20151229133907.GA4227@suse.cz> <20151229061512.79a41f31@gmail.com>
 <20151229170611.GB4227@suse.cz> <20151230013946.7c1f0e12@gmail.com>
 <5683C714.4040705@gmx.com> <20151230045449.7a6c14db@gmail.com>
 <5683E5E4.5010006@gmx.com> <20151230161722.GF4227@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56847AEC.8080409@cn.fujitsu.com>
Date: Thu, 31 Dec 2015 08:46:36 +0800
MIME-Version: 1.0
In-Reply-To: <20151230161722.GF4227@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/12/30 17:17 +0100:
> On Wed, Dec 30, 2015 at 10:10:44PM +0800, Qu Wenruo wrote:
>> Now I am on the same side of David.
>> Which means a runtime interface to change them. (along with mkfs option)
>>
>> If provide some configurable features, then it should be able to be
>> tuned at both right time and mkfs time.
>> Or, just don't touch it until there is really enough user demand.
>> (In stripe_len case, it's also a possible choice, as configurable stripe
>> length doesn't really affect much except RAID5/6)
>
> I think that we need configurable stripe size regardless. The
> performance drop is measurable if the stripe size used by filesystem
> does not match the hardware.

Right, I just missed the benchmark from Christoph and forgot the case of 
RAID 5/6.

>
>> I totally understand that implement will cost you a lot of more time,
>> not only kernel part but also user-tool part.
>>
>> But this also means more patches.
>> No matter what the motivation for you to contribute to btrfs, more
>> patches (except the more time spent) are always good.
>>
>> More patches, more reputation built in community, and more patches also
>> means better split code structures for easier review.
>
> Let me note that a good reputation is also built from patch reviews
> (hint hint).

I must admit I'm a bad reviewer.
As when I review something, I always has an eager to rewrite part or all 
the patch to follow my idea, even it's just a choice between different 
design.

Thanks,
Qu


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


