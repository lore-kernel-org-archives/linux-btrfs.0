Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A6F278161
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 22:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784846194; cv=none; b=UF6ZMLrHsymer7lk7FXYcox0O09G0rfb3e4Q2+qCNsr/ExliObWM4z+mGf+t/5DWkCQhUW2WWSnLSLOmdpZ9GsucEW4NS6ERh3IBf7Y8ZjFDRawW1EevLvW0y+gkFPlwRCENj+3VWVPN+H4dXpthA1RmCto1Wu7RwysQhqCJLl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784846194; c=relaxed/simple;
	bh=enlP2oz8Mv5JRiJutdQPMyj1Q9xMUEZjVZreA8e25pY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gJ/PJEZzOQlBMKs9uHSFUbwnkNZuSBo2KfmPO9GTOiTFVlA/i5Yf1rlxS0w5Wetavk0z4PqxKQPWbLdQui+du9Y+EM6xcHR18vGFci9QoiRR3AhIUKTg0Nh2BIT0BGctLKVNYqEAUdJtrRwK2WazKnlQYgQIeHoiq6n2QTkjYJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gYwG9klN; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gYwG9klN"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-698ab9aae16so1798161a12.3
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 15:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784846190; x=1785450990; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=baW2nsk5vIGwapUyyuDLo1Ql+XfUyHYSZyTNDCsFmWE=;
        b=gYwG9klN/VjsqN/L2vBxcH3gHN+KmCqQalZnE4f63LSJDNUIn9pGfrIExGiNIKYQcu
         zv5uFnYhzLb7rsNwuop88j7pmtJ/CDegVpBIfnj08+ZS5Tj1OR/S+p5Y/CCT9XGNrVPu
         RpLESzzcektstkHw7jEe2iilO+DcX5vkHpvoKsaraKD3XdSkFIe4TEkeOMmTJ5E+nCj7
         pxqMDUp53l9z8O/pvQTuFLs10yM3UyLlDTP9r0xuyKm0bt1lVaVGpCRqCnsRMkvDBB+q
         9a4RKOCbqDYCBCs/yjVxyukZnaL+0o/43p4zP6GsQIQt7mlkXmWpSCqUT7jlx9lSd/3W
         iIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784846190; x=1785450990;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=baW2nsk5vIGwapUyyuDLo1Ql+XfUyHYSZyTNDCsFmWE=;
        b=XXMTkev4Lg2b9LnHAqzed9fxhXkP9Jw9pFxdChZ12Q5dHd5l4a7mBW70mn4E5cZdm4
         O79X5jZ2bNStVS/zOF8S/Awd3ktG10bj99xfV0LkaqnF2VDba5Jzq2qRtoXhHDJjsHCR
         HEH5aBaeyNBloEvQxpvbNqDAR4GLDBQB57WcnEXzfS6MS0ZPrJKfSH3YCC3WiZ1fqslU
         jfwTsDYTuiR0JgfGnUL5r+lDcfbF7azs+LhYV9z97UOwcprqDrQzCntS/b1o1qnfm1zL
         WjuSj3DdbP6z9fz/6dCiWzuvAm6aub/eyzepv8qgk5LPER2O72J5y+Sz2OjM/liHPTpu
         H42A==
X-Gm-Message-State: AOJu0Yy7PURIsEM4xB9elxZ7J6wEXSBxTDcyjED3iqVLDUX2cBobwIEQ
	05sPxyv91bYQlNr8lXA5+zbWKXms1VInIYtNEjEBJqGikIR7tHB3rFqZi4IkYG9P/j8=
X-Gm-Gg: AR+sD13c9nsVutjqBOajku8f1WIVibDjMf1mNHOlahptjYf5IDMnZrfho4ip1qX02HY
	epDidUCsUu6Jd9QTO+YlDtCA06b3xy3FbgNvqFbjn9gZsBHWl+a71+P5MbKSY5yh9fhhgvtXohS
	by7EnowNT9K+j7kCLmiNrsKfcODbtd0mESXkPl1Faj8SgRLGXyq5cGQzRqcpe2phMFsV1xPI4jJ
	kFVyrcXg7xmxAkmDenLVq0M/pMEPXX54tmR3+oMPsRnIL9/tsQMAtNKG/dF92fZBhbfYsBDociF
	yqN3o498OcJBVW1v45WO9x7qERA1oqm4hFXfGcEeUtxvGteCIdlwalTeZtfFqLfFo1h2u3RdnPX
	4XH2D5lfbvJSl7vHufiB6AK88ArU3PRz5Dp4iDtF6a6v8ILv7FGGUwfS084VLY9wO5ATneDY=
X-Received: by 2002:a17:907:1784:b0:c16:8adf:f183 with SMTP id a640c23a62f3a-c1c509794aamr246773666b.14.1784846190367;
        Thu, 23 Jul 2026 15:36:30 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e16f75677sm3641197b3a.0.2026.07.23.15.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 15:36:29 -0700 (PDT)
Message-ID: <19676a9b-ee33-4e06-9287-fb79fa53fd4a@suse.com>
Date: Fri, 24 Jul 2026 08:06:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] allocate extent_buffer GFP_NOFAIL with unlocked
 retry
To: Boris Burkov <boris@bur.io>, David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1784673567.git.boris@bur.io>
 <20260723025857.GO10684@twin.jikos.cz>
 <20260723182802.GA788943@zen.localdomain>
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
In-Reply-To: <20260723182802.GA788943@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/24 03:58, Boris Burkov 写道:
> On Thu, Jul 23, 2026 at 04:58:57AM +0200, David Sterba wrote:
>> On Tue, Jul 21, 2026 at 03:42:11PM -0700, Boris Burkov wrote:
>>> >From sampled fleet data measuring lock holders that go into direct
>>> reclaim with a waiter present when they eventually unlock, we have
>>> observed ~15% of those are btrfs extent_buffer allocations in
>>> btrfs_search_slot() done while holding btree locks. This is the single
>>> largest category. Additionally, a large source of hung_task timeouts is
>>> both btree waiters and direct reclaiming btree allocations, which
>>> further motivates the desire to drive down this source of stalls and
>>> contention.
>>>
>>> The aim of this series is to allow us to allocate the extent_buffer,
>>> btrfs_folio_state, and the extent_buffer folios with GFP_NOWAIT then
>>> fallback with EAGAIN to outside the critical section to retry with
>>> GFP_NOFS | GFP_NOFAIL without any locks held.
>>>
>>> This is analogous to how we must drop locks to read an extent_buffer and
>>> then EAGAIN.
>>>
>>> The series does not manage to completely eliminate allocations from this
>>> lock holding path, as we also allocate inside xarray functions for the
>>> extent_buffer xarray and the btree_inode mapping xarray, the latter of
>>> which is done via filemap_add_folio() with no reserve type API. Luckily,
>>> those particular allocations are small cached slab allocations and have
>>> nearly no contribution to the production reclaim fueled contention.
>>>
>>> Changelog:
>>> v2:
>>> - rebase
>>> - dropped the inhibit array allocation patch
>>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>>
>> The logic makes sense to avoid the stalls. There's no sashiko review
>> because the patches did not apply. You may want to resend a rebased
>> version to see if I have missed something, there are minor typos or
>> style things but that can be fixed during merge.
> 
> Hmm, interesting. I rebased on the btrfs
> (git@github.com:btrfs/linux.git) for-next branch before resending, and
> it just rebased cleanly, and I was able to 'b4 shazam' this version onto
> for-next as well.
> 
> Am I messing up and using the wrong branch? Is sashiko?
> 

It is definitely sashiko, the base seems to be updated infrequently so 
that sometimes it didn't properly get the refreshed base and failed to 
apply.
