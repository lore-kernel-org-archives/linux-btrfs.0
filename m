Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794889884;
	b=cys0e2F4wtOtDvL9BwKiL4n2JCbLgNVz0GKH9pDwzjHF1XVrIFg5tW5tlyo1y2sBvzHV
	 VgBPSEPSnpkHJgOYlZJ1CbYnpybPzXAHh3cT69laEIt6NQu75pL7TCFYMPahq/sgFSy1J
	 eW8rdGKjP1c8lQB6ggN9LBzR1COqqk3CHTXtjWRS/ijLBr/zZvxjmlbuhp04tinq0bNun
	 UlS+aa5f0CYa2OU7T1cr3QLwUy8eaV17J/oJOtRW8wGXphj+jN0lXYT6hdiPISJQGO1r0
	 4LP/P7LQR+uCnX7XNMO3o749WFGBp0+QIbNvUJa81xNkUtcokeK2PAe9nrtwC9xhDkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794889884;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=VTwha74LUualsi3JFl9kgAN0mpaDhmQlRIc9Gl16Ekc=;
	b=VCUOsnwTSalUwlq2lfUSa8LAwQHRuHrgXXJ2gFUKr7HF8WHv9JRV26BR5DewLTvxNMPX
	 IedwhTYuJc05FOb10X+Id8ND/g03lXehj3/l17pQtZr/9cw84pAmTXlQSwGAieF3bPAm7
	 h93RHVcMGmuUfrQ9WE/a1I4Nu8MXHuTi6p11qAohaPSDw7d1GivsOPWBaMqIl9E2UZCkE
	 7XVNRvEoLNi6A9bqPtwt/hkk8YvfcTBYa99Vp9m1XYbiAy4JQtFNhk+xRaYNiI9jX63zK
	 D0PNVr7COG9TJVbHaGAq9OjbO8dRhuM1RwNBso3XqlCMR4410luYLOsNXzlw7Zm0x4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="HLTk/jdG";
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CF0606A32F
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 04:31:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2CF0606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=HLTk/jdG
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c50aaad19fbso328914866b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 20:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794889882; x=1795494682; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VTwha74LUualsi3JFl9kgAN0mpaDhmQlRIc9Gl16Ekc=;
        b=HLTk/jdG9gFZFZLXmGvwDHmD6OplwoHjsBRwkOO6tH78InqP3/4gy/Z9uJMeLz/M/v
         9/Jyu2EwQIjvbPH6RHvg7eAPIqNbqqYICTaclTJrFZ5odl+N+P7bNaXx54eXkQsqe4Yp
         VYnRTImUOBpbYtTBKj8ZpMaSfDRqmAEesZvwZ/pl9x9rde5lhzgOtkbWL+b8NaYePdTY
         jOnoNoY1opQ2DA3sdcjfRz5TIWNpv/ZciZ9VQgDpHdMGsxjghIGv2mJK2/sOtP3d079I
         X6YHrB/UpPG+Lesna+XTnAhBUI55Eg9OUyMdD312xOFliz1v9Aldwwn4q2iqRCCq5KcZ
         B/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794889882; x=1795494682;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VTwha74LUualsi3JFl9kgAN0mpaDhmQlRIc9Gl16Ekc=;
        b=hGupK6ykZFgYRCXfHSHkwrTb6/OACV9zbS/TykToUJsLnBDnoRuBUqd9XVNkgMcwwJ
         1cNv0iLIqZpwbflHuVYO4PxyGehUKOimdYrjls5CuJl7cSxAjrKmByrFFz/q/FD5HIyg
         LEk2ae9CeU+mely2k8qfgRBHj2WEN88+rmJH8g6lNCE9Jffl2lPZf8rJdLX/tz5lnhcA
         6vzrP2tT0MvYG9fqLoJ8XpWt4iDNlMDvsYLlacit7xYLEmmlfJCfYVZC8bFqod4T/WfF
         32Q8b0GocckEJav5iO5xi0eXYBpNgRo3u23bCB4lg7T3i9cZ44ijclG/A2PHdqF8QEnD
         9ZsA==
X-Forwarded-Encrypted: i=1; AL+hErEmfcqidFm7Vwa8FifJY1vNDmNprxmRR6wk2QofcvcCiTWpCJtREiKEWI+o2q4g7mvE4l4gWv6PHnJyPw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/+vuDLXRCPCfuS94YFd11jLX38+11vB0kw+DQFSyAUcSdh716m
	iXGnjNfk+sA9UQUqU3U/1PDQNaTCj+ujVQ5KGAyJ2hD+f5VXPIg2n3QLmCkH+0jdsl0=
X-Gm-Gg: AYBFou3ln4G7KGFUJjqnObV4tSdkLr7N/OLl9jRVaZM/tgMxYmaypb6+5HvlL6NmDkA
	uqE/92+gNwMnb7djeyebjuR6sbn6xG/hz6HrXRC1fkjefjgcDOjLvqxbzETpXAWETY5REQ4L9aI
	Tc556iRUmigDzz9xCjf1QEbfeKN2JU6J6aM/tE0iba6ofWF7ev0r83feJuDLJltN0QkeEyEVanM
	KZe/zmtNvR5zo+Py+cNQkK3CIjaiYi8FEyjOjR7vrfA9LXuoanq1yxg9b+U/e6BPQV0Hhe2Dwjd
	TSpl6DS7QwXk45K3On1I9IP/KnZG8JksDi5ZrrybMcLuFTjFAHPGQ+Y725CeBBL5Kp48XMcLAuQ
	usaMHtCftGeLWORm/cJYmtv8fpOXjnyMGJeJJOYcOeHnk1EBw2ASWaEksVdN6huw15oRx+OLpoU
	X9QYgjxdPFqImNWkp+R7A0hJiv2LLjmLfwQSr8nCCiC9dg3gOMu8vFLPFXivUuHoW6pbrwZKg2G
	7B7dQ8jQRTJ604rL+z3XV11eIetR3XkPg0qmdeXcrWi9Hu0CZ5ry7vmMY9v0WyA7UQ1FWCe2aLk
	rscbiT1FqtkEII/+7IKnkg==
X-Received: by 2002:a17:906:9fc7:b0:c50:521f:13de with SMTP id a640c23a62f3a-c5096543e9amr1024760566b.35.1794889882176;
        Mon, 16 Nov 2026 20:31:22 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac4cff6fsm1908063a91.12.2026.11.16.20.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 20:31:19 -0800 (PST)
Message-ID: <35bcaa47-55c5-4b2f-962a-c3168bdf52a5@suse.com>
Date: Tue, 17 Nov 2026 15:01:14 +1030
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
Subject: Re: [PATCH v3] btrfs: tree-checker: reject file extents with
 oversized disk_num_bytes
To: Cheng Yongkang <teel4res@gmail.com>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261117023841.467366-1-teel4res@gmail.com>
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
In-Reply-To: <20261117023841.467366-1-teel4res@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/17 13:08, Cheng Yongkang 写道:
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
> than BTRFS_MAX_COMPRESSED on disk or BTRFS_MAX_UNCOMPRESSED in memory.
> Uncompressed extents are limited to 256MiB since v3.9, but older kernels
> could create larger preallocated extents.
> 
> Reject a compressed file extent whose ram_bytes is above
> BTRFS_MAX_UNCOMPRESSED or whose disk_num_bytes is above
> BTRFS_MAX_COMPRESSED. For an uncompressed extent, only reject a
> disk_num_bytes above U32_MAX, which should never be reached.
> 
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
> ---
> Changes in v3:
> - Relax the uncompressed limit from 256MiB to U32_MAX, so preallocated
>    extents created before v3.9 are still accepted.
> - Also check ram_bytes of compressed extents against
>    BTRFS_MAX_UNCOMPRESSED.
> 
> v2: https://lore.kernel.org/linux-btrfs/20261116050922.310476-1-teel4res@gmail.com/
> v1: https://lore.kernel.org/linux-btrfs/20261116044543.282187-1-teel4res@gmail.com/

I don't know which agent you're using, but I have seen several ones (not 
only from you) doing this linking-to-older-versions behavior.

It doesn't make much sense.

Let your agent to learn from patches of known developers of each 
involved subsystem, other than follow whatever weird built-in prompts.

And the full changelog would make more sense, other than letting the 
reviewer to jump to your previous version for history.

E.g: 
https://lore.kernel.org/linux-btrfs/036f030792d3b497db41f1e7e376e085e094d006.1794588939.git.fdmanana@suse.com/

> 
>   fs/btrfs/tree-checker.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index f021ac14babf..e5d17bf4051b 100644
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
> @@ -377,6 +378,30 @@ static int check_extent_data_item(struct extent_buffer *leaf,
>   		     CHECK_FE_ALIGNED(leaf, slot, fi, num_bytes, sectorsize)))
>   		return -EUCLEAN;
>   
> +	/*
> +	 * Compressed extents are at most 128K both on disk and uncompressed.
> +	 * Uncompressed extents should never get close to U32_MAX.
> +	 */
> +	if (btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE) {
> +		if (unlikely(btrfs_file_extent_ram_bytes(leaf, fi) > BTRFS_MAX_UNCOMPRESSED)) {

I think the ram bytes check should apply to both compressed and 
uncompressed extents.

For compressed, it's MAX_UNCOMPRESSED, and for uncompressed it's U32_MAX.

> +			file_extent_err(leaf, slot,
> +		"invalid ram_bytes for compressed file extent, have %llu expect <= %u",
> +					btrfs_file_extent_ram_bytes(leaf, fi),
> +					BTRFS_MAX_UNCOMPRESSED);
> +			return -EUCLEAN;
> +		}
> +		max_disk_num_bytes = BTRFS_MAX_COMPRESSED;
> +	} else {
> +		max_disk_num_bytes = U32_MAX;
> +	}
> +	if (unlikely(btrfs_file_extent_disk_num_bytes(leaf, fi) > max_disk_num_bytes)) {

Just like what you did for disk_num_bytes.
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

