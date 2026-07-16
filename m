Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894802E888A
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 22:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784242189; cv=none; b=He8rKWKOM1vDa8i4xUTNchkMYD6ck2PXVgOAyH+/tLAg7+61fM64yBpNDp8ISb5LnJ1X3hMWeLl0epYHuqQm+K8/Q/QKVzqZ5HxB2UsGLjgjN4tbNI9kFlQeTgcONsPVN4KiYCKrdqfuTAR/4qizJa7AXef7Gn7nLweDR06HaOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784242189; c=relaxed/simple;
	bh=fZlMhYzhLbWnLKdx/huIPRfc0AolfavdHOrPImZ+S9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VGz+ZcRrLKWuaxnlFNDP8PCHeWvIb/jFUQKfqRv8yEIsIcjL68/0NX+ksCtzcKrpbvTRC5X0DWQM7sbWKi3CXx+pUAMA6ekvxeKZ30i0SOoU/sW6KvhZNqwTUxWUZb7vPglBRbuLaNOttvn0h/MXiuangBqD4czM9vBA7Zjo4lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YCbmpjRg; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YCbmpjRg"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c167aa9500dso310308466b.3
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 15:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784242185; x=1784846985; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LyxVuBnYqM87yQ8n6nQA0gJNY5mGfC+14hk54ovxj7k=;
        b=YCbmpjRgwCioE10Gy96RFLSxh5HqpyU7uyAYoLhR8/2BzdM+Hr3gQ7Damio9vqR1bV
         0z10zqjcFHIihOl+FZpnh74UgEpGne2ehq8W4p8gB8d+VTXW6aFA7qEPTPu6pgnYt74r
         0WopfGjqXPrx/hfMIms/DpwbVG87nXNpjUveueZoPtyEwOu1MwFAqe1I69aV4m9ar7vn
         VwA790TqHBKD1XUwpE4/a1czB4ApOw4FLQItQvbxPEEOG5zcwcAUqJrHcstsXcGVLG9S
         RAtulRan2BQlmFqzzr37/xEoq9fwquOR8wPopsE1G6e+8zDuux+C/R+Zlk6lKMiYvfLL
         +EZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784242185; x=1784846985;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LyxVuBnYqM87yQ8n6nQA0gJNY5mGfC+14hk54ovxj7k=;
        b=PvSLn7Cz0lkac6xq9EqysKLAx8aJS237mwmgSLJpy+NlLOeXv0o/Axm2m1k+xDcLoF
         MAY/RC/niLSPue68Tved8EzhYmlxp8iuhibVI8/nKqzlZ4FFmk+DFmYoFE45I0YG+wlY
         r3qIUviaE55uoehRQ+TmmiGkVTw41EqvUvw/TjrwZBokcq7rpsfjatO2XcdmyiJVZNDW
         GGkEWbmNDH0xneW2lbhKoqJJbTX9szrLSQMOoXzh4X4fRBsA2T2fb1oqNC+6ZOyHyrVv
         +9Ny0FuF6q5c7J1AFvPvA+1C2hJNEnYpZnY9XSV4UMnnDU3+4HiQ3BALYFFnORZjjGAG
         MDgA==
X-Forwarded-Encrypted: i=1; AHgh+RrNOeGs0RuVS/K2wNudyP0EhoXz6IbAXcckhdo0PcFMFh7i41xLKRgpbAqF/FrTyeHQqg7HRz+cKq/UxA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzCZ4HTDkeLLZQ/ONEUx/MYrPbZ3KrGeEezw/0vm5XWBdunTmRQ
	f3LUfDoGsKtn5M+RKgd2YVGNM/Yw2GQ7JberqQBXubZnSxaf3Muv4cNM8BYvpAUsbD0=
X-Gm-Gg: AfdE7clZyuttGRuRpx7HgD6pnvVh/CIWNTKaekAa4WrseZCiLdYEYZ0zzWZrUsUEbmo
	qDkKvrTT4PJhiKK04SOx5bA618xkRTI8N4B4ZhuwkoQr4mpctHb8f2j0SHmSOOfu1eioET0B3Bt
	w14VLcOL9cNcAu0NCpXXd5CLguQgcAQ/PqkoxQ5krI29BsYFm45/eXJwv4oERUNB0+zfEDIVDh0
	nfPf43ENhXDMKwXFzzU8d+TOd49s+prW7A2WZ+eZqIehE3Df4aldEurwSLnx/Vn9uoiJB9h8OdT
	UcKS0hyw9PUlUTKlkmVyaky+mtGZn7C1MC1tRqu7CbuQPhlNyXQjSP9xZ7KBayOWUJGrR0Ej6jf
	92AgBPSNvKB5AoQJVc/QvEUqHD04tRtkVpAiWpZV3YwUfdRnxys9x19xDotbvAy5J0kWZaK4=
X-Received: by 2002:a17:907:d15:b0:c16:347f:cec3 with SMTP id a640c23a62f3a-c16618773f2mr793957366b.39.1784242185420;
        Thu, 16 Jul 2026 15:49:45 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258ef3c6fsm2399149a12.13.2026.07.16.15.49.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 15:49:44 -0700 (PDT)
Message-ID: <062d26d5-c340-4e3b-bf56-a38d1f98a546@suse.com>
Date: Fri, 17 Jul 2026 08:19:38 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] btrfs: zoned: drop stale dirty btree buffers at
 close_ctree()
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Damien Le Moal <dlemoal@kernel.org>
References: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
 <20260716115656.1319295-3-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20260716115656.1319295-3-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/16 21:26, Johannes Thumshirn 写道:
> On a zoned filesystem btrfs_clear_buffer_dirty() keeps a freed-but-dirty
> tree block dirty (EXTENT_BUFFER_ZONED_ZEROOUT) so its zero-out keeps the
> zone write pointer moving. A block left ahead of the block group's
> meta_write_pointer (e.g. a tree-log block freed before being written) can
> never be written by btree_writepages() and survives to unmount.
> 
> close_ctree() stops the endio workqueues before the final iput() of the
> btree inode but frees the block groups only afterwards. Once the block
> group is gone btrfs_check_meta_write_pointer() no longer defers the buffer,
> so the iput() submits it for writeback; its completion can no longer be
> queued on the destroyed endio_meta_workers and umount hangs on writeback
> that never finishes.

Can we just trigger a btree inode write back for zoned cases?

That sounds much simpler and less hacky.

Thanks,
Qu
> 
> btrfs_free_block_groups() has to stay after btrfs_stop_all_workers()
> (see also commit 5cdd7db6c5c9), so instead drop the dirty state of such
> stale buffers in invalidate_and_check_btree_folios(), which still runs
> while the workqueues are alive.
> 
> Assisted-by: LLM (debugging, commit message)
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   fs/btrfs/disk-io.c   |  4 ++++
>   fs/btrfs/extent_io.c | 12 ++++++++++++
>   fs/btrfs/extent_io.h |  1 +
>   3 files changed, 17 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index acff40469589..b66525701b33 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3317,6 +3317,10 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
>   		if (test_bit(EXTENT_BUFFER_READING, &eb->bflags))
>   			wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING,
>   				       TASK_UNINTERRUPTIBLE);
> +
> +		if (btrfs_is_zoned(fs_info) &&
> +		    test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
> +			btrfs_clear_stale_buffer_dirty(eb);
>   		/*
>   		 * The refs threshold is 2, one held by us at the beginning
>   		 * of the loop, one for the ownership in the buffer tree.
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 4dd8fc5ad247..480d4ec8ca7f 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3841,6 +3841,18 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
>   	__btrfs_clear_buffer_dirty(eb);
>   }
>   
> +/*
> + * Drop the dirty state of a stale, already-freed metadata buffer, bypassing
> + * the zoned EXTENT_BUFFER_ZONED_ZEROOUT deferral of btrfs_clear_buffer_dirty().
> + */
> +void btrfs_clear_stale_buffer_dirty(struct extent_buffer *eb)
> +{
> +	btrfs_tree_lock(eb);
> +	clear_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags);
> +	__btrfs_clear_buffer_dirty(eb);
> +	btrfs_tree_unlock(eb);
> +}
> +
>   void set_extent_buffer_dirty(struct extent_buffer *eb)
>   {
>   	bool was_dirty;
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 869925337699..290d6cff6ddb 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -393,6 +393,7 @@ void extent_clear_unlock_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
>   				  u32 bits_to_clear, unsigned long page_ops);
>   void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
>   			      struct extent_buffer *buf);
> +void btrfs_clear_stale_buffer_dirty(struct extent_buffer *eb);
>   
>   static inline void btrfs_clear_folio_dirty_tag(struct folio *folio)
>   {

