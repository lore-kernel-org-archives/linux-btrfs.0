Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FB83B3BE5
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 06:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786949028; cv=none; b=If0RqSW5fL77z2EzINdS1W4QH5+gYzWmm/kivQYEgs0Ksf0YwR0o6eIqdKA30jtL/bANIp/YjOust6oTdqAYFSzouAxgiMXQw2pgT/0Xoahcq8MSJFpvLuIinhnjZqmjMsp1yGv+2UOeZOE8JWV2iJ9k/AWfkcTwSjTukMPMWgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786949028; c=relaxed/simple;
	bh=GvOIkmM2XCV3u4XbBXkSDGh2vumEklzHgMhxwwsmZFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m96+1uJu4A1+tSkxz0esg8T9YePfD732TE/tR1SW9ua895/GcL8XOYUgoeBvpWDYfztfuV2MGD31w7WaSwallkObZdqNiktkB2DP47i3FptXDLflhnyf8VNJvRp8+q3l/l+r1n6uQZWcnRvhFWKKZ4tx1pkbhRMrO57cAB8RJzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Nf/qMmOH; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Nf/qMmOH"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47fe2d179e2so1935421f8f.1
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Aug 2026 23:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786949025; x=1787553825; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5ZY2hQm9399FpzIqQNXf66bt6CBMezxdVtheF0+VjAE=;
        b=Nf/qMmOHJFIFJHd4lezRUCEMwBnMcRRGc+h/vJxjC2CCU4ODWKRjxMGrcY4I8GmaaR
         RWhyv13+6HglN11nLqu9HQ6f1R4of34/lNYfeH4QXQH4Bud50nXqncM6SIpHDjGZCoOn
         yp5WtP6J/UL/e/lae1kWUj/ofIK1fJPidG7wDffTO/AJYqDuu6hTGl6/6HGyvHL4Zxxk
         sSvGa0uPB0Pp4WWz+kLO9t27UfMMwva8uJEIkr+GKdrjaMrEC9ebqz59IXp4lt7G6SF2
         gXTFVHkz+Rlsp5y0aZMY/TRmvmN8rhjvu22SM35y3+8l2aQaKEhFpfR3Agdw062URdD6
         c+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786949025; x=1787553825;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5ZY2hQm9399FpzIqQNXf66bt6CBMezxdVtheF0+VjAE=;
        b=dLt+Khco40kzs/b84jbh5ek5912BUuSwlyXQs8WtG50CjA3A+lVhEcNG2EI0CkwiEW
         MvR5Mztu8pg48V6VRcKow1RrC8z/TJWgtqlcM5wcd5YF/CjBA7vaHAe/hbDuO6/I8jEG
         ETdgfVtHET6jK1KOuqPpAA9f6SYz/htwa09rjFy0PDwTM1npN3EZ1Ol+KXwfQR0TErED
         iCong7zuQlVI0vSGQ9eJTlVKexR0qLbRYVaIOhqXiz+aWSKwCWD98hFA6mOeIb/1Gsir
         JQ3SfCDTs8FJNn4HktI/P/3rpQO0CW+PQj1bfF+XP0rF/H4Izy6ni/qXOuDRWyj+1WeT
         8sUA==
X-Gm-Message-State: AOJu0YyoHnuBWJeUOrWDSSHwaRZoQ61xi98HWOekAmX6BnBB5S9q6hza
	P/p2xQ8TOwS4qSD6gxpNZq0pR9g+LQBgQTnZ+Olxz7777F8Xe6+abgJCipTfiskSlC4=
X-Gm-Gg: AR+sD13+nO9ZefVxW3moSpLn61lAmSjYW8C/2ILQpO3ZPxaT0DSnH98CATdiIFW2RdS
	6AXi41aZD+wCox0Y9Eh4xflh07cVS7nhkn1L/Fyd9ni+uGfxIjODr/BCYkE42uaGsETXzGb79Sh
	LIxYjvGv2/n9wXnz9xTm69AA8GrrcU8JZS3OUN6wspkw4FiOsRR8/BNEttDraatp5VMxIdK5aC8
	Vo4gSplYvL0S7EY+210UORjEcVF3wlOM/jJ+SMDcm8mV52bpkXcUx0NwMbb3RvOU3w1BtqgLNDo
	4wAxMiDI5nzess5fzmd6ZTgr2Mxqf7SJ6Ga8mXQ/OaiKZPUZmei3HjfVfI6vzd0/mqo2ggZJViu
	+V4ZkHcjYaCdYt0FV1xNDIdW5whEDe9+iGtKPBL6eC0rbAawrL0aBsZDRiYJALEuT8/71Mhr0sk
	Gmr3nL0XIn7L/yMqZJKtKTRawqlCh7kRXeuwqfdHzA/71GL/G9P0E43w==
X-Received: by 2002:a05:600c:4e89:b0:499:516b:83d5 with SMTP id 5b1f17b1804b1-49987961bf9mr309581465e9.11.1786949025011;
        Sun, 16 Aug 2026 23:43:45 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3954d2b85b1sm1047552a91.2.2026.08.16.23.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 23:43:44 -0700 (PDT)
Message-ID: <72e6138f-3c9e-4094-a746-bd1e4c6f1558@suse.com>
Date: Mon, 17 Aug 2026 16:13:37 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix missing folio_unlock in read_merkle_tree_page
 error path
To: Hongling Zeng <zenghongling@kylinos.cn>, clm@fb.com, dsterba@suse.com,
 boris@bur.io, willy@infradead.org
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 zhongling0719@126.com, stable@vger.kernel.org
References: <20260817053607.46939-1-zenghongling@kylinos.cn>
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
In-Reply-To: <20260817053607.46939-1-zenghongling@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/17 15:06, Hongling Zeng 写道:
> filemap_add_folio() adds the folio to the page cache and leaves it locked.
> If read_key_bytes() fails, the error path only calls folio_put() without
> first unlocking the folio, leaving it permanently locked in the page cache.
> This causes subsequent attempts to lock this folio to hang.
> 
> Fix by adding folio_unlock() before folio_put() in the error handling path.
> 
> Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>

A fix is already submitted and merged:

https://lore.kernel.org/linux-btrfs/20260722025435.1493093-1-chenyichong@uniontech.com/

Next time let your agent to read the btrfs developer's note and check if 
there is already a fix:

https://btrfs.readthedocs.io/en/latest/dev/Developer-s-FAQ.html#development-phase-linux-next-for-next

> ---
>   fs/btrfs/verity.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> index 983365a73541..4431656140f8 100644
> --- a/fs/btrfs/verity.c
> +++ b/fs/btrfs/verity.c
> @@ -753,6 +753,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
>   	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
>   			     folio_address(folio), PAGE_SIZE, folio);
>   	if (ret < 0) {
> +		folio_unlock(folio);
>   		folio_put(folio);
>   		return ERR_PTR(ret);
>   	}

