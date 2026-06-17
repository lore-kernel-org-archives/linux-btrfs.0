Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C403F6C2F
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 10:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781693094; cv=none; b=quptScMkct/slaUg4g/231uGvaq16PLiZIowhZASa/J6E1naU3LTxyEhhAjNerulNOh1KLJzQ9SZQUsbqA8TiqVd8E49MKBYTsAv3wt60GpfdV8k52NcfwsReR/F0FqG3njab5c/usJ+Y/3mykHcXghh3Gvf5MIQUccuUmMClpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781693094; c=relaxed/simple;
	bh=iL53PMRJYB+6IEd2hZlB7khSV/8ah7fMXYuZ49sCuoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cwyF/xxJM66CYEqSTJoUKpMS596lWRbrzFbIAcEIQQJZhx7B47Mr05u27loliVy1243wuogD0nFZbEa0Jr0AH3Q1+dp6oFgbzwntxtcV9OuUFq6EQybINLsJp1iOLy+A8fiDc7R0MOaTioEeH6fMvgWnJEAp7IZw+k5N4ZsVJS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eZTxgXou; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eZTxgXou"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c029505b389so138497766b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 03:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781693091; x=1782297891; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jk9vfY9RG8fi4ENJ/5GJJNFMZxjN/vlWbYrcCQEU+5U=;
        b=eZTxgXoukmD8x7e6YN2+LYZtVorXZpGE8jVnzxBAg6jF/ztv/iQjgVE/ARer04YxpU
         Ft7mqEtJXlJrxOmNRwRy99Id81VzBB0XKYtACY3+wy+JDLx782sOk/Lz1ifgQBGYS8gt
         GgslxYUpUTqYcQViXFn8N2fRXvOQOiKbTxkW524Ww7u18146MXvAGvPFMYbMvV8UmDr3
         l30ZLoCK2HN4dRg/ksIMwsgqWPnvmU/ATRTNe29dh8UnDoUJ5tjxbWPgYcMoPfaStT5a
         jyz8k3MrRykGK7cTAnD7N951gsHxWAXkSdd19+1hP4mMJeexDgR7CjQ5c8p2KwgWAb2w
         s0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781693091; x=1782297891;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jk9vfY9RG8fi4ENJ/5GJJNFMZxjN/vlWbYrcCQEU+5U=;
        b=TKbjfHdmeQEObCr50wkOFEfku8dv3EL3tTGKf7T4pRXzqNwyuPT5iZuZqKqhr2F9IJ
         KH3YHv+R4mlam8fhgZIjcM8CccW+813Z3nLbH6CDQlkvVo2x0VKv9aes8sJwOd48b+wK
         Roug/RBtZOKj7CqNbTEtP3wt2uNoq+7t1RxoPlzIq8SRgaLoMQDPT/daLOYnq2WXWBbn
         mutM5TG9OCC4zteaSjpYw2KMShg4o480AHXVdf+xHrOAr4mXzOREFqzCIEQ4/wMKz6S9
         WBXLxA5PM0xwSz84HdKzbvlMwVYqg5wIVY7DR5wZfbf6qM8SNDSyS1CMCcYoaW4yNkXk
         dcaw==
X-Forwarded-Encrypted: i=1; AFNElJ/uGQzAgaymxb+4pPcnj+hqmbkssow66qYOuPdjDsroy2LHdi1y78l7vVbtUvlWhEcS4RIfxOdhvOU7hA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc2WuPHBVWEBSiHkT250k7ZCzCxVq+BsOBxoTfDTaWRft84Yko
	/ajST/oMPw3dUy7G9xHQ/28yabEdwt4b6kr3swsG3n/yJug0fYCHNcXVtlLwFjLhTmI=
X-Gm-Gg: Acq92OEkxqVHBvA81fHVli0B7/6zFFwJeqeINpwayHEE2DQPhb+xDmVGdhMMB7qfYap
	EzFkCeV3xm9aGt4IjO0ovmAWJ7S9mKfcFt1GdUOTqTBVDOnVVs1NDiUZS/wxtzrAQkaKjV2FtA6
	0poXYRB1mPRYqAwdDsnsIR7LdMGP/wylOGJwKIMUhaG5z2q/0/dsMCs+7jS0fYGWDfRxUuFotnK
	QXR0u2y27JMrfmoK4bYO5Fmi3DEU/ZrhBUTBrEDsZdsQeIvdKi1Vb8niTM2P4Sf3b9oQ1uKYcMl
	davNYwsqI7X6dWUzhsuHkvV0BKVgsDDjkDDXDCjFFltqXGo6vEcI5HG5ij3xbYkmfWvPxm5jrjw
	YhIzQpm3JA3DM1WJCGwi+d4d2vKt/FmZI5rQX474BEvShZI6m4fSzIcUc5p1yyAuxY/nPV0Gdij
	oAuNbvfH299a2EgEsv7YN0L75evuy8A/KuUsAypIF8Ptz/4/SyNMWW99He1dc12dAGu4p+hkzp4
	oSX+8BtVAs/jxyy94YUbVrOrTOvrututmUp4SMsxBXTGg==
X-Received: by 2002:a17:907:7283:b0:bee:e42c:8d37 with SMTP id a640c23a62f3a-c05d78fbee4mr129836666b.30.1781693091237;
        Wed, 17 Jun 2026 03:44:51 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c6cf116e65sm5020295ad.24.2026.06.17.03.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 03:44:49 -0700 (PDT)
Message-ID: <66470c2e-56b9-49a9-9cd2-aa49fac75bbf@suse.com>
Date: Wed, 17 Jun 2026 20:14:45 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add 32-bit compat ioctl for
 BTRFS_IOC_GET_SUBVOL_INFO
To: Daan De Meyer <daan@amutable.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20260521075113.1079519-1-daan@amutable.com>
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
In-Reply-To: <20260521075113.1079519-1-daan@amutable.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/21 17:21, Daan De Meyer 写道:
> On 64-bit kernels with 32-bit userspace, struct btrfs_ioctl_timespec is
> laid out as 16 bytes (8B sec + 4B nsec + 4B trailing padding) instead of
> the 12 bytes a 32-bit userspace expects, because the surrounding struct
> is not packed. As a result, struct btrfs_ioctl_get_subvol_info_args has
> a different size and layout in 32-bit userspace than in the 64-bit
> kernel, and BTRFS_IOC_GET_SUBVOL_INFO returns garbage to 32-bit callers.
> 
> Mirror what was done for BTRFS_IOC_SET_RECEIVED_SUBVOL: add a packed
> btrfs_ioctl_get_subvol_info_args_32 with btrfs_ioctl_timespec_32 fields,
> define BTRFS_IOC_GET_SUBVOL_INFO_32 with that struct as the size
> argument, factor the existing handler into a shared _btrfs_ioctl_get_
> subvol_info() helper, and add btrfs_ioctl_get_subvol_info_32() which
> fills the kernel struct and translates field-by-field into the 32-bit
> struct before copy_to_user().
> 
> Signed-off-by: Daan De Meyer <daan@amutable.com>

Unfortunately this is causing libbtrfsutils (from btrfs-progs) to 
regress on the following tests:

======================================================================
FAIL: test_subvolume_get_info_unprivileged 
(test_subvolume.TestSubvolume.test_subvolume_get_info_unprivileged)
----------------------------------------------------------------------
Traceback (most recent call last):
   File 
"/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", 
line 336, in test_subvolume_get_info_unprivileged
     self._test_subvolume_info(subvol, snapshot)
     ~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^
   File 
"/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", 
line 196, in _test_subvolume_info
     self.assertEqual(info.id, 256)
     ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^
AssertionError: 140488005556880 != 256

======================================================================
FAIL: test_subvolume_info_unprivileged 
(test_subvolume.TestSubvolume.test_subvolume_info_unprivileged)
----------------------------------------------------------------------
Traceback (most recent call last):
   File 
"/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", 
line 318, in test_subvolume_info_unprivileged
     self._test_subvolume_info(subvol, snapshot)
     ~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^
   File 
"/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", 
line 196, in _test_subvolume_info
     self.assertEqual(info.id, 256)
     ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^
AssertionError: 140488005503648 != 256

======================================================================
FAIL: test_subvolume_iterator_unprivileged 
(test_subvolume.TestSubvolume.test_subvolume_iterator_unprivileged)
----------------------------------------------------------------------
Traceback (most recent call last):
   File 
"/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", 
line 835, in test_subvolume_iterator_unprivileged
     self._test_subvolume_iterator()
     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^
   File 
"/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", 
line 700, in _test_subvolume_iterator
     self.assertEqual(subvol.id, 256)
     ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^
AssertionError: 0 != 256

----------------------------------------------------------------------
Ran 38 tests in 126.919s

And I have confirmed that, at that commit the libbtrfsutils selftest 
fails, and at the commit ("btrfs: derive f_fsid from on-disk fsid and 
dev_t") just before this one, the self test passes as usual.

I'm afraid this one needs to be removed from for-next branch, as it is 
causing regression for 64bit systems.

Thanks,
Qu

> ---
>   fs/btrfs/ioctl.c | 112 +++++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 99 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a39460bf68a7..31be2590f1b2 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -82,6 +82,30 @@ struct btrfs_ioctl_received_subvol_args_32 {
>   
>   #define BTRFS_IOC_SET_RECEIVED_SUBVOL_32 _IOWR(BTRFS_IOCTL_MAGIC, 37, \
>   				struct btrfs_ioctl_received_subvol_args_32)
> +
> +struct btrfs_ioctl_get_subvol_info_args_32 {
> +	__u64 treeid;
> +	char name[BTRFS_VOL_NAME_MAX + 1];
> +	__u64 parent_id;
> +	__u64 dirid;
> +	__u64 generation;
> +	__u64 flags;
> +	__u8 uuid[BTRFS_UUID_SIZE];
> +	__u8 parent_uuid[BTRFS_UUID_SIZE];
> +	__u8 received_uuid[BTRFS_UUID_SIZE];
> +	__u64 ctransid;
> +	__u64 otransid;
> +	__u64 stransid;
> +	__u64 rtransid;
> +	struct btrfs_ioctl_timespec_32 ctime;
> +	struct btrfs_ioctl_timespec_32 otime;
> +	struct btrfs_ioctl_timespec_32 stime;
> +	struct btrfs_ioctl_timespec_32 rtime;
> +	__u64 reserved[8];
> +} __attribute__ ((__packed__));
> +
> +#define BTRFS_IOC_GET_SUBVOL_INFO_32 _IOR(BTRFS_IOCTL_MAGIC, 60, \
> +				struct btrfs_ioctl_get_subvol_info_args_32)
>   #endif
>   
>   #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
> @@ -1945,9 +1969,9 @@ static int btrfs_ioctl_ino_lookup_user(struct file *file, void __user *argp)
>   }
>   
>   /* Get the subvolume information in BTRFS_ROOT_ITEM and BTRFS_ROOT_BACKREF */
> -static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
> +static int _btrfs_ioctl_get_subvol_info(struct inode *inode,
> +					struct btrfs_ioctl_get_subvol_info_args *subvol_info)
>   {
> -	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
>   	struct btrfs_fs_info *fs_info;
>   	struct btrfs_root *root;
>   	struct btrfs_path *path;
> @@ -1964,12 +1988,6 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
>   	if (!path)
>   		return -ENOMEM;
>   
> -	subvol_info = kzalloc_obj(*subvol_info);
> -	if (!subvol_info) {
> -		btrfs_free_path(path);
> -		return -ENOMEM;
> -	}
> -
>   	fs_info = BTRFS_I(inode)->root->fs_info;
>   
>   	/* Get root_item of inode's subvolume */
> @@ -2048,15 +2066,79 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
>   		}
>   	}
>   
> -	btrfs_free_path(path);
> -	path = NULL;
> -	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
> -		ret = -EFAULT;
> -
>   out:
>   	btrfs_put_root(root);
>   out_free:
>   	btrfs_free_path(path);
> +	return ret;
> +}
> +
> +#ifdef CONFIG_64BIT
> +static int btrfs_ioctl_get_subvol_info_32(struct inode *inode, void __user *argp)
> +{
> +	struct btrfs_ioctl_get_subvol_info_args *subvol_info = NULL;
> +	struct btrfs_ioctl_get_subvol_info_args_32 *subvol_info_32 = NULL;
> +	int ret;
> +
> +	subvol_info = kzalloc_obj(*subvol_info);
> +	if (!subvol_info)
> +		return -ENOMEM;
> +
> +	subvol_info_32 = kzalloc_obj(*subvol_info_32);
> +	if (!subvol_info_32) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = _btrfs_ioctl_get_subvol_info(inode, subvol_info);
> +	if (ret)
> +		goto out;
> +
> +	subvol_info_32->treeid = subvol_info->treeid;
> +	memcpy(subvol_info_32->name, subvol_info->name, sizeof(subvol_info_32->name));
> +	subvol_info_32->parent_id = subvol_info->parent_id;
> +	subvol_info_32->dirid = subvol_info->dirid;
> +	subvol_info_32->generation = subvol_info->generation;
> +	subvol_info_32->flags = subvol_info->flags;
> +	memcpy(subvol_info_32->uuid, subvol_info->uuid, BTRFS_UUID_SIZE);
> +	memcpy(subvol_info_32->parent_uuid, subvol_info->parent_uuid, BTRFS_UUID_SIZE);
> +	memcpy(subvol_info_32->received_uuid, subvol_info->received_uuid, BTRFS_UUID_SIZE);
> +	subvol_info_32->ctransid = subvol_info->ctransid;
> +	subvol_info_32->otransid = subvol_info->otransid;
> +	subvol_info_32->stransid = subvol_info->stransid;
> +	subvol_info_32->rtransid = subvol_info->rtransid;
> +	subvol_info_32->ctime.sec = subvol_info->ctime.sec;
> +	subvol_info_32->ctime.nsec = subvol_info->ctime.nsec;
> +	subvol_info_32->otime.sec = subvol_info->otime.sec;
> +	subvol_info_32->otime.nsec = subvol_info->otime.nsec;
> +	subvol_info_32->stime.sec = subvol_info->stime.sec;
> +	subvol_info_32->stime.nsec = subvol_info->stime.nsec;
> +	subvol_info_32->rtime.sec = subvol_info->rtime.sec;
> +	subvol_info_32->rtime.nsec = subvol_info->rtime.nsec;
> +
> +	if (copy_to_user(argp, subvol_info_32, sizeof(*subvol_info_32)))
> +		ret = -EFAULT;
> +
> +out:
> +	kfree(subvol_info_32);
> +	kfree(subvol_info);
> +	return ret;
> +}
> +#endif
> +
> +static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
> +{
> +	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
> +	int ret;
> +
> +	subvol_info = kzalloc_obj(*subvol_info);
> +	if (!subvol_info)
> +		return -ENOMEM;
> +
> +	ret = _btrfs_ioctl_get_subvol_info(inode, subvol_info);
> +	if (!ret && copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
> +		ret = -EFAULT;
> +
>   	kfree(subvol_info);
>   	return ret;
>   }
> @@ -5273,6 +5355,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>   		return btrfs_ioctl_set_features(file, argp);
>   	case BTRFS_IOC_GET_SUBVOL_INFO:
>   		return btrfs_ioctl_get_subvol_info(inode, argp);
> +#ifdef CONFIG_64BIT
> +	case BTRFS_IOC_GET_SUBVOL_INFO_32:
> +		return btrfs_ioctl_get_subvol_info_32(inode, argp);
> +#endif
>   	case BTRFS_IOC_GET_SUBVOL_ROOTREF:
>   		return btrfs_ioctl_get_subvol_rootref(root, argp);
>   	case BTRFS_IOC_INO_LOOKUP_USER:

