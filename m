Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57BA3D0907
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 23:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789341210; cv=none; b=MIDpY4iENCs9R/lw09ofddtTqLodZlHmqt7E/mqZJvNTn07Q+ep3TXkjthBgD/5Rfsea+r45pxC2KTOWzZJf6269aYOZB4UNHPA6tQyLRMWABqMD3UkSQYApzp/Okeefzwo9uR+JWq/9kTP7eg0SsCpvu/JB1vqg54gsl115nu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789341210; c=relaxed/simple;
	bh=t1SoGVBOhNN3RZcmqZV1cJ0VhGLvTWIcsebS0kL+oMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W4QbMv3SS4M/sGmZxfbGZgtDn4pwMEE4V7OLjTdl6dUYxNLgoeQhDpWcenYWtNVEV8qbxdWKuun/Cb9DqI1QTG3g9fRgG5S5HVmLmsqBb9HYMGIzIsf+g+5+BE4pBWgE6MBCjNlhK8jXQdtWLC+yCJ2gRt2ClDdIcs/kw4eICpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WI/b8pC0; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WI/b8pC0"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a9983162dcso3342765a12.1
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 16:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789341207; x=1789946007; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=shNHh+Hq0eZYkpewtUDUP7tR7NqtNacW/GO1qi4vb/k=;
        b=WI/b8pC049KIRVBuHGy28m5vAMVmLxVhGIiEl+riReE9caJY6QJU6b2LizIGxGIKwr
         edYxTWG49cRmYFZBpLH534gpMoO28DqXkkAKTexAJNyT1CR9zzkdyj5XVrwsiQsuxjGP
         Jpf7F5Kzli/goxFX1xU771IUk6cy4mPgl3dKpDP9dVEg5OtLkPskVi0iyauYAep/4bRT
         c72t8Sk/xkj7/XMTp8SKCE+oiB9DFk8UCqsg+23wLd8emNLK4diiy8uwBr3ZKUz9B67G
         XTVqmOkvpnbdgh/5sQCPMViIesoKpG68mC9iqhAvmz3wZmqqVjUZzNCGWYZuW4JsKp7P
         wGBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789341207; x=1789946007;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=shNHh+Hq0eZYkpewtUDUP7tR7NqtNacW/GO1qi4vb/k=;
        b=XH4xI1jvcyIQnJkVHXKtNhwmlnwUCmwNoq2tI36zmhsTqezIqvbIVRO8ZahaCO+VFO
         JXSjN5e3IxkgI55SXiU+v/jDa0aJqC6dW3uvA86nGLYWQ/p98Po/MuW9HsqDdOJK27UM
         0+Iuo75T4VrOg+I0Wu8z8lOOMDyFbXRdwb/bXe0PSmvzQktLlSt20uqLVPJk5GXmRW74
         NCGHw3Gox+2rtmbIG4SlHBKKtcwkgUQhGItZnCU/USeSCchCNXf1VdqeH2flwUgvMakG
         E+rGir7xr8s34An8reMstqF4eHBjCuUcIhpXW6g2nTLfV2FXe7I8zQvQA3Rg2L5kxG1E
         DlyA==
X-Gm-Message-State: AFuF++nSkQzQ09uoOTg7j3yckn97CDudrs498OIEjWRWMhkUIbBppeI+
	nO8geq4e3TyjQ4fpfWERGQlcLiqJzxQyYldc2qWylbBH0CAEk4c2pXLuRMOgOs9Q4AA=
X-Gm-Gg: AYBFou1HsKbZ/ieRwwoOExiSwQGeMvsUryuKTXoRIRDyhPPz9w1xstqNQWtRBBn/rFM
	4uhioUh8m/msLz41rhQCUOnBMPy3EUHRxORspbC164IOJrPb6YxEQscsTlSP90wqdzVGdwRG6Ml
	/xNKsG/GthAqLGTybyyK3qfQn85IoxMGSWzVdL6yy+39eCLYmKSFamOzMfUzrOqkkxclS2SbXWx
	9s1S9UKUTK0jVGwt129rhRbTTo7LqrWWB7lVtUlL184acTK3GNpI12JOYNj4WquWfF7L4fTOpqK
	YVX3S60dxncue/7SLYBq2z5se6oaBrdDCJpGTbPG/x+VzkwoK63D0PXQ3frM+mfKRQ8J4yu5Zx0
	igyCDIp7l3NRX0PEv8nIMmCmTwvX/r/VzKQHPvCDbEFuG8ICCULF3jhx2vXOaA5W1x59bKMIN2c
	kJdIaYQabF27/D1mlr6+uLOezJSgfcdzeYPuBDuZm0YAMdrak/Ywt3P2yPcMpKGWM=
X-Received: by 2002:a05:6402:21c8:b0:6a7:ee56:6155 with SMTP id 4fb4d7f45d1cf-6a9f63c11e3mr27644a12.23.1789341206845;
        Sun, 13 Sep 2026 16:13:26 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d98e602e7sm19188924a91.5.2026.09.13.16.13.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 16:13:25 -0700 (PDT)
Message-ID: <42025eb2-da6f-4319-83db-9cbd7ac3a7b9@suse.com>
Date: Mon, 14 Sep 2026 08:43:19 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/16] btrfs: stop enabling the v1 space cache from the
 on-disk state
To: Tal Zussman <tz2294@columbia.edu>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
 <20260913-btrfs-remove-v1-space-cache-v2-1-186767a7e106@columbia.edu>
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
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-1-186767a7e106@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/14 06:51, Tal Zussman 写道:
> Since commit 545e560a5b0f ("btrfs: disable v1 space cache") the mount
> options can no longer request the v1 space cache, but a filesystem with
> an active v1 cache and no free space tree still enables it from
> cache_generation, and remount does the same. Drop both, so SPACE_CACHE
> can never be set.

Oh, this is a bug in that commit, I intended to reject all v1 space 
cache usage, but lost the case where no "space_cache=" mount option is 
specified.
> 
> btrfs_start_pre_rw_mount() then sees the on-disk cache as active but
> unwanted and cleans it up, as -o nospace_cache does today. That covers
> the read-only to read-write remount as well, so drop the toggle in
> btrfs_remount_cleanup(), which would otherwise start a transaction on
> remounts of a read-only filesystem with an old cache.
> 
> The cleanup is now unconditional, and the first read-write mount fails
> if it fails, as it did with -o nospace_cache. This also lets an old
> filesystem mount without options when the page size is larger than the
> sector size, which btrfs_check_features() rejected once SPACE_CACHE was
> set from the superblock.
> 
> Assisted-by: Claude:claude-fable-5-1
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>   fs/btrfs/super.c | 16 +++-------------
>   1 file changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 464129b1b0d4..77443ded6db3 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -759,12 +759,12 @@ void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info)
>   
>   	/*
>   	 * At this point we don't have explicit options set by the user, set
> -	 * them ourselves based on the state of the file system.
> +	 * them ourselves based on the state of the file system. An existing
> +	 * v1 space cache is no longer used and gets cleaned up once the
> +	 * filesystem is mounted read-write.
>   	 */
>   	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
>   		btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
> -	else if (btrfs_free_space_cache_v1_active(fs_info))
> -		btrfs_set_opt(fs_info->mount_opt, SPACE_CACHE);
>   }
>   
>   static void set_device_specific_options(struct btrfs_fs_info *fs_info)
> @@ -1264,8 +1264,6 @@ static inline void btrfs_remount_begin(struct btrfs_fs_info *fs_info,
>   static inline void btrfs_remount_cleanup(struct btrfs_fs_info *fs_info,
>   					 unsigned long long old_opts)
>   {
> -	const bool cache_opt = btrfs_test_opt(fs_info, SPACE_CACHE);
> -
>   	/*
>   	 * We need to cleanup all defraggable inodes if the autodefragment is
>   	 * close or the filesystem is read only.
> @@ -1282,10 +1280,6 @@ static inline void btrfs_remount_cleanup(struct btrfs_fs_info *fs_info,
>   	else if (btrfs_raw_test_opt(old_opts, DISCARD_ASYNC) &&
>   		 !btrfs_test_opt(fs_info, DISCARD_ASYNC))
>   		btrfs_discard_cleanup(fs_info);
> -
> -	/* If we toggled space cache */
> -	if (cache_opt != btrfs_free_space_cache_v1_active(fs_info))
> -		btrfs_set_free_space_cache_v1_active(fs_info, cache_opt);
>   }
>   
>   static int btrfs_remount_rw(struct btrfs_fs_info *fs_info)
> @@ -1535,10 +1529,6 @@ static int btrfs_reconfigure(struct fs_context *fc)
>   			btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
>   			btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
>   		}
> -		if (btrfs_free_space_cache_v1_active(fs_info)) {
> -			btrfs_clear_opt(fs_info->mount_opt, FREE_SPACE_TREE);
> -			btrfs_set_opt(fs_info->mount_opt, SPACE_CACHE);
> -		}
>   	}
>   
>   	ret = 0;
> 

