Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017204F93C3
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 09:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792054936; cv=none; b=gNViTFgHnmkXE2IgS0SwZkUlmhgY6XFks8f1eQe6BRHRUGgcOSTKsTvjQp8lsj/ccSkQBTebecxE+QFoTifQqPerXNY1pTA03/keEXFvrLm8TFnIIO9HSbyBqADAA4SAxXFWJbXhb9+KtUc4kdvsRgINM2NsAGfoWHq9GXlcf5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792054936; c=relaxed/simple;
	bh=0/WLtgt8hKK9/6UbZbHkNnQAX0izmZ5zFr4Skps/vz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z8q1tF02amZMzu6OoLkYr6bg9IOyQuok+RGMVZRs00TVdG3yruKuXfeTlh0wja5p3gg7egs+w1mg8gtt6dLf41RoUS/FU9PYZCoNbS+UfXyTbomM3frLAz9CbFZGEWxD6A3x/tC047HOK5Hkx4EiSUDFpdG+ugEBapoNBxsE+4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QwplHTDA; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QwplHTDA"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3a808f09021so14082071fa.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 02:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792054933; x=1792659733; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gCzb5Jpho3eEfUXrbXcsB7wXdosyNE0+dqqyroWERu4=;
        b=QwplHTDAmcBD3So4wLTGADhp1YscyFzy/j18sphTljBmRYhgBdagx+BO4q7hrbd4bL
         E8w1nQy3lXAH12nHJ1u06eGcDgRIlbpuYhAFPI2Q9xro6PMMd7cq1R2UPMoM+NNdrtGa
         /5z2QDhZl6mLAlh0C38ed4rfVm6XImJp8D55xBb7MU7Y+yZMJw76ue804WcEBwY5SuL9
         ByCZK+FzGZEkSWnRdewG+ddLMFVXQP2EE7PaqSoidknd9EHwS8pUHPnrY34TJ5pet1Bv
         yZfdgyFq1lqLgb+Wx50e/3nfX/ZfQFILq/jzuzHhXwPq77Bpj94kL+LkW8XP/n0TZMlt
         Abfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792054933; x=1792659733;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gCzb5Jpho3eEfUXrbXcsB7wXdosyNE0+dqqyroWERu4=;
        b=fZjEgE2V0ZA0qvj6EN7mCZnwOUoH+7kSHkhPtBAf1GZfiWWJVS+4vlCcdNCHbc9KOR
         TKsCh9Ibi1LZnm4y5lE8JEXqob7WtkYxyQCzaKwa5mTSKrSwWMR0wU+Sl6w4YjmmO8Cz
         23VIvcyeg/XbqBb98EFhjmFw+0tWgECzlL5+ylTyrAnbp3Y2iSWHqTNOOEURoCyDDhVu
         IK4y9J+IVlosYIIgte7jzrKXa/7w6VhSMAaTu18aCjoZqlgFuP/93q1dxJbybRi/u+R8
         FmW2wVd+oSkA61Rj4Cq5+MWgpw9nd1bBF0kLwR+eq7dIpla1kaROYG12F73OSDeCrGk5
         4e3Q==
X-Gm-Message-State: AFq9FYJq4vX7bRNxO7aqJ8FMYnEyyXtc4U4MPuSuIzzMG8nYilaw6WFy
	YFmGaw4nauKdeq13ahWdF1Q91/oUJHrqsU50ghEasG5ANL7eEhqp84wFeEbQN8Av69w=
X-Gm-Gg: AYBFou335Go0zzdHUziVTtI7bkvhgVm7DkfipKUlWSEIP3+MfF4ysrqiZEw53KnhPGC
	3u6ps/Wv9o4X15moxyN6ndIJseyYdbE1xWWQvQQp2I2srt+u5CvV7lRsVUXWYN3T3H4rCi9S10h
	BtDNWLoEDNNGSoME4adD1zKHxmlmKRFP94O0nPMmMu0baVEn1cQtMF4U9C8ByzTKl+Pd3SjcjS2
	zKD0CV9amchdztelmr8Kfq+FQ66FgNggzfT7OrRdJ8Ot401dCoasyPZBMs0MXkAHZoh4Zt4bbvt
	XlVBMjGTd1kJjyUdyMMn2fxr4NzHMgD8JUTMcg8rjoFezwHxKFBOanDnt10ldxBPcGswCuG4E1s
	QGjJuYK6FigS41Q8a+f4Ow8IzuEejwc77w+606ge2vU+ISNsFyAUAzJfs0CfQq3Dv0Q3FL5dfGY
	9cwJbl4xnDAou3gpGGA5sDKxjwX6CbIb07jgSB0KB7ii4YgD355dNR3w5ApIelEQu8vlRUtIy/
X-Received: by 2002:a05:651c:1542:b0:3a6:692d:b7ed with SMTP id 38308e7fff4ca-3a9c539343dmr49621261fa.20.1792054932846;
        Thu, 15 Oct 2026 02:02:12 -0700 (PDT)
Received: from [10.86.129.46] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac9376ea64sm1558364a91.2.2026.10.15.02.02.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 02:02:11 -0700 (PDT)
Message-ID: <e3321d2d-d8dc-43e5-8501-31b2d5ae1146@suse.com>
Date: Thu, 15 Oct 2026 19:32:06 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: verity: return error from btrfs_orphan_add in
 begin_enable_verity
To: guolingxing <guolingxing@tju.edu.cn>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261015071128.3319350-1-guolingxing@tju.edu.cn>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
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
In-Reply-To: <20261015071128.3319350-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/15 17:41, guolingxing 写道:
> btrfs_begin_enable_verity() ignores the return value of
> btrfs_orphan_add() and unconditionally returns 0. When inserting the
> orphan item fails (e.g. -ENOMEM), the error is swallowed and the
> caller continues to build the Merkle tree even though the orphan item
> was never written and BTRFS_INODE_VERITY_IN_PROGRESS was not set,
> leaving the on-disk state inconsistent.

This conflicts with your statement just lines below:

"The transaction is already aborted inside btrfs_orphan_add() on failure"

So why the on-disk state can still be inconsistent?

> 
> Propagate the error to the caller so that fsverity_ioctl_enable()
> aborts before building the Merkle tree. The transaction is already
> aborted inside btrfs_orphan_add() on failure and released by the
> unconditional btrfs_end_transaction(), so only the return value needs
> to change.
> 
> Fixes: 705242538ff3 ("btrfs: verity metadata orphan items")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
> ---
>   fs/btrfs/verity.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> index 600337a84fbe..d92c9dab0293 100644
> --- a/fs/btrfs/verity.c
> +++ b/fs/btrfs/verity.c
> @@ -615,7 +615,7 @@ static int btrfs_begin_enable_verity(struct file *filp)
>   		set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
>   	btrfs_end_transaction(trans);
>   
> -	return 0;
> +	return ret;
>   }
>   
>   /*

