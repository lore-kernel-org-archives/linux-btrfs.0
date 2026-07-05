Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194CB1C6FF5
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 05:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783228541; cv=none; b=hxARoJipLl04da1tTsSt35f/5THFmoepmskIA+f84EawOud3kA2b4e1e3/0zwfhrfSFxp2xyWbtdZ/4ORn9fsuWAbQWasoLDOwt7nS7Rw9YoIVW8BXoSPdAPSntlQvJzhZgMhC+SahkrtIyf2KpAqPt+wCvdKFbdh6QT7AqjnYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783228541; c=relaxed/simple;
	bh=1lxBOfrM76Dth1jVY5aVxocbSEM4kFaO8gNgmjK2d2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pkwBAZ7V8AtdhZ/ij8hlwPFhM5F3q00XbxjXD61qxbNb3chyu4rgSF5e8o2dg0VR3jy/D25o50cjhIgLhycTwYnbK02taO9mzG8t5KpuY49fTwzrGz9LvrbGoeWViOHmlMD8eZp6FZghOb3wkYoVKU6tMhDaV4mx4Ya8VuHSo1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=E2oCbRi8; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="E2oCbRi8"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so17974395e9.1
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jul 2026 22:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783228538; x=1783833338; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=IhMTjNAALr6vJEPvq6PkdC1O1tlW7zlY4E+fREX8Q78=;
        b=E2oCbRi8+QHEQ3X2J5UJIXDFHECxYt/lTyMHf28h55fq3b6PnosLxlnSV5lNfCq69A
         i1liKxbb/NmXuHoSEOTKNcM6jlMKDjNQRegelvDwdW7s0TYocqQf0vTcKxBKnN8m8e4j
         KBLnRkT531isvb89YtsY1QzjY9W5EtI1Ki2zZ5P4ezYipxNctxwI2C8EyoygQH4XhZ28
         ai13fEjEDiaRxVUd65cC4VDO6fE2iwt9dnNW2+eMRQRSFHCBd+XSoSMe47nF0atbaGi+
         e6OzGlrRABjzK5msUJ0bof8ik5vFBEAwNNMSQDRk6bptrSquJGPZorr2wCazo1gRglA8
         O3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783228538; x=1783833338;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IhMTjNAALr6vJEPvq6PkdC1O1tlW7zlY4E+fREX8Q78=;
        b=djrOzfXkbT8fq3EwtsYPfaOV43wPBpL1Kk0UvFmGiHozlyaibUCfKBevCHPBQJy/mI
         KvsuqV/gG/0QtR5dDO0gBvDkQAevARwP3XOPwEIWkbLSd52LY19LaU8jPlU+jRLs6EHy
         6sD+0Zeq0DRh4tepp/D5Gzc8lMl2aEGDAuexEo660mZZ92Er/VBWuUxckPFwl9gMuUrd
         +pzsrKY5LDov6bRfkuTAKs8fV+cG/fGnoPyosBWyejNsEYAo6BtTU0xOLMppPGtvFmxt
         y3Ze9CHW6bZoTNPqegatcX+IAHgNvUgSrG/GOlkMG/q4UMDue9p1QWil9RRPX6RJzzGg
         +r5A==
X-Forwarded-Encrypted: i=1; AFNElJ/X2qU+tTp04gjrNxVhXq8iIs3Od3VOKWYHzyljkbuLc/WWizVO6f3UbIbPrx1r5V8JgR/CilnLlxXGfg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgT/vx7GKZuvEK120rgeeZw6BFEt5IRyfwqlvEryKOqiTSAo7L
	3E+8XJpfHKTgJ6PBulTr+d/aQ36Yk1KDKhBgSZK5xuch+zIJxdfzfki5Lv2qhrcBBh0=
X-Gm-Gg: AfdE7cnBoegddKz5IHRTLu8ytfw/xjX4jGG1fa4tOGscDXYwXloB6PBklPIefaM8Q6a
	Bpnm5nzhRK7jws5Ap9taufD97IDYYj8rRvzyWtzdVEqfy03YAL3v6W/911wnboehRckxatTHRcn
	kLY872eHYFNdhEO8zglK0z023jF9DeN2IFd2bcUWuAjjJGkcLLSTQSJIzvcrveDyf+tdEgfstTB
	HVIyqtI6KpBMjRsC7QNbkY2TAiVC7egap/nPyxUDzfoK+S8TjU8W/WewOtQSANYwoygiEYmIKfZ
	Q3ygeaSkeYBSCauThueV8lYbb6wJ9vkhUBnLNVsmC1iw3ADMpdt71bi9NDjLOnbZO7fnJ5h3rZP
	NtyGNgUhWb0m/7waTYaJN4LPgxOqWvJjn6kKUfPUShCP0N2QtY/KzRtQ5ng4hczWJnpTOLhFSiw
	zN2BMllQ3LALjZS9l5qKsSSb5jdSKjSPur8+njglu2
X-Received: by 2002:a05:600c:548c:b0:493:cbd4:8910 with SMTP id 5b1f17b1804b1-493d11f03ecmr58083735e9.18.1783228538409;
        Sat, 04 Jul 2026 22:15:38 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c85b345sm57249556c88.10.2026.07.04.22.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jul 2026 22:15:37 -0700 (PDT)
Message-ID: <82eb6b51-fafa-4357-b1ab-e9c009efa877@suse.com>
Date: Sun, 5 Jul 2026 14:45:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix extent map leak in NOCOW direct I/O write
To: Shuangpeng Bai <shuangpeng.kernel@gmail.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, clm@fb.com, dsterba@suse.com,
 fdmanana@suse.com, jbacik@fb.com, stable@vger.kernel.org
References: <20260705044154.42627-1-shuangpeng.kernel@gmail.com>
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
In-Reply-To: <20260705044154.42627-1-shuangpeng.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/5 14:11, Shuangpeng Bai 写道:
> btrfs_dio_iomap_begin() calls btrfs_get_extent(), which returns an
> extent map reference that must be dropped on all exit paths.
> 
> For direct writes into a NOCOW range, btrfs_get_blocks_direct_write()
> keeps using that extent map and asks btrfs_create_dio_extent() to
> allocate the ordered extent. If that fails, for example because
> btrfs_alloc_ordered_extent() fails, the function returns the error
> without dropping the input extent map. The PREALLOC path avoided this by
> dropping the input extent map before replacing it with the newly
> created one.
> 
> Check the error from btrfs_create_dio_extent() before replacing the
> map and drop the input extent map on failure.
> 
> Fixes: 5f9a8a51d8b9 ("Btrfs: add semaphore to synchronize direct IO writes with fsync")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> ---
>   fs/btrfs/direct-io.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 460326d34143..2b1a55769ec6 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -281,17 +281,19 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
>   		em2 = btrfs_create_dio_extent(BTRFS_I(inode), dio_data, start,
>   					      &file_extent, type);
>   		btrfs_dec_nocow_writers(bg);
> +		if (IS_ERR(em2)) {
> +			ret = PTR_ERR(em2);
> +			btrfs_free_extent_map(em);
> +			*map = NULL;
> +			goto out;
> +		}
> +

Overall looks good to me.


The function btrfs_create_dio_extent() is a pretty bad design for the 
lifespan management of the @em2.

The idea behind it is, for true NOCOW writes we do not need to update 
the extent map. But for PREALLOC writes we have to update the extent map.

So btrfs_create_dio_extent() can return a new em for preallocated 
writes, or return NULL for true NOCOW.

Thus I'd prefer to have a new comment, explaining the returned @em2 
situation.

>   		if (type == BTRFS_ORDERED_PREALLOC) {

And change the above "(type == PREALLOC)" condition to just "(em2)".
And maybe a new "ASSERT(type == BTRFS_ORDERED_PREALLOC);" to be extra sure.

Thanks,
Qu

>   			btrfs_free_extent_map(em);
>   			*map = em2;
>   			em = em2;
>   		}
>   
> -		if (IS_ERR(em2)) {
> -			ret = PTR_ERR(em2);
> -			goto out;
> -		}
> -
>   		dio_data->nocow_done = true;
>   	} else {
>   		/* Our caller expects us to free the input extent map. */

