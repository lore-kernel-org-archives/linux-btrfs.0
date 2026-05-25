Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB7A3537FB
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 10:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779704713; cv=none; b=tr4nOVwwivPla6jC7jMb1DzU36CkipRKs8Mn0+u7s/HxGSIaCIEKw/IgLYuoooKJ5nOHyUfcno80MWRmvEdZ0esWw8FR7qyokfnDGz1rXg6QPsDpMRDGGMbPxdxftQ3Qir/A0AlaiUB7JLU5BHARz/B4AbudDtS9dOfCtFyNKlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779704713; c=relaxed/simple;
	bh=4lynDydB72Mj7/FDZmw2cWlodOseOvJOImwySeJTuqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eGEL+rznVat/Iuk+rbV7cIUyjvCiqjiIMQ5sgN80QbI4SRaQhXPbofjPfSDNwP2km9BHOrQ7VyO1qQtzlPg77osOFAKwL7iUhuSQftcZw3ZcFn9BCVox52jvoDJuE7NUR++mZPBRhcPaeoBvZ1dn1PGaDB9pBfCqpM1oPC/rGzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Bpxbom7R; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Bpxbom7R"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso119379885e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 03:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779704708; x=1780309508; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WYyCEe15Cxgf15kMtvEvAHTT6I/VjMUvnOAajgqtAdo=;
        b=Bpxbom7R5mWFZ0CmYde+MgJ6EClDred7tWhf1ofOfOEZ+BAxum+uVdPgaeyn7xJSpl
         r81Xh4gv4wcrJNge9d90nqoqTR9ekJtHbc12TGv6Dz86K3gAOWmUKbj+F9HjuQLotT/k
         LesVhMBbZtvqGLG/Qv29CzzPj+eGEZh+U5YWdGRgbo3NZzJdUQy3p7NdU1UArJ8aH/Et
         5VjBVw5524J7B8RU9i3mjBbSDsMi35kq83F+E7BFrHy34G0qD7YP6Fu5SVFMhRsr70oo
         JrVOcajVGTu01VQQIt119YmSVpu45NfiKSrL1BiDP6UjELU9G6MUOVzTyx1PJy4kYHTY
         MX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779704708; x=1780309508;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WYyCEe15Cxgf15kMtvEvAHTT6I/VjMUvnOAajgqtAdo=;
        b=aODSqM0DFyq9O1M3FQ/TMoU828kJKw6/BKeLY2h/L5eju1UCFjICcZSr50jCXWTK6x
         0FZUWWERlw8ASJSZot+UF31bL9iA9IkvdP+BtxNaJBCIMcsoThcbQjxwb79QTgMypAK+
         naf021sMkXZ4ed6UXt16coHX6rcEYWTUAbj6Y3Ylw1hXCvGGaiDZMnABo7+WrJYlgDQK
         ArRiBB0N4EEliySV8AypEoprD2IoI9H5SOsLOxMWtGbneISPoqZrnzHFbB7tyVVGE3sN
         i5Cpa/9a5q+VdVcc+emPA5RFBM0WwBSxIm2/+RpWnwOSZtt+YFX8AfEMo2rVqaPVQdGj
         icTQ==
X-Gm-Message-State: AOJu0YzsFWXDM62UBBfl1cNfnr79mr8RFFpKNamAtFbLijx0cnHnq/iF
	vR86vAkhxhcCBAtAUs1+FGRoJtuTjh28M9q6kgkMFVRkJ4kGXHfpstNwl4zBMyqo7qY=
X-Gm-Gg: Acq92OFAJu/E6AovjK8phrOKhmXjWMtB+BJHNjT2gwF0umYC3FxTfSHqHIzr6wNg9a2
	mZIfxkspG+VlSC+TjMYVPUiEEtXBFuUD73gQ9B1SNTH4QcqtD7loAqSZ+Quz4Jr0DWAqMZPZECr
	76iAU0Mzhj/jP5cxEQy3LhOlkFB8BLrd5TMsH5pKl3AVP+bOAaA7j1YK75uX7nG2F725bTySzN9
	C0cuoxOmGOntgn4Bsx82vV0aL8z3ppJ7zjdkVKPedNjl40nzGPRXv1Fs+0vHLu8uyYWqjPTTNzs
	+ZlHD7vOJ1IOA41eSj98FQ0r8k36bBNiE0l2SgzOqKp7JUW091p0xyVAf2W4CSIIOuvoU9IuB0Z
	F0wpnToN3Dpk4a8SB4oiWrhArAbMf6nBTqHOSUfPgdEEtYiFXdpYhJeAcd6MXJ8qeaZKST+044N
	h4rDCSwOZJRpyL/1sORAIMIkkX+vjH1WJalT3Te1ih+w/ZjwC4t+aKyrmpfUKg3JjupnH/Mcdfn
	jBDfO135jYcvq5weWlj/mGLoZ4FVSLSUJ/kmAMYjkVPgC8=
X-Received: by 2002:a05:600c:1f90:b0:490:5e2a:dbaf with SMTP id 5b1f17b1804b1-4905e2adc0dmr79923055e9.21.1779704708337;
        Mon, 25 May 2026 03:25:08 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164ff7d80sm10209860b3a.56.2026.05.25.03.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 03:25:07 -0700 (PDT)
Message-ID: <f8fa4b33-4bca-4c0a-a651-e0ad8a527621@suse.com>
Date: Mon, 25 May 2026 19:55:02 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, hch@lst.de, linux-raid@vger.kernel.org
References: <cover.1779412152.git.wqu@suse.com>
 <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com>
 <20260523142344.GC183694@twin.jikos.cz>
 <e1961351-d563-4d73-b9f3-30063bbe7c4d@suse.com>
 <1b5c39fe-df28-4a21-bace-fc742498945e@suse.com>
 <20260525101236.GU12792@suse.cz>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20260525101236.GU12792@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/25 19:42, David Sterba 写道:
> On Sun, May 24, 2026 at 01:43:54PM +0930, Qu Wenruo wrote:
>> I tried the idea, and it doesn't look elegant at all, we need a lot of
>> if () checks around every xor_gen()/raid6_call.
>>
>> Sure the end result is not that huge (and I have only compile tested
>> it), but if we had some parameters passed wrongly, or some corner case
>> missed, it can be very hard to notice.
>>
>> Just paste the adhoc fix for reference:
> 
> I ended up with something similar, but replaced the open coded ifs with
> a helper so there's not that much churn at the call sites.
> 
>> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
>> index 08ee8f316d96..50fefe33bbe3 100644
>> --- a/fs/btrfs/raid56.c
>> +++ b/fs/btrfs/raid56.c
>> @@ -1410,11 +1410,17 @@ static void generate_pq_vertical_step(struct
>> btrfs_raid_bio *rbio, unsigned int
>>    				rbio_qstripe_paddr(rbio, sector_nr, step_nr));
>>
>>    		assert_rbio(rbio);
>> -		raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
>> +		if (rbio->nr_data > 1) {
>> +			raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
>> +		} else {
>> +			memcpy(pointers[1], pointers[0], step);
>> +			memcpy(pointers[2], pointers[0], step);
>> +		}
>>    	} else {
>>    		/* raid5 */
>>    		memcpy(pointers[rbio->nr_data], pointers[0], step);
>> -		xor_gen(pointers[rbio->nr_data], pointers + 1, rbio->nr_data - 1,
>> +		if (rbio->nr_data > 1)
>> +			xor_gen(pointers[rbio->nr_data], pointers + 1, rbio->nr_data - 1,
>>    				step);
>>    	}
>>    	for (stripe = stripe - 1; stripe >= 0; stripe--)
>> @@ -1987,11 +1993,17 @@ static void recover_vertical_step(struct
>> btrfs_raid_bio *rbio,
>>    		}
>>
>>    		if (failb == rbio->real_stripes - 2) {
>> -			raid6_datap_recov(rbio->real_stripes, step,
>> -					  faila, pointers);
>> +			if (unlikely(rbio->nr_data == 1))
>> +				memcpy(pointers[0], pointers[rbio->real_stripes - 1], step);
>> +			else
>> +				raid6_datap_recov(rbio->real_stripes, step,
>> +						  faila, pointers);
>>    		} else {
>> -			raid6_2data_recov(rbio->real_stripes, step,
>> -					  faila, failb, pointers);
>> +			if (unlikely(rbio->nr_data == 1))
>> +				memcpy(pointers[0], pointers[rbio->real_stripes - 2], step);
> 
> The 2data recovery needs to do 2 memcpy

Nope. The recovery is only to repair the data stripe.
We do not need to bother the failed P or Q stripe here.

And I think this explains exactly why doing adhoc fix is a stupid idea 
in the first place.

We're wasting time on useless corner cases, and corner cases inside 
corner cases.
It makes no sense to waste all the time reviewing those useless details, 
when we have a much better solution to avoid all those hassles.


