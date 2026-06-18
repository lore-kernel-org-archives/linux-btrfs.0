Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB30820E334
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2026 08:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781771615; cv=none; b=iN+gQa6SJrZ9DDmf85XOKo81YFSxVALx507e2Gqm3tlifjK9ltyMEPFO0vOrEkMXsKlApC73EEOYwb543VZk84T5OW54QV3ydW6TSrPGcNp6KPlGyf22a7DP9afZL9I3cFsxOw8RSDzOCcu090JV1l2vWZALfNoXLXBEhjOyEkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781771615; c=relaxed/simple;
	bh=BgoDXfxz74u4BxZ83eHXOSB8dN612gSAvBNXlW2ts38=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=mlQYIwOUIQ1eHOEFgh8AUTZjiUE1ZVOTFxK3oN2+8LHHJBJ4S3Wuzb4LGZ7/PqJddczBtHC+eCq3XQaw1HUtd0K8ct0GXc8lnpQO3gi+05hRq7eYFZft0wvfqxU13MB6l2+6EPov1ToFCerMYnWNbcFUluFUFSNtSPBco2BU7wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZnRCFP/T; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZnRCFP/T"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bf0170c80f7so100243266b.3
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2026 01:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781771611; x=1782376411; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7kpNF0l0LLRV+W7pffbnLBgyA86zcnV9Q8uViWBeU+c=;
        b=ZnRCFP/TcNwWuJuq70vq0Mmdyq62OXmZxUejx6mdknkEDzF3DlYyYNqeBAoeqOfhaQ
         s2g7dfsr2yE4avp8oQ9xkdAI6zM3qLaM3d4LXd5NBRKmaf85JtfRFA6YZk+9vsPqfz7C
         E833NJXhaM6TUsqOPqsbPJqcMEFACF/zO+ZlP8xnddbGgv0TpmEb9iw3HPVIPkuu4o4W
         18l32JY+3BXifV7llEB7dm3JZS85cYEckzr/T0uG5DBrhsvknjSA7C0DzLjXTU6zYNZZ
         CfkdfMs+NFCXWXp994hev4BrC1TuKKUWVc8TV7fR1mBvu8kOxTa24z3qgHXpwfqDlsvt
         CwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781771611; x=1782376411;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7kpNF0l0LLRV+W7pffbnLBgyA86zcnV9Q8uViWBeU+c=;
        b=MxxJI9nUdTC7DkxPiFERB/gPYrIVf3IhEODdKlRoZDur6x1rykaJQ4M0IyJ3Ju7yZe
         HnhP5724QK5xAl6Xe18KrTAginmzY5TnDBKoAKsfWGsniyuOEvEgpI41Ip0i5OoWQXnG
         FY7nNR0b6qZyfj8B6kapsDPzRq7XwzQ0DnyvDrv0wW2NwtIEthp1UF5M/dD5aiXH7toT
         lEYDeIR2kA+7sUVT5tRXid+UO1KV3Fufg9ia9dRtgNhvxMky6oRodBPaS34xvHDyFZro
         UHN6eRnGPBuF/3TnHotWOceqzxi7bpWus/OqbW5W+2QxhW64d+s3j+/inhIGy0oxnNGC
         lzsQ==
X-Gm-Message-State: AOJu0YxW8bGL8ICznshcgQZ6BzY/FuPM/Y68GXHcumJjO8GgsXPGdcLx
	+8s9uKm/W1PZPOXe5fNTUY4j8IGKHGlqohcjTyleObDDnC6/h93Ce4ROVuXxPa3HY6+UW/HjLOj
	hdlVc8DM=
X-Gm-Gg: AfdE7cluBFA5MdxcIlrrwy3Jt/3BB212DI1q/CuQrHdeZEE4LN9lDhdn7EFvvm78kSc
	XX311ibf7EyWARe8Paz7hVpa7QnrPhow/7/l87Ct+tVyW+FP12DpogojFj7MEns8sYwClEOAPxH
	w0+GwXa9VA5o4MitjxjFR7zzCjMB5rB57mRARca2njKzssMizdUAN0afTgFAf6sYxTp4PG2LfWB
	8HUcXRe+xR1Y2GunvkiljxvNjrLEAF8Eny8ecTwJmU/mj0cAElO88YPP+KPLFkMQBq6Os/s9F8W
	RfuE20vLtvtyr00ZplDYeoojIA2E8IyywzDE68mJ0wPTehT41Lm2e962BvXovoLqSowNxY3FU7g
	Ki/d+tllz5Pn/IEf24F/owgbKVWu8AQwsM7kVG1klHOS69lgt3DNboaT2dXrJssBMsED3xqnYKv
	U10pkKzLgDa7drdCmydPwqe1I3jUh776jAPqfrZ9V7HX3HOjXcgrInDpRqUQOt7HKW0WX12/GB1
	hMlnA6shsb+fKtnHqIKBwySS5C1zw+yS7BIke++GE8Wog==
X-Received: by 2002:a17:907:d0e:b0:bed:a7d7:82c8 with SMTP id a640c23a62f3a-c074dce83bcmr139803466b.37.1781771610839;
        Thu, 18 Jun 2026 01:33:30 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c52213332sm8544454a91.15.2026.06.18.01.33.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 01:33:29 -0700 (PDT)
Message-ID: <f3f9025e-6ae3-47c3-8cf8-94dc1e3593ef@suse.com>
Date: Thu, 18 Jun 2026 18:03:25 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "btrfs: add 32-bit compat ioctl for
 BTRFS_IOC_GET_SUBVOL_INFO"
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, Daan De Meyer <daan@amutable.com>
References: <83e52b702dcad16021067cc9b57a23f44ee4ed3b.1781693491.git.wqu@suse.com>
Content-Language: en-US
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
In-Reply-To: <83e52b702dcad16021067cc9b57a23f44ee4ed3b.1781693491.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Daan

Do you any clue why this unprivileged ioctl regressed? So that we can 
get a proper fix other than a full revert.

Meanwhile I believe we should have a proper btrfs ioctl test case in 
fstests, so we do not need to use btrfs-progs to test this.

Thanks,
Qu

在 2026/6/17 20:22, Qu Wenruo 写道:
> This reverts commit 538e5bdbc8996d3f6ce65565dda7df58e6e97e04.
> 
> This patch is causing libbtrfsutils regression on 64bit systems, which
> is the most common cases.
> 
> The involved selftests failures look like this, all related to
> unprivileged ioctls:
> 
>   ======================================================================
>   FAIL: test_subvolume_get_info_unprivileged (test_subvolume.TestSubvolume.test_subvolume_get_info_unprivileged)
>   ----------------------------------------------------------------------
>   Traceback (most recent call last):
>     File "/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", line 336, in test_subvolume_get_info_unprivileged
>       self._test_subvolume_info(subvol, snapshot)
>       ~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^
>     File "/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", line 196, in _test_subvolume_info
>       self.assertEqual(info.id, 256)
>       ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^
>   AssertionError: 140488005556880 != 256
> 
>   ======================================================================
>   FAIL: test_subvolume_info_unprivileged (test_subvolume.TestSubvolume.test_subvolume_info_unprivileged)
>   ----------------------------------------------------------------------
>   Traceback (most recent call last):
>     File "/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", line 318, in test_subvolume_info_unprivileged
>       self._test_subvolume_info(subvol, snapshot)
>       ~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^
>     File "/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", line 196, in _test_subvolume_info
>       self.assertEqual(info.id, 256)
>       ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^
>   AssertionError: 140488005503648 != 256
> 
>   ======================================================================
>   FAIL: test_subvolume_iterator_unprivileged (test_subvolume.TestSubvolume.test_subvolume_iterator_unprivileged)
>   ----------------------------------------------------------------------
>   Traceback (most recent call last):
>     File "/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", line 835, in test_subvolume_iterator_unprivileged
>       self._test_subvolume_iterator()
>       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^
>     File "/home/adam/btrfs-progs/libbtrfsutil/python/tests/test_subvolume.py", line 700, in _test_subvolume_iterator
>       self.assertEqual(subvol.id, 256)
>       ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^
>   AssertionError: 0 != 256
> 
> Adding 32bit compatibility should never cause regression on 64bit
> systems.
> 
> Revert the offending commit to avoid regression.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/ioctl.c | 107 ++++++-----------------------------------------
>   1 file changed, 13 insertions(+), 94 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9d47d16394fc..360637e9edfc 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -83,30 +83,6 @@ struct btrfs_ioctl_received_subvol_args_32 {
>   
>   #define BTRFS_IOC_SET_RECEIVED_SUBVOL_32 _IOWR(BTRFS_IOCTL_MAGIC, 37, \
>   				struct btrfs_ioctl_received_subvol_args_32)
> -
> -struct btrfs_ioctl_get_subvol_info_args_32 {
> -	__u64 treeid;
> -	char name[BTRFS_VOL_NAME_MAX + 1];
> -	__u64 parent_id;
> -	__u64 dirid;
> -	__u64 generation;
> -	__u64 flags;
> -	__u8 uuid[BTRFS_UUID_SIZE];
> -	__u8 parent_uuid[BTRFS_UUID_SIZE];
> -	__u8 received_uuid[BTRFS_UUID_SIZE];
> -	__u64 ctransid;
> -	__u64 otransid;
> -	__u64 stransid;
> -	__u64 rtransid;
> -	struct btrfs_ioctl_timespec_32 ctime;
> -	struct btrfs_ioctl_timespec_32 otime;
> -	struct btrfs_ioctl_timespec_32 stime;
> -	struct btrfs_ioctl_timespec_32 rtime;
> -	__u64 reserved[8];
> -} __attribute__ ((__packed__));
> -
> -#define BTRFS_IOC_GET_SUBVOL_INFO_32 _IOR(BTRFS_IOCTL_MAGIC, 60, \
> -				struct btrfs_ioctl_get_subvol_info_args_32)
>   #endif
>   
>   #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
> @@ -1948,9 +1924,9 @@ static int btrfs_ioctl_ino_lookup_user(struct file *file, void __user *argp)
>   }
>   
>   /* Get the subvolume information in BTRFS_ROOT_ITEM and BTRFS_ROOT_BACKREF */
> -static int _btrfs_ioctl_get_subvol_info(struct inode *inode,
> -					struct btrfs_ioctl_get_subvol_info_args *subvol_info)
> +static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
>   {
> +	struct btrfs_ioctl_get_subvol_info_args AUTO_KFREE(subvol_info);
>   	struct btrfs_fs_info *fs_info;
>   	struct btrfs_root *root;
>   	struct btrfs_path *path;
> @@ -1966,6 +1942,12 @@ static int _btrfs_ioctl_get_subvol_info(struct inode *inode,
>   	if (!path)
>   		return -ENOMEM;
>   
> +	subvol_info = kzalloc_obj(*subvol_info);
> +	if (!subvol_info) {
> +		btrfs_free_path(path);
> +		return -ENOMEM;
> +	}
> +
>   	fs_info = BTRFS_I(inode)->root->fs_info;
>   
>   	/* Get root_item of inode's subvolume */
> @@ -2044,6 +2026,11 @@ static int _btrfs_ioctl_get_subvol_info(struct inode *inode,
>   		}
>   	}
>   
> +	btrfs_free_path(path);
> +	path = NULL;
> +	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
> +		ret = -EFAULT;
> +
>   out:
>   	btrfs_put_root(root);
>   out_free:
> @@ -2051,70 +2038,6 @@ static int _btrfs_ioctl_get_subvol_info(struct inode *inode,
>   	return ret;
>   }
>   
> -#ifdef CONFIG_64BIT
> -static int btrfs_ioctl_get_subvol_info_32(struct inode *inode, void __user *argp)
> -{
> -	struct btrfs_ioctl_get_subvol_info_args AUTO_KFREE(subvol_info);
> -	struct btrfs_ioctl_get_subvol_info_args_32 AUTO_KFREE(subvol_info_32);
> -	int ret;
> -
> -	subvol_info = kzalloc_obj(*subvol_info);
> -	if (!subvol_info)
> -		return -ENOMEM;
> -
> -	subvol_info_32 = kzalloc_obj(*subvol_info_32);
> -	if (!subvol_info_32)
> -		return -ENOMEM;
> -
> -	ret = _btrfs_ioctl_get_subvol_info(inode, subvol_info);
> -	if (ret)
> -		return ret;
> -
> -	subvol_info_32->treeid = subvol_info->treeid;
> -	memcpy(subvol_info_32->name, subvol_info->name, sizeof(subvol_info_32->name));
> -	subvol_info_32->parent_id = subvol_info->parent_id;
> -	subvol_info_32->dirid = subvol_info->dirid;
> -	subvol_info_32->generation = subvol_info->generation;
> -	subvol_info_32->flags = subvol_info->flags;
> -	memcpy(subvol_info_32->uuid, subvol_info->uuid, BTRFS_UUID_SIZE);
> -	memcpy(subvol_info_32->parent_uuid, subvol_info->parent_uuid, BTRFS_UUID_SIZE);
> -	memcpy(subvol_info_32->received_uuid, subvol_info->received_uuid, BTRFS_UUID_SIZE);
> -	subvol_info_32->ctransid = subvol_info->ctransid;
> -	subvol_info_32->otransid = subvol_info->otransid;
> -	subvol_info_32->stransid = subvol_info->stransid;
> -	subvol_info_32->rtransid = subvol_info->rtransid;
> -	subvol_info_32->ctime.sec = subvol_info->ctime.sec;
> -	subvol_info_32->ctime.nsec = subvol_info->ctime.nsec;
> -	subvol_info_32->otime.sec = subvol_info->otime.sec;
> -	subvol_info_32->otime.nsec = subvol_info->otime.nsec;
> -	subvol_info_32->stime.sec = subvol_info->stime.sec;
> -	subvol_info_32->stime.nsec = subvol_info->stime.nsec;
> -	subvol_info_32->rtime.sec = subvol_info->rtime.sec;
> -	subvol_info_32->rtime.nsec = subvol_info->rtime.nsec;
> -
> -	if (copy_to_user(argp, subvol_info_32, sizeof(*subvol_info_32)))
> -		ret = -EFAULT;
> -
> -	return ret;
> -}
> -#endif
> -
> -static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
> -{
> -	struct btrfs_ioctl_get_subvol_info_args AUTO_KFREE(subvol_info);
> -	int ret;
> -
> -	subvol_info = kzalloc_obj(*subvol_info);
> -	if (!subvol_info)
> -		return -ENOMEM;
> -
> -	ret = _btrfs_ioctl_get_subvol_info(inode, subvol_info);
> -	if (!ret && copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
> -		ret = -EFAULT;
> -
> -	return ret;
> -}
> -
>   /*
>    * Return ROOT_REF information of the subvolume containing this inode
>    * except the subvolume name.
> @@ -5610,10 +5533,6 @@ long btrfs_ioctl(struct file *file, unsigned int
>   		return btrfs_ioctl_set_features(file, argp);
>   	case BTRFS_IOC_GET_SUBVOL_INFO:
>   		return btrfs_ioctl_get_subvol_info(inode, argp);
> -#ifdef CONFIG_64BIT
> -	case BTRFS_IOC_GET_SUBVOL_INFO_32:
> -		return btrfs_ioctl_get_subvol_info_32(inode, argp);
> -#endif
>   	case BTRFS_IOC_GET_SUBVOL_ROOTREF:
>   		return btrfs_ioctl_get_subvol_rootref(root, argp);
>   	case BTRFS_IOC_INO_LOOKUP_USER:

