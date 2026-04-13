Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EA130EF6C
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 21:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776116884; cv=none; b=bVaUC7JO0M58+7FZxsCAUHK7KbtQbX6GJCmw0RniwdEW6KTFCmHJFKSSiWA+yewOYI5jxekvQjpSLGmpb9FNUlbqiKpB6Nband2DwEB9vkx/X4j262C9zTYUTstocsJNSp9Iv77wTrkzzEHvr4Pl98zOrYWGtXviYgQCmKnuv9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776116884; c=relaxed/simple;
	bh=zO0MfUL0CEEDPa/fl5raSjoZEhl2VsKRFRghyJHamLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jUhOcRjnLr0m6G0/zyugyAvt6c6LFLsg25D4AM9yjO0xTWfAIgI2wnfwVV3UZkIoJDq2NB4VOsqIvdiKNYO/21HoJGx9q3YpRXQ5M6gyuMZyJIOI8nabS7CQSKtatLYvaySszKI8yqIg39FOFtrmn+fc0GvWIJZe1IJxQSk1dY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=brDhN0NG; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="brDhN0NG"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488ad135063so47203025e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 14:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776116882; x=1776721682; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DNQGs34sgnshoxfUB8ncrjdUYbHue1FEAluL0OlImp4=;
        b=brDhN0NGGUBvZxCDREwRALu8W21xs5YxA7sm0F89o1RRkPL8oWpwWSxW+36kq9M/cD
         PdKUfc1OEfEYvuWb3Gy7RIMd8Xng9/A9h7rppjSILiV1XsE7av4GbVuREFWVQ3wZxn8Z
         kOvFtXvCcy0HRK45P/JV6U0mvTdrLwpRRzQaDjv1S64xpg0BFZinZpW+ETlKBqVaWvFR
         TghpS7yyx6ma9nWc6RiVBsa/82xTnVHBucgfr7uw2RzenXsuKEv4mJpKG6uXPDba9wKA
         wAme7a94f9zcyKphHL1YLxyt5q43BTyNpU7aGAS1DcFighSSkWY9Ip1O2H2jweUcRD4b
         9z2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776116882; x=1776721682;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DNQGs34sgnshoxfUB8ncrjdUYbHue1FEAluL0OlImp4=;
        b=iEejpklVEyYkCc/CxPbQFAGKeGhGFX2E815cUPIUFxmEGeyqKVnz7z8WjyGP6MvAOx
         ScKxhtBixHVL+wX0phbwpwvI1dHOJUaDvrhZhdlFZjfazEFTG8eSfuvuTzc/uSEHRWQH
         I7nfxTufuHVRpBQ+Bx5BEzWRSigCxDiT7lI7DdLfQdT85MLVcGnt15m384HfNaCeAFmt
         IKBwHN6qC/vVfwwtLJQn0Est+yOiPWyM0JcZguaP/KhMRKWb5SypnOXkj2TZ6w/C4Km/
         dzd8fHKI9stKcSuQBDZZ0YvVcP5fwVC4CYUhA8906V/GtEQ0CejdPk5b5xdYU2pob5m7
         2VgA==
X-Gm-Message-State: AOJu0Ywiy+kdGXvpH6oAvxMGBdB/D+7C37Pt49A4/FS6Cfyf0lBoRY3I
	9zc7Od7TFgEo0zpjkfVQJv+nuQ+b+HGW3kuFZERl3ScaCAYNBE6AAOHDnomR60qv3ho=
X-Gm-Gg: AeBDiest4WhkE+UU/3r9avT41hGR+yZsilrEXfczkj8y6mS6KED5lBh45vhzoUC5AvU
	zjBfiiY0gLt6SsrOcwMMAzOohlROV6yRIBGyZ/9mcTfAH0/sdSr5kmFz5bSUPTq/SxpBZ9hLKHn
	kTOVhABwKGpjj0w5rlt30vaz3Bvnj7thuYeHIMc2VR1UjvXAr7DEQH+dDUAqT+uYc2F0uJKcZ4M
	zZeYyTST2HxHY1XzhmynNV+798SWeFLdPSuUQ552sMRAGf2d/IwoqkRSYh7/NuDCvRA+wnhFgVK
	yCeDSRrrZAcbX/XqFS8PHFcBD2d72ptgWdKRxhm1pl9IqhAktfin1sqKUvsFs3fAm9Jtq7K7HZR
	lkmU9ehqW2aJU+Ldwfu43aZ9oYqlOX5z98OAUv3rqtrw2NLWFTXKTs0L6RFBlw1hLYTOCv9iQmx
	VMPg+NDgqnHmM7bBdNm5dpAoYotNLY1/e4LK0w8cREUwBokCO0JTC0nkx+Xqc98w==
X-Received: by 2002:a05:600c:8585:b0:488:ba19:da25 with SMTP id 5b1f17b1804b1-488d6822a0bmr149591075e9.12.1776116881664;
        Mon, 13 Apr 2026 14:48:01 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4dabca4sm126079575ad.15.2026.04.13.14.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 14:48:00 -0700 (PDT)
Message-ID: <10492f55-d744-478e-872f-1dc2bd03e680@suse.com>
Date: Tue, 14 Apr 2026 07:17:55 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: apply first key check for readahead when possible
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <49ae0f6badb787c1111daff252f034b7ae94f257.1775991651.git.wqu@suse.com>
 <20260413175638.GC12792@twin.jikos.cz>
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
In-Reply-To: <20260413175638.GC12792@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/14 03:26, David Sterba 写道:
> On Sun, Apr 12, 2026 at 08:31:05PM +0930, Qu Wenruo wrote:
>> Currently for tree block readahead we never pass a
>> btrfs_tree_parent_check with @has_first_key set.
>>
>> Without @has_first_key set, btrfs will skip the following extra
>> checks:
>>
>> - Header generation check
>>    This is a minor one.
>>
>> - Empty leaf/node checks
>>    This is more serious, for certain trees like the csum tree, they are
>>    allowed to be empty, thus an empty leaf can pass the tree checker.
>>    But if there is a parent node for such an empty leaf, it indicates
>>    corruption.
>>
>>    Without @has_first_key set, we can no longer detect such a problem.
>>
>>    In fact there is already a fuzzed image report that a corrupted csum
>>    leaf which has zero nritems but still has a parent node can trigger
>>    a BUG_ON() during csum deletion.
>>
>> However there are only two call sites of btrfs_readahead_tree_block():
>>
>> - Inside relocate_tree_blocks()
>>    At this call site we are trying to grab the first key of the tree
>>    block, thus we are not able to pass a @first_key parameter.
>>
>> - Inside btrfs_readahead_node_child()
>>    This is the more common call site, where we have the parent node and
>>    want to readahead the child tree blocks.
>>
>>    In this case we can easily grab the node key and pass it for checks.
>>
>> Add a new parameter @first_key to btrfs_readahead_tree_block() and pass
>> the node key to it inside btrfs_readahead_node_child().
>>
>> This should plug the gap in empty leaf detection during readahead.
>>
>> Link: https://lore.kernel.org/linux-btrfs/20260409071255.3358044-1-gality369@gmail.com/
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 
>> ---
>>   fs/btrfs/extent_io.c  | 16 +++++++++++++---
>>   fs/btrfs/extent_io.h  |  3 ++-
>>   fs/btrfs/relocation.c |  2 +-
>>   3 files changed, 16 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 3f59fb0a9ee5..4d5605aaf827 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -4635,15 +4635,21 @@ int try_release_extent_buffer(struct folio *folio)
>>    * to read the block we will not block on anything.
>>    */
>>   void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
>> -				u64 bytenr, u64 owner_root, u64 gen, int level)
>> +				u64 bytenr, u64 owner_root, u64 gen, int level,
>> +				const struct btrfs_key *first_key)
>>   {
>>   	struct btrfs_tree_parent_check check = {
>>   		.level = level,
>> -		.transid = gen
>> +		.transid = gen,
> 
> It's not necessary to add the "," or was there another reason?

My bad, I was originally also setting @has_first_key there, but removed 
later without reverting this part back.

Will remove this change during merge.

Thanks,
Qu

> 
>>   	};
>>   	struct extent_buffer *eb;
>>   	int ret;
>>   
>> +	if (first_key) {
>> +		memcpy(&check.first_key, first_key, sizeof(struct btrfs_key));
>> +		check.has_first_key = true;
>> +	}
>> +
>>   	eb = btrfs_find_create_tree_block(fs_info, bytenr, owner_root, level);
>>   	if (IS_ERR(eb))
>>   		return;

