Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51432 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751949AbdASDnh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jan 2017 22:43:37 -0500
Subject: Re: [PATCH v3] btrfs-progs: Fix disable backtrace assert error
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20170118030425.28065-1-quwenruo@cn.fujitsu.com>
 <765a9beb-3d39-8b86-eff1-84eb85f2d0a2@suse.de>
 <30e9ce6b-3393-be93-d209-3d23ed74a0ce@cn.fujitsu.com>
Cc: dsterba@suse.cz
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <4a97de85-9dcc-d5ca-3b98-671699d13511@suse.de>
Date: Wed, 18 Jan 2017 21:42:45 -0600
MIME-Version: 1.0
In-Reply-To: <30e9ce6b-3393-be93-d209-3d23ed74a0ce@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/18/2017 06:27 PM, Qu Wenruo wrote:
> 
> 
> At 01/18/2017 07:38 PM, Goldwyn Rodrigues wrote:
>>
>>
>> On 01/17/2017 09:04 PM, Qu Wenruo wrote:
>>> Due to commit 00e769d04c2c83029d6c71(btrfs-progs: Correct value printed
>>> by assertions/BUG_ON/WARN_ON), which changed the assert_trace()
>>> parameter, the condition passed to assert/WARN_ON/BUG_ON are logical
>>> notted for backtrace enabled and disabled case.
>>>
>>> Such behavior makes us easier to pass value wrong, and in fact it did
>>> cause us to pass wrong condition for ASSERT().
>>>
>>> Instead of passing different conditions for ASSERT/WARN_ON/BUG_ON()
>>> manually, this patch will use ASSERT() to implement the resting
>>> ASSERT/WARN_ON/BUG(), so we don't need to pass 3 different conditions
>>> but only one.
>>>
>>> Also, move WARN_ON() out of the ifdef branch, as it's completely the
>>> same for both branches.
>>>
>>> Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>> Sorry for late update, being digging the dev-replace/scrub bug
>>>
>>> v2:
>>>   Keep ASSERT() outputing meaningful error string, use ASSERT() to
>>>   implement BUG_ON() so only the abused BUG_ON() output is affected.
>>>   Suggested by David.
>>> v3:
>>>   Update commit message, since we use ASSERT() instead of BUG_ON() as
>>>   main assert function now.
>>> ---
>>>  kerncompat.h | 13 +++++--------
>>>  1 file changed, 5 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/kerncompat.h b/kerncompat.h
>>> index 19ed3fc0..fe23774e 100644
>>> --- a/kerncompat.h
>>> +++ b/kerncompat.h
>>> @@ -291,18 +291,15 @@ static inline void assert_trace(const char
>>> *assertion, const char *filename,
>>>      abort();
>>>      exit(1);
>>>  }
>>> -
>>> -#define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__,
>>> (long)(c))
>>> -#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__,
>>> (long)(c))
>>>  #define    ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__,
>>> (long)!(c))
>>> -#define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 1)
>>>  #else
>>> -#define BUG_ON(c) assert(!(c))
>>> -#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__,
>>> (long)(c))
>>> -#define ASSERT(c) assert(!(c))
>>> -#define BUG() assert(0)
>>> +#define ASSERT(c) assert(c)
>>>  #endif
>>>
>>> +#define BUG_ON(c) ASSERT(!(c))
>>
>> The problem with this is that you are killing the value printed as a
>> part of the trace for BUG_ON(). The main reason why commit
>> 00e769d04c2c83029d6c71 was written. Please be careful with your notting
>> especially when the values are being printed.
>>
> 
> This is designed.
> 
> As ASSERT() is more meaningful than the abused BUG_ON(), I changed it to
> print correct value for ASSERT() and ignore BUG_ON().

If ASSERT is meaningful, correct it. But please don't make BUG_ON worse
and leave it as it is, at least until the time you can remove the
BUG_ONs or convert it. It should print the correct value of why it did
bug, or else it will print just 1, which is of no debug value.

> 
> Thanks,
> Qu
> 
>>
>>> +#define BUG() BUG_ON(1)
>>> +#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__,
>>> (long)(c))
>>> +
>>>  #define container_of(ptr, type, member) ({                      \
>>>          const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
>>>              (type *)( (char *)__mptr - offsetof(type,member) );})
>>>
>>
> 
> 

-- 
Goldwyn
