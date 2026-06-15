Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBC6340403
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 23:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781566757; cv=none; b=T0Ggoql+DdZTOg1THAWKia1Ss90ZYlPzNdW+3MLLA4TqNFI/5Pe8nJJgWA20P7AEiz/4t3ooN8o8O4whpS3FA0NHpyWXwiYCvqO9PPJyY0erQEYeVCbI7DiJ3RkZnNSCH0HpgqcJBacwhgVOpzxoxx3lW1bWSyWaQNqzq6LHh48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781566757; c=relaxed/simple;
	bh=bzBWJpEOIq3Ssuqm/8TrzFTVje0i43YVH411+vtVzzE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ATlWmaeRWSfMmd3XG7mF55k7EfmElaXn2t/ztRH4jP1nMFfhlp4NHqRhdSkzMxGMrk+R1sbvhOj4Mm1tLq1fUpjzDRicCRUzDcc0noynk6kwmi7zzi6ahHKPm9KcVdmj8Fi02vhfxr3BQcH4dSL46nSscpNAneIh0A4NE+e3sgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eoypbmYe; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eoypbmYe"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-693c51a8a19so4147142a12.3
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 16:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781566754; x=1782171554; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=NMBz4B6FugIWzvzNwnXAHY1D03fO9BNg+Cee6zUOGJw=;
        b=eoypbmYeYuyWKexREq0WBvXlraz3Ixalx8QPs+csoJfmnrq869eB/2EmY5lGQ/ymnO
         lClvq8O+LQZtVKZ+/PLPRsJnUkv7Qi2h2NsQmhSThV9cUFnAGbsyjjUl4ZyHmkF2VwUC
         nCyL14rTawCqqT/pJnRwz1dmesuhJlUW4gOL1/2kEqZjt8GnQytY+MrJzvneE7r4WN2G
         stsezuEqhiEaaqcpTFK7120ZwFOKxjo9LXd7ZE3gfpksfVTMuERbck75IXEqBNmPlgGm
         GKAq43NW/Dkn7gKxW0FdOfLQkIcQ5vxnWWpVJxSVfpdL9NfQMaYNFKrg7e0heUYDINcF
         DcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781566754; x=1782171554;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NMBz4B6FugIWzvzNwnXAHY1D03fO9BNg+Cee6zUOGJw=;
        b=PCUdcPF9CO9sOOSWWqz/uZ+3cA/2zy0CZQ/7RNrGIgQwcbN0niwvnJfywFN5QCkUhD
         GnaJD8mxxlgkxbZl+D7wJYpkdC8RBlSZ4VCgGnTMzPxvwVM2jzuXCV9a3V3SusgJDP5N
         4oqXpT5a5tyxE/xzfgDeP+hoqzOjEQ46q9Tawz5hdRsSEziS0z+asQ90CObcKGTzUSr2
         Euh120pEd30X0cYIbKRk90Qt0FFvwy4QqVj8X7aKoJiM8dcTsXXXv+px6jtcfbA0Rk99
         mnqqcGN9wFrAPhzK/B9ivQMfY9iGxOuoFQ5t/oA8sojic8nx3aeEtwk5315j0bfvgxQg
         Vjdg==
X-Gm-Message-State: AOJu0YwLTqXrZyKF/J0CGGaVmC/vtBiI1voIIBIrQkwOTdYF68Sv4WI5
	v5niT9M686DWIihDBDQ4NLlDmp64QzhQdSDNe3qANpalQxJNqK0rjMyjxH61SHYMCmk=
X-Gm-Gg: Acq92OFyvyVTFNeypZIvTaC4jJ9izQsBNebPU3dcK+ciSO/sty0CRZo4B1PJrISS1VF
	v/vnGdsxmFsRJdky9kBT4aTlSXD1w77VVcH7gb41avm25IQNaCQW0I38QYCqOw0PkyaqICqM12a
	LHfob8DqPQMRVdeOoMJcWKOtTlzF/yqfGBb5+7QOiUFXfFWTdudOGJCNeFjOXEGeBfDvkM9Tu2D
	0LrrosqAI4KdHEoJBY3/cb8qSboeLHeQDJqrXxGs7tWhQFVmGcslIJMJw14UAb2Ik6iGzn/uYRS
	uVXc/5TEBEJvaDJTcjT8YCv7/nENMgwo+hBgEDdLHtm7SGaEUzEpHhNoB7y3wiBTpFkdNRS4K+C
	3WacyhwwOpojGPWaO9uXhCF1SgCLUzidVoQ40dTyZllDEyv+6zVCHIvaniPRTfqW75mo8rpeSJJ
	CQmy7OgeO1SIEZFdttPyYf6Vz3vDuP8I6zsXG0zNOuLjEOsHhohouB8Mp5YbF+dPf7MrG0Z3cYt
	GBIFwc678FwozzjNsPFuh0xLiw4raouYlmIPGpbJM61jnE=
X-Received: by 2002:a17:906:5a59:b0:bef:87ca:aec5 with SMTP id a640c23a62f3a-bfe29f1fbaamr575009566b.47.1781566754106;
        Mon, 15 Jun 2026 16:39:14 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b00d4f5sm11010017b3a.43.2026.06.15.16.39.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 16:39:12 -0700 (PDT)
Message-ID: <317afb96-ab71-4f1e-9748-bf4b5598d157@suse.com>
Date: Tue, 16 Jun 2026 09:09:08 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: log swapfile activation/deactivation and warn
 about pinned block groups
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
References: <7c78c0a89b825e6bd3759e425a5e69ea338cf976.1781499135.git.wqu@suse.com>
 <CAL3q7H6G2gGuhKQ_v3nP-cKm+5xoM8YPt_jkOupO4Kc3Q2eQvw@mail.gmail.com>
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
In-Reply-To: <CAL3q7H6G2gGuhKQ_v3nP-cKm+5xoM8YPt_jkOupO4Kc3Q2eQvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/15 21:00, Filipe Manana 写道:
> On Mon, Jun 15, 2026 at 5:52 AM Qu Wenruo <wqu@suse.com> wrote:
>>
[...]
> 
> For relocation we don't log such a warning message, we just return
> -ETXTBSY in btrfs_relocate_block_group().
> It would be better to log a message here too.

We already have several different ones for them:

- btrfs_shrink_device()
- __btrfs_balance()

The above ones are all checking -ETXTBSY and give out a message.
The shrink one is warn level, but the balance one is info level.

I'll unify them into warn level.


The remaining ones are known not affected by swapfile:

- btrfs_reclaim_block_group()
   Pinned swapfile extents will prevent the bg from reclaiming.

- btrfs_relocate_sys_chunks()
   Swapfile extents can only exist in DATA chunks.

- relocating_repair_kthread()
   Zoned btrfs doesn't support NODATACOW/preallocation.

[...]
> 
> The phrasing is a bit misleading - it gives the idea that only the
> extents of a swap file cannot be scrubbed/balanced, i,.e. that other
> extents in the same block group can be scrubbed/balanced.
> We should make it clear that an entire block group cannot be
> scrubbed/balanced because it has extents used by a swapfiles.
> 
> Something like:
> 
> "block groups with swapfile extents will not be scrubbed or balanced"

Thanks for the better sentence.

Thanks,
Qu>
> Otherwise it looks fine to me, thanks.
> 
> 
>> +
>>          if (device)
>>                  sis->bdev = device->bdev;
>>          *span = bsi.highest_ppage - bsi.lowest_ppage + 1;
>> --
>> 2.54.0
>>
>>

