Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E46113790B
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 21:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774386302; cv=none; b=BbvMyNKIlheVX3bNO1axTHoz6AkQ4l9uQvUXxPZMiAK8MBPvfCUsLEvXLbXRbZVv7CiDMq4oNduVi/yZ0+h2SyZNHWQjr0j4h2n1B6nTe+Q7mrMb3QEenEQ5kJAZCDgLSusdOhcU/CUAdT/VQ43nEhCQthNpdEL+oZllqm7mdP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774386302; c=relaxed/simple;
	bh=7K7qaeVtYcZSnbzQDFYQjvGydUadnzn1QghkjPuO7aI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pNCjvp9QQ6c11Cai1UkuK+kprZvMhj7EllaNBIinpIv5ViTruMtCOWGZjRtO6CaRQhtWz/ZrGFSyrubNzF3XabLclLjbz6NXLT3C+EPOXUtMDEWKayl2kN9O5YslT1/aiDZfuPfi5KoCFh1rX2bS41UIHdrEaNl+7j/aUEJ+3UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U3ucQW62; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U3ucQW62"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-482f454be5bso2598075e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 14:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774386298; x=1774991098; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=KC+2tsmdptFw8idLDKh8cogqkOougefTgZ4VWagz6YY=;
        b=U3ucQW62Ujlc4rx+AC78VT8xwQof2/Ks4qGXoeUdhzAVxNN8C9+2c9G26DWbd9zQBu
         R30oyC8GAQpyOXsRhLVGSLQJ9bjyJK9LkjF8uWAqn19d8RPsFPikObAvg/wyelCCE8yK
         BGHhB0RswZqGAOf5quAUovZbOfZUC7ov6Zy506q6wBDRgcmnGwa+P/KrFu/zI10q+Pvk
         iSQbX7ARLkf8mDqKTMramctoOVm3IxvizdZYkPyC+HppkZlRuakJJqwmhaLeIlIaDdcF
         n30z5DhKDQUNkHSCnhFtZjNDW+qtg+4uNb4zemYJSq1Q/QA42ykV+1v+VWR76HwK9gtn
         Y4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774386298; x=1774991098;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KC+2tsmdptFw8idLDKh8cogqkOougefTgZ4VWagz6YY=;
        b=eUMXnN+KbOqVJk6DQAylQRmgUyTfqqSjAV1lHe7bYLYUfL/joPsnmkmsA25vdKZH8i
         WY28rJBOmRwnKvMw7JJGCwOnq3bVk8E+TO8Z6u0X4bmx+VdqMQPZSfzrrdWtHCMGBoa5
         t6z/y6nKMwLBm+5x5I21D0k2G6NOEy9btcX/EGOgcakc6Wplq3knN/L2dU1FGCcDDPKU
         arUYQU4apX8pnpcpMDThsqRtBG810d4ug/TaVc9cTdT5TvOK9pB6Xu6IBcEB+TpFBcN4
         blJGpXlO4MMzpTdllVmvV35etaNIORa8bXDQspHBAszkeUhgmQpqZpUIk5b/Lc60deNh
         lNpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZwdvnuc3po35NsIkaiFjKfbNhYvtbnb8tbgSkqAa86EfsX7bdbv4E3/n8QhQqfICNh/AhYYME8idp8g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwG7V3ra2vZVhCbXGLGxfMyd+85kYK7HY1OEZd4KwA8zmGz8JZP
	xyWb6SqjDo2EYPLyKMHeS1/GZACc4ntX5a/Lv2m0AhT4eBdiffjcE9w/9c8jM6NJquk=
X-Gm-Gg: ATEYQzyTkLKgATI68RixmfvhNLI0lcfclq7cdlV5yoxkCzrgXbICBy/ckJ5Yi/YAwl+
	JqkmjkNxnTuLMPNXZCC56C1oAPoBq3h4GXYcjiF3nPzqIg3hW/SuQl3JImII7EWBP7bYDxZhlRc
	H6PJ+MDZlyrZwoFzzWqDJF4oPZmVXBBNRwawh53Ghj28tPMgV8LeCgMh/RQdF9a+Skx8jokXWXH
	rvXWW8OmJWFFmqUNX81ECv3MOgqr42Ae0vbb/XcraCPdfCCe9yRSYW0rM2H6oKoa0JEoCEwQ913
	db7f9SYJkALi2Y+eKIe7Ph5n9D/2Oh2r3J+ky7BzxntFQnzBcL9ehHn3YcmUBVcrbUwAjCDc1ia
	Oo44/jfcHNcP+bB/ha5IWO3MljgrNkEogwCk83EOPJSBYwZ6Vix9Dny7qakX6NdmeSDI/jzCiOd
	ptHtrPrSmdxwuP4u6dgvyvUtw+LrQeqFlvF01C+VZgwu2K//riaYs=
X-Received: by 2002:a05:600c:58ce:b0:487:467:49e9 with SMTP id 5b1f17b1804b1-4870f1f29cdmr53921645e9.7.1774386298151;
        Tue, 24 Mar 2026 14:04:58 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74487b5b8csm11346366a12.31.2026.03.24.14.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 14:04:57 -0700 (PDT)
Message-ID: <972fc966-47b0-4376-9843-03a7b276d59e@suse.com>
Date: Wed, 25 Mar 2026 07:34:51 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: make btrfs_free_log() and
 btrfs_free_log_root_tree() return void
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <ef83fd57b6c94993091a6ad52cb2a828b3557724.1774364595.git.fdmanana@suse.com>
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
In-Reply-To: <ef83fd57b6c94993091a6ad52cb2a828b3557724.1774364595.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/25 01:33, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> These functions never fail, always return success (0) and none of the
> callers care about their return values. Change their return type from int
> to void.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/tree-log.c | 8 +++-----
>   fs/btrfs/tree-log.h | 4 ++--
>   2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index de4707b1227e..f883d9d979d4 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3681,25 +3681,23 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
>    * free all the extents used by the tree log.  This should be called
>    * at commit time of the full transaction
>    */
> -int btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root)
> +void btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root)
>   {
>   	if (root->log_root) {
>   		free_log_tree(trans, root->log_root);
>   		root->log_root = NULL;
>   		clear_bit(BTRFS_ROOT_HAS_LOG_TREE, &root->state);
>   	}
> -	return 0;
>   }
>   
> -int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
> -			     struct btrfs_fs_info *fs_info)
> +void btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
> +			      struct btrfs_fs_info *fs_info)
>   {
>   	if (fs_info->log_root_tree) {
>   		free_log_tree(trans, fs_info->log_root_tree);
>   		fs_info->log_root_tree = NULL;
>   		clear_bit(BTRFS_ROOT_HAS_LOG_TREE, &fs_info->tree_root->state);
>   	}
> -	return 0;
>   }
>   
>   static bool mark_inode_as_not_logged(const struct btrfs_trans_handle *trans,
> diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
> index 41e47fda036d..ad4e82e86bf9 100644
> --- a/fs/btrfs/tree-log.h
> +++ b/fs/btrfs/tree-log.h
> @@ -71,8 +71,8 @@ static inline int btrfs_need_log_full_commit(struct btrfs_trans_handle *trans)
>   
>   int btrfs_sync_log(struct btrfs_trans_handle *trans,
>   		   struct btrfs_root *root, struct btrfs_log_ctx *ctx);
> -int btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root);
> -int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
> +void btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root);
> +void btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
>   			     struct btrfs_fs_info *fs_info);
>   int btrfs_recover_log_trees(struct btrfs_root *tree_root);
>   int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,

