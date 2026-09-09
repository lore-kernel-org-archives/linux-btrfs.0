Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E411492E54
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2026 01:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788915979; cv=none; b=QFOn0sSagFVMVwyldwkRYZF3obTyHCAeD+N6mtzsg463lo1H4wLJp+MTUa7H68zwxIxuhfo6xl+ivTngadIUungyEw94bsIgdjUUfMFawhcFVP6lNjQ83nZTLJPbtifgddVsUFr0zfc7BYjyS9JaWnZNYq/dc8/sKUzlilgZ8oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788915979; c=relaxed/simple;
	bh=Z0TFSd966n6PMcN6H1IxRspxeMSfyAjCGMA6LHs6Dvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m/RDqvmzD6Ous87rC2he4FUkuei88AFiYGboSOmv+xmlxjSbcDICwxQzvicy6FhOsZJO5tGFlLdh8c4rnUZGtdju4/WaLF6XeObyAxJ9dHVdXk2fy74sbVZV37ncACAl/T3sV5FlBmEKsD2/3Wrr2Ttw07TD6VsBPTKgsw1X8b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Dp9qFtea; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Dp9qFtea"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-485abf3b93aso129500f8f.2
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 18:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788915976; x=1789520776; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P6vffU4LmzeDOpgGWfXr7ZABK8sEqb7rZKft6fChsF4=;
        b=Dp9qFtea7HrATfNrYu6o32SvqujFadRQGu+nBKXxFgJWwQxcJTM7vL8nUSFndtk2HM
         DR6zsJ8SKTCVRLgVtiIl/Qrz73WxcilGHAs2Q7YjyVFQcQnbZuINxJWkHdLhyTDgKUs6
         lFU10/zDr0w6FHKAK30eaGoNj+Phy5MTyoClRDumgAZvWmRRfx2qEfsDOpM32qjgt/yc
         So5UlrdKPnQ4WcS3DIWeq7x+7zh4S/Dmvyv7tMFtmP19FHtGT+CKFAsWjeWzrsQ1gf4v
         dc7yQSQoMbWT6IOgO2kr9vlBpCtXtX4B8Gj16fFOiqVmjdGrmzCsMm1aPiw2BvWnYk3k
         RNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788915976; x=1789520776;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P6vffU4LmzeDOpgGWfXr7ZABK8sEqb7rZKft6fChsF4=;
        b=pW5f4j49KOHTy/CZezaLKAE1vC9RpNQg7Y2uV/Qjbb/EIOwTHrXQePna3E42fkDxjG
         AfNXNUczWkklPMjCT4Ycrb22D0r+0joydsETDkdGlQDXA4D5QFmv3OtMLc3LoWfMkbzz
         BAQ8zUR5Fwz7MFWAr4dyCLaKPPj/mM8QF20yAXy6SYU2X62ZLtvb3CHN3BYuR10D52Ev
         41mbZ0mEjkWBxCWaDtB7Qf40o/U2UnxL0fDR61XEP+SwfqOfib6shLvxXUIg4yLTVA45
         oqlFCMmy+jqN9vZI87FOPM9+to0NQXfErd5Azmi3lXJ98W29mg00z7YJ0CnXPEwt+Mxk
         6ZjQ==
X-Gm-Message-State: AFuF++kJAVefBgcc/Xtedg4yFpPKsVHsiUCpGOQnuguyD9zLp31evS7b
	bzYoo+2AKmgkVLCHUJVVEwxSxP+Z20+NsxVAV8Deil7NAXCLek30+1UoEjPGLlOmI50=
X-Gm-Gg: AYBFou0ZZo3LsEScmlaCqytjGnfAcTmqybY5UUOL5akvtSpU+2e+0vo4IXMe+7slwxw
	RojAzsKTvg88XgTQAnpfreTIZBQQe1uCnCv5e26klfcUaIxZbd7wdTFMN+88MFE0i1SvLKE93Z6
	+wUBzQM/HdeYR2aIiGm1r6ymA1CYHjAsOJUzKsez1DInSURg70vQ7tBRlD+Ca3C7EW/DjAyvuKB
	tzrzPyjnXyNSv+5Q5vbkzENrYNptZZ0tfofBIuGB3DjuXBTAMEimv1V2JrNrsYWzS5QmmORW4KX
	5A5sPc4Q+560sqQhtYFKYzxGtLFftz+YH8zdRvHm3tc+C+g9dso0Haq2FlvG2UP8m7X37xfNQRr
	IkdOKBFMPae+v70kW9LMUUcylzD87dMPpd5i63q1xTseiQuJQUvUiJVAS7FljSBb658XJyM9irw
	zjKnrGSjaI5Z7+D41uRSTsm9IbUFcZN6dyCTfzyq+94nsfFfCG9AKUchhGoItEvoM=
X-Received: by 2002:a05:600c:1d08:b0:49b:96a0:5c00 with SMTP id 5b1f17b1804b1-49cf825168cmr345471775e9.13.1788915976342;
        Tue, 08 Sep 2026 18:06:16 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm33682206eec.4.2026.09.08.18.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 18:06:15 -0700 (PDT)
Message-ID: <f6eed62a-c9f6-4f0f-848e-e99445f46538@suse.com>
Date: Wed, 9 Sep 2026 10:36:10 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fwd: btrfs: OOM in split_item().
To: dsterba@suse.cz
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <nka8fLGwxf2NcMXCcuLi4CkGSIKrKG4Sc9IbvTTBG5L6T63w6tImgOKYEmu-pWaoZZFO4Eqg8zDyMggihfvlFRTd1Vubz6E52PVEhU83gn8=@protonmail.com>
 <250decb0-d940-4fe6-9b54-d06e1b293a1b@suse.com>
 <20260908131439.GC9053@twin.jikos.cz>
 <962e0f59-ca17-4467-b762-0b225df0d25f@suse.com>
 <20260909004439.GG9053@suse.cz>
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
In-Reply-To: <20260909004439.GG9053@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/9 10:14, David Sterba 写道:
> On Wed, Sep 09, 2026 at 06:57:59AM +0930, Qu Wenruo wrote:
>> 在 2026/9/8 22:44, David Sterba 写道:
>>> On Tue, Sep 08, 2026 at 07:45:58AM +0930, Qu Wenruo wrote:
>>>> Forwarded for archive purposes, as patchcheck requires a link: tag
>>>> following reported-by: tag.
>>>>
>>>> Meanwhile the original report is only a private mail to me.
>>>>
>>>> -------- 转发的消息 --------
>>>> 主题: 	btrfs: OOM in split_item().
>>>> 日期: 	Mon, 07 Sep 2026 20:10:56 +0000
>>>> 发件人: 	xavierbachmeyer182 <xavierbachmeyer182@protonmail.com>
>>>> 收件人: 	wqu@suse.com <wqu@suse.com>
>>>>
>>>>
>>>>
>>>> Hello.
>>>>
>>>> Attached is a kernel log entry showing a strange out of memory issue
>>>> that rarely seems to happen.
>>>> It's kind of annoying and makes me wish GFP_NOFS would go the way of the
>>>> dinosaur.
>>>
>>> What is the story behind that? One way or another we will get GPF_NOFS
>>> semantics, either the flag or the scoped NOFS and this limits the
>>> allocator.
>>
>> No extra follow up unfortunately.
> 
> For the record, as it was in a separate mail, that GFP_NOFS can
> sometimes fail because of page fragmentation and limited options for the
> allocator.
> 
>>> Using 64k nodes is problematic and so I'd rather people not use it on 4k
>>> systems.
>>
>> In fact the only problematic part in b-tree operation is exactly the
>> vmalloc() I'm fixing.
>>
>> Other than that I see no obvious problem related to 64K nodesize on 4K
>> page systems.
> 
> Technically if the allocation has a fallback then there's no problem. In
> practice the 64K contiguous memory needs to get shifted for almost every
> metadata insertion.

That is not true, at least not for all cases.

The 64K buffer is only needed when we got a huge item to split. 
Meanwhile the most common cases of btrfs items are all fixed sized.

Some have variable length like DIR items, but name length should not 
exceed 4K either.

The real exceptions are:

- XATTR items
   User can provide a huge XATTR, and the end user may even intentionally
   choose 64K nodesize just for such large XATTR support.

   This should be rare, but I still remember some users are using XATTR
   to store extra checksums.
   But on the other hand, such XATTR should not be split, so nothing to
   bother yet.

- Inline extents
   For 4K sectorsize it's never a problem, even for bs > ps support it's
   not a problem either as we do not allow inlined extent for extent
   larger than 4K.

   But it's still possible to hit a 64K inlined extent if it's created
   on 64K page systems, then mount on 4K page systems.

   It's not only very rare, but also we won't split the item, so again
   not to bother.

- Csum items
   This is the exact case we're hitting.

   The point here is, we can use as large as the whole leaf for a csum
   item.
   This makes split much harder, requiring a huge buffer for such split.

   I think we should introduce an artificial limit on the csum item size.
   Keep it 16K at max should greatly reduce the need for large buffer.
   And the cost is pretty minimal, just extra btrfs_items.
   At most it will be 3 * 25 bytes for 64K node size, I think it's
   definitely acceptable.

   By that, we also reduce the buffer requirement for such csum item
   split.

> COW requires the whole 64K set of pages to be
> allocated. So there's a lot of dead weight carried around.
> 
> It's a tradeoff, 4K nodesize would need taller b-tree for the same
> amount of raw items. This is worse due to lock contention and concurrent
> changes. I think the 16K is a reasonable middle ground.

It's a trade-off for nodesize selection, but for this particular csum 
item split, I think we should fix it no matter if you want to prevent 
64K node size or not.

Personally I do not want to discourage any valid nodesize/sectorsize 
combination.

> 
>> The way we handle metadata is already vmalloc() like, we allocate page
>> sized folios for 64K nodes anyway.
> 
> Yeah, that we've been heading towards large folios also means contiguous
> ranges for nodes. Memory management is aware of that and allocator
> should provides that by the means of compaction. I don't know how much
> it could be improved.

