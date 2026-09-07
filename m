Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9805F23BCEE
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 00:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788740606; cv=none; b=GMmIvHoiWTXVAjr7KYApEw7jGKcVqTaFmWrPhAzZvALjG6rp2BIeZfg+H3V95SvcCTmZt7c1FuqVUL3gNMBp4P5QaA+Q1/vvKlftmBhLB9VxO/v/2pzW6pQRi+3s6wMsEkEbRcUsa/+K/jNENGXlhiXJlfb6kXNrxxadc4HoOeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788740606; c=relaxed/simple;
	bh=nf/53iVx1ixfTZhWAYgW12cYVM5gEpl/BK6YzERMD2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p1Z4tsyWRqmhTJoHB5LUiouquse78iLBIWoXltZOs8qcjel1c0MPdgg1830H1MQkgO1jk5u0h6KF7lRWTaEjXfyowFFoSl2bZY8Jwagy4SHr5jpxff9MK1Y5gd70fg6jvt3ylN04DG+kTzDE9UTNNL7y6vqaelF34zZmm+YQ/lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H4VO73yc; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H4VO73yc"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so41294715e9.3
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 17:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788740603; x=1789345403; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q32eSLiOmeomkMGaunec3rTfJwD0WJMGhGLmwkvfkQk=;
        b=H4VO73ycKB+LP6kWdMWwP4G2qfbB+AK8T/U5bPFLnF8+KD+Z2NgBf6xwDjT2VhDcZX
         TbOEP+KyWx0Dbu/7B8C8HeaPE6oEGWCAIobU51qrBYVwkWUmsD2zKSrCfK0CKcU2C5BH
         KXiCFPkTGOj98FmKtBC9wrvEQ4Vk1rohom4sj2EQFRnqBfX9Ot8STpKbB6v1V1DJ64oh
         EP5LZ+McPJ256w9L7cC86LV+PgwpjkXdO4q/olYapFplHBVpjkED3s9sbf/JJj5BNNoo
         ygIvAQJaVRIjDQ7f4ZIGmFzIIlPbcOXDjXvs5yTbtEoAAX8KiwWF6lxcVOXM2iZ9lFxH
         WFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788740603; x=1789345403;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q32eSLiOmeomkMGaunec3rTfJwD0WJMGhGLmwkvfkQk=;
        b=m81j72XRFqIYrNkFu7kvLwknGbG6YBFnxRuFJTVw7pEDE7SmvU39+NevMH3gzOu8l0
         4tgYW8tiN+m+QbNXSGgtpDRLkFTfyGQ9PHfMfj5llN5HFHulkgWn73Brg1cRuCQ15oF/
         81B4aWCk9/Te8LlTSh8Ssxl2VreYltyad/fRG4Ay0Ddj7aJGZgrHgatocOOt1jgqvFt2
         r3tvNrV916kOYqkTbahwOaJRb9jKW98/iqhRZEMYYXibbxya7PiGpLTHD3gCW+8XdFNm
         RPy32Zh0nOdGapwaQegCiRqektHDQ/+NXZPTYQufpfxYEC7TitMrVhAzZvQbUnAHZLg6
         lsVw==
X-Forwarded-Encrypted: i=1; AKwUvBxyCPpANwEDo0HzI2qEg/bkCJ7GME0HSfcur/OQ14R4OjrwC6Rl2G/bxsG8WOl+epZwT+2f6y1MM5W/2w==@vger.kernel.org
X-Gm-Message-State: AFuF++lOTf3wwU50mMI//4JAE6Kt/yBNJPm2POVrlMX2upjDFDKNqm84
	OEwJoD3IHpSPwk2U2tnjlWXffNPRbnll7XAlxU0nUQZJg2DuIhCgtTbkFRqpbnN2awQ=
X-Gm-Gg: AYBFou2UWf++y8Z1Hrzb8K/B468zDsQCK9nm24ajanMJMyPpEvVwXO4e4PfIGFkh+gF
	gKclmMB3JGkNVwT2fw8zL3pbzX7Dt2Mwpl8bybXxHUL1eUcChVpVPmX5wmi+8rXb8wM2ShsMDWl
	n00f1xqTm70y02mh6OdzKaGTXb82u4tw7fIp+zwB4Z29nXf/NUZOpgAYKfWhTfNkYpwUz0noYoN
	gbnn4a9Vg7o0cruG/TAXKm1DS5yZe6++FTOpEVt6+u9K+NwybO0gV2fF7CSQyto3fPUsBXOGxUf
	ItM0h4JSq40yLdk7W+qj0jqVG58dnkPQfMn0kY/jKjpIqnatsqvV+KA0UpWuHlkWdRi58vguSEf
	pKzVWivZVp3JoN2KB+gJDsQIJFbSpHxafVqXcQ3bDxdlpYNzlS4rkx4p2u9EX2iNHMQDj0kZj9p
	mdYhzHFOXUjPV+/owOqN30pfsj+Ap8C8y/O7VEmCC7JqWeHcxhUWpmdg==
X-Received: by 2002:a05:600c:8012:b0:49c:d818:8764 with SMTP id 5b1f17b1804b1-49cf826818dmr203525515e9.11.1788740602500;
        Sun, 06 Sep 2026 17:23:22 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243767e1sm19279901c88.6.2026.09.06.17.23.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Sep 2026 17:23:21 -0700 (PDT)
Message-ID: <e1dd5a75-9a67-4bc6-b8d8-bfff79b5b907@suse.com>
Date: Mon, 7 Sep 2026 09:53:14 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] btrfs: rename io_ctl page helpers to folio helpers
To: Tal Zussman <tz2294@columbia.edu>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
 <20260906-btrfs-folio-conversions-v1-10-834b9d7b06f5@columbia.edu>
 <3f82fc56-b621-4d94-9079-b4984dc3823b@gmx.com>
 <ee1e1ce6-123b-4f98-bf1c-ef8e5d892baa@columbia.edu>
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
In-Reply-To: <ee1e1ce6-123b-4f98-bf1c-ef8e5d892baa@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/7 08:50, Tal Zussman 写道:
> On 9/7/26 2:12 AM, Qu Wenruo wrote:
>> 在 2026/9/7 07:59, Tal Zussman 写道:
>>> These functions now operate on folios. Rename them and update comments
>>> accordingly.
>>
>> Again, v1 space cache is fully disabled since commit 545e560a5b0f
>> ("btrfs: disable v1 space cache"), it would make more sense to remove
>> those functions other than doing a rename for codes that we're going to
>> remove anyway.
>>
> 
> No problem, I can drop this and patch 8. I wasn't sure what the removal
> timeline looked like and wanted to keep things consistent.

Would appreciate a lot if you are also interested in removing those v1 
space cache code.

> 
>>>
>>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>>> ---
>>>    fs/btrfs/free-space-cache.c | 78 ++++++++++++++++++++++-----------------------
>>>    1 file changed, 39 insertions(+), 39 deletions(-)
>>>
>>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>>> index ab933ee6f19c..73cfc1d1a5c1 100644
>>> --- a/fs/btrfs/free-space-cache.c
>>> +++ b/fs/btrfs/free-space-cache.c
>>> @@ -406,7 +406,7 @@ static void io_ctl_free(struct btrfs_io_ctl *io_ctl)
>>>    	io_ctl->folios = NULL;
>>>    }
>>>    
>>> -static void io_ctl_unmap_page(struct btrfs_io_ctl *io_ctl)
>>> +static void io_ctl_unmap_folio(struct btrfs_io_ctl *io_ctl)
>>>    {
>>>    	if (io_ctl->cur) {
>>>    		io_ctl->cur = NULL;
>>> @@ -414,7 +414,7 @@ static void io_ctl_unmap_page(struct btrfs_io_ctl *io_ctl)
>>>    	}
>>>    }
>>>    
>>> -static void io_ctl_map_page(struct btrfs_io_ctl *io_ctl, int clear)
>>> +static void io_ctl_map_folio(struct btrfs_io_ctl *io_ctl, int clear)
>>>    {
>>>    	ASSERT(io_ctl->index < io_ctl->num_folios);
>>>    	io_ctl->folio = io_ctl->folios[io_ctl->index++];
>>> @@ -425,11 +425,11 @@ static void io_ctl_map_page(struct btrfs_io_ctl *io_ctl, int clear)
>>>    		clear_page(io_ctl->cur);
>>>    }
>>>    
>>> -static void io_ctl_drop_pages(struct btrfs_io_ctl *io_ctl)
>>> +static void io_ctl_drop_folios(struct btrfs_io_ctl *io_ctl)
>>>    {
>>>    	int i;
>>>    
>>> -	io_ctl_unmap_page(io_ctl);
>>> +	io_ctl_unmap_folio(io_ctl);
>>>    
>>>    	for (i = 0; i < io_ctl->num_folios; i++) {
>>>    		if (io_ctl->folios[i]) {
>>> @@ -439,7 +439,7 @@ static void io_ctl_drop_pages(struct btrfs_io_ctl *io_ctl)
>>>    	}
>>>    }
>>>    
>>> -static int io_ctl_prepare_pages(struct btrfs_io_ctl *io_ctl, bool uptodate)
>>> +static int io_ctl_prepare_folios(struct btrfs_io_ctl *io_ctl, bool uptodate)
>>>    {
>>>    	struct folio *folio;
>>>    	struct inode *inode = io_ctl->inode;
>>> @@ -453,7 +453,7 @@ static int io_ctl_prepare_pages(struct btrfs_io_ctl *io_ctl, bool uptodate)
>>>    					    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
>>>    					    mask);
>>>    		if (IS_ERR(folio)) {
>>> -			io_ctl_drop_pages(io_ctl);
>>> +			io_ctl_drop_folios(io_ctl);
>>>    			return PTR_ERR(folio);
>>>    		}
>>>    
>>> @@ -461,7 +461,7 @@ static int io_ctl_prepare_pages(struct btrfs_io_ctl *io_ctl, bool uptodate)
>>>    		if (ret < 0) {
>>>    			folio_unlock(folio);
>>>    			folio_put(folio);
>>> -			io_ctl_drop_pages(io_ctl);
>>> +			io_ctl_drop_folios(io_ctl);
>>>    			return ret;
>>>    		}
>>>    
>>> @@ -472,13 +472,13 @@ static int io_ctl_prepare_pages(struct btrfs_io_ctl *io_ctl, bool uptodate)
>>>    			if (folio->mapping != inode->i_mapping) {
>>>    				btrfs_err(BTRFS_I(inode)->root->fs_info,
>>>    					  "free space cache page truncated");
>>> -				io_ctl_drop_pages(io_ctl);
>>> +				io_ctl_drop_folios(io_ctl);
>>>    				return -EIO;
>>>    			}
>>>    			if (!folio_test_uptodate(folio)) {
>>>    				btrfs_err(BTRFS_I(inode)->root->fs_info,
>>>    					   "error reading free space cache");
>>> -				io_ctl_drop_pages(io_ctl);
>>> +				io_ctl_drop_folios(io_ctl);
>>>    				return -EIO;
>>>    			}
>>>    		}
>>> @@ -492,7 +492,7 @@ static int io_ctl_prepare_pages(struct btrfs_io_ctl *io_ctl, bool uptodate)
>>>    
>>>    static void io_ctl_set_generation(struct btrfs_io_ctl *io_ctl, u64 generation)
>>>    {
>>> -	io_ctl_map_page(io_ctl, 1);
>>> +	io_ctl_map_folio(io_ctl, 1);
>>>    
>>>    	/*
>>>    	 * Skip the csum areas.  If we don't check crcs then we just have a
>>> @@ -521,7 +521,7 @@ static int io_ctl_check_generation(struct btrfs_io_ctl *io_ctl, u64 generation)
>>>    		btrfs_err_rl(io_ctl->fs_info,
>>>    			"space cache generation (%llu) does not match inode (%llu)",
>>>    				cache_gen, generation);
>>> -		io_ctl_unmap_page(io_ctl);
>>> +		io_ctl_unmap_folio(io_ctl);
>>>    		return -EIO;
>>>    	}
>>>    	io_ctl->cur += sizeof(u64);
>>> @@ -539,7 +539,7 @@ static void io_ctl_set_crc(struct btrfs_io_ctl *io_ctl, int index)
>>>    
>>>    	crc = crc32c(crc, io_ctl->orig + offset, PAGE_SIZE - offset);
>>>    	btrfs_crc32c_final(crc, (u8 *)&crc);
>>> -	io_ctl_unmap_page(io_ctl);
>>> +	io_ctl_unmap_folio(io_ctl);
>>>    	tmp = folio_address(io_ctl->folios[0]);
>>>    	tmp += index;
>>>    	*tmp = crc;
>>> @@ -561,13 +561,13 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
>>>    	tmp += index;
>>>    	val = *tmp;
>>>    
>>> -	io_ctl_map_page(io_ctl, 0);
>>> +	io_ctl_map_folio(io_ctl, 0);
>>>    	crc = crc32c(crc, io_ctl->orig + offset, PAGE_SIZE - offset);
>>>    	btrfs_crc32c_final(crc, (u8 *)&crc);
>>>    	if (val != crc) {
>>>    		btrfs_err_rl(io_ctl->fs_info,
>>>    			"csum mismatch on free space cache");
>>> -		io_ctl_unmap_page(io_ctl);
>>> +		io_ctl_unmap_folio(io_ctl);
>>>    		return -EIO;
>>>    	}
>>>    
>>> @@ -595,12 +595,12 @@ static int io_ctl_add_entry(struct btrfs_io_ctl *io_ctl, u64 offset, u64 bytes,
>>>    
>>>    	io_ctl_set_crc(io_ctl, io_ctl->index - 1);
>>>    
>>> -	/* No more pages to map */
>>> +	/* No more folios to map */
>>>    	if (io_ctl->index >= io_ctl->num_folios)
>>>    		return 0;
>>>    
>>> -	/* map the next page */
>>> -	io_ctl_map_page(io_ctl, 1);
>>> +	/* map the next folio */
>>> +	io_ctl_map_folio(io_ctl, 1);
>>>    	return 0;
>>>    }
>>>    
>>> @@ -610,24 +610,24 @@ static int io_ctl_add_bitmap(struct btrfs_io_ctl *io_ctl, void *bitmap)
>>>    		return -ENOSPC;
>>>    
>>>    	/*
>>> -	 * If we aren't at the start of the current page, unmap this one and
>>> +	 * If we aren't at the start of the current folio, unmap this one and
>>>    	 * map the next one if there is any left.
>>>    	 */
>>>    	if (io_ctl->cur != io_ctl->orig) {
>>>    		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
>>>    		if (io_ctl->index >= io_ctl->num_folios)
>>>    			return -ENOSPC;
>>> -		io_ctl_map_page(io_ctl, 0);
>>> +		io_ctl_map_folio(io_ctl, 0);
>>>    	}
>>>    
>>>    	copy_page(io_ctl->cur, bitmap);
>>>    	io_ctl_set_crc(io_ctl, io_ctl->index - 1);
>>>    	if (io_ctl->index < io_ctl->num_folios)
>>> -		io_ctl_map_page(io_ctl, 0);
>>> +		io_ctl_map_folio(io_ctl, 0);
>>>    	return 0;
>>>    }
>>>    
>>> -static void io_ctl_zero_remaining_pages(struct btrfs_io_ctl *io_ctl)
>>> +static void io_ctl_zero_remaining_folios(struct btrfs_io_ctl *io_ctl)
>>>    {
>>>    	/*
>>>    	 * If we're not on the boundary we know we've modified the page and we
>>> @@ -636,10 +636,10 @@ static void io_ctl_zero_remaining_pages(struct btrfs_io_ctl *io_ctl)
>>>    	if (io_ctl->cur != io_ctl->orig)
>>>    		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
>>>    	else
>>> -		io_ctl_unmap_page(io_ctl);
>>> +		io_ctl_unmap_folio(io_ctl);
>>>    
>>>    	while (io_ctl->index < io_ctl->num_folios) {
>>> -		io_ctl_map_page(io_ctl, 1);
>>> +		io_ctl_map_folio(io_ctl, 1);
>>>    		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
>>>    	}
>>>    }
>>> @@ -666,7 +666,7 @@ static int io_ctl_read_entry(struct btrfs_io_ctl *io_ctl,
>>>    	if (io_ctl->size >= sizeof(struct btrfs_free_space_entry))
>>>    		return 0;
>>>    
>>> -	io_ctl_unmap_page(io_ctl);
>>> +	io_ctl_unmap_folio(io_ctl);
>>>    
>>>    	return 0;
>>>    }
>>> @@ -681,7 +681,7 @@ static int io_ctl_read_bitmap(struct btrfs_io_ctl *io_ctl,
>>>    		return ret;
>>>    
>>>    	copy_page(entry->bitmap, io_ctl->cur);
>>> -	io_ctl_unmap_page(io_ctl);
>>> +	io_ctl_unmap_folio(io_ctl);
>>>    
>>>    	return 0;
>>>    }
>>> @@ -797,7 +797,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
>>>    
>>>    	readahead_cache(inode);
>>>    
>>> -	ret = io_ctl_prepare_pages(&io_ctl, true);
>>> +	ret = io_ctl_prepare_folios(&io_ctl, true);
>>>    	if (ret)
>>>    		goto out;
>>>    
>>> @@ -869,7 +869,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
>>>    		num_entries--;
>>>    	}
>>>    
>>> -	io_ctl_unmap_page(&io_ctl);
>>> +	io_ctl_unmap_folio(&io_ctl);
>>>    
>>>    	/*
>>>    	 * We add the bitmaps at the end of the entries in order that
>>> @@ -882,13 +882,13 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
>>>    			goto free_cache;
>>>    	}
>>>    
>>> -	io_ctl_drop_pages(&io_ctl);
>>> +	io_ctl_drop_folios(&io_ctl);
>>>    	ret = 1;
>>>    out:
>>>    	io_ctl_free(&io_ctl);
>>>    	return ret;
>>>    free_cache:
>>> -	io_ctl_drop_pages(&io_ctl);
>>> +	io_ctl_drop_folios(&io_ctl);
>>>    
>>>    	spin_lock(&ctl->tree_lock);
>>>    	__btrfs_remove_free_space_cache(ctl);
>>> @@ -1280,7 +1280,7 @@ cleanup_write_cache_enospc(struct inode *inode,
>>>    			   struct btrfs_io_ctl *io_ctl,
>>>    			   struct extent_state **cached_state)
>>>    {
>>> -	io_ctl_drop_pages(io_ctl);
>>> +	io_ctl_drop_folios(io_ctl);
>>>    	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
>>>    			    cached_state);
>>>    }
>>> @@ -1297,7 +1297,7 @@ static int __btrfs_wait_cache_io(struct btrfs_root *root,
>>>    	if (!inode)
>>>    		return 0;
>>>    
>>> -	/* Flush the dirty pages in the cache file. */
>>> +	/* Flush the dirty folios in the cache file. */
>>>    	ret = flush_dirty_cache(inode);
>>>    	if (ret)
>>>    		goto out;
>>> @@ -1402,8 +1402,8 @@ static int __btrfs_write_out_cache(struct inode *inode,
>>>    		spin_unlock(&block_group->lock);
>>>    	}
>>>    
>>> -	/* Lock all pages first so we can lock the extent safely. */
>>> -	ret = io_ctl_prepare_pages(io_ctl, false);
>>> +	/* Lock all folios first so we can lock the extent safely. */
>>> +	ret = io_ctl_prepare_folios(io_ctl, false);
>>>    	if (ret)
>>>    		goto out_unlock;
>>>    
>>> @@ -1443,10 +1443,10 @@ static int __btrfs_write_out_cache(struct inode *inode,
>>>    	if (ret)
>>>    		goto out_nospc;
>>>    
>>> -	/* Zero out the rest of the pages just to make sure */
>>> -	io_ctl_zero_remaining_pages(io_ctl);
>>> +	/* Zero out the rest of the folios just to make sure */
>>> +	io_ctl_zero_remaining_folios(io_ctl);
>>>    
>>> -	/* Everything is written out, now we dirty the pages in the file. */
>>> +	/* Everything is written out, now we dirty the folios in the file. */
>>>    	i_size = i_size_read(inode);
>>>    	for (int i = 0; i < round_up(i_size, PAGE_SIZE) / PAGE_SIZE; i++) {
>>>    		u64 dirty_start = i * PAGE_SIZE;
>>> @@ -1461,17 +1461,17 @@ static int __btrfs_write_out_cache(struct inode *inode,
>>>    	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
>>>    		up_write(&block_group->data_rwsem);
>>>    	/*
>>> -	 * Release the pages and unlock the extent, we will flush
>>> +	 * Release the folios and unlock the extent, we will flush
>>>    	 * them out later
>>>    	 */
>>> -	io_ctl_drop_pages(io_ctl);
>>> +	io_ctl_drop_folios(io_ctl);
>>>    	io_ctl_free(io_ctl);
>>>    
>>>    	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
>>>    			    &cached_state);
>>>    
>>>    	/*
>>> -	 * at this point the pages are under IO and we're happy,
>>> +	 * at this point the folios are under IO and we're happy,
>>>    	 * The caller is responsible for waiting on them and updating
>>>    	 * the cache and the inode
>>>    	 */
>>>
>>
> 

