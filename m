Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E50353A6B
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2026 09:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786007425; cv=none; b=izf5/MhT9xK1f4EihgiAHfT/Ihhe/z6hz6OU3/QOEZz/M/bTzuM8mT/d2NK1CbI94oGLeRyEcJ8EJ09N0bfP3N1Hcnggo/CSniURv9WNAu3UmnAbNY+P/JrHVpYWtkvyUVZSpZUcLbknHY0DI2GNC5t0XDp9Btdd8CfghdJFi58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786007425; c=relaxed/simple;
	bh=7G++yVM850WACl/SY6RzM4/AnpU60dkSeWAOSsjF/Ds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GaE5pjwCWIbF6evRkgfOagNHXT38kQBO1gUzdNdrkAQOqUWG/uZa4LMVMe1AwQfkKVrb+cuGTzCQfbtgVZaukfXFXkYVEBOWoQr5ceHemTXSjMXv/MkuxUfa2MEOQu3gOoiDU1LfFw/TN5yYydjXQrn62VE0rYWVVFlajvcfONg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QYPDehb7; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QYPDehb7"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so17836445e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Aug 2026 02:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786007420; x=1786612220; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S4yMZH32nJIYDfBv8jXcdhwhM4mQya/pkJRPHRaGp/I=;
        b=QYPDehb7OmdfNLaCntDGpdox9SD0fLWIgdR685XCsAYW7qrG2VRsauUpFBzFYJsK1X
         JDXgArm+VqpyRhwVG0JvF4+Y0imJ1dkPwApwiXX7L8A2a1g6h1ynMCAg8g1Qu5LmemPV
         pPJy0w/p6I3lMRQVkRnxzNFfhxtXv/FVklNJLeXrdcqUlZLKn0gp62B5mSBXFg+kIBjN
         6DakEHd836hkF1SUWBrGOuH7mSZPTLvwTqSrUYBtyzINyTU87eBurrGVMitYyCZnLio2
         7sP/mXpvChYhjKfcf631Hv0ryrxlHb4CnWfFAbTKlA+Aa/qcy6lFOXx7C9crzCiKZSgA
         OoDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786007420; x=1786612220;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S4yMZH32nJIYDfBv8jXcdhwhM4mQya/pkJRPHRaGp/I=;
        b=HZiS87/ShxfMwWEr0PGp3kT367EUFB7z2aurU/Xa68wN/ce7D7InbuQcd11RK5XSB4
         Zw0dh4vJMweclKI/RYAjfOc2nFbhwH12DV8oGX9Om+TaEFprfBns2+lKpVdAY9gelAys
         5/M/qe9MjBJ2BUM12YwxclXBjDLdaWAXAQDme1wBOTjEnOiXd7VGVn9E0OkEVBusCT1Z
         A/eIS3+VXXZ2aypmqMXnlVgSo9FPAq1MS9D8gRLuB25kYq8/9vtYjhDWnuBRSQ5cKiVB
         zsjhPQb+5kvblEAiK3+cu93JcN1yo62eoq5Samzp0Xkow/DOPMce+1iQ66KpRImfbaBJ
         9S6A==
X-Forwarded-Encrypted: i=1; AHgh+RquV6JPHD6FSLLHJb+IbsUMN6hV2c2w2K6E6jlV2kAgbk0VXKe6bw900Yh0ZMTcSF5tujoaWzq0aiSA5A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9POeIRy5u2dxBytSTuNyb/vhPjYUd0cI1WG2XhvXk1sSZ+sgF
	tE61i0wVp4dU1QWWcvD7SlU5xsNGdOJc447NsTowY4PMu2IOyfXtwkfc9NJGfvxkRlw=
X-Gm-Gg: AR+sD11Argx5soAVymd+lcrptC8yHYJJuEzQHcMZQRiERfMNEAMTIOVKo2w7MS8Nti3
	UrNWHtjBeufyq4HHMQRT4XsXPkJ2HTtULL1lIg8kK8m5H5Kwy3Xk21bGlqHEgnMolmys49Chrhp
	z3/e+ArFnHzGeVwGRKdG6VTS1G+gmDILyEzs5yjou+yYiUmWBX3bArv/nonlWvNqRk1CYn7iXrv
	AQw4dX96VB1ZoCpithG46AECYCVt0axtwz2zDJSkuIaJVCSgV6HfSMH0vqdxdqW+u5V3b0/hJlE
	LeA7oNRSg4TaKydQj11Zce4Ou/W5lPwrhNG3aekEe367m+J9Xy0Hqj+ErhMHKKanQ4PzcFYz7wc
	obNjr5mZMF2ftifeP1k1op+C21TAslWUFh8xxeVfK5MznozXXUymo+MK5+7Oqq1RF8E3V7Y25Dl
	WSORkjIXEUnVVTXhn0aDncCUQtws3TuJoIjcEaG3WrSgeevPDl/XwdtQ==
X-Received: by 2002:a05:600c:a597:b0:499:4d50:7230 with SMTP id 5b1f17b1804b1-4994e7d9c03mr109493145e9.18.1786007419802;
        Thu, 06 Aug 2026 02:10:19 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31586401507sm25592325eec.9.2026.08.06.02.10.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 02:10:18 -0700 (PDT)
Message-ID: <2f43370d-0319-479d-998e-8cf09c84675f@suse.com>
Date: Thu, 6 Aug 2026 18:40:10 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] btrfs: unlock inode and extent in caller when
 uring read extent fails
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Mark Harmstone <maharmstone@fb.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org
References: <20260806085041.1410576-1-yangxiuwei@kylinos.cn>
 <20260806085041.1410576-6-yangxiuwei@kylinos.cn>
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
In-Reply-To: <20260806085041.1410576-6-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/6 18:20, Yang Xiuwei 写道:
> btrfs_uring_read_extent() runs only after btrfs_encoded_read() has
> taken the inode shared lock and the extent lock.  On failure it used to
> unlock in out_fail, and a pages-array allocation failure returned
> -ENOMEM without unlocking at all.
> 
> Unlock in the caller instead, matching the copy_to_user() error path.
> out_fail only frees the local priv/pages allocations, and the pages
> array failure joins that path.
> 
> Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
> Suggested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
> ---
>   fs/btrfs/ioctl.c | 21 ++++++++++++---------
>   1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 939c4a9d47b6..b576887469bb 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4552,7 +4552,7 @@ static void btrfs_uring_read_finished(struct io_tw_req tw_req, io_tw_token_t tw)
>   	size_t page_offset;
>   	ssize_t ret;
>   
> -	/* The inode lock has already been acquired in btrfs_uring_read_extent.  */
> +	/* The inode lock has already been acquired in btrfs_encoded_read(). */
>   	btrfs_lockdep_inode_acquire(inode, i_rwsem);
>   
>   	if (priv->err) {
> @@ -4618,7 +4618,6 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
>   				   struct iovec *iov, struct io_uring_cmd *cmd)
>   {
>   	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
> -	struct extent_io_tree *io_tree = &inode->io_tree;
>   	struct page **pages = NULL;
>   	struct btrfs_uring_priv *priv = NULL;
>   	unsigned long nr_pages;
> @@ -4626,8 +4625,10 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
>   
>   	nr_pages = DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
>   	pages = kzalloc_objs(struct page *, nr_pages, GFP_NOFS);
> -	if (!pages)
> -		return -ENOMEM;
> +	if (!pages) {
> +		ret = -ENOMEM;
> +		goto out_fail;

Why go to that label? We have nothing to release, the old return -ENOMEM 
works completely fine now.

Otherwise looks good to me.

> +	}
>   	ret = btrfs_alloc_page_array(nr_pages, pages, GFP_NOFS);
>   	if (ret) {
>   		ret = -ENOMEM;
> @@ -4674,12 +4675,12 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
>   	return -EIOCBQUEUED;
>   
>   out_fail:
> -	btrfs_unlock_extent(io_tree, start, lockend, &cached_state);
> -	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>   	kfree(priv);
> -	for (int i = 0; i < nr_pages; i++) {
> -		if (pages[i])
> -			__free_page(pages[i]);
> +	if (pages) {
> +		for (int i = 0; i < nr_pages; i++) {
> +			if (pages[i])
> +				__free_page(pages[i]);
> +		}
>   	}
>   	kfree(pages);
>   	return ret;
> @@ -4819,6 +4820,8 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
>   					      data->iov, cmd);
>   		if (ret == -EIOCBQUEUED)
>   			goto out_acct;
> +		btrfs_unlock_extent(io_tree, start, lockend, &cached_state);
> +		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>   	}
>   
>   out_free:

