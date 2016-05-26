Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10949 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752580AbcEZA3O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 20:29:14 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: utils: Introduce new pseudo random API
To: Noah Massey <noah.massey@gmail.com>
References: <1464149645-4308-1-git-send-email-quwenruo@cn.fujitsu.com>
 <CADfjVrgxsgEOF4R5nuTXt8ujkjpWvnW5PNSis+a4LugLvZ49PQ@mail.gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <607731d1-cbc1-e5c4-6346-acdb512b5e63@cn.fujitsu.com>
Date: Thu, 26 May 2016 08:29:10 +0800
MIME-Version: 1.0
In-Reply-To: <CADfjVrgxsgEOF4R5nuTXt8ujkjpWvnW5PNSis+a4LugLvZ49PQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Noah Massey wrote on 2016/05/25 12:15 -0400:
> On Wed, May 25, 2016 at 12:14 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> David has reported some quite chaos usage of pseudo random numbers.
>> Like using static srand seed, or even calling rand() without setting
>> seed correctly.
>>
>> The new pseudo random API will initialize the random seed on its first
>> calling and use uniformly distributed pseudo random number generator as
>> backend.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  utils.c | 36 ++++++++++++++++++++++++++++++++++++
>>  utils.h | 36 ++++++++++++++++++++++++++++++++++++
>>  2 files changed, 72 insertions(+)
>>
>> diff --git a/utils.c b/utils.c
>> index 7761165..c0e860a 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -54,9 +54,11 @@
>>  #define BLKDISCARD     _IO(0x12,119)
>>  #endif
>>
>> +static int seed_initlized = 0;
>>  static int btrfs_scan_done = 0;
>>
>>  static char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
>> +static unsigned short seeds[3];
>>
>>  const char *get_argv0_buf(void)
>>  {
>> @@ -4051,3 +4053,37 @@ out:
>>
>>         return ret;
>>  }
>> +
>> +void rand_seed(u64 seed)
>> +{
>> +       int i;
>> +       /* only use the last 48 bits */
>> +       for (i = 0; i < 3; i++) {
>> +               seeds[i] = (unsigned short)(seed ^ (unsigned short)(-1));
>> +               seed >>= 16;
>> +       }
>> +       seed_initlized = 1;
>> +}
>> +
>> +u32 rand_u32(void)
>> +{
>> +       struct timeval tv;
>> +
>> +       if (seed_initlized)
>> +               return nrand48(seeds);
>> +
>
> Missing a (u32) cast.

Right, just forgot that.

>
>> +       /*
>> +        * It's possible to use /dev/random, but we don't need that true
>> +        * random number nor want to wait for entropy,
>
> Sounds like a good candidate for /dev/urandom, then?

Yes, urandom is much better for such non-cypto use case.

>
>> +        * since we're only using random API to do corruption to test.
>> +        * Time and pid/ppid based seed would be good enough, and won't
>> +        * cause sleep for entropy pool.
>> +        */
>> +       gettimeofday(&tv, 0);
>> +       seeds[0] = getpid() ^ (tv.tv_sec & 0xFFFF);
>> +       seeds[1] = getppid() ^ (tv.tv_usec & 0xFFFF);
>> +       seeds[2] = (tv.tv_sec ^ tv.tv_usec) >> 16;
>> +       seed_initlized = 1;
>> +
>> +       return (u32)nrand48(seeds);
>> +}
>> diff --git a/utils.h b/utils.h
>> index ebe6d61..0977262 100644
>> --- a/utils.h
>> +++ b/utils.h
>> @@ -362,4 +362,40 @@ static inline int error_on(int condition, const char *fmt, ...)
>>         return 1;
>>  }
>>
>> +/* pseudo random number generator wrappers */
>> +u32 rand_u32(void);
>> +
>> +static inline int rand_int(void)
>> +{
>> +       return (int)(rand_u32());
>> +}
>> +
>> +static inline u64 rand_u64(void)
>> +{
>> +       u64 ret = 0;
>> +
>> +       ret += rand_u32();
>> +       ret <<= 32;
>> +       ret += rand_u32();
>> +       return ret;
>> +}
>> +
>> +static inline u16 rand_u16(void)
>> +{
>> +       return (u16)(rand_u32());
>> +}
>> +
>> +static inline u8 rand_u8(void)
>> +{
>> +       return (u8)(rand_u32());
>> +}
>> +
>> +/* Return random number in range [0, limit) */
>> +static inline unsigned int rand_range(unsigned int up)
>> +{
>> +       return (unsigned int)(rand_u32() % up);
>> +}
>
> Wouldn't distribution be more uniform if you took the full 48 bits
> from nrand64(), and only downcast after the mod?

Makes sense.

Will update the patchset soon.

Thanks,
Qu

>
>> +
>> +/* Also allow setting seeds manually */
>> +void rand_seed(u64 seed);
>>  #endif
>> --
>> 2.8.2
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


