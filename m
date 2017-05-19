Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34742 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753561AbdESAcW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 20:32:22 -0400
Subject: Re: [RFC PATCH v3.2 5/6] btrfs: qgroup: Introduce extent changeset
 for qgroup reserve functions
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20170517025628.303-1-quwenruo@cn.fujitsu.com>
 <20170517025628.303-6-quwenruo@cn.fujitsu.com>
 <20170517153749.GH4065@suse.cz>
 <0652a2d4-746c-c8a9-dfef-ce212cbd96ff@cn.fujitsu.com>
 <20170518134531.GP4065@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <4cbc5b03-7b8a-3f50-0eac-ba6f5d599369@cn.fujitsu.com>
Date: Fri, 19 May 2017 08:32:18 +0800
MIME-Version: 1.0
In-Reply-To: <20170518134531.GP4065@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/18/2017 09:45 PM, David Sterba wrote:
> On Thu, May 18, 2017 at 08:24:26AM +0800, Qu Wenruo wrote:
>>>> +static inline void extent_changeset_init(struct extent_changeset *changeset)
>>>> +{
>>>> +	changeset->bytes_changed = 0;
>>>> +	ulist_init(&changeset->range_changed);
>>>> +}
>>>> +
>>>> +static inline struct extent_changeset *extent_changeset_alloc(void)
>>>> +{
>>>> +	struct extent_changeset *ret;
>>>> +
>>>> +	ret = kmalloc(sizeof(*ret), GFP_KERNEL);
>>>
>>> I don't remember if we'd discussed this before, but have you evaluated
>>> if GFP_KERNEL is ok to use in this context?
>>
>> IIRC you have informed me that I shouldn't abuse GFP_NOFS.
> 
> Use of GFP_NOFS or _KERNEL has to be evaluated case by case. So if it's
> "let's use NOFS because everybody else does" or "he said I should not
> use NOFS, then I'll use KERNEL", then it's wrong and I'll complain.
> 
> A short notice in the changelog or a comment above the allocation would
> better signify that the patch author spent some time thinking about the
> consequences.
> 
> Sometimes it can become pretty hard to find the potential deadlock
> scenarios. Using GFP_NOFS in such case is a matter of precaution, but at
> least would be nice to be explictly stated somewhere.

Yes it's hard to find such deadlock especially when lockdep will not 
detect it.

And this makes the advantage of using stack memory in v3 patch more obvious.

I didn't realize the extra possible deadlock when memory pressure is 
high, and to make completely correct usage of GFP_ flags we should let 
caller to choose its GFP_ flag, which will introduce more modification 
and more possibility to cause problem.

So now I prefer the stack version a little more.

Thanks,
Qu

> 
> The hard cases help to understand the callchain patterns and it's easier
> to detect them in the future. For example, in your patch I already knew
> that it's a problem when I saw lock_extent_bits, because I had seen this
> pattern in a patch doing allocation in FIEMAP. Commit
> afce772e87c36c7f07f230a76d525025aaf09e41, discussion in thread
> http://lkml.kernel.org/r/1465362783-27078-1-git-send-email-lufq.fnst@cn.fujitsu.com
> 
> 


