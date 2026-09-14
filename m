Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076592FE057
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 21:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789421621; cv=none; b=pxmBbXIcP067nXo1E/E1B04odyzgXDjp6VJ5d57Cym9ENg2nzA1+XCkUM0Cvpow/tbE8iKyp+Rj/cyy58hDyqlDOLyd5jcsF6TxoCOXEwK0kH3RzsePRQXIdhC6UFatslFnnP3HXXVoYOMt5XlfP0iZsXRZ3ikytT8mAArDlwmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789421621; c=relaxed/simple;
	bh=034N9vpnski9up3Fdr4ZpqK8zg8XSKdqfRDgKY+yI9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=D5GGpBL5WYIKAVr/pnTI/1GsTVC+ea1Q5f6f7bubie2ejHL2UAX6N0NyOb7mgzUWTJRawYjcGK0eZG3GMVFja0DhkTbp4/92rKNn60/P3JevD5RkIyL7m3VUgGLZwxOpqHKp5QWvVpgxX8j4NrJCXh61GrPZEnBhBElyql5vsRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a3AVKhZF; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a3AVKhZF"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c25ef7a3ce9so321535866b.3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 14:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789421618; x=1790026418; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KSryFhBp/2feyW9IPemruF+3mtUFbC4lpOWJCsxEEgw=;
        b=a3AVKhZFVnQfjY6DnkMyxWJR1WkoQ++MY5Rs7EmRrfsymzzpWynglj08DhJO+uzCrv
         nMOiXJzPk3ypba3iSWHj9C14Ak71V9KPv6waLMbYkTXKuZmLILfUqp6Ut+goFz2I68RS
         zX2l/llKjpl1NczdYg6FVBjxM91qtyzXdqp2oCva6SuHNwHdCzHMtUBpOw4bPIaypsWF
         fE5f9mwpONyJ6boQwr6NIZ++xPZUUvc3Y/tqtIt/TOU49g9oJuI4Y8vrcf1mttHFXzxj
         brg2lfZT2oFkHdEwK7LhS3PIv7J9U3nEqtKI4rV3gfpUm31NNV08oWC0cbvprzAE7D3B
         6XrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789421618; x=1790026418;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KSryFhBp/2feyW9IPemruF+3mtUFbC4lpOWJCsxEEgw=;
        b=zePqrSinGsac5k2lVWfTGzVjFHCWMmcfeEj99aUY7pumavXfQe1/WpW1Cu2d9WcM/J
         DhEAQiidzheeP6xkxbBjzL6qKPehy+ebc19Vl9oaGBvYtyx04ZZWTI97ixDKj8MFzfDo
         WUysjLsfUNUsWnETTBEzkCQH7szaIkdE4Vb0rG+J98GFS0qug3oieMjuGNQO31VNI6SK
         i04mRw+YWcw1g4hIxuGYw+MV3u2Q+KbqUAfPuQBTF1lvni41OJYVt+OtFd9atGXv6+0K
         NXJeNGlE6ymZ2LYPGotCegFWdPQlxOLwp+VuMyMT1ENLjtOJtDZGdAOPlgmZA0S6ZkvT
         6Akg==
X-Forwarded-Encrypted: i=1; AKwUvBz6Fu95VbCDgkyyT0zSUsEKHSGieuYaUSu3ocyHtuwiCaFDfln8da6y0L3ISD8wpMiORYwamo4OIrrp7w==@vger.kernel.org
X-Gm-Message-State: AFuF++mCXSU4IJeDCmQUWzRw2DZNJzf1QDKFLX8XSOQ8eW/8DizL+j1z
	G+cTN8+Wy755ZhjUv4pacZUmtoqmzQ2pHCeDxtj2DHEqSCAbZ2SN2GNhpMh2P8Q8abc=
X-Gm-Gg: AYBFou1z2eRMihLNigu/10aIOKrsGFzP6crnAo+sqGyZmBcZ4X3mxQhs2+oY7ydXOWt
	YmbN7A7zIGrDFgmF+DoH5DRPsVqUl40x3jzNZltwqsjYxBmOPWwl3/v+EqNA+ER/75VcgbMfpY4
	xENdxOqve4/TqGfUvbVpr3j1uxrA/HsWJzSEqPb2MWJR24qpiLAcxzAZ6GC9y90z9z0NRIEohc5
	3DPvOA+9OVZB3T3AvEpWr7kMrWH4yS/Mn3DFebTnnfNXpbe7+roouX+HKwHQXwsWox/mW+KbtDV
	nTDuVhTi0ZPVk6jzv+PF63jveorVkyMC9Pbv1cNoF4LGAyc/d4gruTSYgnYyXrEXKCv14G/inUM
	70UBvC63G7KnaC0YT+BMWMJ6xMXU/0k7n08I/+7ws9FfAiUMjnctJyHdYmC+CI/BPw6N7igBWK/
	n5/klifqB29FGUSRvhaWVTuoG/GewEtv9eX5KuMpDUUaBnRuXy6H9h/I6yCDUPFB8=
X-Received: by 2002:a17:907:720d:b0:c26:1649:47b4 with SMTP id a640c23a62f3a-c29b87180e1mr286778166b.42.1789421618124;
        Mon, 14 Sep 2026 14:33:38 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39dfdd9668dsm1186927a91.16.2026.09.14.14.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 14:33:37 -0700 (PDT)
Message-ID: <733c94c9-a24d-4bce-9baa-a87f29b9deae@suse.com>
Date: Tue, 15 Sep 2026 07:03:31 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: fix creation of compressed inline extents that
 don't save space
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <721d8fd2c73095d06cbdbfa714a6dfac9c488953.1789407346.git.fdmanana@suse.com>
 <db49ecd42bbdfb15a6e103d1e65da94cb7409543.1789414631.git.fdmanana@suse.com>
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
In-Reply-To: <db49ecd42bbdfb15a6e103d1e65da94cb7409543.1789414631.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/15 05:10, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If the compressed data of an inline extent is larger than or equals to the
> size of the uncompressed data, we are still allowing the creation of the
> compressed inline extent, which does not result in any benefits, quite the
> contrary as we waste metadata space and have to decompress when reading.
> 
> This is a recent regression introduced in commit 3eaf5f082c4c ("btrfs:
> extract inlined creation into a dedicated delalloc helper").
> 
> It happens because we are passing the block size to btrfs_compress_bio(),
> so we don't get -E2BIG from the compression code anymore, but we can not
> pass i_size either, because if i_size is smaller than sector size, we
> end up never creating lzo compressed inline extent for such small i_size
> values. So refuse the compressed result at run_delalloc_inline() if
> its size is not smaller than the uncompressesed size (i_size).
> 
> Fixes: 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated delalloc helper")
> Reported-by: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/c97652a5-ac6b-4de6-aa23-3cdebc01d00b@gmail.com/
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> 
> V3: Fix being unable to create lzo compressed inline extents when the
>      data size (i_size) is smaller than the sector size (caught by
>      sashiko again).
> 
> V2: Check first if we can create an inline extent otherwise a too large
>      i_size would create a lot of work just to be discarded later.
> 
>   fs/btrfs/inode.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a85a7c561cf8..2b4387db937e 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2339,12 +2339,27 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
>   		} else if (inode->prop_compress) {
>   			compress_type = inode->prop_compress;
>   		}
> +		/*
> +		 * We need to pass blocksize and not i_size, otherwise we can't
> +		 * create compressed inline extents for data smaller than sector
> +		 * size with lzo.
> +		 */
>   		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
>   		if (IS_ERR(cb)) {
>   			cb = NULL;
>   			/* Just fall back to non-compressed case. */
>   		} else {
>   			compressed_size = cb->bbio.bio.bi_iter.bi_size;
> +			/*
> +			 * If we did not save space, it's pointless and wasteful
> +			 * to have an inline compressed extent, so fallback to
> +			 * an uncompressed inline extent.
> +			 */
> +			if (compressed_size >= i_size) {
> +				cleanup_compressed_bio(cb);
> +				cb = NULL;
> +				compressed_size = 0;
> +			}
>   		}
>   	}
>   	if (!can_cow_file_range_inline(inode, 0, i_size, compressed_size)) {

