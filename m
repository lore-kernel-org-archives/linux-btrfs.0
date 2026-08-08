Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1456B3B7746
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Aug 2026 09:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786180445; cv=none; b=ufGww3sDj6eeoxkhO6EE04Xt/XlGSnVOZYpUgZjNdiYM2YSng3maIf/AJHcMfPSd9Ik02Ty6AiW27W1XWXeEqlW9NP5+WcQwo9J6vLDwQCFPGDPGsUMBfNhLS1243yO/8UIVQ1fRn+PkVy4svYPRjlzgh7J+If2K94kyQ2cK7ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786180445; c=relaxed/simple;
	bh=pTuZyw5CrndMDPrLI4wFLmzo++wY5b+35esW09gg0Fk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=akxImAq5b+B08IB5vetgmHyhBr/25hoTQUueyQi2SBfafhH9IXaVUOMWWrDDYq/Vw44FALORFloK33txOaEE7B9XzEy9vrflbJlgSiY2Z1hjIl4V8eV6oOM+kwOdViBfSXjqeyF4WkWqAhytv6jensrm9yuk/ZIx29IZC+wHYgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d9YGRYNr; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d9YGRYNr"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4807df69172so701486f8f.1
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 02:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786180442; x=1786785242; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ig2zHLSTsuNpm67YQYnbI7J+yp6TC89TMrbZ5lUnmq4=;
        b=d9YGRYNrc8ZE2LJnNdX3M7TApVAx2X0/EQcLj4Z1MjkfsMbr5yn3WRWyS516rRA5DD
         OHfLfyxOXTGHE7lONAp06pDtxthSwr298DPE0rlHeQx3dWF5ZV5yNTjuXLs3r5wuWB9E
         6yJsX6pQVP6gZ/Gnr0sXmH5+eSytvTTGsJl8XortRuCXx/xbO4nHw9BiZIK5TPM3TaEq
         Qs29xaT78nk/LBoaN/l0Q6xi+mzmv3maSbFcn7T0u0y/Bd5qPkd1nmx8vu77o+HWB76Y
         IeLMf6WgDZ1Iaw7Y2EKFzX2w3oCYsneL+mYDgQ/Qt9IYgNRZN+FoKisjZtojTNnz05At
         awKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786180442; x=1786785242;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ig2zHLSTsuNpm67YQYnbI7J+yp6TC89TMrbZ5lUnmq4=;
        b=CfwzQyRTVyj42A2Kp8+EZXm+aaPf6dXYNP7QhCrpc1ZoErZ6akzir+27Y/GcXCUGX3
         NMlJAaZwrM8pVNbdU0VOv8ETXx/Xj+bDsf4tZtcmnyPHqJU2qwNDwn4zTStiy++9BS3l
         7/c7VTiWdZQisT7aeGxXoB+TlVJPpkc6cXwTQAIl9x5qvR1wvBge+/evNFc42CUvlgax
         1YNnRiUyfAChubWWaSf4Z/GmS4q0fx2o2PzuLDP+ey3zG5+WI35e664jjcZZ35omgul5
         c6ANGR9gw69U76u3v6m7CI/tM0M/2i4eW72QaZ/osUUuyA3MJGsq63gpS89v+u02dqEA
         E3BQ==
X-Forwarded-Encrypted: i=1; AHgh+RppyI1Uz1fJ8D96iA5E2YXBnUWBURZRGvAC2f7X2EO2ByYoKbWP6pQHUw0ZOdyTu93TlYmkCkaJVwry8g==@vger.kernel.org
X-Gm-Message-State: AOJu0YywS34pUEUR4wsVdjNb51slicbTgvUy6DRiAMFrEPBtONrMe3R1
	ukHiNqD2YQLEYPCXEZ0n78Vzbb2JWcRs/Ol3nSONi52hZ9N2UQTxQR6v9Gp/m8w/trc=
X-Gm-Gg: AR+sD10pOy32X8PiZ/LrsfZKLGJMfO8aoVN0/7zhj0spN4emv/Ai6/X8TvqhVwYuuhH
	JP3+wcMF1itz6s0VFuJY1R8445Ksoa3642RWOoZfSutGtAYCrVZ0RnvDem93l23KbsXESsP9ALu
	rdT677Lss3QhkS5UGSJ+S6+E8WHxrjpGBJT31jmPopT3B5vM8O/+W+aGZBwCCMZqR5p+o3Mkkd7
	XOkEWVSmUk4wWefKriUzR6L6gM3X9Xm7xLBX9ig/9Sp1JJYoNS1YSOz/SI4djwHXRDhLLhy31Hg
	aOix3rizkU5YxFnoCvy/LRh9dxf8ulsvqyLYvbRsQxIyouMcCKBUVPmd1NtFRDteZNjFR9RBkVK
	ZtDE0oIt811AiL/OziyUH0sJDRbLd7CqtJ46em1v22hySgjcdKIKD7r9TEohvkGfSgJe1zh/SlS
	RxblLBsI23C3pgXbt9SS6whce8yg22LxmVaUmyxQPQEDd9RmulW2WYPA==
X-Received: by 2002:a05:600c:5356:b0:495:7aaf:77b with SMTP id 5b1f17b1804b1-49962233099mr40421895e9.0.1786180442089;
        Sat, 08 Aug 2026 02:14:02 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315be86e90asm16598856eec.3.2026.08.08.02.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 02:14:00 -0700 (PDT)
Message-ID: <d3daa69d-7020-4384-a46c-9a098f115cbe@suse.com>
Date: Sat, 8 Aug 2026 18:43:55 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: free unlinked replace target on initialization
 failure
To: Guanghui Yang <3497809730@qq.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <47a4dbfb-906c-440c-999c-d6dba7981232@suse.com>
 <tencent_7C7BBA87F8B9F1419CC7B05319F15C28FA0A@qq.com>
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
In-Reply-To: <tencent_7C7BBA87F8B9F1419CC7B05319F15C28FA0A@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/8 15:43, Guanghui Yang 写道:
> btrfs_init_dev_replace_tgtdev() allocates the replacement target
> before looking up its dev_t and initializing its zoned device
> information. If either lookup_bdev() or btrfs_get_dev_zone_info()
> fails, the device has not been linked into fs_devices->devices yet,
> but the error path only drops the block device file reference.
> 
> Free the allocated device on this error path to release its name,
> allocation state, zone info, and the device itself.
> 
> The issue was found by a failure-path metadata residual analyzer and
> verified with targeted failure injection on v6.14.
> 
> Assisted-by: Codex:gpt-5
> Signed-off-by: Guanghui Yang <3497809730@qq.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Pushed to for-next branch.
> ---
>   fs/btrfs/dev-replace.c | 10 +++++++---
>   fs/btrfs/volumes.c     |  2 +-
>   fs/btrfs/volumes.h     |  1 +
>   3 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 318ddb790..3762429b5 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -235,7 +235,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>   				  struct btrfs_device **device_out)
>   {
>   	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> -	struct btrfs_device *device;
> +	struct btrfs_device *device = NULL;
> +	struct btrfs_device *tmp_device;
>   	struct file *bdev_file;
>   	struct block_device *bdev;
>   	u64 devid = BTRFS_DEV_REPLACE_DEVID;
> @@ -264,8 +265,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>   
>   	sync_blockdev(bdev);
>   
> -	list_for_each_entry(device, &fs_devices->devices, dev_list) {
> -		if (device->bdev == bdev) {
> +	list_for_each_entry(tmp_device, &fs_devices->devices, dev_list) {
> +		if (tmp_device->bdev == bdev) {
>   			btrfs_err(fs_info,
>   				  "target device is in the filesystem!");
>   			ret = -EEXIST;
> @@ -285,6 +286,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>   	device = btrfs_alloc_device(NULL, &devid, NULL, device_path);
>   	if (IS_ERR(device)) {
>   		ret = PTR_ERR(device);
> +		device = NULL;
>   		goto error;
>   	}
>   
> @@ -327,6 +329,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>   	return 0;
>   
>   error:
> +	if (device)
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

