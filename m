Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1F6351C2D
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 07:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780041332; cv=none; b=GJLujn5LhgGMmlFjLBoAn08qQMHrlo1mCOLth4Xa8vLy/jc5TWfe0+logIfsaBOq6Mnz+Df18LxmNIIV22zSqOmCzWGxg8aOcrJ3pIkIZoLptU7yR1hTqyOTL4ZGB81QFKEQ08ttqHNv06CyzPnv6DelXJMzQIhqOTIKCYezxpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780041332; c=relaxed/simple;
	bh=az+YGSnbEkqUPIWgm9boM+jZptAY8k8bCMuxg4pC9CE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=AYc/d566PlmDw5LKv6dlUdqTLTswwQ2RKGnDfig4Ny1ivx/b+BhRbhh0bbuDGPv9zqFuxIAghmUeyuZxRlPKDYEifeqt90IJI5KiWAUAxPZ34QBqjQXp8gcOrJH1JvJz34ReChUI2VX1dVOOS2arM0wIWiug1uP3oGNbFQvx018=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fmYfJNwg; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fmYfJNwg"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49050bfe053so42135625e9.3
        for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 00:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780041330; x=1780646130; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=NND3xz9n8aYUKvYXVex2mmyeZtIglxNaprb2v639ix4=;
        b=fmYfJNwgj6tGim4TVejSiA8dTkBmB4b16E6eNaWN0Jd6Iyqi2wBkkNrLD7GWirvHqQ
         BAFq4e39p9yb3uKWM9hwgpJsMdNtQ+HoV3vnb9JdBkPVtdjiH17rG0gKJqcLuwAxgE3W
         lDjZ3yS6DKfCKRX5PVzV2LS/DH2x9VMqWxerarG8tueOLb74nNhXTWv0Dwz0QkkUip8i
         Q1MHygf6cjHYYlkFzlf9TCLDWnvlEq0iidybDTdYpLD34P5jjLeMi7pJQxVJZEUEEyzV
         /BYRMyU2NSlbMQUJO3gmqa0W+zgU4scbSjjUICArnEl7uBUG25f64DFdyUHQvGaGByh/
         GkDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780041330; x=1780646130;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NND3xz9n8aYUKvYXVex2mmyeZtIglxNaprb2v639ix4=;
        b=QsCkQowIrGuNBr55srKdj8w5ueIMq6AlyspxVC3KhaC2cyCeYxFlmSWcRNnQNeMBEy
         C4O0yIhUJe+gXlvSHJyF1TBqbCrB1Ofrx/aWPndb04ME4G+uvb6EO/iPliiTdv+4N18h
         gp5YpFRBVdi1+8Mchu6OLr3ko1SE6fIxPh494G8HQ4hZ2OKvy9GoMoffVQWtcnmm4Iy4
         WFgxPLwYJcNZjxtLNf4CjPh/zn6Gt34kkf6biwLXGgYcviuhwRjghhbQNnnpJI2rimYd
         dhucH5qb5m8rnaqxaeOs+Rg4wD0dcOcCq3uMy1cxU9elQZBwxr1kVdTVe880RgS2wA7x
         H5tQ==
X-Gm-Message-State: AOJu0Yz2O0TYUXkCO6SoFK7lSOtNfJDjt1J+bUyif9joTjFgEsDKFGAw
	BIuBQ6KrBsxZGlKbS97haNdOgABSN3czn/IUBX8uiXjZECXRWwkV8krPNBCELa3x/NuxxaEnrkv
	r+nmu
X-Gm-Gg: Acq92OF2NEKmapIc87Hz26w41UXkUtjz4ivw/6+DKSRVKUjJVNghlaTU46aGkJwgloy
	FZNvyJHwZ0CT7+hyf6Y6Ri9L0jDvXMWGC5YgBZbSfWkgVkDrUCWbab6ynFUkSxOKAVOuR/6Zz9C
	NgNd6Qyob1Lp2+Wp23ro+VssYyzIBNdntnVQ6ZZYxhveCQ0lO6/qjsO3NuH5h490ujgiTgOnRBM
	vBM46cO1JjBEIr3xcNoFZYFclU/3/IjR+4sjQJwO44Is5vr8+PiEKvUe7YIVUi7SXqxq6EY6guu
	x36UMg3E1umlBir8H0OFPSnWoEAIDCfREtQ0G1aYAePij/9goJU5QxAzipH4qr9CsaFLhRWZ9Om
	yxOghFSPsZANskUfhcAWAUuiRey7okmaHVWIOnECmF95U4GCs17kVEF5iqEaYRh5ZVy3AUI/ycv
	Jja5sfESV5tCpTejm7/Z1ylUmi4t2jWZdSvUBG8lXzpEoMwguZ8XdvvZzeYLQvjZcUz2eV8X0Gt
	5brPP9J6V85NFiFvAdQ/be3Ml7eDAllgRmXEgKfwjfxVJfQBvE8r1BQDQ==
X-Received: by 2002:a05:600c:e489:10b0:490:778:4fe4 with SMTP id 5b1f17b1804b1-4909c0c570bmr22167225e9.26.1780041329849;
        Fri, 29 May 2026 00:55:29 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bc65e760dsm1359533a91.2.2026.05.29.00.55.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 00:55:28 -0700 (PDT)
Message-ID: <a3482652-5944-4623-9257-3118aeda4fb1@suse.com>
Date: Fri, 29 May 2026 17:25:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] btrfs: fix incorrect buffered IO fallback for append
 direct writes
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
References: <cover.1779846117.git.wqu@suse.com>
 <54b90ef99f59d9a787e121779ad82b2c77d68466.1779846117.git.wqu@suse.com>
Content-Language: en-US
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
In-Reply-To: <54b90ef99f59d9a787e121779ad82b2c77d68466.1779846117.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/27 14:36, Qu Wenruo 写道:
> [BUG]
> With the previous bug of short direct writes fixed, test case
> generic/362 (*) will still fail with the following error with nodatasum
> mount option:
> 
>   generic/362  0s ... _check_dmesg: something found in dmesg (see /home/adam/xfstests/results//generic/362.dmesg)
>   - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
>      --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
>      +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-27 10:13:09.072485767 +0930
>      @@ -1,2 +1,3 @@
>       QA output created by 362
>      +Wrong file size after first write, got 8192 expected 4096
>       Silence is golden
>      ...
> 
> *: If the test case has been executed before with default data checksum,
> the failure will not reproduce. Need the following fix to make it
> reliably reproducible:
> https://lore.kernel.org/linux-btrfs/20260526070055.60193-1-wqu@suse.com/
> 
> [CAUSE]
> Btrfs disables page fault in during direct IO write, to avoid a specific
> deadlock that is only specific to btrfs.
> 
> So for the test case generic/362, it will make the direct IO to fail
> with -EFAULT, then we fallback to buffered IO.
> 
> However at btrfs_dio_iomap_begin() -> btrfs_get_blocks_direct_write(),
> we have already updated the isize during extent allocation.
> And if we failed the direct IO, the isize is still the updated one.
> 
> So it means the buffered write will respect the IOCB_APPEND flag and
> write the new data at the update isize, resulting the above failure.
> 
> [FIX]
> Introduce btrfs_dio_data::updated_isize and btrfs_dio_data::old_isize,
> so that if btrfs_get_blocks_direct_write() enlarged the inode size, we
> can know the old inode size.
> 
> Then if we got a short write, and btrfs_dio_data::updated_isize is set,
> then revert to the old isize, so the buffered fallback can write into
> the correct location.
> 
> Cc: stable@vger.kernel.org # 6.1+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/direct-io.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 598480b77002..24163a4bcfb0 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -15,10 +15,16 @@
>   
>   struct btrfs_dio_data {
>   	ssize_t submitted;
> +	/*
> +	 * If we got a short dio write and @updated_isize is set,
> +	 * revert to the old isize.
> +	 */
> +	loff_t old_isize;
>   	struct extent_changeset *data_reserved;
>   	struct btrfs_ordered_extent *ordered;
>   	bool data_space_reserved;
>   	bool nocow_done;
> +	bool updated_isize;
>   };
>   
>   struct btrfs_dio_private {
> @@ -341,8 +347,11 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
>   	 * Need to update the i_size under the extent lock so buffered
>   	 * readers will get the updated i_size when we unlock.
>   	 */
> -	if (start + len > i_size_read(inode))
> +	if (start + len > i_size_read(inode)) {
> +		dio_data->old_isize = i_size_read(inode);
> +		dio_data->updated_isize = true;
>   		i_size_write(inode, start + len);
> +	}
>   out:
>   	if (ret && space_reserved) {
>   		btrfs_delalloc_release_extents(BTRFS_I(inode), len);
> @@ -634,6 +643,10 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
>   			 */
>   			btrfs_mark_ordered_extent_truncated(ordered, 0);
>   			btrfs_finish_ordered_extent(ordered, pos, length, true);
> +			if (dio_data->updated_isize) {
> +				i_size_write(inode, dio_data->old_isize);

This part is incorrect, as if we have a short direct write, we can still 
have part of the range written.

In that case we should not revert to the old isize, but to the new 
written size.

Considering we may go several different tries, I think it's better to 
save and set the isize inside btrfs_direct_write(), other than relying 
on the iomap_start/iomap_end() callbacks.

Thanks,
Qu> +				dio_data->updated_isize = false;
> +			}
>   		} else {
>   			btrfs_unlock_dio_extent(&BTRFS_I(inode)->io_tree, pos,
>   						pos + length - 1, NULL);

