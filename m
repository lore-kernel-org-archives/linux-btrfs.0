Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794869287;
	b=z4lFTemPfzcOyvUHtZ4+x4xH8GZrC9Zpe1fmFpVEBxcNSrSMYARbb3pGej+BROADlbg1
	 Dy8tcrHR4lg85/drWdJTeoSbJEyy4W9TpudV7s7KcnDBA7wSyntXHYkhkbj6mMj7TWQt7
	 skFEcEa92AXIZOul6UfMexp171blNfeSoiQozQL7iayP14r3xb6AonA7NWZPIfHNbJYlu
	 qNZb8or7754XhYYPXuoucITBhJMrThcyhVFcVfxdVZIX+5ygqEWFhKi92+1LmsM26WFj6
	 wYzr3cdK4TFfSNo4hRLmp+x7x9aAYsn1EbhJaDjQqm7HhyN2UWgrQ8qOXI0bKN5PVXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794869287;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=sU4YqyP5FNgmymeEWSjJc6o+Mj6OkOMdTqnGg7f2My8=;
	b=u4tLHTD1jHvhXN8KwYftgt+nZUNMLYqNlppYhv1eJC6Y2Zs/Rp0oCkpgoCj9B3/ajWm3
	 LWuTK5cP216R+MCp6K9w0Hpv7TCAV1WEje63pKBKmegRnkAbQilIbw7gXrZhWZ64j1E90
	 7SezHIN/Nwc5nMNQyb5CnwYXItZW8Dk/MqUPbrpaFoxT6CKoc0DMgugpLPMGmTJummmz0
	 3K54EBJmGtzn1dQGEvuDmK/o87S4cZYkiO5MX9kUqbHnjMuZaFYEB00NwPqNYUngYXbTS
	 guraSNZkqu15FS7jBD9mcZi+6z+drMvsqocyUtqh6NbNaFPpE1ZmsMYBGHmnu4UTtcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Tqij0Ls3;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2879606A329
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 22:48:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2879606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Tqij0Ls3
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4395d31228so644891766b.1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 14:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794869285; x=1795474085; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sU4YqyP5FNgmymeEWSjJc6o+Mj6OkOMdTqnGg7f2My8=;
        b=Tqij0Ls35duQSpJgBlkattHZ1rYqD9vGHGegODAx8s5c5oMLV4IOyuCS8Z6dPD3lqx
         hnPC/oaLUWmq2Bhym/evt6pCXSSYhj/o8zOSuKVhBJAk8TIb/sl96q+MHvypsbkNrCuS
         MDToM6G5jI7l91xIOAVpvhvPWCmPDLCTuEVYl2i4WfaeNFHl4iODJlLcvyVMaP0lr+KK
         mkz8OtB4dDfysZtBSV4HTKvQr1tTgE68/ad4cdHaG1TIkUgDPs1SNpIcR/5dM5CfrAKQ
         VojX2sPoNxUO2wwKkLqTeRAJFHqa0p2ThcwxbNYlxZ3E9ELytvnrUCNZNW8mJ9BuVqlA
         3xcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794869285; x=1795474085;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sU4YqyP5FNgmymeEWSjJc6o+Mj6OkOMdTqnGg7f2My8=;
        b=Lz6wKbHUVQnnSZ3EW7c1Sb+qC1Ptk6LlpoIUGk5F0ztLDdOBDPjhcvxmqhwihlprtY
         Of6L98FPqt3WJRPVAo5ZBUOu7ktTmOtk96AjFCi0XpvUp1og7WPefFsv0xHbYzZ/ys9A
         tVmjexTpeKsgR1StsRhLOJNg2R8STfrbD43Gjk85yogMwrTzbs/bjcZfxsfsMaMx+m2O
         D/ezTDNn0Xw5k1obf9OYkQMA4yEfEA+RQo78LY1zCmwxq25SP8vW03rwjrNH4Fe8//KX
         OV5cHqZOTpo20K9paXTESQZSMjMK9+a6pHvWQW/L+xYVdXLOAPjnEZDQhzGKtQywpeXo
         nuUQ==
X-Forwarded-Encrypted: i=1; AL+hErHl88V09Ngt4nENeIphLKdwZdc+Fh8OXCVniEIM9N/xG7IloelGCvHM5ByLJQQH8Z4o4m5fLvX19puTDQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z8O0L4D04kaFHeZak1QIkShaaSgdy9xTsphEhQ9QQ2dgjEK6Sf4
	IKp5uUAv9v+FjI1OOcgydbpuVMrarHf+YxgUTazFjfZctRb4HTnqaYZuTogV+QKScfQ=
X-Gm-Gg: AYBFou1YOB98VSFiHRI8fOFOpxZh4sdtZxOhZjQyu0OOHaJVr1iUzXnao1cK2KV4FJJ
	nSqr51b318GQPdriDULFc4XtgupID5AG35nWk6yM/e+yDqdI/GQCRVv6sPspa/2tXzGOfZ+JSBg
	TO/F1B1XkM/Uve59YYguvj3ZkVP0Ofm0aU+jN7ecXjzmfU6dQyDwMM6nSl7ojafKgQgQa5IXNy3
	34j56LOsnK5TjzvuZIsqwKrQHO5e0vmiBhq7u3fF+EkmYXFPDcJoWaQLxgH4j8h1WY7EoM/cdMA
	sKteJcaZAHPRptpa5KxRLFXL2P12TH0uBycPy1m3/xhkIqa8HfBQiptjyN7B6NRwDY0VsBftPWW
	W1JJ7lbX9b61AFo+aTjBP75bzFYl50aqpJcjBqgdSNfbJETT5v8lRZRqW2cSxLao/NX32K+bELN
	A+lB+qB3CklYbWXCQ0tTrN6rxYdgDnu55Sk2A0M2tUw/k8iLhirC6y00/dhj4U5QGSAj/eCWle4
	LfI+NKiGqCxhkMcpgBMP2kpYmJPKYOS6vlqT2CNyQ2WSpPjhZYRUZAAdIq7JHOcWman0TYMFURi
	qwuimh0lJIZiSZwy9bFl5w==
X-Received: by 2002:a17:906:794f:b0:c50:4b7a:de71 with SMTP id a640c23a62f3a-c5096371337mr1005561066b.28.1794869285237;
        Mon, 16 Nov 2026 14:48:05 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a5835bsm4661905ad.41.2026.11.16.14.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:48:04 -0800 (PST)
Message-ID: <6263b557-1f52-407b-90b6-30af6ad3e3c9@suse.com>
Date: Tue, 17 Nov 2026 09:17:59 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: tree-checker: reject file extents with
 oversized disk_num_bytes
To: Cheng Yongkang <teel4res@gmail.com>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261116050922.310476-1-teel4res@gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <20261116050922.310476-1-teel4res@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/16 15:39, Cheng Yongkang 写道:
> check_extent_data_item() only checks that disk_num_bytes of a regular or
> preallocated file extent is sector aligned. A crafted image can have a
> compressed extent far larger than anything btrfs writes, and reading it
> goes wrong in different ways:
> 
> - With disk_num_bytes == 4GiB, btrfs_submit_compressed_read() truncates
>    it to a zero compressed_len and submits an empty bio:
> 
>      assertion failed: IS_ALIGNED(logical, blocksize) &&
>      IS_ALIGNED(length, blocksize) && length != 0, in fs/btrfs/bio.c:895
> 
> - With a 4MiB zlib extent whose num_bytes and ram_bytes are above 4GiB,
>    bvec_offset + bv_len wraps in btrfs_decompress_buf2page() and memcpy()
>    reads past the zlib workspace buffer:
> 
>      BUG: KASAN: slab-out-of-bounds in btrfs_decompress_buf2page+0x3e0/0x650
> 
> Compression and encoded writes never create a compressed extent larger
> than BTRFS_MAX_COMPRESSED. An uncompressed extent is at most
> BTRFS_MAX_EXTENT_SIZE for a regular write and 256MiB for preallocation.
> 
> Reject a file extent whose disk_num_bytes is above BTRFS_MAX_COMPRESSED
> if it is compressed, or above 256MiB otherwise.
> 
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
> ---
> Changes in v2:
> - Use SZ_256M directly instead of adding a new macro, and leave
>    inode.c alone.
> - Shorten the comment.
> 
> Note that kernels before v3.9, without 24542bf7ea5e ("btrfs: limit
> fallocate extent reservation to 256MB"), could create preallocated
> extents larger than 256MiB. If such old extents should still be
> accepted, the uncompressed limit needs to be looser.

This is indeed a problem. I think you can limit the disk_num_bytes check 
for uncompressed extents to U32_MAX, just to be extra safe.
The U32_MAX limit should never be reached, but we can still catch 
obviously too large members.

On the other hand, you can add extra checks against the ram bytes too 
for compressed extents. That ram bytes should not exceed the same limits.

> 
> v1: https://lore.kernel.org/linux-btrfs/20261116044543.282187-1-teel4res@gmail.com/
> 
>   fs/btrfs/tree-checker.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index f021ac14babf..6bd1dfc58e7d 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -244,6 +244,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
>   	struct btrfs_file_extent_item *fi;
>   	u32 sectorsize = fs_info->sectorsize;
>   	u32 item_size = btrfs_item_size(leaf, slot);
> +	u32 max_disk_num_bytes;
>   	u64 extent_end;
>   	u8 fi_type;
>   
> @@ -377,6 +378,19 @@ static int check_extent_data_item(struct extent_buffer *leaf,
>   		     CHECK_FE_ALIGNED(leaf, slot, fi, num_bytes, sectorsize)))
>   		return -EUCLEAN;
>   
> +	/* Compressed extents are at most 128K on disk, preallocated ones 256M. */
> +	if (btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE)
> +		max_disk_num_bytes = BTRFS_MAX_COMPRESSED;
> +	else
> +		max_disk_num_bytes = SZ_256M;
> +	if (unlikely(btrfs_file_extent_disk_num_bytes(leaf, fi) > max_disk_num_bytes)) {
> +		file_extent_err(leaf, slot,
> +		"invalid disk_num_bytes for file extent, have %llu expect <= %u",
> +				btrfs_file_extent_disk_num_bytes(leaf, fi),
> +				max_disk_num_bytes);
> +		return -EUCLEAN;
> +	}
> +
>   	/* Catch extent end overflow */
>   	if (unlikely(check_add_overflow(btrfs_file_extent_num_bytes(leaf, fi),
>   					key->offset, &extent_end))) {
> 
> base-commit: 3aefd67f08f8ed59ed0fa90619b25856df415031

