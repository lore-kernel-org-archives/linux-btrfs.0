Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4883B298CAF
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 06:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790749076; cv=none; b=hLaRdKFTl4mx4ErZYJ7F/wdOCA7fuY4JyhRlFnA4taAbtNfqBpGcPfWuGPHF/OhpL5kf9YinFG2qJ9pp5uF35RpgGyiWA31ICVimOJmPPQmWD9sRwKsuc4P7O/nocgp1g9Zttb3F70n2iEU8Me3hGx2jtc/rRUUyZvceOQtd3h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790749076; c=relaxed/simple;
	bh=+nfM5gimSXfDcJHTOQI3ZLEOA1c2m9uOt5xXFDqbvF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fe2orGN3FtHOGjudk0KyXAcHUkpYud+UNidh2FXyrV1RoPQX6UHP1iNQoVi4roPdp7YmCjg8wAWFfKqBtUij/1rBVfGDRE5xj4eyrgmfCC2HIPkf6P/csvlD8M9XQyyUH8/VIPEAkySgvJNjQcG7tjEAztbIi7gT/wlMbiaIgHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a64a7760bc9611f19a56ed5b684f684d-20260930
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:7256ab20-1c2e-4cc8-92b4-a18c945a97ff,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:7256ab20-1c2e-4cc8-92b4-a18c945a97ff,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:d5cecbae507b9a51ceff7dff9c797ae5,BulkI
	D:260930125920ORI7EMY8,BulkQuantity:1,SF:17|19|38|64|66|78|80|81|82|83|102
	|127|136|841|865|898,TC:nil,Content:0|15|16|52|99,EDM:-3|-100,IP:-2,URL:0,
	File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO
	,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a64a7760bc9611f19a56ed5b684f684d-20260930
X-User: liuhuan01@kylinos.cn
Received: from [192.168.13.123] [(123.53.38.137)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1835058410; Wed, 30 Sep 2026 14:17:44 +0800
Message-ID: <d00a9825-4bde-444c-96ca-c70a73979d6f@kylinos.cn>
Date: Wed, 30 Sep 2026 14:17:42 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs-progs: receive: fix unused variable warning
 without LZO
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <1ba84f08-92d8-4add-9e19-82f47446de87@gmx.com>
 <20260930022142.26073-2-liuhuan01@kylinos.cn>
 <dc67e026-1af8-44e6-adc6-f4c2e398f93e@suse.com>
Content-Language: en-US
From: liuh <liuhuan01@kylinos.cn>
In-Reply-To: <dc67e026-1af8-44e6-adc6-f4c2e398f93e@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/9/30 12:59, Qu Wenruo 写道:
>
>
> 在 2026/9/30 11:51, liuh0329 写道:
>> When btrfs-progs is built without LZO support, sector_shift is still
>> declared in decompress_and_write(), while all its uses are guarded by
>> COMPRESSION_LZO. This results in an unused variable warning.
>>
>> Move the sector_shift declaration to the LZO-specific code path so it is
>> only declared when LZO support is enabled.
>>
>> Fixes: 345731fff32d ("btrfs-progs: receive: optional build for lzo, 
>> zstd")
>> Signed-off-by: liuh0329 <liuhuan01@kylinos.cn>
>>
>> ---
>> Changes in v2:
>> - Move sector_shift declaration to its only usage, as suggested by Qu 
>> Wenruo.
>> - Add a local scope for sector_shift.
>>
>>   cmds/receive.c | 18 ++++++++++--------
>>   1 file changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/cmds/receive.c b/cmds/receive.c
>> index 49103ea3..02c864a6 100644
>> --- a/cmds/receive.c
>> +++ b/cmds/receive.c
>> @@ -1186,7 +1186,6 @@ static int decompress_and_write(struct 
>> btrfs_receive *rctx,
>>   {
>>       int ret = 0;
>>       char *unencoded_data;
>> -    int sector_shift = 0;
>>       u64 written = 0;
>>         unencoded_data = calloc(unencoded_len, 1);
>> @@ -1220,13 +1219,16 @@ static int decompress_and_write(struct 
>> btrfs_receive *rctx,
>>       case BTRFS_ENCODED_IO_COMPRESSION_LZO_32K:
>>       case BTRFS_ENCODED_IO_COMPRESSION_LZO_64K:
>>   #if COMPRESSION_LZO
>> -        sector_shift =
>> -            compression - BTRFS_ENCODED_IO_COMPRESSION_LZO_4K + 12;
>> -        ret = decompress_lzo(encoded_data, encoded_len, unencoded_data,
>> -                     unencoded_len, 1U << sector_shift);
>> -        if (ret)
>> -            goto out;
>> -        break;
>> +        {
>
> Why? Why not just simply do the following?

Thanks, that is simpler. I'll drop the extra scope and move the 
declaration directly to its only usage in v3.

> diff --git a/cmds/receive.c b/cmds/receive.c
> index 49103ea3eeea..f592a044801d 100644
> --- a/cmds/receive.c
> +++ b/cmds/receive.c
> @@ -1186,7 +1186,6 @@ static int decompress_and_write(struct 
> btrfs_receive *rctx,
>  {
>         int ret = 0;
>         char *unencoded_data;
> -       int sector_shift = 0;
>         u64 written = 0;
>
>         unencoded_data = calloc(unencoded_len, 1);
> @@ -1220,7 +1219,7 @@ static int decompress_and_write(struct 
> btrfs_receive *rctx,
>         case BTRFS_ENCODED_IO_COMPRESSION_LZO_32K:
>         case BTRFS_ENCODED_IO_COMPRESSION_LZO_64K:
>  #if COMPRESSION_LZO
> -               sector_shift =
> +               int sector_shift =
>                         compression - 
> BTRFS_ENCODED_IO_COMPRESSION_LZO_4K + 12;
>                 ret = decompress_lzo(encoded_data, encoded_len, 
> unencoded_data,
>                                      unencoded_len, 1U << sector_shift);
>
>
>> +            int sector_shift =
>> +                compression - BTRFS_ENCODED_IO_COMPRESSION_LZO_4K + 12;
>> +
>> +            ret = decompress_lzo(encoded_data, encoded_len, 
>> unencoded_data,
>> +                         unencoded_len, 1U << sector_shift);
>> +            if (ret)
>> +                goto out;
>> +            break;
>> +        }
>>   #else
>>           error("LZO compression for stream not compiled in");
>>           ret = -EOPNOTSUPP;
>
