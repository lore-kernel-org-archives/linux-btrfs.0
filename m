Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793566399;
	b=3s+G1de369h738oCgfraJWDfzHVdH0tXQiuhVScv9RR5spsjTE+eZ8j1ev8W3t2cSxuZ
	 3IE+z+MrxPLoClSRzXUzBxvdtxkrgZo+9PIYwY/7lFF98q8d570TBCMd358yHOJCnp8dr
	 aRmRLuzOoGGcaMIZH7NF31Zi184WaJOYKiXbMrH467l6qZ8PFpLqjzP7A2sTSIEkwPmub
	 zJZRAO7QfxAJPJWUwRtX+/nec4t7nlWbzFb1AQdrYvs8QF/hKu1d/KJNk4NPQdaZGzveq
	 y+mAE+f7d6a6Txr/2VGA2i0/Z1bQDx7K/W0Fpd9B5PYmweTi7tZ+WzR8kGRf+ohE6bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793566399;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=YizFf4AEtw6zZlgJzFAYSkY4tTOLJiRNsRvkBS7I8H8=;
	b=3xMbvVogTRcqtg+dVpbXncTNxaS3Q01uWMlsEecb7q/05qTdWWmkYoE41QMa6KiNabqc
	 ElA4iCH4bvVrLIYWHKHyHVvblr5hL7NacUosurMVnMffTTz+WQIf/u6g7OinGXPw+9XK9
	 8K1elipjxfgiyqreS5T/Q2Qh18y63VoSH0wN0D3SbjvwDAdnea5+bgbkFcxZz6tL3WPWd
	 pv5JrkMbdRh17IxqpOrwMhj0wyWTEH8clYLZqGcD8MtorymYx9a2AZcsdPsHT2ZVNm28P
	 mMzieOT0QsD80Kwv2E/cgzDK+qFD++ws2xMu6ViHZpeOvHCVACTC791vvN3Mk8SUaLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="g+aP/XeU";
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43787606A324
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 20:53:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43787606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=g+aP/XeU
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso27386405e9.1
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 12:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793566397; x=1794171197; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YizFf4AEtw6zZlgJzFAYSkY4tTOLJiRNsRvkBS7I8H8=;
        b=g+aP/XeUd2nAFuvnr+pN0LPlSAq/hqccEwVbz0RW2Q9l9/TA/4Pvp6tGwORyJPzxVo
         X6MtTPqJ0sCt2o9Y3XrsE+XzpZzLQefhu8oC8OGiQjKtLk+bfhmWn6GQD6n9PugzyTCg
         RgDDgY5HIrjwJO3DAyKPa23HgMQAGv6YlyIuMH/1FTYF8KLPMgIz75woopxBQO/fr2c8
         lWaq427682uTIP9pl+IR0D+OBnml9PdSNYByYLmF/aDSn2YplZTq+iNpgjPdt1iw6pPZ
         SXHNjmLlUHbTym+YIaVYnM/XCrOv8zq4aj3OukremIMf1+lsfudDIkcUQ52CpL+VhBQm
         kHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793566397; x=1794171197;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YizFf4AEtw6zZlgJzFAYSkY4tTOLJiRNsRvkBS7I8H8=;
        b=w+z2UO9j03yv0Ipr+YgzwaT0eaQXKd2GLZb26bOX+r2CVJrcaxT9BTPqyOPHu2SjVI
         CZeyQSZ9FTKDNyD0NWV7eOPU4xWUFj0tfbW4Hmg/Ui5XbUEMZLCHLruXRXTJlI/lMaX2
         C8c4/skBbVN6rT+QrQSiAGYnwTmI8plzMdDbWZDGePXh/nVRAX1JR8KcyIfuOsqKKe1y
         jcnb60cieM4lafLEbmmsnqM/eM1YOzkxq08CytRNOS06X1AeTgeonxs9uc6chICKW14c
         gaFjuwjI0vn7JH+gWmlEUTqfra18lOMLqIYJ09awt2Q3i6Rud2cgeYXy0h0xFFXAA+KL
         OKJw==
X-Forwarded-Encrypted: i=1; AKwUvBxe97R3/peJ8qenRcNuPFx8EBYec0icFzSp4L5Oe6A96WNffqyIkSlXVjjRrQgAmtMSvjKSAv1aUS9PnA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJM0J4Kzm6u8ehyW84LWq9envhofruaqQiTrWhXcd2qtDMVAcJn
	DLjNSThMS+RpK7OLKHWF7eTOqIyr/I6tgms/CNa76ax/GY/k0cYSD6Po1ZX1ecVjSDk=
X-Gm-Gg: AYBFou29fAQk6YF4pEVAzet5/SMuoIuczfnitFagxoKC2JBgFTropfIWsyGgnnWCxQp
	zeekwkd5M2Fq39g4UgrCRfYI+2Z5zx9H2l6l9DPPwjMjL8aYBxLlUpCGvfnv/akKtAp6eGNQk1u
	OlkiPRu/Qq7yBEHTmsi2oEd/bUjfypeF5hJAmtYflLjERu4dIb3LTj0TR/ryVAnmqkp9pwNX6+b
	AdE38WePnIZrVSSsq5jvl+mGFXnh/2cbgaxQeAkQMtJKfJYf0oJgZwDTAj53YaOIt8C1Q1MosTU
	UlzxW0oy2qBjAHW+G1lw7a20i9jhbOsiHfLBwXz1M83RUjKaDZS/990BQoi6cA2KXupBVAiiPh3
	ActQZ2E5ZcOuh774pQP9Q59PmXBgPb09qFn/z1CZT0HVWQtPdqRLOZOc3T+raSJNcBWRiWScwnz
	CaqMWEGzZdYS1ww264ya0FsArxFP64yVRpWDEKVl2b8cRHY61aU0ekzd+ceasiyTU9JsWfdSkAj
	1jHYT4oO+26iPj7pP4xXXpN1P1O/x+ecmiQlEO2MDh//hy6naRcGRhuk1dnpcR0LS7N5czW0o4F
	v8nAZyqU8h3JKvMQzsBm
X-Received: by 2002:a05:600c:138c:b0:4a1:acaa:9d4c with SMTP id 5b1f17b1804b1-4ac18c740c5mr182610545e9.25.1793566396642;
        Sun, 01 Nov 2026 12:53:16 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42a6f7f9sm35580246eec.25.2026.11.01.12.53.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 12:53:15 -0800 (PST)
Message-ID: <3d3cedc7-a148-40ef-ac22-9aa89d0920f6@suse.com>
Date: Mon, 2 Nov 2026 07:23:09 +1030
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
Subject: Re: [PATCH] btrfs: fix bio counter and bioc leak when async
 checksumming fails
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, mt4022@columbia.edu,
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 tz2294@columbia.edu, stable@vger.kernel.org
References: <20261101-btrfs-async-csum-leak-v1-1-feafe7ae61e9@columbia.edu>
 <d9990870-188d-49b5-badf-9e7ae9a273ed@gmx.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
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
In-Reply-To: <d9990870-188d-49b5-badf-9e7ae9a273ed@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/2 07:08, Qu Wenruo 写道:
> 
> 
> 在 2026/11/2 05:09, Mani Tofigh via B4 Relay 写道:
>> From: Mani Tofigh <mt4022@columbia.edu>
>>
>> A single failed checksum allocation can make a later device replace
>> hang forever.  btrfs_submit_chunk() takes a dev-replace bio counter
>> reference and a bioc before it hands a write to the checksum worker.
>> If the checksum fails there (eg its allocation fails),
>> run_one_async_done() ends the bio but drops neither.  The counter then
>> never gets back to zero and the next replace waits for it:
>>
>>    [    8.369171] BTRFS info (device ram0): dev_replace from /dev/ram0 
>> (devid 1) to /dev/ram1 finished
>>    [   41.534247] INFO: task btrfscsum:80 blocked for more than 20 
>> seconds.
>>    [   41.534391]  btrfs_rm_dev_replace_blocked+0x135/0x180
>>    [   41.534463]  btrfs_dev_replace_finishing+0xefe/0x13b0
>>
>> Put the bioc and drop the counter in that error branch as the
>> synchronous error path does.  Also put the bioc on the synchronous
>> path, which only drops the counter.  With the fix, the replace
>> finishes.
>>
>> This bug was identified and confirmed with the help of fault-injection
>> testing on a deterministic hypervisor currently under development.  The
>> C reproducer below however hits it within about 35s.
>>
>> Fixes: f8a53bb58ec7 ("btrfs: handle checksum generation in the storage 
>> layer")
>> Cc: stable@vger.kernel.org # 6.6+
>> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> Although it's not that common to hit this path.
> 
> On EXPERIMENTAL builds you are already running with async csum 
> generation, other than the offload path.
> 
> Otherwise on most x86_64, the default CRC32 is considered fast, so is 
> xxhash on all archs, and they will not go through the offload mode.
> 
> So I'm wondering what's your setup? Are you running SHA256 algo for 
> checksum? I can add it to the commit message during merge.

And Sashiko exposed an existing problem, even with this patch applied, 
the error handling of btrfs_split_bio() is not going to release the bioc.

https://sashiko.dev/#/map/223655

Although it's an existing bug, since you're touching all the bioc 
releasing, it would be better to handle them all in one patch.

Thanks,
Qu

> 
>> ---
>> Reproducer: https://github.com/manitofigh/files/blob/main/linux- 
>> repros/btrfscsum.c
>> ---
>>   fs/btrfs/bio.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
>> index 2c6234f6182f..a508f4abd3a3 100644
>> --- a/fs/btrfs/bio.c
>> +++ b/fs/btrfs/bio.c
>> @@ -624,6 +624,8 @@ static void run_one_async_done(struct btrfs_work 
>> *work, bool do_free)
>>       /* If an error occurred we just want to clean up the bio and 
>> move on. */
>>       if (bio->bi_status) {
>> +        btrfs_put_bioc(async->bioc);
>> +        btrfs_bio_counter_dec(async->bbio->inode->root->fs_info);
>>           btrfs_bio_end_io(async->bbio, bio->bi_status);
>>           return;
>>       }
>> @@ -822,6 +824,7 @@ static bool btrfs_submit_chunk(struct btrfs_bio 
>> *bbio, int mirror_num)
>>       return map_length == length;
>>   fail:
>> +    btrfs_put_bioc(bioc);
>>       btrfs_bio_counter_dec(fs_info);
>>       /*
>>        * We have split the original bbio, now we have to end both the 
>> current
>>
>> ---
>> base-commit: 5e6c45aaaf93343c7f8a1cde9797080238af5c1b
>> change-id: 20261030-btrfs-async-csum-leak-1772df5f0c32
>>
>> Best regards,
>> -- 
>> Mani Tofigh <mt4022@columbia.edu>
> 

