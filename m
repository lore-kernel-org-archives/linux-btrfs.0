Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE99327B4F7
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 00:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790986930; cv=none; b=AR6PNf/Wu2iGEptovGiSJ0QkQPCo4NRCKkDjkgxm1ZBxuMP9wBsvE8KLoYv0dMbKNDaTQAc+qIgYieeNEZ4NOGkz0dKnxsE/LiR/pn9P945n8D7VMQVzFokLpLq/9AT/LTiM0+W1hjmxeRw8vnaGgGkvjzkiWAwWyhgPUGtYSXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790986930; c=relaxed/simple;
	bh=oQP5gFmHlaHTTSrYdNvSBG0lptWFTJuyV1v1sbXHAiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KN0nVCAEaPipgFiqMvjjIpPdUmZP+Tq0/Ey4K0AZXUJJp7YxDyvHpnknKAyLzaSN42zjkRQ3MDeycdZNhGro04FbuVu946GypCxfdP9/yRJDpvi1TfqjXlEjeTXhRgbWH7YepeSRtFxcPXAHPPKhpwZU/YkHunR9cnkfjFkxeFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=e40tSfvq; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="e40tSfvq"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49e73611928so1899385e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2026 17:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790986927; x=1791591727; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tw9kKg/kDBdVjuCFa9BYWx0BniCcoe2uQ82XrgWgGu4=;
        b=e40tSfvqMjLZMN1k6IYstniqJup2A3oEvrv5g1DAYi+xDYwIXdVNZMqQ7A5Y7j1IKO
         2kfFL0tfQrYfNLMOWfxv+FXEIilq+8L2xsGAHbq6Sb7zGEbPnEPmfhP4GNh12QYT2dvs
         lCDHqhRGQKqcRygIZqdOnYpPUbH72oQSF9jAsxtqRZTvUGGhpjEfUOn8SHrpLrsk2oJf
         Pr1n6bQ5DPAIw0N8f4M4wmAjT7B0MYZtFPOpDjAgjOi4MMwpclB8hfj2DnBtNxo7UNHC
         yIKqdy68yUmhQoa+H8dZpHX/0FXFzcg8XnPOCBQqITmYiugrDmSBPKlL9HB47iC+71Zq
         POXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986927; x=1791591727;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tw9kKg/kDBdVjuCFa9BYWx0BniCcoe2uQ82XrgWgGu4=;
        b=e29u85kkmqivLZtD4CWDxvwg4LaU3iBRcarOJsUmAcx9aXhKEKO1SHkT82xJY9l4eW
         aiNIZo5ZKC8QZcRz4uJVAf7mZHKwupE97xKYW8xlZBMbwdusqmUvYX2w6N3q6VWPThNd
         ih391h+nWkSzP8ct9MOdkflUD5v3oRPJjTUGQmQO8D0YzNlTYFVsmtWNi2zSYGpLHO8/
         kBxUHbyNhIFbkIfrGzZFV8/kALpxQppxNRD3vJ5yETZedBYtwyUQigsQe6AG/rze7vMa
         IbKrmVNX58C+wdwPxc+CdKZIGm8aFwk07auxrLhQ43QRy7XhKK971KT24KM4RKWElBoo
         Sbpg==
X-Forwarded-Encrypted: i=1; AKwUvByPnSdIr912pBn/+Ojx8AL5Il4Z99+LqPcR5JK+J0pGK1jjXm7MumMvsEDGesUnYrE2mw1r3BnA5JiehQ==@vger.kernel.org
X-Gm-Message-State: AFuF++ks3gpw7ybx2AcHJ9DzjfPvnJQzK3VL10CBwM6QFYgUtpTOZbJ2
	p1rUxzhY+sJRwA6WIUPub6Y8o86bHjfNuAM3VJOm2f7Lqc5OTsz/OhZC3mI1AIxYKtpFe8vZmpg
	FsLyLaxOVqQ==
X-Gm-Gg: AYBFou2zryhAEpLiQPE0rv1u/qdqz5sSs3k32+YPcSuEynWDM+U2FoZl98FN9qZ7wMQ
	yrLqpKH58C6AddQnglZhbkCqbGOe7jjmincGiozz4Ljir8ewZp89NWv+p+fxH6PJ63lraPwriwZ
	Xwp9LFKDvIyvwp12uy6rdkbPSivSSU9YD4OLrzo4KwjjMTqZ0IkcMqyNPZSyIVr986eVmNgzSlP
	9rsvJcKRiWWlM/knApln2Vc0fgn2BIOQXCE5DOfLEmy0yx1h47YsHvx1vIkI97vdacvPZtcIXca
	CbI5NH6QqvHYolRxdv62jtqskdM/ohbZsYXVZ28b9qDkEwlLOYRmMoR4mvq3iXuF7Dr1VZxOwBl
	P2+guvnS/dZaHoRYHn5zIZCqqH4WWbJ7yO5nrtlWXxWtsNkr4f0yGKnXa47YgJqvrNPZKbE2kan
	oBlWHkStitpG3d5asMvKbWsaVceTK+Hejl/wF3xk0YB6n378U8ZsQRY8JWa43SJTm+wvXhDD/TR
	Q==
X-Received: by 2002:a05:600c:a419:b0:4a0:1ff5:319c with SMTP id 5b1f17b1804b1-4a01ff53289mr85264505e9.12.1790986927073;
        Fri, 02 Oct 2026 17:22:07 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78e61386csm655872a91.17.2026.10.02.17.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2026 17:22:06 -0700 (PDT)
Message-ID: <f3e6f740-c90c-4cea-a11f-3c86081da7e4@suse.com>
Date: Sat, 3 Oct 2026 09:52:02 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] btrfs: qgroup: merge error labels in
 btrfs_quota_enable()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1790967259.git.fdmanana@suse.com>
 <40436d61da8f99a8c302d7210093552f3be4acd1.1790967259.git.fdmanana@suse.com>
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
In-Reply-To: <40436d61da8f99a8c302d7210093552f3be4acd1.1790967259.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/3 04:25, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> There is no need to have 3 different labels to which we goto on error.
> Simplify this and have a single one, named 'out', where we always free
> the path and put the root, as btrfs_free_path() and btrfs_put_root()
> accept NULL arguments and do nothing in that case.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>   fs/btrfs/qgroup.c | 36 +++++++++++++++++-------------------
>   1 file changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 9f21b091c545..c9fc3b6a5132 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -999,7 +999,7 @@ static int btrfs_clean_quota_tree(struct btrfs_trans_handle *trans,
>   int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
>   		       struct btrfs_ioctl_quota_ctl_args *quota_ctl_args)
>   {
> -	struct btrfs_root *quota_root;
> +	struct btrfs_root *quota_root = NULL;
>   	struct btrfs_root *tree_root = fs_info->tree_root;
>   	struct btrfs_path *path = NULL;
>   	struct btrfs_qgroup_status_item *ptr;
> @@ -1076,6 +1076,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
>   	quota_root = btrfs_create_tree(trans, BTRFS_QUOTA_TREE_OBJECTID);
>   	if (IS_ERR(quota_root)) {
>   		ret =  PTR_ERR(quota_root);
> +		quota_root = NULL;
>   		btrfs_abort_transaction(trans, ret);
>   		goto out;
>   	}
> @@ -1084,7 +1085,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
>   	if (unlikely(!path)) {
>   		ret = -ENOMEM;
>   		btrfs_abort_transaction(trans, ret);
> -		goto out_free_root;
> +		goto out;
>   	}
>   
>   	key.objectid = 0;
> @@ -1095,7 +1096,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
>   				      sizeof(*ptr));
>   	if (unlikely(ret)) {
>   		btrfs_abort_transaction(trans, ret);
> -		goto out_free_path;
> +		goto out;
>   	}
>   
>   	leaf = path->nodes[0];
> @@ -1131,7 +1132,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
>   		goto out_add_root;
>   	if (unlikely(ret < 0)) {
>   		btrfs_abort_transaction(trans, ret);
> -		goto out_free_path;
> +		goto out;
>   	}
>   
>   	while (1) {
> @@ -1150,14 +1151,14 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
>   			if (unlikely(!prealloc)) {
>   				ret = -ENOMEM;
>   				btrfs_abort_transaction(trans, ret);
> -				goto out_free_path;
> +				goto out;
>   			}
>   
>   			ret = add_qgroup_item(trans, quota_root,
>   					      found_key.offset);
>   			if (unlikely(ret)) {
>   				btrfs_abort_transaction(trans, ret);
> -				goto out_free_path;
> +				goto out;
>   			}
>   
>   			qgroup = add_qgroup_rb(fs_info, prealloc, found_key.offset);
> @@ -1165,13 +1166,13 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
>   			ret = btrfs_sysfs_add_one_qgroup(fs_info, qgroup);
>   			if (unlikely(ret < 0)) {
>   				btrfs_abort_transaction(trans, ret);
> -				goto out_free_path;
> +				goto out;
>   			}
>   			ret = btrfs_search_slot_for_read(tree_root, &found_key,
>   							 path, 1, 0);
>   			if (unlikely(ret < 0)) {
>   				btrfs_abort_transaction(trans, ret);
> -				goto out_free_path;
> +				goto out;
>   			}
>   			if (ret > 0) {
>   				/*
> @@ -1188,7 +1189,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
>   		ret = btrfs_next_item(tree_root, path);
>   		if (unlikely(ret < 0)) {
>   			btrfs_abort_transaction(trans, ret);
> -			goto out_free_path;
> +			goto out;
>   		}
>   		if (ret)
>   			break;
> @@ -1199,21 +1200,21 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
>   	ret = add_qgroup_item(trans, quota_root, BTRFS_FS_TREE_OBJECTID);
>   	if (unlikely(ret)) {
>   		btrfs_abort_transaction(trans, ret);
> -		goto out_free_path;
> +		goto out;
>   	}
>   
>   	ASSERT(prealloc == NULL);
>   	prealloc = kzalloc_obj(*prealloc, GFP_NOFS);
>   	if (!prealloc) {
>   		ret = -ENOMEM;
> -		goto out_free_path;
> +		goto out;
>   	}
>   	qgroup = add_qgroup_rb(fs_info, prealloc, BTRFS_FS_TREE_OBJECTID);
>   	prealloc = NULL;
>   	ret = btrfs_sysfs_add_one_qgroup(fs_info, qgroup);
>   	if (unlikely(ret < 0)) {
>   		btrfs_abort_transaction(trans, ret);
> -		goto out_free_path;
> +		goto out;
>   	}
>   
>   	/*
> @@ -1245,7 +1246,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
>   			clear_bit(BTRFS_FS_SQUOTA_ENABLING, &fs_info->flags);
>   			fs_info->qgroup_enable_gen = 0;
>   		}
> -		goto out_free_path;
> +		goto out;
>   	}
>   
>   	/*
> @@ -1262,7 +1263,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
>   
>   	/* Skip rescan for simple qgroups. */
>   	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
> -		goto out_free_path;
> +		goto out;
>   
>   	ret = qgroup_rescan_init(fs_info, 0, 1);
>   	if (!ret) {
> @@ -1287,18 +1288,15 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
>   		ret = 0;
>   	}
>   
> -out_free_path:
> -	btrfs_free_path(path);
> -out_free_root:
> -	if (ret)
> -		btrfs_put_root(quota_root);
>   out:
> +	btrfs_free_path(path);
>   	if (ret) {
>   		/*
>   		 * Free all qgroups previously added with add_qgroup_rb() and
>   		 * sysfs entries.
>   		 */
>   		btrfs_free_qgroup_config(fs_info);
> +		btrfs_put_root(quota_root);
>   	}
>   	mutex_unlock(&fs_info->qgroup_ioctl_lock);
>   	if (ret && trans)

