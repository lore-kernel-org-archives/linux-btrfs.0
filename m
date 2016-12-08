Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50189 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932827AbcLHASx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 19:18:53 -0500
Subject: Re: [PATCH] btrfs-progs: Fix disable backtrace assert error
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, <linux-btrfs@vger.kernel.org>
References: <20161207012944.10545-1-quwenruo@cn.fujitsu.com>
 <05213ee7-ecb9-8171-d4b3-eec45204ff25@suse.de>
CC: <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <2a57f567-8c04-0050-f319-c85a69061dd1@cn.fujitsu.com>
Date: Thu, 8 Dec 2016 08:18:44 +0800
MIME-Version: 1.0
In-Reply-To: <05213ee7-ecb9-8171-d4b3-eec45204ff25@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/07/2016 11:06 PM, Goldwyn Rodrigues wrote:
>
>
> On 12/06/2016 07:29 PM, Qu Wenruo wrote:
>> Due to commit 00e769d04c2c83029d6c71(btrfs-progs: Correct value printed
>> by assertions/BUG_ON/WARN_ON), which changed the assert_trace()
>> parameter, the condition passed to assert/WARN_ON/BUG_ON are logical
>> notted for backtrace enabled and disabled case.
>>
>> Such behavior makes us easier to pass value wrong, and in fact it did
>> cause us to pass wrong condition for ASSERT().
>>
>> Instead of passing different conditions for ASSERT/WARN_ON/BUG_ON()
>> manually, this patch will use BUG_ON() to implement the resting
>> ASSERT/WARN_ON/BUG(), so we don't need to pass 3 different conditions
>> but only one.
>>
>> And to further info the review for the fact that the condition should be
>> different, rename "assert_trace" to "bugon_trace", as unlike assert, we
>> will only trigger the bug when condition is true.
>>
>> Also, move WARN_ON() out of the ifdef branch, as it's completely the
>> same for both branches.
>>
>> Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  kerncompat.h | 19 +++++++++++--------
>>  1 file changed, 11 insertions(+), 8 deletions(-)
>>
>> diff --git a/kerncompat.h b/kerncompat.h
>> index e374614..be77608 100644
>> --- a/kerncompat.h
>> +++ b/kerncompat.h
>> @@ -277,7 +277,7 @@ static inline long IS_ERR(const void *ptr)
>>  #define vfree(x) free(x)
>>
>>  #ifndef BTRFS_DISABLE_BACKTRACE
>> -static inline void assert_trace(const char *assertion, const char *filename,
>> +static inline void bugon_trace(const char *assertion, const char *filename,
>>  			      const char *func, unsigned line, long val)
>>  {
>>  	if (!val)
>
> To keep confusion to the minimum, you can call this *condition instead
> of *assertion.

Right, I'll update it.

>
>> @@ -287,17 +287,20 @@ static inline void assert_trace(const char *assertion, const char *filename,
>>  	exit(1);
>>  }
>>
>> -#define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
>> -#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
>> -#define	ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)!(c))
>> -#define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 1)
>> +#define BUG_ON(c) bugon_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
>>  #else
>>  #define BUG_ON(c) assert(!(c))
>> -#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
>> -#define ASSERT(c) assert(!(c))
>> -#define BUG() assert(0)
>>  #endif
>>
>> +#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
>> +/*
>> + * TODO: ASSERT() should be depercated. In case like ASSERT(ret == 0), it
>> + * won't output any useful value for ret.
>> + * Should be replaced by BUG_ON(ret);
>> + */
>> +#define	ASSERT(c) BUG_ON(!(c))
>
> I am not sure of this. As you are stating, this (double negation) will
> kill the value of the condition. Won't it be better to remove all
> ASSERTs first instead of putting this TODO?

IIRC the ASSERT/BUG_ON will be removed step by step.
And we have about 60+ ASSERT in current code base, not an easy thing to 
fix soon.

So I prefer to mark ASSERT() deprecated and remove them in later cleanups.

Thanks,
Qu

>
>
>> +#define BUG() BUG_ON(1)
>> +
>>  #define container_of(ptr, type, member) ({                      \
>>          const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
>>  	        (type *)( (char *)__mptr - offsetof(type,member) );})
>>
>


