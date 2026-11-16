Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794863789;
	b=HGTGwN9F51vGcuSA3QjERLS8BMJYIqoMnXy/zqfnV9WXy3JaCJXynsYz2TFWm2Yqpc49
	 ZkNiFiPALpH4VpfA778VGPCShAkTxgBigVfM4M1TUL3h7cBq/8GCDclwRyh8tJUjWo5/c
	 CMAf+pWt/C+VxPHfcKAyALkTyfGqhm6/L6FEzDb3e4h/S/qslmGBiGrMHiI5cWnlt6eYW
	 54JWdZQrPNFZuPbaZ5bpKg3hxNswGM/GOSuTKt0RHcvYoajxXHGorzM3B9lN9p2wTbpRc
	 jF9sO+wU+XFJamOVYKaNDIBiMd7qqwtfBDZKA67MlJAogoQkXfIcxqmjPOZHLOUdPcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794863789;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=df83JBfuahJAVUG4U/tuP+END5bVlv22R/rPjFaLrto=;
	b=dyNY0jL89zZOBhnTNwXOYyomRwXCJ+hDym5hfn4iZ+VLm63ZoVNB4dxp3i6d76qkJgPv
	 mH6LDFkxg/5uut2G9OcKJcF5jHx0+/mQZ02O4NhjBCubrZGbutXStqKUBNxzQG1iNebDS
	 ggMv0FC+m8Q4quqBfrME2Emd07ZO8kccmHrbqmPm7npCTU9Ti8m097ZS/84NDr9KPSYig
	 aYAGpVlDwQN94SitrklfkL5mmoM4POUgYE/xtE4IqNPcsGe1M/mUSkBM/M48BH+sxeTp4
	 uRM8QQnaRzXIoTmD0cemChyEwWxb1Ffm1hSSmX2jvUMSfptuyJQ+q6sdE0fOt9P/CWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=MD0MCASE;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42CC606A32C
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 21:16:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A42CC606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=MD0MCASE
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c505186727fso174937766b.3
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 13:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794863787; x=1795468587; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=df83JBfuahJAVUG4U/tuP+END5bVlv22R/rPjFaLrto=;
        b=MD0MCASEmyYZ42MxkDfzyN+27I4rW6l+lAfgFdPp4MOUlel+qaFlthEQYVsnzl5Vob
         vWFoZjgUYxk1apC/DkWy/BjTX9jflSuQKO4PEHnN/b0oLgC6e0hvFel1h21R/PPhXy9G
         qNFahXliHOeQDW6dhVUmUPP7H36Fahf1wYlBWGGL5ITP0Fzyvp2RMMpvZCvXGHd3F3Dj
         ZA/m0o+oSCIrKBzJFuEdAqTqakiitnVeYCqCS9/Lf2wxjF5RwHxslRSDtC2d5rdz7XAC
         inBrRjzPt4YAvNOqOLsf29eBKj59dMegXhGHMDljydfAwAA/9pqQX6fgkDxkeTsnDYID
         o1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794863787; x=1795468587;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=df83JBfuahJAVUG4U/tuP+END5bVlv22R/rPjFaLrto=;
        b=ugSqLvwV3oX6cqjixd4mWq0CtpHe8crrmYhAcb5u/1+LQVMCBIMnOyLheqYnddrEp4
         S3KyHeWqBDxEDcB8YI7WY9LAJ1P884qL4xvzdm4mo34onPqQByhCPDF28jIWsnB3DB8+
         C0Z3o1Z3yd3G/ny1B3STrmCtTFxEVBs6Jk7w57FVvysrpH/U+67NzNp/aQkUK3V9MQd/
         tw3M78NgzX6Rb8ZJUfRm0VHKlcuOjVD8Yvj/rCYdd6UhXxUbctxI/QZyr8ZVeRQUTW5P
         0U6nmZC1ZMIu/KFUwx33jhw5ERZ6W9rqIFfBRCq+UqSGw+URBBqES9TZ+ZywanqdZAKj
         3PYg==
X-Forwarded-Encrypted: i=1; AL+hErFLnUqZezqmFVWHJPTdtTActrFcACZ0ubLRqZWl4GObMdYdOULtU8ZZ3M2N3WofZK7r3gapxik7Aqcl1Q==@vger.kernel.org
X-Gm-Message-State: APuU4Z/tl/18prHSrPXnjV1zPY7P9pdl+Uc3neL8rEFLg2SUfsCiiuqG
	PTyuJWKtX5rL+lPiP+tMSCAIzkIdtDrLFwBAiTSFDwgi2JBohuDTO8GDEwKz35njv1kRfYDb8Sd
	uYXuNOKNvHw==
X-Gm-Gg: AYBFou3SpfQ5YgkbUGzfTKUAcRQI6vGuqD5VLlxFl5ntTuISpUN9km46PmiuPs4kmPM
	iSAP9zu5hHgQG0P13b4ob/U+/IU6ReV3huj/I6Qlxak+YtS72OvF3vxhXIjdlcCIM8ymqpkWzdT
	/xwv+7ahhGEoHe+GghwJe6XSSFBtBfpexjRu76Ta79mVeWoNT7O61IbYbuZW3ISlZy+dK5xr34p
	RGt2MLWywYW4RQBQ1TWirsFT1GH6kfxLZV83+Ml36Cw7qMnTPOiCjr2SeV9QSqLTWEvPIzZDbPs
	6dQ50SclxDSkz7QCnYN9EArzH62VerbxZl/Ltv8rAqGF4NaHOmuHDDG7QDn4uT4pkEJPt1cTWXA
	U5L4gmkYzCvEy+qRNrwYen3SCrhv3eo7QSJ3zjwC1Ufd6MtBPkwtsx5Zfs9YAiWKZnv6FwXmj8v
	zSuanstxM+T+IMUSxmjIRjpwJDYcihOP9SxAE4T4Kkk6B6CvxQZcXYXGmf8lE08vOkEm+vdBwhC
	GCBGLF7Xg70NtkaVqFQ+1Tf0iNSspOxpYm7UZCSKIT5mEyg/Cac71yCgXbcLrpc0emmqRdkuyoN
	4kiEb3B+Ot/mLHOoDZvF5Q==
X-Received: by 2002:a17:907:608f:b0:c46:ca2b:84bd with SMTP id a640c23a62f3a-c50963972dbmr928210466b.30.1794863786988;
        Mon, 16 Nov 2026 13:16:26 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3abd063e8sm791480a91.8.2026.11.16.13.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 13:16:26 -0800 (PST)
Message-ID: <16bce0fb-85de-4db6-a6f7-61d478a1169f@suse.com>
Date: Tue, 17 Nov 2026 07:46:22 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix race between getting device stats and removing
 device
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <ad13663d72d23c941b0655ed7b7b46fd7541293d.1794342214.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <ad13663d72d23c941b0655ed7b7b46fd7541293d.1794342214.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/11 06:55, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When getting device stats we lock the device list mutex, get the device,
> unlock it and then use the device - but after we unlock the device we can
> have a concurrent device remove operation free the device while we are
> still using it in the device stats task, resulting in a use-after-free on
> the device:
> 
>    CPU 0 (BTRFS_IOC_GET_DEV_STATS)     CPU 1 (btrfs_rm_device)
>    -------------------------------     -----------------------
>    btrfs_get_dev_stats()
>      mutex_lock(&device_list_mutex);
>      dev = btrfs_find_device(...);
>      mutex_unlock(&device_list_mutex);
>                                         mutex_lock(&device_list_mutex);
>                                         list_del_rcu(&device->dev_list);
>                                         mutex_unlock(&device_list_mutex);
>                                         synchronize_rcu();
>                                         btrfs_free_device(device); // kfree
>      if (!dev->dev_stats_valid) // UAF
>      btrfs_dev_stat_read_and_reset() // UAF
>      btrfs_dev_stat_set() // UAF
>      btrfs_dev_stat_read() // UAF
> 
> Fix this by holding the device list mutex while accessing the device in
> btrfs_get_dev_stats(), which is safe since btrfs_rm_device() deletes the
> device from the list while holding that mutex.
> 
> Link: https://sashiko.dev/#/bug/linux-1ac8d72d-3ab5-4feb-b957-c4862ba1d15b
> Fixes: c11d2c236cc2 ("Btrfs: add ioctl to get and reset the device stats")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/volumes.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 3d4ef6725de0..9e37aee00824 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -8658,15 +8658,20 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
>   	mutex_lock(&fs_devices->device_list_mutex);
>   	args.devid = stats->devid;
>   	dev = btrfs_find_device(fs_info->fs_devices, &args);
> -	mutex_unlock(&fs_devices->device_list_mutex);
>   
>   	if (!dev) {
> +		mutex_unlock(&fs_devices->device_list_mutex);
>   		btrfs_warn(fs_info, "get dev_stats failed, device not found");
>   		return -ENODEV;
> -	} else if (!dev->dev_stats_valid) {
> +	}
> +
> +	if (!dev->dev_stats_valid) {
> +		mutex_unlock(&fs_devices->device_list_mutex);
>   		btrfs_warn(fs_info, "get dev_stats failed, not yet valid");
>   		return -ENODEV;
> -	} else if (stats->flags & BTRFS_DEV_STATS_RESET) {
> +	}
> +
> +	if (stats->flags & BTRFS_DEV_STATS_RESET) {
>   		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++) {
>   			if (stats->nr_items > i)
>   				stats->values[i] =
> @@ -8681,6 +8686,9 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
>   			if (stats->nr_items > i)
>   				stats->values[i] = btrfs_dev_stat_read(dev, i);
>   	}
> +
> +	mutex_unlock(&fs_devices->device_list_mutex);
> +
>   	if (stats->nr_items > BTRFS_DEV_STAT_VALUES_MAX)
>   		stats->nr_items = BTRFS_DEV_STAT_VALUES_MAX;
>   	return 0;

