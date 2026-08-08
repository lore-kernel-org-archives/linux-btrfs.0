Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F3754763
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Aug 2026 05:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786166309; cv=none; b=sLl7zuv6q1rWBfak05okgj8LES93eP+TJMIcW1kgAvzMiV/1RZRTyMicUICj98ry6tFVu0eMZ+Z28dvZ7nHpZ7uNSDGQ/VkGYsVNIYalhNZMo156BAINCL+CFwKmmVZBcnvsSH2HRLRiDAvhs5xAxugYniCTE2CQGcXcY+QVpGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786166309; c=relaxed/simple;
	bh=e1KD8zoraLjog2njrsX2zkpMHC24yAUgHxLM38jjGf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B9qfz/ZUYQoPnaG8biaX1k1ctWtXXm8+jUtdqxcWfpSJrFMuK9q4FJALp1W1YM4UFFEDpgZA2tFusBeZ04Ils8Jti9o2o2ipnlg8cO4GplmRz7NkQ30yt/yW9kEk6t+gW/okcUvX9ioQbCw/DBd0ybZ7z0YsDrwaC9TH+GYq8uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Hd8XNQBg; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Hd8XNQBg"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so2035995e9.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2026 22:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786166306; x=1786771106; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JJhvRbAgbyNO89YM7BEIHxWEebN9b6RcPSHpLs6/nDU=;
        b=Hd8XNQBgA8USILsrl89vmRmywInuKKhJFpnIabcdauiMq9OMYOoCBJAB9FFmySF4Kn
         Uk0vFkVXG9w95lziIYL+ja2dkFR3nROP88+OhZUWHYW/pXgmMNzaUjVFm6XrvWYlsTBw
         Whrjpbq/AVX0N5kHibW20gNKvkdt5gcUe5rhyNHcPDeIwGrRaJ2wsH2sp2LG8fb7Vu5M
         sVPiNEip+iocy6WKSSvjVisYKGHcZt1AuiNcBKe7EbRS9470BtGG/H4p0qrHVSd/bwyB
         7SSfklPoXje1Sb//Wjttz7QAt0WUegHRbogVxg0xyuf7cZgSdLP2uOQrkgqHpc7TcE3M
         CfXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786166306; x=1786771106;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JJhvRbAgbyNO89YM7BEIHxWEebN9b6RcPSHpLs6/nDU=;
        b=IehY+PQo0GMFjcfhwDgoev4fIPPEBQ396mXtu3QZ7K4JYNjphOWdjseXP95DJn958J
         YLbE6705tEyIUssme4tlu26SCeZ55atIqv8oHNJitlJFBXDKWXHTS1IrqklQtSSEdzQG
         8+1cqC5ldfAS0ALcxPqcGe/FXElGVD5Fl/NP4Xlj0JzcMJhZQlthgEL9FayJkJT8SRyM
         ND4oQJWJHzvncnXFfW7p5M8bRgWUvhhaX5fz5RAWh/gFc5cUWmNjxLoQMY5CjbANFGvH
         bQcV3ABRY6A6D0u4l7Vr/Fo6tv9PUQO06WqV+1iJ5aZISp0vge1UuFhkyBKsjRqEZ+y0
         q2Uw==
X-Gm-Message-State: AOJu0YzizxVvAfh5JRPlOLZHXtg8fFibUFj5R+79/nWm8BZ0sQOuElR3
	6QT63hwCFOFNuFBFqijIZQNkFjHKzNgW+S/u8dEKtBTyYxynjxicBU03zW1Z3+S/2BU=
X-Gm-Gg: AR+sD10uklfcnAxdggHGpfQ+/cePI1NZLjgq9YQqKQgpVO6IV+TcEDD4SMFJkd4CzoJ
	JuIcpf6pW7osDx8AuPmF6mHxyaqJGtYFBCZWP3O5C0WxJA+Md4CTjnCjEyDazMYQwU/Y3zjO72x
	6fiuqD0f3YlI294EOVT22lHnEWaA21RB7Wm82BpQNrypotOEXmbVzMcZAuWo83c0ofZcWbfo/ca
	uwSKbCkz6EK01Vw9sZ12kTTzpUjpxGoEtShvOHRiVf2z/WK3EUB4dQ4dejXkLF65c6SVxN5+2vQ
	qZzeoCa6QHbybRdW4O3RM7rKMUSyhCMwRUrtdXvW51Z4m6vOvyktYJPXGShQ3H9jow6GNUBEO+l
	JTYgtTVN2+AyE52tEfSOb7ByUk4IhOprcD/lLlhTIjJVXJseJ04m+mT9/V1SmpdkvlqRWnNIxDC
	PcLy9+lna8fc3PBzKf7x5vQSAm3D4r9gSLKYLlhrmveNMyq0r4qiYVehpXh8KA80eVPg==
X-Received: by 2002:a05:600c:4594:b0:499:5f7a:7ea2 with SMTP id 5b1f17b1804b1-4995f7a7ec4mr97873255e9.12.1786166305870;
        Fri, 07 Aug 2026 22:18:25 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bec2ec20sm16808385eec.28.2026.08.07.22.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 22:18:24 -0700 (PDT)
Message-ID: <47a4dbfb-906c-440c-999c-d6dba7981232@suse.com>
Date: Sat, 8 Aug 2026 14:48:19 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: free unlinked replace target on initialization
 failure
To: Guanghui Yang <3497809730@qq.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_CB14173C19427EDC26219662D6A984787209@qq.com>
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
In-Reply-To: <tencent_CB14173C19427EDC26219662D6A984787209@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/8 14:12, Guanghui Yang 写道:
> btrfs_init_dev_replace_tgtdev() allocates the replacement target before
> looking up its dev_t and initializing its zoned device information. If
> either lookup_bdev() or btrfs_get_dev_zone_info() fails, the device has
> not been linked into fs_devices->devices yet, but the error path only
> drops the block device file reference.
> 
> Free the allocated device on this error path to release its name,
> allocation state, zone info, and the device itself.
> 
> Signed-off-by: Guanghui Yang <3497809730@qq.com>

I have a very strong feeling that you're using LLM hunting down bugs.

In that case, be responsible and disclose the usage of LLM.

> ---
>   fs/btrfs/dev-replace.c | 4 ++++
>   fs/btrfs/volumes.c     | 2 +-
>   fs/btrfs/volumes.h     | 1 +
>   3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 318ddb790..3c17481c9 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -240,6 +240,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>   	struct block_device *bdev;
>   	u64 devid = BTRFS_DEV_REPLACE_DEVID;
>   	int ret = 0;
> +	bool device_allocated = false;

You can just initialize @device to NULL, and use that pointer to 
determine if the device is properly allocated.
>   
>   	*device_out = NULL;
>   	if (srcdev->fs_devices->seeding) {
> @@ -287,6 +288,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>   		ret = PTR_ERR(device);
>   		goto error;
>   	}
> +	device_allocated = true;
>   
>   	ret = lookup_bdev(device_path, &device->devt);
>   	if (ret)
> @@ -327,6 +329,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>   	return 0;
>   
>   error:
> +	if (device_allocated)
> +		btrfs_free_device(device);
>   	bdev_fput(bdev_file);
>   	return ret;
>   }
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a8e27db8e..c479f268a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -402,7 +402,7 @@ static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid)
>   	return fs_devs;
>   }
>   
> -static void btrfs_free_device(struct btrfs_device *device)
> +void btrfs_free_device(struct btrfs_device *device)
>   {
>   	WARN_ON(!list_empty(&device->post_commit_list));
>   	/*
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index eaf23c0dc..ecab3ce3c 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -795,6 +795,7 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans);
>   void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_device *srcdev);
>   void btrfs_rm_dev_replace_free_srcdev(struct btrfs_device *srcdev);
>   void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev);
> +void btrfs_free_device(struct btrfs_device *device);
>   unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
>   				    u64 logical);
>   u64 btrfs_calc_stripe_length(const struct btrfs_chunk_map *map);

