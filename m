Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BAA372B45
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 21:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788471550; cv=none; b=d6hoqHNNS4vXN7iTRiV+BxRqpn0zUvAjU2Mh93NUSwxa2Vo+/h/ubnXf7UZ8YxUy/vljJAU1jnvj5CizCidXlZXSHY/ACCU7lJzI8CMuIt8DFxE+Qm3G+JhpcODx1pI8j6Cqi8DcqS2zFAA4kN8M8UE7CA0kpH0sevDKv1DirMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788471550; c=relaxed/simple;
	bh=sth9O7vGnhr8iR5Zb3piUuXGkN8Yuleu7T6S31hMuOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BwCUafqAWFqaOG0QaWFUYfBL7fnTTtrmsQ1KEhEvlv5nJi5SbxK61yg4TwszwH4kWGMkdMUyZzXGWVoIxOdc/8Fowgbo5KimHsWENPXXoBwxqQCXfcPDI/ur1r+BZfBHDfT2EDTmsYstg0mlNPjKvL0IPY6rUI7eEJNeXkJz3oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N2sFohnC; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N2sFohnC"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49cd77e0f95so3344075e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2026 14:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788471547; x=1789076347; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=olHVLRl6xvoR4kf99wJbOE5Q68KbuZTES9T95dErUis=;
        b=N2sFohnCmtSZgHFas10uGoC/HzO2ovI2zOfj/X4aUMItUHZmSvIxZZhI+rNimQ8L9W
         VOwpGZZjYa1hhSehqjsOwTXh9wn1c2dmbiTuo0Nvx8BdxKsK1VtNMUB4mfs80oHK7b98
         KffB8QiU+HrrhrEg3cHcuVGhT7jAGfARzfQ9o053wlCdU9QslAFtTS2mlDUywbgcQhQr
         Tgv24bj/MpXjZNqWOpvVBhrZChvYjjFpdlsVqoCLcOVkTnrW2VQ/EDAUqKOib3es7Vz7
         i4Lby4nxmt0cEKbMgevrvsRmPU9A3MC2lZdLELHx6l95ORh9w5Yg5ICryyMS5xFmfTUG
         Vzjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788471547; x=1789076347;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=olHVLRl6xvoR4kf99wJbOE5Q68KbuZTES9T95dErUis=;
        b=sAEXT4/ejfYqsEG2eCmqb9U+dnMkvoesccJpRLWdEBH1BRe3rDH3NqC3c85zByHqbv
         pdCFvHhlll+8gNBTkcH5+4RiyhXAzcM3k9Frva0QqYkGx5q2KlQ+Vi0sCKQk0cWbpsK8
         dYGGP7nJrHKRtXvxUH2TGlVPdifShXI4qOv6aFHfsc4aerlfw1M/q/rDe4/FRDkn6z0u
         4/Va8ZEx6B5cNhjTO4uWp9aU5+7LJdq/ZmgktzRXzvR2EaQCaotp96ZtUGkBZ+85ii3v
         5lchf7CH3dFmTq/EE/Zq/y1HsmhqiKk52282KXzfU/jnF+QNfI/6LygagKyNvkfajY+a
         9FwA==
X-Forwarded-Encrypted: i=1; AKwUvBzb/YTojY/Dm4Ulu/CKNHjW1seXRkyX6eCLddKFUhBAk0Z4Zlxc2k7LyxdzvtDKVhx/xGuDzGHowgca3w==@vger.kernel.org
X-Gm-Message-State: AFuF++l3QVKRVfaMmMhjBP7ywZguFpiPxOPkQ0RIV5cO75wKtMb1i6JU
	ohn1DVUEHMEF+4BfPoX8IxHZ1jFfnVn8AHst3/fo6GhiJdeC94w8lp/8HiRz1yQ/hd8UJxio8Ns
	jTFZLjvuHng==
X-Gm-Gg: AYBFou3Xs7qwlu1xlhXwJSIcXkpvXbgjq5y0ExH+EHFCCmZvkh/ee3XrVzcUpf6GAmJ
	WyyIciuwPjj30CVzYut46eY4hhNMXJHkYrkbbfyqCfDiqgvPTRB5jfIA5USrmYXucEV0EDOBLyg
	biHgOzwvtiZ0cTsVL1Lbi6w02RcJ2/+jYiqcQTmzu4lGxS3c3b1PKgbm/Ag2Vf0XoYTrf6K/JGj
	cYBmT2q5BFEIUqH5MMySHuIwj0HZ0UIbaOm1xYysRmeAUTrTLqCwLcqQQ4fl4RStuzDbYwSVoUs
	CSSSpIH0YiiTqLNzQRxTrzz5iE/Hisqc6lKLj1LNIAcv9PjsHp0z66f7VaLQW6SsryyAospGuYv
	XzBePgFk6wz6jpES3OK5FpHduH5YSgl6SHWW+YTlzxLyIAtVf2Ocmk/UnkDvwESt0Yh59V15jva
	N6jV0j+sAQzh218xc8mMxUPbNbNhOLF9NRlhel/TgOgH8aVFlw0qqp
X-Received: by 2002:a05:600c:34c7:b0:499:adb4:a922 with SMTP id 5b1f17b1804b1-49cf825121fmr16215615e9.12.1788471547512;
        Thu, 03 Sep 2026 14:39:07 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b2615039asm851892a91.15.2026.09.03.14.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 14:39:06 -0700 (PDT)
Message-ID: <53ffa99c-fe53-4f00-a714-0fd4a8481f69@suse.com>
Date: Fri, 4 Sep 2026 07:08:57 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: tree-checker: validate name length for extref
 items
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <0fbde4f56df4c84aa62864a2641217fe2a8132c1.1788452841.git.fdmanana@suse.com>
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
In-Reply-To: <0fbde4f56df4c84aa62864a2641217fe2a8132c1.1788452841.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/4 01:57, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We are validating the name length of inode ref items, but we miss the same
> validation for extref items. Sashiko pointed this out while reviewing
> other patch. Add the missing validation, similar to what was done in commit
> 3dc22abc21f5 ("btrfs: tree-checker: validate INODE_REF's namelen").
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu> ---
>   fs/btrfs/tree-checker.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 3a0715798282..401fd40ec7b2 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -2032,6 +2032,13 @@ static int check_inode_extref(struct extent_buffer *leaf,
>   		}
>   
>   		namelen = btrfs_inode_extref_name_len(leaf, extref);
> +		if (unlikely(namelen == 0 || namelen > BTRFS_NAME_LEN)) {
> +			inode_ref_err(leaf, slot,
> +				"invalid inode extref name length, has %u expect [1, %u]",
> +				namelen, BTRFS_NAME_LEN);
> +			return -EUCLEAN;
> +		}
> +
>   		if (unlikely(ptr + sizeof(*extref) + namelen > end)) {
>   			inode_ref_err(leaf, slot,
>   				"inode extref overflow, ptr %lu end %lu namelen %u",

