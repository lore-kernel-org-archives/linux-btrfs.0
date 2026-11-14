Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794616869;
	b=PDZjB18RDghySorEotNmXqudwxX5dqdvDqtsW5UciwAMiqSagU1oi3CGqwkkDYxQXcEd
	 pXJ2zMyhQrLSP/xGfVVam3O+vvD7CtH58NH5pF1uF8uFh3chfMB4ODnxo/Qf+jy/+N7f8
	 wJ1ggaovZY+/YoRpc8OkPy+63Q45WZY8cZf0upbw8GtTCCRxK+LK8NEf+s80HBmNYOsx/
	 kUPUsZFScXpaVSyb65IIQIoxg5d2L1X3YTvKQOaUqxyYpsaugkdDDyENvvZLibptecgXK
	 LpZqEIBWZSHxffzEQRGJcPj6tmfnq3cOPl7IbNDebi/wNUkSVrpm2JvVDGUGKS7INzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794616869;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Tc+uMj0q8pptwp2lc327ujdvBLHLZyfh+PplobvAzTI=;
	b=sXAmcPRsPwDVTm/M94A7yWcRnjr/1d8Via7N547aHuzM2DvDRGYO6rJbDLYkMnI309+I
	 9MNG4WrAwOdcG2aYJZly5oEryAUwtXtiQE4IcF1P9zBr6cMVoiqEyp5Qq9xQ+QEiD75bj
	 UCV86yeKiQE6OCOf/HSVeyGYPTTqUHgKrMMG35nqC2KPuVeaJYhU2/hvf07YF0MrcXUW3
	 xM+JHGgHfodDBhj45b+W5VGPeIh5O+BmGpuDOSq3LzGoOFaVFLSFR/fmZjPHSx2RzXEU6
	 rXAFuoMAmJp4Thg9YHXTkUniHj/5sPdB4fQrA9S6L7Dn2MbkLh4ckfFMQzlaC2P36Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=W2q7uhX1;
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAEE606A339
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 00:41:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DAEE606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=W2q7uhX1
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b547d6c07bso2734933a12.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 16:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794616867; x=1795221667; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Tc+uMj0q8pptwp2lc327ujdvBLHLZyfh+PplobvAzTI=;
        b=W2q7uhX10WEXSFrOKKSYYjBexJx+dM8IvKrNw/s7tlOtAcT9nSUsGEBgG/dziJaw6U
         kGvnZbpFHa46HhhehCcglIZcaxhrLvaIjnOXmsXbr242Ak0MbRMSnGH/N+8kF51Hr9VA
         Wdjxt3HAhlRDOEDQljduHqxbArRnbdsJd1ogQxGy+7vqUw2e16OC8s+zlzud3q4SxcZG
         f43d9cqQe5va3U13wjucAxvpeJ8Rpd2KUpR85lUywbfBXRD+vlQVhmynD2XsIJ/HZFY4
         iCT49vFl/HSNlEtpH+OL+LhqjveCl6z0n5e7lAdpmNWK+1jRU5slvL6whMgvHXO2JiOR
         MpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794616867; x=1795221667;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Tc+uMj0q8pptwp2lc327ujdvBLHLZyfh+PplobvAzTI=;
        b=dHq+bkuf5Y0APC2WMtZ/vtf6ptJ1vOPdXDr7xdCHNZxBi3xmcwk4RG/hpUTgj4iHtu
         CxKoS9gxsyuAnsKokRTIcUCFqA3n07/HoYRduaOBPgPTIJyEwRgRHGESTRiZqX+03ifS
         8J/b71oHrDbggnVwpp5EmhC9ZDQrtzWjqCqO06OAswBGsPrHe5hFwwr0OuNeVktuiE9b
         y+J4+Wt3ddPHJu11N0jvw54sPuwtpaJTQxvm8qq4hh4ikIB8ZqkCayxuae6Qav3CohTX
         siZk6sYNBNut3F8xp3k+BTw+IgsvH9AjaIiGk7yK8pQn+gX4ZQp8bno6RCok/aq+3jTT
         t9MQ==
X-Forwarded-Encrypted: i=1; AL+hErEg3+ua8Q4FelIMmVvUePQclwVoL20Y/9Zab7gfcKfEuaccuHcMq8yhSNOyN/rW2PI6duVzNbeliLGMiw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/Dp/1RAl34tZqwaBvx+qIBmZunsoR0DH9bMYl3mF5ou21HANQ0
	gXlr8B/B8/z5hdQF63M0leFIewLYWvwv4RSqq3xUSN+ZkZ2/t/nArkht4TR2pUdw7W3F5n4ocaB
	bwjQkCno=
X-Gm-Gg: AYBFou2Cvm9H/bmTNdihsjO3285Iis3LCMVEDsRNW6nejKTfh09xtpDfJVehMYxV0OU
	D0NCghBi97dpi3vrOaG+fHHt2pQSks99u/i3Q6kfEtkX9ZK3RqQuXfl3UMIcAR1oueogliVeq4V
	Rax0/7cTDolCU0RGt85UUsyMuifYf/3Dmzsm3DarVMI2M93NqreQcbA9kCeoiPBsZv6tW7VjMpD
	C4gBEGePY1zsZrGrUXKiOvwv7bgjqQZV/C9iGscG5/UkJR1d/KmE9OFzQF9qRh77++pQoVDJe+P
	rzp9/snVq3biKGX5eYTNXfmnPwj44FOa19vwMS9VCmZXXDM0k1CkUA37tmEGY4YVo9H4vZX4SIS
	rahBgm7cuIArh34rVSV70jqGBEZC20/rnD7a5mTL+2FaSuuYFUvJjcZEKn5CtxxYYDpCVdrPMH5
	+/g8BZ+mAgKepLZH5gK6QZa4PI74SwJiOO7h38WbF1SQg+6tJi9wMd/UTucDUbdaSRb8Qc23lD9
	f6O/JnDyClxnySoXUHTozKjbtHHwEpwjF0sI2Xr4Q8b8+i64hwjVRMg/1dxSCregIBXP1OGf+V3
	JgZsHGgFKzCW83rlzDVXiw==
X-Received: by 2002:a05:6402:23d1:b0:6b1:ca87:c588 with SMTP id 4fb4d7f45d1cf-6b7c0d03742mr2969868a12.37.1794616867372;
        Fri, 13 Nov 2026 16:41:07 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b3b708adsm2853328a91.4.2026.11.13.16.41.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 16:41:06 -0800 (PST)
Message-ID: <50cfbe7d-e925-447d-9131-bfd019bf97ea@suse.com>
Date: Sat, 14 Nov 2026 11:11:01 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: speed up steal_from_bitmap_to_front() with a
 backward word scan
From: Qu Wenruo <wqu@suse.com>
To: Elias Jernberg <eliasjernberg@gmail.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
 Chris Mason <mason@kernel.org>
References: <20261114000234.339513-1-eliasjernberg@gmail.com>
 <d829648c-3fc2-4f6e-ad07-ffce8be579a8@suse.com>
Content-Language: en-US
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <d829648c-3fc2-4f6e-ad07-ffce8be579a8@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/14 10:55, Qu Wenruo 写道:
> 
> 
> 在 2026/11/14 10:32, Elias Jernberg 写道:
> [...]
>>
>> Fixes: 200055239604 ("Btrfs: improve free space cache management and 
>> space allocation")
>> Signed-off-by: Elias Jernberg <eliasjernberg@gmail.com>
>> ---
>>
>> Notes:
>>      - The numbers above come from a 7.3-based tree (aurora-silicon/ 
>> linux,
>>        Apple M5 MacBook Pro, 16K pages) carrying this change in an
>>        equivalent form. This version was build-tested on btrfs for-next
>>        (3aefd67f08f8) as x86_64 UML with W=1, no new warnings, and the 
>> btrfs
>>        self-tests pass (CONFIG_BTRFS_FS_RUN_SANITY_TESTS, including the
>>        bitmap stealing tests).
>>      - On x86_64 with 4K pages I could not reproduce a clear stall 
>> with the
>>        similar fragmenting workload (sync after the delete took 
>> 0.4-1.9 s), so the
>>        effect looks tied to the larger bitmaps of 16K and 64K pages.
> 
> I'm more interested on the page size bounding part.
> 
> As btrfs_free_space_bitmap_cachep is using fixed PAGE_SIZE for the 
> allocation, it's causing the behavior difference in the first place.
> 
> I'm wondering if we should make the bitmap size not bounded to 
> PAGE_SIZE, but the sectorsize of each filesystem.
> 
> Have you tried 16K page size with 16K sector size? (along with changed 
> blocksize in the fio)
> Did that can reproduce the same latency?

My bad, that won't change the bitmap size.

Instead what about the following change? Would it resolve the latency 
problem on 16K page sized systems?

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index bff6e5b372d6..4250792a3b9c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -29,7 +29,7 @@
  #include "super.h"
  #include "relocation.h"

-#define BITS_PER_BITMAP                (PAGE_SIZE * 8UL)
+#define BITS_PER_BITMAP                (SZ_4K * 8UL)
  #define MAX_CACHE_BYTES_PER_GIG        SZ_64K
  #define FORCE_EXTENT_THRESHOLD SZ_1M

@@ -279,7 +279,7 @@ static void recalculate_thresholds(struct 
btrfs_free_space_ctl *ctl)
         else
                 max_bytes = MAX_CACHE_BYTES_PER_GIG * div_u64(size, SZ_1G);

-       bitmap_bytes = ctl->total_bitmaps * unit;
+       bitmap_bytes = ctl->total_bitmaps * SZ_4K;

         /*
          * we want the extent entry threshold to always be at most 1/2 
the max
@@ -2910,7 +2910,7 @@ int __init btrfs_free_space_init(void)
                 return -ENOMEM;

         btrfs_free_space_bitmap_cachep = 
kmem_cache_create("btrfs_free_space_bitmap",
-                                                       PAGE_SIZE, 
PAGE_SIZE,
+                                                       SZ_4K, SZ_4K,
                                                         0, NULL);
         if (!btrfs_free_space_bitmap_cachep) {
                 kmem_cache_destroy(btrfs_free_space_cachep);

> 
> Thanks,
> Qu
> 
>>      - Reproducer (fio, run on the btrfs filesystem under test):
>>          fio --name=a --filename=f --rw=write --bs=1M --direct=1 -- 
>> size=4G --end_fsync=1
>>          fio --name=r --filename=f --rw=randwrite --bs=4k -- 
>> ioengine=libaio --iodepth=32 \
>>              --direct=1 --size=4G --time_based --runtime=15 --end_fsync=1
>>          fio --name=s --filename=f --rw=write --bs=4k --direct=1 -- 
>> size=4G \
>>              --time_based --runtime=15 --fsync=1
>>          rm f
>>          fio --name=b --filename=f --rw=write --bs=1M --size=4G -- 
>> end_fsync=1
>>        The last job takes 29-36 s without this patch and under 1 s 
>> with it.
>>      - Prior art: Yun Levi suggested replacing this loop in December 
>> 2020 on
>>        LKML, as a user of a proposed find_prev_zero_bit()
>>        (https://www.mail-archive.com/linux-kernel@vger.kernel.org/ 
>> msg2402457.html).
>>        That helper was never added and the loop is unchanged in for-next.
>>        This version keeps the backward scan local to free-space-cache.c.
>>      - Tool use: the stall was profiled, the fix written and the 
>> changelog
>>        drafted with an LLM coding assistant (Claude). I have reviewed the
>>        change; the equivalence test and the measurements were run on my
>>        machine.
>>
>>   fs/btrfs/free-space-cache.c | 30 ++++++++++++++++++++++--------
>>   1 file changed, 22 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>> index bff6e5b372d6..c599a8f25821 100644
>> --- a/fs/btrfs/free-space-cache.c
>> +++ b/fs/btrfs/free-space-cache.c
>> @@ -1269,6 +1269,26 @@ static bool steal_from_bitmap_to_end(struct 
>> btrfs_free_space_ctl *ctl,
>>       return true;
>>   }
>> +/*
>> + * Return the index of the last clear bit at or below @bit, or 
>> ULONG_MAX if
>> + * bits 0 to @bit are all set.  Scan backwards a word at a time, so 
>> the cost
>> + * follows the length of the run of set bits that ends at @bit rather 
>> than the
>> + * number of clear bits below it.
>> + */
>> +static unsigned long find_last_clear_bit_upto(const unsigned long 
>> *bitmap,
>> +                          unsigned long bit)
>> +{
>> +    unsigned long idx = BIT_WORD(bit);
>> +    unsigned long word = ~bitmap[idx] & BITMAP_LAST_WORD_MASK(bit + 1);
>> +
>> +    while (!word) {
>> +        if (idx == 0)
>> +            return ULONG_MAX;
>> +        word = ~bitmap[--idx];
>> +    }
>> +    return idx * BITS_PER_LONG + __fls(word);
>> +}
>> +
>>   static bool steal_from_bitmap_to_front(struct btrfs_free_space_ctl 
>> *ctl,
>>                          struct btrfs_free_space *info,
>>                          bool update_stat)
>> @@ -1277,7 +1297,6 @@ static bool steal_from_bitmap_to_front(struct 
>> btrfs_free_space_ctl *ctl,
>>       struct btrfs_free_space *bitmap;
>>       u64 bitmap_offset;
>>       unsigned long i;
>> -    unsigned long j;
>>       unsigned long prev_j;
>>       u64 bytes;
>> @@ -1294,13 +1313,8 @@ static bool steal_from_bitmap_to_front(struct 
>> btrfs_free_space_ctl *ctl,
>>           return false;
>>       i = offset_to_bit(bitmap->offset, unit, info->offset) - 1;
>> -    j = 0;
>> -    prev_j = (unsigned long)-1;
>> -    for_each_clear_bit_from(j, bitmap->bitmap, BITS_PER_BITMAP) {
>> -        if (j > i)
>> -            break;
>> -        prev_j = j;
>> -    }
>> +    prev_j = find_last_clear_bit_upto(bitmap->bitmap,
>> +                      min(i, BITS_PER_BITMAP - 1));
>>       if (prev_j == i)
>>           return false;
> 

