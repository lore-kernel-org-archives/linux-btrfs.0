Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E813A5E6C
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 03:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787024258; cv=none; b=fmOm9a1mmy4T+0vNN9GGe22H4M0t8/Fu63+h0VvuECjnRA8dxPBpfTFotvShkCeiU6YIydJNskrK+GQSE3vVFoDzu/49sdfipd1/nb2eetZZTcMX1VrH3JfEgKk9vNlDb1ug+5fss2XE4rI9luKk3UcaWfy0L4rdPpUWjRV8TuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787024258; c=relaxed/simple;
	bh=LZJi5BwdSD+7wbEIxPlcRQa9evUumd3WkIOPbIlpDjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xv6Wzku6srqUiXju3ZzuRwVwmcTQwGUnN9Mu3qVfH6vz0ezT78pP2jBpPs/I0NBoN7m6QlSaRiZGcM9rWj6uPJqL8d9jWE8x55h+3OMZrZEnor9DTY/OTgRi2O8O0ZxJGE0vfK/Jsh05wqWpaMVdKx7KW5rkoqEKSNuNZ0FV8JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FLlJXvwl; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FLlJXvwl"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47db714766aso344162f8f.0
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 20:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787024254; x=1787629054; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FP95Yc5h3+k/fHaHjQvxSlOe9fyikbEA4yzjHUSCS8s=;
        b=FLlJXvwlAVPpsCcvn4GcjDSrvpx55UtbV/uLKHdSj36l4O+nurUrd7u2XV7kRnu8Kz
         L4HICMSATzJnA1/D9prurwsKOX2l9E4oRBVcvzKjUZnAxJwdLOmAT72WbN4bW/Va0Rxv
         OV+Ph+G9MlZftmSBjFkaHCyqGnDOH1UK4ev8lsVr4avMP0nNuEEGkTppzyvmDb3hdFXu
         n1z3oyJJbDrnYir98m3OMbBh3sWYjIGJzqTs+jASf3/m2HDg2UQti0dyl6ua0JCTVntW
         N+LZjGS9++IUaXXTbvdQUTDibb6AAsEsgZob92QEQBLY2SIKxjt4kqoglGO5cs/0suFZ
         E2yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787024254; x=1787629054;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FP95Yc5h3+k/fHaHjQvxSlOe9fyikbEA4yzjHUSCS8s=;
        b=h5bOBHakCsPibwaxDN2QdSokeqoQScRONACznKVqW/yVspq7w0emv54qbVmWKArv3r
         +8YqFl1HmcMJOeqPV5bMi7BJ5rAEPDSrnKv8aIpRE1d4423PGY4a7FpeF5L6s6n6tiCt
         1B8zIWykDyF9+I30J5DjJ8qEXb1cDlIyC3kannOuhO5U2zWpcWnSPEM0Y17hUTx55R5s
         96Im7WDGy2PS3GlnBf8b/OOt2rfCUtOXVrr9GHwRu/TyVJ8o+bhYYf+fzJPmmXLD4I5F
         YUlkaUkPtCB46YsceGHeG9ek/2jJghoY2tMWpq/a2lknq6fpSSfe4mTDFoUBEIRnY3Up
         UstQ==
X-Gm-Message-State: AOJu0Yykvmze4XvzxgpkFj4+EnaWQPqpp1eyN3zq7HefHSzICknS0AZR
	9Ayy+hiaPZrfh2yfSCNSBOL0SqJ/eEpYSbCTOullEH2qTUY9X5pYt3n7aI15Oo0k30M=
X-Gm-Gg: AR+sD13rC6lt7D32ElhdpxeGRZJJpAemZCE/uj0OWi/s2InboEbhy1j7ieYRz2Cp+13
	zIUwUTmWBRc4y/9bqibP2hx6BgszxrAW01qtk0OTIBiksiPmVk3WjXnWcJV4LJv/0putCq/P3bT
	YNTr15wc1BrP7j9DPUvWSrqbGxGTWdsAjNqyOi8sN/k1Ss25oxLiqgaJYFECcLhIYmEWDyEA1xJ
	YnTvuGQtzhxR8rhidojwe+sUJ2+0YvOyghgmiLEr6ub9/pzT4NYtj9/eDSXLSRy1WwR1tCtE4R3
	kOPsLGejGT3JnhuXv5tZ6leBpRRbRGd9erZspWipwG2BXJ5mnh6go4uBYiEi0BQQOv9bgaNWdG7
	fdmRkgXibaUTSTre+hxkrcQVl4IYS5dA9zo1GGiiMWKjVRCHT/5WCT7o/esxAHVy6mmGS7iofek
	cxrFRwk3J6Z6S8yoCfN2E/PT6Fr7CqLUbtm+bxvlZrxsW2Zbltv7e6uA==
X-Received: by 2002:a05:600c:91a:b0:499:8117:8830 with SMTP id 5b1f17b1804b1-499a08e9a57mr35754245e9.7.1787024253795;
        Mon, 17 Aug 2026 20:37:33 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3267c490ee9sm12209924eec.25.2026.08.17.20.37.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 20:37:32 -0700 (PDT)
Message-ID: <4522f7e6-f735-44b7-a98d-b704df8a49ac@suse.com>
Date: Tue, 18 Aug 2026 13:07:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: send: reject extents for non-regular inodes
To: ZhengYuan Huang <gality369@gmail.com>, clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 tom442288@tuta.io
References: <20260817132051.267646-1-gality369@gmail.com>
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
In-Reply-To: <20260817132051.267646-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/17 22:50, ZhengYuan Huang 写道:
> [BUG]
> A corrupted subvolume tree can leave an EXTENT_DATA item attached to an
> inode whose mode is not S_IFREG or S_IFLNK. During send, such an item can
> be treated as file data and crash through a NULL address_space operation:
> 
>    BUG: kernel NULL pointer dereference, address: 0000000000000000
>    #PF: supervisor instruction fetch in kernel mode
>    #PF: error_code(0x0010) - not-present page
>    Call Trace:
>      <TASK>
>      read_pages+0x80b/0xb30 mm/readahead.c:173
>      page_cache_ra_unbounded+0x40d/0x890 mm/readahead.c:302
>      do_page_cache_ra mm/readahead.c:332 [inline]
>      page_cache_ra_order+0xa16/0xcd0 mm/readahead.c:535
>      page_cache_sync_ra+0x5ce/0x9d0 mm/readahead.c:626
>      page_cache_sync_readahead include/linux/pagemap.h:1379 [inline]
>      put_file_data fs/btrfs/send.c:5224 [inline]
>      send_write fs/btrfs/send.c:5291 [inline]
>      send_extent_data+0x16b2/0x29b0 fs/btrfs/send.c:5715
>      send_write_or_clone fs/btrfs/send.c:6135 [inline]
>      process_extent+0x5d4/0x17b0 fs/btrfs/send.c:6504
>      changed_extent fs/btrfs/send.c:7079 [inline]
>      changed_cb+0x22f9/0x3cd0 fs/btrfs/send.c:7245
>      full_send_tree fs/btrfs/send.c:7318 [inline]
>      send_subvol fs/btrfs/send.c:7910 [inline]
>      btrfs_ioctl_send+0x46a9/0x57f0 fs/btrfs/send.c:8248
>      ...
> 
> [CAUSE]
> process_extent() skips extent items for symlinks but assumes every other
> inode with an extent item is a regular file. For a corrupted non-regular
> inode, btrfs_iget() does not install the regular file address_space
> operations. The readahead fallback can then call a NULL read_folio
> callback before the existing validation in btrfs_get_extent() can run.
> 
> [FIX]
> Reject extent items for inode types other than regular files and symlinks
> at the common send extent-processing boundary. Symlink handling is left
> unchanged because send emits symlink data from read_symlink(). This covers
> full, incremental and new-generation sends without adding a check to the
> regular I/O path.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

> ---
>   fs/btrfs/send.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index dca3570168c7..f88623bbc491 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -6417,6 +6417,13 @@ static int process_extent(struct send_ctx *sctx,
>   
>   	if (S_ISLNK(sctx->cur_inode_mode))
>   		return 0;
> +	if (unlikely(!S_ISREG(sctx->cur_inode_mode))) {
> +		btrfs_crit(sctx->send_root->fs_info,
> +			   "send: extent for non-regular inode %llu root %llu mode 0%llo",
> +			   key->objectid, btrfs_root_id(sctx->send_root),
> +			   sctx->cur_inode_mode & S_IFMT);
> +		return -EUCLEAN;
> +	}
>   
>   	if (sctx->parent_root && !sctx->cur_inode_new) {
>   		ret = is_extent_unchanged(sctx, path, key);

