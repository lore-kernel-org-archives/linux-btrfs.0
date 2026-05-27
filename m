Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659F4356761
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 21:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779918339; cv=none; b=Cjqfo2lFx4z1APava+wkvjP9W1oTwDE50s00LWGAuo1e/MCVjU2O/np4zJVrCzH+myuoY1AV04hpJLbal/2HYGN0JJDxk9bYSJzWfoXCvvaDhP869V7FZX3b/LtWsV1B/0hlMUmgaXnFw2bDsZbyHcaeA4GCSI1mauWN0xTcjb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779918339; c=relaxed/simple;
	bh=RIS/E68KyHH3DBy5x5jSpSo5Egts7+jFl2fUDUnWeBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZS4P7t0C1etsg0+ownap39aybOdS9P0vPiaQQH9S8MG8uqaZDl7a4hg0JHdeY1JOR1VUpykLrhdw6ZyB6gJETlmltAGBC0RhtsvgVVRbFsjVWeET+Hb88GeqdeVe5RiPBduqfgGV55kpW2xd1NpTIcWctwT1aCPqIhUfDEGBaSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HEBsz08T; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HEBsz08T"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4905e190c71so45175145e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 14:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779918336; x=1780523136; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=sLPGos2emiDUZB01fCRV1Uv0AE7h6zD6z2Plr3zZSFI=;
        b=HEBsz08T7U2SVztHLOGc7WQOfiXchelHxucl7aJ4GWINtYVuvD29WJ1oCPKlvDPeDj
         9wAzDSC9vsq1Zu+PXnB/YgaYSaZoj89iBAUU4lROHtKF/q/5D/AqG92DvvBYX1cIJYfb
         hBp7rNmWxPAPRhrIbOzm/N5/xAiFL4NZ62KPZk8WZU6nmCssQsoGyosVv8zCyZ9+eI+Z
         nb31wkynEi/VSSUlFqZ/dIk9CgkzGpJcHJqzd9WnUf+eysgtOAYrvS78cnEW22jGCz/N
         9MwgYAvQPUYI7q94GSsI8Hnt1BzWpmUC4FluxtKB1jOrbbf8Y6OArc/omMBmiQcPzb8v
         3zGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779918336; x=1780523136;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLPGos2emiDUZB01fCRV1Uv0AE7h6zD6z2Plr3zZSFI=;
        b=PCMow9dsPYHaTfjeMpQ9DhMKHe4SIfsLmf4ku8Gwh2XztTMK91PPaVt/vhk2jdR6ol
         j2YlSTJB7EXsY8hyabBT1OhYuVOiyYhu7dMbJq1hpX0sWm0/OJ1m/ifVdr1+VMD4R42G
         oR2QLDoPBvP0KmeYKjldiIW/rDP5dxb1Z/VIFH/HPtF4I1tJ9vnz614xwLENXFDUKyLG
         V6eSRn0wAZ6EnJw614Or/drCx9xTqHnJhR4wVh0/o2p+fxIDfaVPV618yyYQr4K02A3V
         z6QnycZKI2Be1xDdBDKvE8hKQse4qZzLcKOiwedhhsvsYaCVi+mz3xuPU8sCzJt60avi
         C7Jw==
X-Forwarded-Encrypted: i=1; AFNElJ+Wu5d9cEwiyWAK3EoL3U2WniBh4/MZLJFJO/pxWbyxRjB/bhqSrfVX3DLRS4Ka6A7qE9DLf2wOymNIwg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFUk7hX030US9mH3T3Jce7U6E+EGZmDhMwMGYCOzNuxdxr+VHx
	jYl0StQnNpEV+a+tlRZgGbIvg2zszlhv4M6Nf8dQ/uoIh36EJLL9JHKc22zFw2pxQlU=
X-Gm-Gg: Acq92OFbRoMYSiOtawwhwNsruZpqNl27kCAafu+9bzd87JGrMz56ADqLzemXu6ri/Cd
	jUQJ+kHETyseBsIFhi6x0bgTsZUZq6VBvKSoWo4UAp2Z9Va4iMNrIA23AuTXgPMNMm9XPolmKqE
	Sc8pbqzCOiQW8d0QIbOnDbBsNAWm5B5+cjSWpvz1tqcd1g6WdESKK/EE1do8vYpLN/0GD5DE3ND
	wp6ADU5FM3GnjOEYQGLiGbVMNW75nPPX5fFlFHWYqsAlbSjR244AeWUG5QTm8NSc1sdkI9bu8Su
	wta8IR6uFM8oXiHBGw6fMiHbZ0U50XSF/BocorbcuKsjWMY+X5PUuT7I2/7o3JsoAklUR5ucJe6
	DZ47kj+0WKXvG19B19nlmXJv/QMlP/vJn7V3geB8qRJgbCZ9pxe7E+WrPjJ8J+mh2rMy9N6/lQG
	nJknU8vzj56F8wQ8JB5X3I8zmGLDS0gSN3iykr1Cd3LJUEe5yKtoxsPsKQvS1LRJ6OIu7kIxz7Q
	eX3aIEn2BIdSCsUHeLQrN8t9q1YJSZTGFyD3J5V/cxVRezEa89KjvXXyw==
X-Received: by 2002:a05:600d:640f:10b0:490:3ff5:737f with SMTP id 5b1f17b1804b1-490426cefe0mr302983195e9.18.1779918335584;
        Wed, 27 May 2026 14:45:35 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d6eae464sm4145099b3a.20.2026.05.27.14.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 14:45:34 -0700 (PDT)
Message-ID: <df399edc-eb21-4566-9640-02b446eb6d3a@suse.com>
Date: Thu, 28 May 2026 07:15:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use shifts for sectorsize and nodesize
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20260527111652.944584-1-dsterba@suse.com>
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
In-Reply-To: <20260527111652.944584-1-dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/27 20:46, David Sterba 写道:
> Convert more multiplications of sectorsize or nodesize to use the
> shifts. The remaining cases are multiplications by constants that
> compiler can optimize by itself, and in tests.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/delalloc-space.c | 4 ++--
>   fs/btrfs/disk-io.c        | 2 +-
>   fs/btrfs/file-item.c      | 2 +-
>   fs/btrfs/relocation.c     | 4 ++--
>   fs/btrfs/transaction.c    | 2 +-
>   5 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> index 0970799d0aa443..5d5ff5a0280844 100644
> --- a/fs/btrfs/delalloc-space.c
> +++ b/fs/btrfs/delalloc-space.c
> @@ -279,7 +279,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
>   	 *
>   	 * This is overestimating in most cases.
>   	 */
> -	qgroup_rsv_size = (u64)outstanding_extents * fs_info->nodesize;
> +	qgroup_rsv_size = ((u64)outstanding_extents << fs_info->nodesize_bits);
>   
>   	spin_lock(&block_rsv->lock);
>   	block_rsv->size = reserve_size;
> @@ -309,7 +309,7 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
>   	 * for an inode update.
>   	 */
>   	*meta_reserve += inode_update;
> -	*qgroup_reserve = nr_extents * fs_info->nodesize;
> +	*qgroup_reserve = (nr_extents << fs_info->nodesize_bits);
>   }
>   
>   int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index e6ed52f5cd6d99..590da1ba5de485 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -563,7 +563,7 @@ static bool btree_dirty_folio(struct address_space *mapping,
>   			continue;
>   		}
>   		spin_unlock_irqrestore(&subpage->lock, flags);
> -		cur = page_start + cur_bit * fs_info->sectorsize;
> +		cur = page_start + (cur_bit << fs_info->sectorsize_bits);
>   
>   		eb = find_extent_buffer(fs_info, cur);
>   		ASSERT(eb);
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 82ae4a2afd3471..9f6454e9db8186 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -1309,7 +1309,7 @@ int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
>   
>   	index += ins_size;
>   	ins_size /= csum_size;
> -	total_bytes += ins_size * fs_info->sectorsize;
> +	total_bytes += (ins_size << fs_info->sectorsize_bits);
>   
>   	if (total_bytes < sums->len) {
>   		btrfs_release_path(path);
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 67af02e732d0ce..8212abc2d13652 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1560,7 +1560,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
>   	 * and * 2 since we have two trees to COW.
>   	 */
>   	reserve_level = max_t(int, 1, btrfs_root_level(root_item));
> -	min_reserved = fs_info->nodesize * reserve_level * 2;
> +	min_reserved = (reserve_level << fs_info->nodesize_bits) * 2;
>   	memset(&next_key, 0, sizeof(next_key));
>   
>   	while (1) {
> @@ -2558,7 +2558,7 @@ static int relocate_cowonly_block(struct btrfs_trans_handle *trans,
>   
>   	nr_levels = max(btrfs_header_level(root->node) - block->level, 0) + 1;
>   
> -	num_bytes = fs_info->nodesize * nr_levels;
> +	num_bytes = (nr_levels << fs_info->nodesize_bits);
>   	ret = refill_metadata_space(trans, rc, num_bytes);
>   	if (ret) {
>   		btrfs_put_root(root);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index a289a8fa237c8a..2263cb6bd8ca47 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -631,7 +631,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
>   	 * the appropriate flushing if need be.
>   	 */
>   	if (num_items && root != fs_info->chunk_root) {
> -		qgroup_reserved = num_items * fs_info->nodesize;
> +		qgroup_reserved = (num_items << fs_info->nodesize_bits);
>   		/*
>   		 * Use prealloc for now, as there might be a currently running
>   		 * transaction that could free this reserved space prematurely

