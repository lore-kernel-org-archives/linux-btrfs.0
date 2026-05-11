Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D563B8958
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 08:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778488826; cv=none; b=DFIEAP5wlVd87B/wI03Hu9YMiDw/9VvnMUDmYPNDD0EsEKy6/VFiWlpKIEwY1agcP+OTpjWiH4jVu6VXEDj7ghPHMhbUEM0SRu8d7qaBZviMRa/QH7EVmTvCYiE8rzPaI8ibvz4rGVmSNbl//jQhjbYR9MR2svsKjTU+culqHfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778488826; c=relaxed/simple;
	bh=RUNXuCNauhj/Bd4/obWnFWGyixluJtJbNGGLq5Vo68A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TythUxj5S0nCBW2x20BjcGecGfIkdsoMqmOU1+HQfLa+AaafXO/WAc8zRhAYgXD7+7Oxt07DygfzHwMBkFuZcl0ufRuJJixp5JE/Is/yYWjo9oR50X2My56YejiljHLJcM+PhbEs5GEVj1HiU8d3TWKdmxlxBxe+17qq8o+28ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Fq0NTbF5; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Fq0NTbF5"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso23720565e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 01:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778488819; x=1779093619; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CHxYnI+QBQYLNf1VV1LDxLeQyvkZ6upXWShDGuhGVQU=;
        b=Fq0NTbF5SKqG4eptIHaoXbNbFXz5KIAjCgD/wrLc/xtVebTg0Bxf8fnoIBX8IRHjxj
         gMneSf77mEEU+leYE5VzWEOKe/A3N4oy+iSB8a6kVBu7aOawyzg9hh4r7gYttEsPl69v
         zZ816vLlcVQ1G2GY1IJVHAS2NefkyXzcSTRbfMckmi7GgxNJFgmIKYpq2BpJadyfSIok
         t8Uujo9mJbn96iK0jOJsJhTp9ZpQhG5igl/oy7PcbQgEO9iu2eSA6qzOUJG6+6X3vEjl
         4IXrgIYc6ZI/MyXRuVUo/lFP0WjynBz5feVzXDSVol1IClufxsCIzdRToCf+sxA1jpQb
         zRzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778488819; x=1779093619;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CHxYnI+QBQYLNf1VV1LDxLeQyvkZ6upXWShDGuhGVQU=;
        b=OvPzJYU7Ze6uUfv29FIT4aXuMFWj/7P3afWHWv7ItJX9dqvrW+Z4ALx+J4iTP1T4Qc
         HPwlMTjbQ6LzKbusRiq0pfVDQt3u6FPII0r+CKVZK1s/50lOROMJcb8lHku2TDaPn1NY
         7Ik9t++ZMf3ZUovnJk45lbiZrWKyQh8IFpHhAD7o2fc0sM52mVM4GDQVi+PJnpp2XVk1
         7EubVeTlJusDTPyEIYPNKM00GGMfTF1C8Y6IcB2ombJbXnSRydkj9HipFhyfjIag3r2Y
         nWmn5sB2Eqh+zXQhdvJvHV8383gAzP10IefKO8Ww9u9rJaul/HRL27t25lLK01kA7ui9
         Tmyg==
X-Gm-Message-State: AOJu0YzZo0fNq6wh/4Q3giFvSZkX/XvfoEhNSAlRvs+KhK8Kw4rBliJD
	GLCc36ppwZAJ16qNl8FYw9S3tFLu4XFHNZ73hRi0S23oUZ8VpwpWOiHbWxTHcdnflpy4LTYIVvH
	vNvQs1kY=
X-Gm-Gg: Acq92OEP30asWIfN2hK3aOl48Mq48OlJXHuNfPJUgU/pRlftsCPITGAO0ExbhZH4XgO
	qycbMV2H3v2Inc8VbcF0e1sod2lSnMxSrBGXRZXSP1RBmjqsirS7x7SM/SPeuaMT0xCWTnhw7di
	clMOo+c3sz9mHYuR+fPfNJ5+OK8w4X3LLWfXTTckNP1t2Gi9EMbTUNPUqttuRaEc5IM0bsjEGsr
	0GdAyH+9OYnOKPSveiSN/1saZzm+4uSX69DsVipvJS6K11O/yb+3ErKdEGSVYI0+in0kszEXnNK
	X1VSscvtBGFLGsQUM8POcIDmPFvu4XcjIFvH3lL3ZmsD3mYku1txqAJJfXuYvakPDT5y0GaVuOw
	inLoS0BVGWwq+Mm8WxnAXrfj7dB4loQu22DuuODyfSGzKKA6wVYr4U8eOIILF6YlyIai7XxZBQr
	a39+J37+RLZ5mQ4bJX7L3vaYxZ7zlc1yDr/yTyhSwGwwQXzLPh66pWum3PiqpOHMyVVcsqPDVwf
	ufr0bxrgAJ7rrFOvh4gRoCAEoQtbJr4uy8TPPgSVgQj+PM=
X-Received: by 2002:a05:600c:45c5:b0:48e:526e:1040 with SMTP id 5b1f17b1804b1-48e676b45eamr206284435e9.23.1778488818679;
        Mon, 11 May 2026 01:40:18 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965c30ddasm24549775b3a.21.2026.05.11.01.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2026 01:40:17 -0700 (PDT)
Message-ID: <ac2708c1-e247-4b5d-bba5-fbf921cfb28a@suse.com>
Date: Mon, 11 May 2026 18:10:12 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] btrfs: validate root ref names in tree-checker
To: Zhang Cen <rollkingzzc@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, zerocling0077@gmail.com, 2045gemini@gmail.com
References: <20260511070128.2093775-1-rollkingzzc@gmail.com>
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
In-Reply-To: <20260511070128.2093775-1-rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/11 16:31, Zhang Cen 写道:
> ROOT_REF and ROOT_BACKREF items contain a struct btrfs_root_ref followed
> by the subvolume name. Several readers assume that this layout is already
> valid and then use the on-disk name length directly. A corrupted item can
> therefore make those readers address bytes outside the item, and
> BTRFS_IOC_GET_SUBVOL_INFO can copy too many bytes into its fixed-size UAPI
> name buffer.
> 
> Validate ROOT_REF and ROOT_BACKREF items in tree-checker before any reader
> uses them. Reject records that do not contain a non-empty name, whose
> name_len does not exactly describe the remaining item payload, or whose
> name exceeds BTRFS_NAME_LEN.
> 
> For BTRFS_IOC_GET_SUBVOL_INFO, copy only the validated on-disk name_len
> instead of deriving the copy length from the item size. The ioctl result is
> zeroed when allocated. That leaves the existing trailing zero byte
> untouched.
> 
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Will run a full test before merge.

Thanks,
Qu

> ---
>   fs/btrfs/ioctl.c        | 12 ++++++------
>   fs/btrfs/tree-checker.c | 36 ++++++++++++++++++++++++++++++++++++
>   2 files changed, 42 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a39460bf6..5958aa8c7 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1956,7 +1956,6 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
>   	struct btrfs_root_ref *rref;
>   	struct extent_buffer *leaf;
>   	unsigned long item_off;
> -	unsigned long item_len;
>   	int slot;
>   	int ret = 0;
>   
> @@ -2031,17 +2030,18 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
>   		btrfs_item_key_to_cpu(leaf, &key, slot);
>   		if (key.objectid == subvol_info->treeid &&
>   		    key.type == BTRFS_ROOT_BACKREF_KEY) {
> +			u16 name_len;
> +
>   			subvol_info->parent_id = key.offset;
>   
>   			rref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
> +			name_len = btrfs_root_ref_name_len(leaf, rref);
>   			subvol_info->dirid = btrfs_root_ref_dirid(leaf, rref);
>   
> -			item_off = btrfs_item_ptr_offset(leaf, slot)
> -					+ sizeof(struct btrfs_root_ref);
> -			item_len = btrfs_item_size(leaf, slot)
> -					- sizeof(struct btrfs_root_ref);
> +			item_off = btrfs_item_ptr_offset(leaf, slot) +
> +				   sizeof(*rref);
>   			read_extent_buffer(leaf, subvol_info->name,
> -					   item_off, item_len);
> +					   item_off, name_len);
>   		} else {
>   			ret = -ENOENT;
>   			goto out;
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 1f15d0793..b48520ff0 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1371,6 +1371,38 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
>   	return 0;
>   }
>   
> +static int check_root_ref(struct extent_buffer *leaf, struct btrfs_key *key,
> +			  int slot)
> +{
> +	struct btrfs_root_ref *rref;
> +	u32 item_size = btrfs_item_size(leaf, slot);
> +	u32 name_len;
> +
> +	if (unlikely(item_size <= sizeof(*rref))) {
> +		generic_err(leaf, slot,
> +			    "invalid root ref item size for key type %u, have %u expect > %zu",
> +			    key->type, item_size, sizeof(*rref));
> +		return -EUCLEAN;
> +	}
> +
> +	rref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
> +	name_len = btrfs_root_ref_name_len(leaf, rref);
> +	if (unlikely(name_len > BTRFS_NAME_LEN)) {
> +		generic_err(leaf, slot,
> +			    "root ref name too long for key type %u, have %u max %u",
> +			    key->type, name_len, BTRFS_NAME_LEN);
> +		return -EUCLEAN;
> +	}
> +	if (unlikely(item_size != sizeof(*rref) + name_len)) {
> +		generic_err(leaf, slot,
> +			    "invalid root ref item size for key type %u, have %u expect %zu",
> +			    key->type, item_size, sizeof(*rref) + name_len);
> +		return -EUCLEAN;
> +	}
> +
> +	return 0;
> +}
> +
>   __printf(3,4)
>   __cold
>   static void extent_err(const struct extent_buffer *eb, int slot,
> @@ -2226,6 +2258,10 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
>   	case BTRFS_ROOT_ITEM_KEY:
>   		ret = check_root_item(leaf, key, slot);
>   		break;
> +	case BTRFS_ROOT_REF_KEY:
> +	case BTRFS_ROOT_BACKREF_KEY:
> +		ret = check_root_ref(leaf, key, slot);
> +		break;
>   	case BTRFS_EXTENT_ITEM_KEY:
>   	case BTRFS_METADATA_ITEM_KEY:
>   		ret = check_extent_item(leaf, key, slot, prev_key);

