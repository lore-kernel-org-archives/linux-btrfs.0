Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABF125B31D
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 22:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777328141; cv=none; b=u4OK3PUkbzhSVMy0EUTsRNcgjXw6k0mo9rtkvcda0aDWniDLn1AS/VzuZv4Up2exN+HJ23PXthU4g16uNoatoozLFFjfRs9jccFeXQjEouspy2JzldN0+YNFxuqo0c1EnTYK9dkhMjAl+PNRtNaXlhsfx9t7FKnxBri6sJ9ue7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777328141; c=relaxed/simple;
	bh=4sz4fGRhGLGWc8g0sgeM4O9gRfCJWCJCvcY+wj8wNvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oxXFVPHw1e/SqcI0LK8cArq1HN9jYsN8LGRLwgBVl/6CAACBMmWjA2o5SuzLTtmHIJtOWhYINdLWkmOnDKsomU16N0i/LzRhang0tZOJYnI4b7D+ALKTmjlyZiHM/agu8k+T4fymEEAgVvyGvL2agsk8wfWum2bZNZMz+VhEV8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Di9H4bgo; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Di9H4bgo"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488a14c31eeso88869595e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 15:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777328138; x=1777932938; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=t2+ieBwo+xn3ZHSYjVYdxB0SEdC5QVsUiaN0W+mruxQ=;
        b=Di9H4bgoRoB46NmBWTbPWzNIyk88ZzTUUugjMAimzEwJGAF31Gu/1j6CrLxWhGQmc6
         xEogPmUlws0ijy3iyOmmGV7yV59473nZtmCNg9uoNDBiqXCtILEoeQA8brStZNP5wZaR
         UfbXNJYftyCsNyTFzdDCvOnnb5s2rhFOPLhsymkvLJBswPYvkCQRWfCPnmwmLFIMiUpk
         7UWTiWsoj29YwMJBqM5urbzmnx1VRavs1qBzl0MAkpmkNjKy1pc0daLr1vP/hAr7OcAl
         8ZMl5vetc9bjq71DutRrqBQ74lvZ/4mGw2UxujBnJkI9QBbJ8LaqBOZiAB8gmBIWhCUz
         vuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777328138; x=1777932938;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t2+ieBwo+xn3ZHSYjVYdxB0SEdC5QVsUiaN0W+mruxQ=;
        b=kbhdmX0zW2/z+ugiDRzEHM2OyL3OXPRGDaHVuPbHNBK5YN9o8FFeK/eVj4kAjRnlCI
         Fj8uGVHLm29XFCvj9WaDFSZc9m/iaN3D30A33LY9L6CSKcK5zj+WPt8PKgxvXB+lILDW
         8RWcvfDU9TFbb9da1eF6VrerAT98Z5hZ1eQgqcoj2e3Jd3tfKyUioXHKj0DS3cT40NFn
         zpb57VlY1u2otglZdjuopKx0464jzRYH9chLblt+3r/7s3eJYgYCHx8FoPaRq+CYLqUR
         TYyFog+6K5MGNn6I6dt2nmTkLAQs7ztKP9qD1W1V2bWhgYbHTLRIyqmNJb6K6iS9neYt
         JUVA==
X-Forwarded-Encrypted: i=1; AFNElJ8AIBPrpF3Mkr1oYTZ/H35VStZbAD/ll42RcwqOjfmZL8ApVS/fWe6RwzWfB87ZM2qIbcDp6tckrnvS2A==@vger.kernel.org
X-Gm-Message-State: AOJu0YykweG+jYa7faab1mIx9r6MlzWBTAcMYZzaBtLsc8LF6v/WhEbM
	K9GMI0pdet2KJ84vXPavtCbVk+EUWdM09+rM7wnx3Zb+BOskdceYcPowoEwnlJcwres=
X-Gm-Gg: AeBDieuBOoHZwgLmA7MWReSUbDrfIlreLnqfLWI85iSBuOJJLDWpVQjF3NQ4x8Zo9Bb
	v2U+A4t1DiVZknoooxofjqdWGOiBeY+Osm7ggGSl1wxGWZgUVU0zI9KC2UITjdrcEuK+NkJIa2h
	962O1cPUtYpDBBPHma6wDFscRSYhaVnvv+99eSa7o+fdZK908doCaxPcVprLLh+SQ0YnWqdqusc
	m6vrFS/66ii9IUZAy0fjPPyOzYcPqrkinDQnVzlfl5HLhDSab22jHikyHvPxtHAMttePvJfOog+
	GrqXKlCFuLbGmI8gXsuSCE5O5aMPqjJQFgum66k9qPWai3kTsjdM8OTdleeqCpYqN39YrS09p0G
	3DNkulzalKpBO5Jg4PcNawHd2dacs84YbaeVpp8SgXp90g4Sw/s+/axUp8TVKGyWPgO6Bv7B13R
	MFfsREi8g3wxI02GOgOkDqfNAWlyFM/CNP/RjNcN2K8JAKxzU0M2JY+0s3lGiXYg==
X-Received: by 2002:a05:600c:8b04:b0:485:2a85:e5ec with SMTP id 5b1f17b1804b1-48a77ae03ffmr6759685e9.2.1777328137781;
        Mon, 27 Apr 2026 15:15:37 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac78911sm4448445ad.54.2026.04.27.15.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 15:15:36 -0700 (PDT)
Message-ID: <aeb71a41-2727-472d-a869-20ca9bd2b005@suse.com>
Date: Tue, 28 Apr 2026 07:45:31 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: validate data reloc tree file extent item
 members in tree-checker
To: Teng Liu <27rabbitlt@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com, linux-kernel@vger.kernel.org,
 syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
References: <20260426201605.36626-1-27rabbitlt@gmail.com>
 <20260427202822.278326-1-27rabbitlt@gmail.com>
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
In-Reply-To: <20260427202822.278326-1-27rabbitlt@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/28 05:54, Teng Liu 写道:
> get_new_location() uses BUG_ON() to crash the kernel if the file extent
> item it looks up has any of offset, compression, encryption, or
> other_encoding set. The data reloc inode is only written by relocation's
> own paths -- insert_prealloc_file_extent() and
> insert_ordered_extent_file_extent() -- which always leave those four
> fields at 0 (the data reloc inode is created with BTRFS_INODE_NOCOMPRESS,
> and encryption/other_encoding are reserved-and-zero). Observing a
> non-zero value therefore means the leaf decoded from disk does not match
> what the kernel wrote, i.e. on-disk corruption. A malformed image can
> reach this code via balance and panic the kernel.
> 
> Move the validation into tree-checker's check_extent_data_item(), where
> the constraint is enforced when the leaf is read off disk rather than
> after relocation has already started. The data reloc tree has a fixed
> root id (BTRFS_DATA_RELOC_TREE_OBJECTID) recorded in the extent buffer
> header, so check_extent_data_item() has all the information it needs to
> apply this check on its own. Report violations via file_extent_err() and
> print the four offending values.
> 
> In get_new_location() replace the BUG_ON() with an ASSERT().
> The caller in replace_file_extents() already handles non-zero returns from
> get_new_location() by breaking out of the loop without aborting the
> transaction, so no caller changes are needed.
> 
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Suggested-by: David Sterba <dsterba@suse.com>
> Reported-by: syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3e20d8f3d41bac5dc9a2
> Signed-off-by: Teng Liu <27rabbitlt@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

And merged.

Thanks,
Qu

> ---
> Changes in v3:
>   - Move the corruption check from relocation.c into tree-checker's
>     check_extent_data_item(), per Qu and David. The data reloc tree's
>     fixed objectid is recorded in the extent buffer header, so the
>     check has all the context it needs at read time.
>   - Use file_extent_err() and print offset/compression/encryption/
>     other_encoding values, per Qu.
>   - Replace the BUG_ON in get_new_location() with ASSERT() rather than
>     -EUCLEAN, per David.
> 
> Changes in v2:
>   - Pair the -EUCLEAN return with btrfs_print_leaf() and btrfs_err() so
>     the offending leaf is dumped to dmesg, per Qu's review of v1.
>   - Expand the changelog to argue why non-zero
>     compression/encryption/other_encoding in the data reloc inode imply
>     on-disk corruption.
> 
>   fs/btrfs/relocation.c   |  8 ++++----
>   fs/btrfs/tree-checker.c | 21 +++++++++++++++++++++
>   2 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 1c42c5180bdd..527d4dbfe31c 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -835,10 +835,10 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
>   	fi = btrfs_item_ptr(leaf, path->slots[0],
>   			    struct btrfs_file_extent_item);
>   
> -	BUG_ON(btrfs_file_extent_offset(leaf, fi) ||
> -	       btrfs_file_extent_compression(leaf, fi) ||
> -	       btrfs_file_extent_encryption(leaf, fi) ||
> -	       btrfs_file_extent_other_encoding(leaf, fi));
> +	ASSERT(!btrfs_file_extent_offset(leaf, fi) &&
> +	       !btrfs_file_extent_compression(leaf, fi) &&
> +	       !btrfs_file_extent_encryption(leaf, fi) &&
> +	       !btrfs_file_extent_other_encoding(leaf, fi));
>   
>   	if (num_bytes != btrfs_file_extent_disk_num_bytes(leaf, fi))
>   		return -EINVAL;
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 1f15d0793a9c..e4864f7a471e 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -296,6 +296,27 @@ static int check_extent_data_item(struct extent_buffer *leaf,
>   		return 0;
>   	}
>   
> +	/*
> +	 * For the data reloc tree, file extent items are written by
> +	 * relocation's own paths, which always leave offset, compression,
> +	 * encryption and other_encoding as 0. Any non-zero value here means
> +	 * the leaf decoded from disk does not match what the kernel wrote,
> +	 * i.e. on-disk corruption.
> +	 */
> +	if (unlikely(btrfs_header_owner(leaf) == BTRFS_DATA_RELOC_TREE_OBJECTID &&
> +		     (btrfs_file_extent_offset(leaf, fi) ||
> +		      btrfs_file_extent_compression(leaf, fi) ||
> +		      btrfs_file_extent_encryption(leaf, fi) ||
> +		      btrfs_file_extent_other_encoding(leaf, fi)))) {
> +		file_extent_err(leaf, slot,
> +"invalid members for data reloc tree, offset=%llu compress=%u encryption=%u other_encoding=%u",
> +				btrfs_file_extent_offset(leaf, fi),
> +				btrfs_file_extent_compression(leaf, fi),
> +				btrfs_file_extent_encryption(leaf, fi),
> +				btrfs_file_extent_other_encoding(leaf, fi));
> +		return -EUCLEAN;
> +	}
> +
>   	/* Regular or preallocated extent has fixed item size */
>   	if (unlikely(item_size != sizeof(*fi))) {
>   		file_extent_err(leaf, slot,

