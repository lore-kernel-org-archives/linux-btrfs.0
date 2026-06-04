Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17442594B9
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 09:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780564518; cv=none; b=GdTfUdykIYzo3UQJTkZMGwNSRGmQS2xvRUHV6UdzmdTKe0jzOgEPIe6i7e3jCdW6J7RA51ciWB7tomjUlieo6ksEkvQsN+PpvgcCwLo08khVb5yNfzpXb2yUQjIUraLeGS/tw4jeQsftLlcXtUlkpk995qsOnKK1C0Ajs8jM3C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780564518; c=relaxed/simple;
	bh=xivZB3avaVlASYcyHOlDrWuzNRlt8S7F8prLxaMUj+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AMQICoo4q13u80vbAvpAWylFwCIN++//zgYFA2JXKvheTO+Lt0ep6wLNnXc7wYQXhiLkGldKAyLZPMJ3p++SS5tzBzfkproZa1Wod168YW4Y9ujC5r8rNh++0B4co85wE6USQ0Z3r2g8t4wQG8yGIwRWimX+wer+D9z6kZwT/WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AA78nz8C; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AA78nz8C"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-becfa735b9aso61941366b.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2026 02:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780564515; x=1781169315; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DAWpEL2R11YjhYYxVzUAqJ02icipZs4jvWATPBo347M=;
        b=AA78nz8CzU/3ZIVvXUC9twpBFPngiI7AyS0TniGgfe63uPQDPZi8DwYeXFdc9ItC69
         jUxJLMwZr7gyhHoiApAPamXbxlUkXiEA8dW7IoV6hQUDK+9s+dz6YSa1JzuyddNKExof
         2jaNL8yrohgX0wgoQUdneZmHbXPivdQcqEqLlsvoVpaC+sO533jPVgd5Z8MkEhVEH/MG
         ZwzYVKxYdMcT0q8LYdqUDVBqwyEDanO2CL+R+bmWd/QIJnmVHPl5RPZdTWcPvE2LN6e+
         RHbXy/cuG9N61WIxiSrOGy6KV5zHyLM3eFMkgePOdAGE+8lgq1V8PtHlGlu+3Aizg8Ph
         AAHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780564515; x=1781169315;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DAWpEL2R11YjhYYxVzUAqJ02icipZs4jvWATPBo347M=;
        b=RZoNI4faeHCwyOfppKQccJY9KpPXUewpILcgc0anjZ+8kcPl8tLlBGn+bdVqXd5WqT
         RVIXbYF86p3oGSA56LRpjo4W+TGzQFe84Btz6Pk7Z0e5UqCRsfKCS9SfEx7RH0lCC0zJ
         eTg4nRPxD343isWMRX82qS+DC5oCk8LjOIKumIWzuS67ClI9Iq28bV/+wDG3WbHcCtbm
         ch11dUr74XBzaDUrdt/6Dy1YDYdpDD0HIwLfzX22nCvjzCqmls4JUv2+NcaOfGucxCgi
         nuSf/9z1iTYyMCAI5T+efi1PgwiUq63aPoYufjcJjypFQurTc8pjU1+6mxCtqEnveJyj
         Brbw==
X-Forwarded-Encrypted: i=1; AFNElJ/1zBE6/HVkNn7PXygTlVwd7/PUjMZkzS40KQLWTNFqtikAh7HLYWKlcP3RLIwsxGSgDlruTMTWwwV61Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+NcOzj92lq+9SeNAnx0XI/ay/VIyTH/u0rwHyNq4VJOVHULR1
	YSrI/a01Tlbc5ySCeidtnDSUek7mioeUFg+JS1xBY6JwsleIuoNTWfV1p6tWMY/RoCs=
X-Gm-Gg: Acq92OEeLBxp2nUYOY+/c/xCCT2ssZqVEtpF+X5i8+tqerU/w3v7i7gLxr8vDcTEJM8
	vRLYyn55R9/gqbqAGo9xP7NN+lGBZ+t7TXHm3gy9iZueZQYMsgI11oQ6HgM/HoSDpQZ/Qv5cWRT
	PjP1GxU6ItJCgyFjCHvLueAk4V+b3hNnbnVQsc/7S02QFhVHpLvrfAf10tSJUxCPy0ukKO89cTY
	vQGdPtO8jXYBiIgfte67DL7PRSQgaSvIB1U/acdSL8HeeHiiuL7z8btS1CXI4+TCNeF4yLiiULF
	bfEB5tjIgGlNj1cMhsDpxilERMn5sX7VgCsBc+oVsIDjNJ6DpeoIP86JD60nTTHFfXdiVEWVn7s
	XvcKecHLgL1huMKbekp/9mzNfmnk5ONRpzDKDSKcoYTwaEQIZyEUpO+Q/XAsPRWRg3/Kv+N77JP
	gJ2wymagF+3YK2U0DTH/jvyOOQhtG7wK72G8h6ZVhjqURiw1Qnsp9jYAQeWHPqt11c6UM26xToz
	0TsydMkCvH/RdJ/MBLSNo6bGY8FlmIK556RuIaSAlzpo/2iT1XiLS8lVfQXlTs36TM=
X-Received: by 2002:a17:907:7290:b0:bec:6c5c:ccee with SMTP id a640c23a62f3a-bf0ae701d9amr384743366b.27.1780564512971;
        Thu, 04 Jun 2026 02:15:12 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828e5638sm5622627b3a.50.2026.06.04.02.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 02:15:11 -0700 (PDT)
Message-ID: <02849934-ca88-42a7-ba3e-a7196e1fcef1@suse.com>
Date: Thu, 4 Jun 2026 18:45:07 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: start qgroup ioctl transactions on the quota
 root
To: Dongjiang Zhu <zhudongjiang@fnnas.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, fdmanana@suse.com
References: <20260604085522.3872126-1-zhudongjiang@fnnas.com>
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
In-Reply-To: <20260604085522.3872126-1-zhudongjiang@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/4 18:25, Dongjiang Zhu 写道:
> The qgroup ioctls update the quota tree, but they currently start their
> transactions using the root of the inode passed to the ioctl. This makes
> the transaction reservation depend on the path used for the ioctl instead
> of the tree being modified.
> 
> Start qgroup ioctl transactions on the quota root instead. Grab a
> reference to the quota root before starting the transaction, as quota
> disable can clear fs_info->quota_root concurrently after the early quota
> enabled check.
> 
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
> ---
> Changes since RFC:
> - Rework the fix to start qgroup ioctl transactions on fs_info->quota_root
>    instead of adding a no-qgroup-enforce transaction helper.
> - Grab the quota root before starting the transaction to handle concurrent
>    quota disable.
> 
>   fs/btrfs/ioctl.c | 38 +++++++++++++++++++++++++++++++-------
>   1 file changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9d47d16394fc..bec4f921aefd 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3606,7 +3606,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
>   {
>   	struct inode *inode = file_inode(file);
>   	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
> -	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_root *quota_root;
>   	struct btrfs_ioctl_qgroup_assign_args AUTO_KFREE(sa);
>   	struct btrfs_qgroup_list AUTO_KFREE(prealloc);
>   	struct btrfs_trans_handle *trans;
> @@ -3637,8 +3637,15 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
>   		}
>   	}
>   
> +	quota_root = btrfs_grab_root(fs_info->quota_root);

No need to increase the root refs.

Qgroup root is a global one, no need to grabbing it using ref count.

Furthermore, all those qgroup related operations (including 
enabling/disabling) are all holding qgroup_ioctl_lock, thus there is no 
way the quota root is gone halfway.

> +	if (!quota_root) {
> +		ret = -ENOTCONN;
> +		goto drop_write;
> +	}
> +
>   	/* 2 BTRFS_QGROUP_RELATION_KEY items. */
> -	trans = btrfs_start_transaction(root, 2);
> +	trans = btrfs_start_transaction(quota_root, 2);
> +	btrfs_put_root(quota_root);

Again unnecessary.

Furthermore, the pattern of grab root -> start trans -> put root is 
completely incorrect and dangerous.

If we're the last one holding a root pointer, after holding a trans 
handler, calling btrfs_put_root() can cause the root pointer to be gone, 
resulting all kinds of use-after-free bugs.

I do not understand where you come up this cursed usage, it's completely 
incorrect.

>   	if (IS_ERR(trans)) {
>   		ret = PTR_ERR(trans);
>   		goto drop_write;
> @@ -3675,7 +3682,8 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
>   static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
>   {
>   	struct inode *inode = file_inode(file);
> -	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
> +	struct btrfs_root *quota_root;
>   	struct btrfs_ioctl_qgroup_create_args AUTO_KFREE(sa);
>   	struct btrfs_trans_handle *trans;
>   	int ret;
> @@ -3684,7 +3692,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
>   	if (!capable(CAP_SYS_ADMIN))
>   		return -EPERM;
>   
> -	if (!btrfs_qgroup_enabled(root->fs_info))
> +	if (!btrfs_qgroup_enabled(fs_info))
>   		return -ENOTCONN;
>   
>   	ret = mnt_want_write_file(file);
> @@ -3707,11 +3715,18 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
>   		goto drop_write;
>   	}
>   
> +	quota_root = btrfs_grab_root(fs_info->quota_root);

The same.

> +	if (!quota_root) {
> +		ret = -ENOTCONN;
> +		goto drop_write;
> +	}
> +
>   	/*
>   	 * 1 BTRFS_QGROUP_INFO_KEY item.
>   	 * 1 BTRFS_QGROUP_LIMIT_KEY item.
>   	 */
> -	trans = btrfs_start_transaction(root, 2);
> +	trans = btrfs_start_transaction(quota_root, 2);
> +	btrfs_put_root(quota_root);

The same.
>   	if (IS_ERR(trans)) {
>   		ret = PTR_ERR(trans);
>   		goto drop_write;
> @@ -3736,6 +3751,8 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
>   {
>   	struct inode *inode = file_inode(file);
>   	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_root *quota_root;
> +	struct btrfs_fs_info *fs_info = root->fs_info;
>   	struct btrfs_ioctl_qgroup_limit_args AUTO_KFREE(sa);
>   	struct btrfs_trans_handle *trans;
>   	int ret;
> @@ -3745,7 +3762,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
>   	if (!capable(CAP_SYS_ADMIN))
>   		return -EPERM;
>   
> -	if (!btrfs_qgroup_enabled(root->fs_info))
> +	if (!btrfs_qgroup_enabled(fs_info))
>   		return -ENOTCONN;
>   
>   	ret = mnt_want_write_file(file);
> @@ -3758,8 +3775,15 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
>   		goto drop_write;
>   	}
>   
> +	quota_root = btrfs_grab_root(fs_info->quota_root);

The same.

> +	if (!quota_root) {
> +		ret = -ENOTCONN;
> +		goto drop_write;
> +	}
> +
>   	/* 1 BTRFS_QGROUP_LIMIT_KEY item. */
> -	trans = btrfs_start_transaction(root, 1);
> +	trans = btrfs_start_transaction(quota_root, 1);
> +	btrfs_put_root(quota_root);

The same.

>   	if (IS_ERR(trans)) {
>   		ret = PTR_ERR(trans);
>   		goto drop_write;

