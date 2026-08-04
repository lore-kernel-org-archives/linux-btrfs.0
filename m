Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4BE43C046
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Aug 2026 23:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785887515; cv=none; b=FIJYu47wDWCJRiUy0rCcdpxS/hke8FDhBvevC2yiu66Gv4d70UDhI1aMmh8Eet0K6CkpvITprIw60MgzRZP07iy3kpcoCqVy8GQvuciR+efO0ldHzPs4wTBwzSXc+7TVzN/wDzGuPj+CA9r0dvG5lxTjkb/OSdj9rpfLAnzUSmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785887515; c=relaxed/simple;
	bh=m+D0wdZeDWNriMdDYMy1Fd7o7wCY9p7aabsDB8B6lk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KC+cc/UcovHqITevXvrDpKKSFZTq2Chv5EM08KRP47OqutVKe0F34wA3SpDK4ogg62wNACbPAOP+rZrVa1BTpOQwAJq2HMObXmyOfDTEh0hN2zhXNtObink6HFUbDZuCTQZWnUM+PqMjDn50Nwb/bhwOM3cB7bTekNGQvvId5qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fbVvajSY; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fbVvajSY"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-495635a85d2so2966055e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Aug 2026 16:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785887512; x=1786492312; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=74GYCzcDBaNT4UzSN2YvRRVJqSM6BiqgVmyqSv9tGz0=;
        b=fbVvajSYD9sheKoT4RW0w3nztUyT1lLOqc+mYjj8X3hDVW0I1FdKD71dQZhbLoTSOZ
         +vBDv1AIMwLRXMoMVon6Ixo7sDut/92FG8IxWfE4sO/i3pFrT64cPbad9Rb2KE0MZGLQ
         iohsEE1yp2Vkw+UYUy+YwH3YGAGVik5Y4Wp0+qMPgvswdmzMAYyvut9aU3zDwZwEvxh2
         UFRqOefin07XZ92JkvVER/UxPER0jNQWvhv285/cRUlX3tVxnxwSoaaQSeVT20/3XWhq
         nJWeH4fWVgKlIAFvI2mFGSNb7ff/o6sl6Oe+/PK27kvVmRNcUcrsm2aKH4qAxQVRjkzB
         JuBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785887512; x=1786492312;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=74GYCzcDBaNT4UzSN2YvRRVJqSM6BiqgVmyqSv9tGz0=;
        b=GiN9MGQ7IGkE2joT6B6r2S2wyJtjSMi3dFTGGgWodpqCGCKjRSCHdfKahN1WW4jff6
         qFEu6HDchOhwKeqHKOVToatYPtpDfUDBMqseaq0kKiBDEYJmIzqfac0/lYVxAgBAlLPT
         9yKjVhxOlJqIwGqfMnwGQo08PQequ/ID5j3o+iv2aK/I4umxsdwlHPhaEcAxdQP+pvNG
         MXEm0beeMxy0NlqGXHiuMrnIl1qer1+zfN+L9EMujkNHKQ45uM+1Tv0bdkTeLv9mORZ4
         mvmya7jVeS1vrV+P0MhbV/yOAknFetTGpEeNJ/iqVhEhCMnvDeIHLSiKTjNgvImyG5rf
         KJ5g==
X-Gm-Message-State: AOJu0Yzv2ukda17pfejVty933XNa9q/cW6wCNId2zRxdcR627ZrPXIiS
	NE6fD3CmO2wAYCR0/FY0PSbVtHfYxMFk0Y3BMOYjrCvCSKhFLZ+D7mYrhR+l1h1Taq4=
X-Gm-Gg: AR+sD116dA85ruJm2/BQ5RFofXLOgbuXE+WzAxOaXUgrIMlPP1PZ7feyrnQVkBymXEV
	DZKyZvqQRv8oMxj92wd67S3qFd3sPb5IlZvK53QkPSW6vyIQViYMELkmEtArqtkOsSsqmWGzQ5r
	LxvppSNqjMu0oFKyU/JvOGyb57FuMghgFwv+yp4e/U9IW64qRoC+r9KZtu+ddrBdkrsYTIcMlZW
	Zs43JEOMfpSSbCKuUatTTNJ4OyIPj6v974hFHbt4YU3+xJx8mp1M2yvFzqPoCJ90iA1PFr5Nsza
	gK9d+BroBMfP7/ux1M5x0H0gKlpfnsEzfa0Uolb8ht3Par81gfqS950lepWBM8hxykyo6S1x7Mo
	aWfI3aoy48/LCKTFOA7AqfqbswAp0nAD/ZnGkZxrK6DVHUP9RKee5H1BBS2GnZCAX4qGUjGTkx7
	2dCGRqwKlLcxVwyLS0CoU0hTFav6fRf+VyC42+0eRymQCYBFFYTe/KUg==
X-Received: by 2002:a05:600c:3b20:b0:499:4893:97d3 with SMTP id 5b1f17b1804b1-4994e7cb8ebmr20218755e9.13.1785887511828;
        Tue, 04 Aug 2026 16:51:51 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fca660e66sm7246499c88.8.2026.08.04.16.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 16:51:50 -0700 (PDT)
Message-ID: <dc3389ba-f29f-4897-9304-c9689eef4f37@suse.com>
Date: Wed, 5 Aug 2026 09:21:46 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] btrfs: pre-allocate delayed dir index before btree
 modification
To: Jeff Layton <jlayton@kernel.org>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@fb.com
References: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
 <20260804-btrfs-enomem-v2-3-4d923170e8c1@kernel.org>
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
In-Reply-To: <20260804-btrfs-enomem-v2-3-4d923170e8c1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/5 01:14, Jeff Layton 写道:
> Move the delayed dir index allocation in btrfs_insert_dir_item() before
> the insert_with_overflow() call that modifies the btree. Previously, the
> allocations happened after the DIR_ITEM was already inserted, meaning an
> ENOMEM failure left the btree in a partially-modified state that could
> only be resolved by aborting the transaction.
> 
> Add an optional caller-provided btrfs_dir_index_prealloc parameter to
> btrfs_insert_dir_item(). When non-NULL, ownership of the prealloc
> transfers to btrfs_insert_dir_item(). When NULL, it allocates internally.
> All existing callers pass NULL to preserve the current behavior.
> 
> Remove the btrfs_insert_delayed_dir_index() wrapper, as there are no
> more callers.
> 
> Assisted-by: LLM
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/btrfs/delayed-inode.c | 21 ---------------------
>   fs/btrfs/delayed-inode.h |  5 -----
>   fs/btrfs/dir-item.c      | 30 ++++++++++++++++++++++++------
>   fs/btrfs/dir-item.h      |  5 +++--
>   fs/btrfs/inode.c         |  2 +-
>   fs/btrfs/transaction.c   |  2 +-
>   6 files changed, 29 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 95d2dca80444..d9de7f269874 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1608,27 +1608,6 @@ int btrfs_insert_delayed_dir_index_prealloc(struct btrfs_trans_handle *trans,
>   	return ret;
>   }
>   
> -/* Will return 0, -ENOMEM or -EEXIST (index number collision, unexpected). */
> -int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
> -				   const char *name, int name_len,
> -				   struct btrfs_inode *dir,
> -				   const struct btrfs_disk_key *disk_key, u8 flags,
> -				   u64 index)
> -{
> -	struct btrfs_dir_index_prealloc prealloc;
> -	int ret;
> -
> -	ret = btrfs_prealloc_delayed_dir_index(dir, name, name_len, &prealloc);
> -	if (ret)
> -		return ret;
> -
> -	memcpy(prealloc.item->data + sizeof(struct btrfs_dir_item), name,
> -	       name_len);
> -
> -	return btrfs_insert_delayed_dir_index_prealloc(trans, dir, &prealloc,
> -						       disk_key, flags, index);
> -}
> -
>   static bool btrfs_delete_delayed_insertion_item(struct btrfs_delayed_node *node,
>   						u64 index)
>   {
> diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
> index e310a257c9a6..878d70aee2f9 100644
> --- a/fs/btrfs/delayed-inode.h
> +++ b/fs/btrfs/delayed-inode.h
> @@ -115,11 +115,6 @@ struct btrfs_delayed_item {
>   };
>   
>   void btrfs_init_delayed_root(struct btrfs_delayed_root *delayed_root);
> -int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
> -				   const char *name, int name_len,
> -				   struct btrfs_inode *dir,
> -				   const struct btrfs_disk_key *disk_key, u8 flags,
> -				   u64 index);
>   
>   struct btrfs_dir_index_prealloc {
>   	struct btrfs_delayed_node *node;
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index 84f1c64423d3..1b956df2c571 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -106,8 +106,11 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
>    * Will return 0 or -ENOMEM
>    */
>   int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
> -			  const struct fscrypt_str *name, struct btrfs_inode *dir,
> -			  const struct btrfs_key *location, u8 type, u64 index)
> +			  const struct fscrypt_str *name,
> +			  struct btrfs_inode *dir,
> +			  const struct btrfs_key *location, u8 type,
> +			  u64 index,
> +			  struct btrfs_dir_index_prealloc *prealloc)
>   {
>   	int ret = 0;
>   	int ret2 = 0;
> @@ -119,6 +122,8 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
>   	struct btrfs_key key;
>   	struct btrfs_disk_key disk_key;
>   	u32 data_size;
> +	const bool need_delayed_index = (root != root->fs_info->tree_root);
> +	struct btrfs_dir_index_prealloc local_prealloc;
>   
>   	key.objectid = btrfs_ino(dir);
>   	key.type = BTRFS_DIR_ITEM_KEY;
> @@ -130,6 +135,18 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
>   
>   	btrfs_cpu_key_to_disk(&disk_key, location);
>   
> +	/* Pre-allocate the delayed dir index before modifying the btree. */
> +	if (need_delayed_index && !prealloc) {

This is exposed by sashiko.

If we have @prealloc passed in, and before we even hit 
insert_with_overflow(), the previous btrfs_alloc_path() failed, we 
return -ENOMEM directly, leaking the @prealloc.


> +		ret = btrfs_prealloc_delayed_dir_index(dir, name->name,
> +						       name->len,
> +						       &local_prealloc);

Sashiko also pointed out that, the preallocation itself doesn't really 
utilize name->name.

Thus it may be a good idea to merge the later memcpy() into the 
preallocation function.

Thanks,
Qu

> +		if (ret)
> +			return ret;
> +		memcpy(local_prealloc.item->data + sizeof(struct btrfs_dir_item),
> +		       name->name, name->len);
> +		prealloc = &local_prealloc;
> +	}
> +
>   	data_size = sizeof(*dir_item) + name->len;
>   	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
>   					name->name, name->len);
> @@ -137,6 +154,8 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
>   		ret = PTR_ERR(dir_item);
>   		if (ret == -EEXIST)
>   			goto second_insert;
> +		if (need_delayed_index)
> +			btrfs_free_delayed_dir_index_prealloc(trans, prealloc);
>   		goto out_free;
>   	}
>   
> @@ -154,15 +173,14 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
>   	write_extent_buffer(leaf, name->name, name_ptr, name->len);
>   
>   second_insert:
> -	/* FIXME, use some real flag for selecting the extra index */
> -	if (root == root->fs_info->tree_root) {
> +	if (!need_delayed_index) {
>   		ret = 0;
>   		goto out_free;
>   	}
>   	btrfs_release_path(path);
>   
> -	ret2 = btrfs_insert_delayed_dir_index(trans, name->name, name->len, dir,
> -					      &disk_key, type, index);
> +	ret2 = btrfs_insert_delayed_dir_index_prealloc(trans, dir, prealloc,
> +						       &disk_key, type, index);
>   out_free:
>   	if (ret)
>   		return ret;
> diff --git a/fs/btrfs/dir-item.h b/fs/btrfs/dir-item.h
> index e52174a8baf9..d7a7d0b66f37 100644
> --- a/fs/btrfs/dir-item.h
> +++ b/fs/btrfs/dir-item.h
> @@ -16,9 +16,11 @@ struct btrfs_trans_handle;
>   
>   int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir_ino,
>   			  const struct fscrypt_str *name);
> +struct btrfs_dir_index_prealloc;
>   int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
>   			  const struct fscrypt_str *name, struct btrfs_inode *dir,
> -			  const struct btrfs_key *location, u8 type, u64 index);
> +			  const struct btrfs_key *location, u8 type, u64 index,
> +			  struct btrfs_dir_index_prealloc *prealloc);
>   struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
>   					     struct btrfs_root *root,
>   					     struct btrfs_path *path, u64 dir,
> @@ -53,5 +55,4 @@ static inline u64 btrfs_name_hash(const char *name, int len)
>   {
>          return crc32c((u32)~1, name, len);
>   }
> -
>   #endif
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3c10a0ef0002..3a2dca093c7d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6924,7 +6924,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
>   		return ret;
>   
>   	ret = btrfs_insert_dir_item(trans, name, parent_inode, &key,
> -				    btrfs_inode_type(inode), index);
> +				    btrfs_inode_type(inode), index, NULL);
>   	if (ret == -EEXIST || ret == -EOVERFLOW)
>   		goto fail_dir_item;
>   	else if (unlikely(ret)) {
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index c641099d66e2..6fdfea5d35af 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1882,7 +1882,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>   
>   	ret = btrfs_insert_dir_item(trans, &fname.disk_name,
>   				    parent_inode, &key, BTRFS_FT_DIR,
> -				    index);
> +				    index, NULL);
>   	if (unlikely(ret)) {
>   		btrfs_abort_transaction(trans, ret);
>   		goto fail;
> 

