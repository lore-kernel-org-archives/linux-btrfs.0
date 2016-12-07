Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15145 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752626AbcLGAbU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Dec 2016 19:31:20 -0500
Subject: Re: [PATCH 1/2] btrfs-progs: Correct value printed by
 assertions/BUG_ON/WARN_ON
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
References: <20161129162452.28402-1-rgoldwyn@suse.de>
 <f0beaab1-a09c-cd3e-c00e-2727c3ec8ecd@cn.fujitsu.com>
 <ff3428dc-ee0e-8feb-fa76-1627b4fa411b@suse.de>
 <a5d9ed5f-d8cc-f2ae-52e2-5a4bf4285910@cn.fujitsu.com>
 <f1fad444-39d0-d79f-0774-491d5f444ed5@suse.de>
 <3a1b9e0d-db65-91aa-f298-519b0040c220@cn.fujitsu.com>
 <b929d5ff-2ec1-9ac0-eb39-d2ed3ddff6da@suse.de>
CC: Goldwyn Rodrigues <rgoldwyn@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <269500a6-a96d-c23e-fced-f74d55059b63@cn.fujitsu.com>
Date: Wed, 7 Dec 2016 08:31:14 +0800
MIME-Version: 1.0
In-Reply-To: <b929d5ff-2ec1-9ac0-eb39-d2ed3ddff6da@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/06/2016 08:44 PM, Goldwyn Rodrigues wrote:
>
>
> On 12/05/2016 09:08 PM, Qu Wenruo wrote:
>>
>>
>> At 12/06/2016 10:51 AM, Goldwyn Rodrigues wrote:
>>>
>>>
>>> On 12/05/2016 08:03 PM, Qu Wenruo wrote:
>>>> BTW, the DISABLE_BACKTRACE branch seems quite different from
>>>> backtrace one.
>>>>
>>>> #define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__,
>>>> (long)(c))
>>>> #define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__,
>>>> (long)(c))
>>>> #define ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__,
>>>> (long)!(c))
>>>> #define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 1)
>>>> #else
>>>> #define BUG_ON(c) assert(!(c))
>>>> #define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__,
>>>> (long)(c))
>>>> #define ASSERT(c) assert(!(c))
>>>> #define BUG() assert(0)
>>>>
>>>> Condition of BUG_ON/ASSERT/BUG are all logical notted for
>>>> DISABLE_BACKTRACE.
>>>> While WARN_ON() of both branch are the same condition.
>>>
>>> WARN_ON is using warning_trace as opposed to assert, and that is the
>>> reason it is not notted.
>>>
>>>>
>>>> This seems quite confusing to me.
>>>>
>>>> Any idea to make it more straightforward?
>>>>
>>>
>>> I just kept it the same as before. warning_trace was using an extra
>>> variable, trace, which was not needed because the print_trace was
>>> already in ifndefs.
>>
>> I mean, better make the condition the same for both BUG/BUG_ON/ASSERT.
>> So that we don't need to manually logical not the condition.
>
> First of all, ASSERT and BUG_ON have opposite meanings. ASSERT() checks
> if the condition is true and continues (halts if false). BUG_ON() "bugs"
> if condition is true and halts (continues if false). So you would have
> to use opposite conditions.

I know, I mean, for both backtrace disabled and enabled case, the 
condition should be the same.

If not the same condition, it means assert_trace() has different meaning 
than original assert.

>
>>
>> For example:
>> #define ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__,（long）
>> (c))
>> and
>> #define ASSERT(c) assert((c))
>>
>> This looks much more straightforward, and easier to expose bug at review
>> time.
>
> Could you explain with a patch? You idea seems to add more code than
> reduce it.

Sure, will submit one soon.

Thanks,
Qu


