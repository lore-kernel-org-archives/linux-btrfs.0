Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AF8242D6A
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 22:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778451184; cv=none; b=C0t80AridCDMj4GDmzwmsa92saTXatmp/J8QxF0hQvSKOAN8cyuNJ+bjZ26HB1GhpyBP4E6Tlsa/ZwaraUM0ciGXoyp39wH0zdhNwIrEjLR2aiI3fjo9NJwN1BdM9WuQmqfuqIOs2U88dJlhwWO95FSdB+SUkTEsS1BP6+B0IVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778451184; c=relaxed/simple;
	bh=ExGCFEf/x2UlK2fQmP1zsJeE/1DSLyEQNl9SlRdOuro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jSEtyOZzOcezeMTiEsfBHZqYD5fKK1O0UiZxABoYBIIL09iGne9AS5pgzStkbgfqTfFs4YWq1U6QZKcxK3++3ptzuvweOgq06GRczIXktVN0Jp3UXdklZRX+3JUJZZ0JLN4GDDUGm0/XhhZi05ywZI13/R0iOs7tKFeL1xzArBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WLRTgoS/; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WLRTgoS/"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso34673545e9.2
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 15:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778451181; x=1779055981; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jBvS4/CfkU/nhI9wlpzwR56DJi7lcCEmDFi5TzNkQAM=;
        b=WLRTgoS/hknqzF3dhzkXTZqe/7Xh0p0QtG8bEewa0B59EcTx8ZtgwMYLxsPOcXrTeC
         m/rfCoYbPUp7cmKNp0wljQLw/1aRy3WkZI3838U9OTF5EqvDcZUJ0BBBqH/3l0YT74wi
         I6PKglFmF8TnGANjzI8+P6Vz2Dv6xJvu4W/aHVFq04ptAOVjJ85s8KcSoP3HCsetCvCy
         mTM0uwGvdrWQgHGADp1HWICXErqOTd6bI9yo3CYm2iZgsz2TCVz0YppKC5ONjBsEVJ+B
         LcQSabpAdsNku11QitD+18hA8jlkhXAN3AQbTvGR65rpX4+KmHnOKZTIWWbZYTh0QCqU
         NRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778451181; x=1779055981;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jBvS4/CfkU/nhI9wlpzwR56DJi7lcCEmDFi5TzNkQAM=;
        b=OWeDuqorADjsusumZpuDstgo+TRbFxa6RfXyJO8tsTApJDDXyjGMrKYLlLCbU4kJx+
         L4WWnEptRhLnXTzVzkPDNgJKa3osHa7WEFulhhRbDcXgh0ySk1uyD/onwaAVAPAskxdB
         AWCUHUhFTzWlXNm3mVJw4J2dc9bC0GHIo9MhDbMM7OOrR//pgVp4R4Pmo9kzTXxLAF2q
         cHAQE3h4mIOSpRenWiOsx/1FODyJ5yblT7i6X1aBRlhjP7zEX0Neh5IvQX1TU9e4FtAq
         uaZcBEjaMAmiAdvvejpRgGZR+XFal1Z2FUlD8L3npwZ9ZTF47gYsTKH8H/NVLrOG4sMy
         4iMw==
X-Gm-Message-State: AOJu0Yxa4Mj5CelvfbV4YGSD5Vanfqj+nQZkKzx7rAGczeOWSqBZiY5I
	pBNszjnmLeDKwkrFIa2DJPq7IVoZ/s9jMm5BZcU/cbiNuvPzK3WjjEEdZPUZuE6Zf9Y=
X-Gm-Gg: Acq92OFxM7rpiNbSiTTzKEKR0gETobrgl17h+82GnbbPfhUyRdWBwN6UuWBVeAXQgvH
	3iygEzm/rz1JdCoGunhsdide9/G7iBSONvaOcDgb0vxSYSyuyFXB7hhacXrKqfrk9VsU7iLkWQx
	UyEfFYf3F+rT7Arp/ThV6Cg9ZmXL3YUZLBCNM/vJJ72EUk9kX09fXX1bE09DGANDo0wQdOlZ0zJ
	gUyu859e5rIB6+/lopgywIeiZSahX4BRHuQQNr0PHH42nG5+9K/2VecQNrMdpNxIYRqLPGJS9QN
	mIDcIgUO0sq6NJ4G5oJ+vKgMBSHXF9cqOATvVJktBW8nMViOSTahP+QyBdNsgcOEJzYYfqNcg/q
	GHqm3ETaxTx4JVDuOHEOsRqGCfAqwWdvkG2/2n//hb9MWT1VSPR0rvgyVmJmkjZTc6+tcyje3Mp
	S+7cOjR/bVDikAZZqYfMratov9AGDFakoNSuDaCVmKsV5HGBTCB58Ma7KX4K8vpujM2gbOKhrPq
	aw8EnLhan4oEch6PIyb80qCxsB8sCcgsU8jMKG6EfNCyy4=
X-Received: by 2002:a05:600c:3f18:b0:48e:5990:9698 with SMTP id 5b1f17b1804b1-48e5990978bmr296166975e9.24.1778451180630;
        Sun, 10 May 2026 15:13:00 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c826771c6ddsm7035722a12.23.2026.05.10.15.12.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2026 15:12:58 -0700 (PDT)
Message-ID: <2b94bd00-d2b4-427a-b181-5607f8298f44@suse.com>
Date: Mon, 11 May 2026 07:42:52 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: validate root ref names in tree-checker
To: Zhang Cen <rollkingzzc@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, zerocling0077@gmail.com, 2045gemini@gmail.com
References: <20260510074943.2644335-1-rollkingzzc@gmail.com>
 <qu-root-backref-20260510-161800@local>
 <20260510150322.3778139-1-rollkingzzc@gmail.com>
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
In-Reply-To: <20260510150322.3778139-1-rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/11 00:33, Zhang Cen 写道:
> ROOT_REF and ROOT_BACKREF items contain a struct btrfs_root_ref followed
> by the subvolume name. Several readers assume that this layout is already
> valid and then use the on-disk name length directly. A corrupted item can
> therefore make those readers address bytes outside the item, and
> BTRFS_IOC_GET_SUBVOL_INFO can copy too many bytes into its fixed-size UAPI
> name buffer.
> 
> Validate ROOT_REF and ROOT_BACKREF items in tree-checker before any reader
> uses them. Reject items smaller than struct btrfs_root_ref, reject records
> whose name_len does not exactly describe the remaining item payload, and
> reject names longer than BTRFS_SUBVOL_NAME_MAX.
> 
> For BTRFS_IOC_GET_SUBVOL_INFO, copy only the validated on-disk name_len and
> keep a local BTRFS_VOL_NAME_MAX guard for the fixed ioctl output field.
> Terminate the copied name explicitly.
> 
> Sanitizer validation reported:
> BUG: KASAN: slab-out-of-bounds in read_extent_buffer()
> Write of size 505 at addr ffff88810936d608
> Call trace:
>    read_extent_buffer()
>    btrfs_ioctl_get_subvol_info()
> 
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
> ---
> Changes since v2:
> - Regenerate the mail-ready patch without the nested mbox wrapper.
> - No code changes beyond the v2 fix.
> 
>   fs/btrfs/ioctl.c       | 17 +++++++++++++----
>   fs/btrfs/tree-checker.c | 39 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 52 insertions(+), 4 deletions(-)
> diff --git aa/fs/btrfs/ioctl.c bb/fs/btrfs/ioctl.c
> index a39460bf68a7..b43d33eaea07 100644
> --- aa/fs/btrfs/ioctl.c
> +++ bb/fs/btrfs/ioctl.c
> @@ -1956,7 +1956,8 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
>   	struct btrfs_root_ref *rref;
>   	struct extent_buffer *leaf;
>   	unsigned long item_off;
> -	unsigned long item_len;
> +	u32 item_size;

Move the declaration where it's really used, aka, the if () branch where 
it's first utilized.

> +	u16 name_len;
>   	int slot;
>   	int ret = 0;
>   
> @@ -2034,14 +2035,21 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
>   			subvol_info->parent_id = key.offset;
>   
>   			rref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
> +			item_size = btrfs_item_size(leaf, slot);
> +			name_len = btrfs_root_ref_name_len(leaf, rref);
> +			if (name_len > item_size - sizeof(*rref) ||
> +			    name_len > BTRFS_VOL_NAME_MAX) {

Those conditions are already checked in tree-checker.
And you return -EUCLEAN without any error message.

An ASSERT() will be more than enough, and I even prefer not to have an 
ASSERT().

And that's the idea of tree-checker, we validate everything (that we can 
validate) in tree-checker, so that callers won't need to bother 
re-checking them at random location again and again.

> +				ret = -EUCLEAN;
> +				goto out;
> +			}
> +
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
> +			subvol_info->name[name_len] = '\0';

No need to manually add terminating \0.

subvol_info is allocated by kzalloc_obj(), all members in 
subvol_info->name[] should be zero, and the BTRFS_VOL_NAME_MAX check 
ensured there is at least one byte left in name[] that is not touched.

>   		} else {
>   			ret = -ENOENT;
>   			goto out;
> diff --git aa/fs/btrfs/tree-checker.c bb/fs/btrfs/tree-checker.c
> index 1f15d0793a9c..41417b2df32d 100644
> --- aa/fs/btrfs/tree-checker.c
> +++ bb/fs/btrfs/tree-checker.c
> @@ -1371,6 +1371,38 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
>   	return 0;
>   }
>   
> +static int check_root_ref(struct extent_buffer *leaf, struct btrfs_key *key,
> +				  int slot)
> +{
> +	struct btrfs_root_ref *rref;
> +	u32 item_size = btrfs_item_size(leaf, slot);
> +	u32 name_len;
> +
> +	if (unlikely(item_size < sizeof(*rref))) {

There should be a name_len that is not zero.
So the check should be (item_size <= sizeof(*ref)).

Thanks,
Qu
