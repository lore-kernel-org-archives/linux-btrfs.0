Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9673 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750977AbdFABBe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 21:01:34 -0400
Subject: Re: [RFC PATCH v3.2 5/6] btrfs: qgroup: Introduce extent changeset
 for qgroup reserve functions
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20170517025628.303-1-quwenruo@cn.fujitsu.com>
 <20170517025628.303-6-quwenruo@cn.fujitsu.com>
 <20170517153749.GH4065@suse.cz>
 <0652a2d4-746c-c8a9-dfef-ce212cbd96ff@cn.fujitsu.com>
 <20170518134531.GP4065@suse.cz>
 <4cbc5b03-7b8a-3f50-0eac-ba6f5d599369@cn.fujitsu.com>
 <20170529155145.GP14523@twin.jikos.cz>
 <75a5a010-2259-34e1-9da3-e37eb4916d51@cn.fujitsu.com>
 <20170531143001.GA12135@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <17c52fe5-40fb-5c4c-1066-01928098a69f@cn.fujitsu.com>
Date: Thu, 1 Jun 2017 09:01:26 +0800
MIME-Version: 1.0
In-Reply-To: <20170531143001.GA12135@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/31/2017 10:30 PM, David Sterba wrote:
> On Wed, May 31, 2017 at 08:31:35AM +0800, Qu Wenruo wrote:
>>>> Yes it's hard to find such deadlock especially when lockdep will not
>>>> detect it.
>>>>
>>>> And this makes the advantage of using stack memory in v3 patch more obvious.
>>>>
>>>> I didn't realize the extra possible deadlock when memory pressure is
>>>> high, and to make completely correct usage of GFP_ flags we should let
>>>> caller to choose its GFP_ flag, which will introduce more modification
>>>> and more possibility to cause problem.
>>>>
>>>> So now I prefer the stack version a little more.
>>>
>>> The difference is that the stack version will always consume the stack
>>> at runtime.  The dynamic allocation will not, but we have to add error
>>> handling and make sure we use right gfp flags. So it's runtime vs review
>>> trade off, I choose to spend time on review.
>>
>> OK, then I'll update the patchset to allow passing gfp flags for each
>> reservation.
> 
> You mean to add gfp flags to extent_changeset_alloc and update the
> direct callers or to add gfp flags to the whole reservation codepath?

Yes, I was planning to do it.

> I strongly prefer to use GFP_NOFS for now, although it's not ideal.

OK, then keep GFP_NOFS.
But I also want to know the reason why.

Is it just because we don't have good enough tool to detect possible 
deadlock caused by wrong GFP_* flags in write path?

Thanks,
Qu


