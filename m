Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34368 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751917AbdJGAJH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Oct 2017 20:09:07 -0400
Received: by mail-oi0-f66.google.com with SMTP id h200so4637000oib.1
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Oct 2017 17:09:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171006182451.GB3521@twin.jikos.cz>
References: <20171005100726.16438-1-nefelim4ag@gmail.com> <20171005100726.16438-2-nefelim4ag@gmail.com>
 <20171006182451.GB3521@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sat, 7 Oct 2017 03:08:26 +0300
Message-ID: <CAGqmi76Jf4mXpGYkW-_3jW7hLOrUef3VwCZMggPWePmwnGJPDA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Btrfs: heuristic add shannon entropy calculation
To: David Sterba <dsterba@suse.cz>, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-10-06 21:24 GMT+03:00 David Sterba <dsterba@suse.cz>:
> On Thu, Oct 05, 2017 at 01:07:26PM +0300, Timofey Titovets wrote:
>> Byte distribution check in heuristic will filter edge data
>> cases and some time fail to classificate input data
>>
>> Let's fix that by adding Shannon entropy calculation,
>> that will cover classification of most other data types.
>>
>> As Shannon entropy need log2 with some precision to work,
>> i precalculate table for our max sample size (8KiB).
>>
>> Shannon entropy slightly changed for avoiding signed numbers
>> and divisions
>>
>> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
>> ---
>>  fs/btrfs/compression.c | 314 ++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 313 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
>> index 0060bc4ae5f2..b002ee980243 100644
>> --- a/fs/btrfs/compression.c
>> +++ b/fs/btrfs/compression.c
>> @@ -1225,6 +1225,290 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
>>  }
>>
>>
>> + /*
>> +  * Precalculated log2 values for 0 - 8193 range
>> +  * return data shifted to left for 4 bit,
>> +  * for improve precision without float point.
>> +  *
>> +  * Used only in shannon entropy for heuristic
>> +  *
>> +  * Only first 128 elements precalculated for save memory
>> +  */
>> +
>> +#define LOG2_RET_SHIFT (1 << 4)
>> +
>> +static int log2_lshift4(uint16_t x)
>> +{
>> +     /*
>> +      * Predefined array for first 128 values
>> +      * Python generator example
>> +      * import math
>> +      * for i in range(1, 128):
>> +      *     print(int(math.log2(i)*16),end=', ')
>> +      */
>> +     uint8_t ret[128] = {
>
>         static const uint8_t ret
>
> Otherwise it consumes 128 bytes of the stack space.
>
>> +             0,    0,    16,   25,   32,   37,   41,   44,   48,   50,
>> +             53,   55,   57,   59,   60,   62,   64,   65,   66,   67,
>> +             69,   70,   71,   72,   73,   74,   75,   76,   76,   77,
>> +             78,   79,   80,   80,   81,   82,   82,   83,   83,   84,
>> +             85,   85,   86,   86,   87,   87,   88,   88,   89,   89,
>> +             90,   90,   91,   91,   92,   92,   92,   93,   93,   94,
>> +             94,   94,   95,   95,   96,   96,   96,   97,   97,   97,
>> +             98,   98,   98,   99,   99,   99,   99,   100,  100,  100,
>> +             101,  101,  101,  102,  102,  102,  102,  103,  103,  103,
>> +             103,  104,  104,  104,  104,  105,  105,  105,  105,  106,
>> +             106,  106,  106,  106,  107,  107,  107,  107,  108,  108,
>> +             108,  108,  108,  109,  109,  109,  109,  109,  110,  110,
>> +             110,  110,  110,  111,  111,  111,  111,  111
>> +
>> +     };
>> +
>> +
>> +     if (x < 128)
>> +             return ret[x];
>> +
>> +     if (x < 1024) {
>> +             if (x < 256) {
>> +             }
>> +             if (x < 470) {
>> +             }
>> +             if (x < 981) {
>> +             }
>> +             return 159;
>> +     }
>> +
>> +     if (x < 8193) {
>> +             if (x < 2048) {
>> +             }
>> +             if (x < 4096) {
>> +             }
>> +             if (x < 7845) {
>> +             }
>> +             return 207;
>> +     }
>> +     return 208;
>
> I hear the compiler scream, trying to optimize all the ifs. And I think
> the CPU branch prediction would have a hard time, there's practically no
> expected pattern and the performance could be worse compared to the
> formula calculation.
>
> What's the reason you opencode it like that? Could you please post how
> it would be implemented in C? There are potentially optimized functions
> to do integer log2 (ilog2).

That is just:
log2_lshift4(n) { return ilog2(pow(n, 16)); }
But that will cause a overflow.

log2(8192) -> 13 - 13 bit long
13 * 4 = 52, 52 < 64

That also restrict sample size to 15 bit

So we can get approximately same behaviour,
by doing like ilog2(pow(n, 4));

https://pastebin.com/VryvqkCy - some numbers
TL;DR version:
pow(n, 4)
 - count        100          7    28300
 - error %    0.0%     1.1%    3.0%
pow(n, 16)
 - count     18843    11483    14
 - error %     0.0%     1.0%    2.8%

(I sample Win10.iso image as just big file with different data).
I gen error value by:
if (shannon_e_f > 0)
    error = 100 - (shannon_e_i * 1.0 * 100 / shannon_e_f);

In fact that cause errors in entropy level like:
TRUE -> Integer
83 -> 80
87 -> 84
32 -> 28

In theory that possible to just make entropy level markers more aggressive,
like: 70->65 and 85 -> 80

That will cover precision errors.

or make a byte level BigInt in kernel (bigint_log2, bigint_Lshift & etc) %)
(But this seems inexcusable to me + i'm unsure about performance + I'm
afraid Big/Little.Endian)

> Code like that could be microbenchmarked so we can see actual numbers,
> so far I'm just guessing.

I'm mentioned in a cover letter https://github.com/Nefelim4ag/companalyze
(implement the heuristic with no optimizations, all code run, to get
RAW counters)
Over in memory bad compressible data:
 8188. BSize: 131072, RepPattern: 0, BSet: 256, BCSet: 220, ShanEi%:
99| 99 ~0.0%, RndDist:     0, out: -3

With -O0 - ~1100 MiB/s
With -O2 - ~2500 MiB/s

With (i found in kernel and add pow(n, 4))
static int ilog2(uint64_t v)
{
    int l = 0;
    v = v*v*v*v;
    while ((1UL << l) < v)
        l++;
    return l;
}

With -O0 - ~1150 MiB/s
With -O2 - ~2500 MiB/s

So, my solutions looks more bad at code, than performance
(i may be that because most requests for bad compressible data got
directly to lookup table)

Thanks!

>> +}
>> +
>> +
>> +/*
>> + * Shannon Entropy calculation
>> + *
>> + * Pure byte distribution analyze fail to determine
>> + * compressiability of data. Try calculate entropy to
>> + * estimate the average minimum number of bits needed
>> + * to encode a sample data.
>> + *
>> + * For comfort, use return of percentage of needed bit's,
>> + * instead of bit's amaount directly.
>> + *
>> + * @ENTROPY_LVL_ACEPTABLE - below that threshold sample has low byte
>> + * entropy and can be compressible with high probability
>> + *
>> + * @ENTROPY_LVL_HIGH - data are not compressible with high probability,
>> + */
>> +
>> +#define ENTROPY_LVL_ACEPTABLE 70
>> +#define ENTROPY_LVL_HIGH 85
>> +
>> +static uint32_t shannon_entropy(struct heuristic_ws *ws)
>> +{
>> +     const u32 entropy_max = 8*LOG2_RET_SHIFT;
>> +     const u32 q = log2_lshift4(ws->sample_size);
>> +     u32 p, i;
>> +     u64 entropy_sum;
>> +
>> +     entropy_sum = 0;
>> +     for (i = 0; i < BUCKET_SIZE && ws->bucket[i].count > 0; i++) {
>> +             p = ws->bucket[i].count;
>> +             entropy_sum += p * (q - log2_lshift4(p));
>> +     }
>> +
>> +     entropy_sum = div_u64(entropy_sum, ws->sample_size);
>> +     return div_u64(entropy_sum * 100, entropy_max);I
>
> I wonder if some of the 64bit types and 64bit division could be avoided.



-- 
Have a nice day,
Timofey.
