Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4AACA4E
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 06:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780986893; cv=none; b=kYKelreBhbAVl0NxosQsGbK4WfzaPag+TtGmZOGW2dE6QGqFCianpvygdhEsCW1NDSqxNdxmfpjusjTYuEgBfNU/mK4vlBkjRUgz3lgDAbRHverCXDrfRxpkIGMzSwP6y6F9XkkJNGrwf28tPVri1rcSW861BTN4up6p8D00O6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780986893; c=relaxed/simple;
	bh=1uwVXMWFud+QPmhzmi7H46SqsPPemEVM/xBb9kevx3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=amjA5ErGa2dbXe7KAE49dVyxfnyH5ljpYv9m8coyesTYmoQDBlY6ObH8JuvMajPB6QajmwE5694RqtOha6EW3LdzucY+TJ4HFR+piMyvr0suMHZTXnGruU+PgPTTzwFQ5sGbmtRbqEbah+J/6seqrJYsqY63aTpbopraUi8qL28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aOqMMb1S; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aOqMMb1S"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490aebf33e9so28738425e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jun 2026 23:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780986890; x=1781591690; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bY9d+Q/QWYN1JENL8yW8Gmai1hC/OneOqqXFbIP0JL4=;
        b=aOqMMb1SR0yRvHe2wn40YqUUsZDAc0iuSlB97dfPColMkGXQa+oCQXnpQxGbZ6ALe/
         nsAl1m7SHz0IKwMJeDaIQU/O6wg4pTWkafREkCIrleeyrRE6HHRYoYgu07pVk+cNKlY7
         WK8VLjqIcxQAGt6ZXcovNimHLDachRxhXoNSFzj3qkq6SxJPslc98kRRSEp9mxj8rFDD
         +umZ1qJYpqCYcw6eJV3/lYcrPai6HZyCqdaQsDht+3Da9ZRM1UC9pu85H7gYk7GUykBI
         KJdyMbsXOr0qrVTbcNp6wcpH5CrdrKIWtwKIjkulY10quIzeRMyQwW3bw7Bi3t+VtBvS
         C28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780986890; x=1781591690;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bY9d+Q/QWYN1JENL8yW8Gmai1hC/OneOqqXFbIP0JL4=;
        b=iDJWhuWt2rCTrXAplJX400E49MY+07KDe2uqTRyi/hUsA3zq4njDEw4jWJ0iyHw1xt
         F/GL5/ylW4UIbB2izLZCIv0B6A3LHM3qwq9dz+s8Z6HE9duFxit2pVqqgTNEI0SkpAD6
         1l1x1VU+LJJYH/92amLARA1zXkbbM5uk0wY6T+XA3WvZwjw7xroaerxUCOXPqxt4jDKv
         qcJELVqSsQInhM85+Q/5IILIm0qC50aXWyAsKZRoUAQV4zCzO+nSk5wgczixV3O+DQrz
         qxRS0KQYeIAKqJt1L2M3aBdxogVY+RQt9yz6rjyMiKfSYRVsFhgYWaQ3Ao0Op+PWvSqu
         eV5w==
X-Forwarded-Encrypted: i=1; AFNElJ8wHdHQ7Qtam/17Hf/9kxD/qEae/JPegVNeFKLDxxNvPQ/C74poaUaLlJQiXRsnRzIAwpZHvtoUNraYzA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxzI689jeFhc6S0p6ec6A2opoZqN9YoDZQdUdggSEaT/kvFIWGC
	3GIOHsLp9YA1oKj0KZahXascXw+5Qf6wKldJdvM1RT4rPNMux3CIijqVPh86tQQ2Z7zE05yI3Gs
	LQg21
X-Gm-Gg: Acq92OHXjIfvMn5dM5/iCZk2DJ5cwKlvWe2E/75YJUV/Uj6REsXnPEcAOsg+0Vc+dwy
	naebgAHPvS4NyEasbLbFJEN0scYnzJvhLazPEEMWCDflXSutHehFDZh8Hl++HuRoXyhrT1JBAD2
	bZDcz34PCMSuJkjmSrSZ9dvg3f202T0uSBrESMbEYwzwcSlo7+kMLe667+J/y7/8wMO0QsJ2yV2
	wQhZJF9zCsdsBNRPc+dfcULIQt/Xqc76EX32UPWFYdWPRqK6GH06U+SvbXYTkwxwaqWngGhgoa8
	QyWqWTf9yMKz/h6/8uuKnnPav3oXsm4sW4+F7ru3ikzzuKfmdiRYklHij4VHF8Wnz0+cxp1x+/B
	qS+3VwaNV/wciTmHXbbBx+rua8BU/2JkLoUlGwdUbpm7GoVQ2pDsiVvHVhOwotZFgq7ef/w+UBU
	aJtPm/f6hAKmOoxCf2Tq/7zkHgV5jjSFyJH10r/OW4/1UDc3o6IPkvhpbiQSJsfA2c8mpA5h8oy
	Fh8GJE4s5pJUQG+gLMKmwpRqvuidXRHjQ/bWPDahvRSToA0dVOiUmeP7Q==
X-Received: by 2002:a05:600c:c0d3:b0:48e:6db3:ff33 with SMTP id 5b1f17b1804b1-490c265c091mr217066855e9.14.1780986889496;
        Mon, 08 Jun 2026 23:34:49 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c245dd3b5dsm75769755ad.81.2026.06.08.23.34.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 23:34:48 -0700 (PDT)
Message-ID: <7e1fe8fc-4c24-466d-a57e-24bfba837500@suse.com>
Date: Tue, 9 Jun 2026 16:04:42 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: start qgroup ioctl transactions on the quota
 root
To: Dongjiang Zhu <zhudongjiang@fnnas.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, fdmanana@suse.com
References: <20260609032318.3745767-1-zhudongjiang@fnnas.com>
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
In-Reply-To: <20260609032318.3745767-1-zhudongjiang@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/9 12:53, Dongjiang Zhu 写道:
> The qgroup ioctls update the quota tree, but they currently start their
> transactions using the root of the inode passed to the ioctl. This makes
> the transaction reservation depend on the path used for the ioctl instead
> of the tree being modified.
> 
> Start qgroup ioctl transactions on the quota root instead. Take a reference
> to fs_info->quota_root under qgroup_ioctl_lock before starting the
> transaction, because quota disable can clear and put fs_info->quota_root
> after the early quota-enabled check. Keep the reference until the
> transaction handle is ended.
> 
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
> Changes since v2:
> - Grab fs_info->quota_root under qgroup_ioctl_lock to close the race with
>    concurrent quota disable before taking the root reference.
> - Keep the grabbed quota root reference until btrfs_end_transaction()
>    instead of dropping it immediately after starting the transaction.
> 
> Changes since RFC:
> - Rework the fix to start qgroup ioctl transactions on fs_info->quota_root
>    instead of adding a no-qgroup-enforce transaction helper.
> - Add quota root grabbing to handle concurrent quota disable.
> 
>   fs/btrfs/ioctl.c | 50 +++++++++++++++++++++++++++++++++++++++++-------
>   1 file changed, 43 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9d47d16394fc..2d693775cad5 100644
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
> @@ -3637,10 +3637,20 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
>   		}
>   	}
>   
> +	mutex_lock(&fs_info->qgroup_ioctl_lock);
> +	quota_root = btrfs_grab_root(fs_info->quota_root);
> +	mutex_unlock(&fs_info->qgroup_ioctl_lock);
> +
> +	if (!quota_root) {
> +		ret = -ENOTCONN;
> +		goto drop_write;
> +	}
> +
>   	/* 2 BTRFS_QGROUP_RELATION_KEY items. */
> -	trans = btrfs_start_transaction(root, 2);
> +	trans = btrfs_start_transaction(quota_root, 2);
>   	if (IS_ERR(trans)) {
>   		ret = PTR_ERR(trans);
> +		btrfs_put_root(quota_root);
>   		goto drop_write;
>   	}
>   
> @@ -3664,6 +3674,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
>   			   "qgroup status update failed after %s relation, marked as inconsistent",
>   			   sa->assign ? "adding" : "deleting");
>   	err = btrfs_end_transaction(trans);
> +	btrfs_put_root(quota_root);
>   	if (err && !ret)
>   		ret = err;
>   
> @@ -3675,7 +3686,8 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
>   static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
>   {
>   	struct inode *inode = file_inode(file);
> -	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
> +	struct btrfs_root *quota_root;
>   	struct btrfs_ioctl_qgroup_create_args AUTO_KFREE(sa);
>   	struct btrfs_trans_handle *trans;
>   	int ret;
> @@ -3684,7 +3696,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
>   	if (!capable(CAP_SYS_ADMIN))
>   		return -EPERM;
>   
> -	if (!btrfs_qgroup_enabled(root->fs_info))
> +	if (!btrfs_qgroup_enabled(fs_info))
>   		return -ENOTCONN;
>   
>   	ret = mnt_want_write_file(file);
> @@ -3707,13 +3719,23 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
>   		goto drop_write;
>   	}
>   
> +	mutex_lock(&fs_info->qgroup_ioctl_lock);
> +	quota_root = btrfs_grab_root(fs_info->quota_root);
> +	mutex_unlock(&fs_info->qgroup_ioctl_lock);
> +
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
>   	if (IS_ERR(trans)) {
>   		ret = PTR_ERR(trans);
> +		btrfs_put_root(quota_root);
>   		goto drop_write;
>   	}
>   
> @@ -3724,6 +3746,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
>   	}
>   
>   	err = btrfs_end_transaction(trans);
> +	btrfs_put_root(quota_root);
>   	if (err && !ret)
>   		ret = err;
>   
> @@ -3736,6 +3759,8 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
>   {
>   	struct inode *inode = file_inode(file);
>   	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_root *quota_root;
> +	struct btrfs_fs_info *fs_info = root->fs_info;
>   	struct btrfs_ioctl_qgroup_limit_args AUTO_KFREE(sa);
>   	struct btrfs_trans_handle *trans;
>   	int ret;
> @@ -3745,7 +3770,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
>   	if (!capable(CAP_SYS_ADMIN))
>   		return -EPERM;
>   
> -	if (!btrfs_qgroup_enabled(root->fs_info))
> +	if (!btrfs_qgroup_enabled(fs_info))
>   		return -ENOTCONN;
>   
>   	ret = mnt_want_write_file(file);
> @@ -3758,10 +3783,20 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
>   		goto drop_write;
>   	}
>   
> +	mutex_lock(&fs_info->qgroup_ioctl_lock);
> +	quota_root = btrfs_grab_root(fs_info->quota_root);
> +	mutex_unlock(&fs_info->qgroup_ioctl_lock);
> +
> +	if (!quota_root) {
> +		ret = -ENOTCONN;
> +		goto drop_write;
> +	}
> +
>   	/* 1 BTRFS_QGROUP_LIMIT_KEY item. */
> -	trans = btrfs_start_transaction(root, 1);
> +	trans = btrfs_start_transaction(quota_root, 1);
>   	if (IS_ERR(trans)) {
>   		ret = PTR_ERR(trans);
> +		btrfs_put_root(quota_root);
>   		goto drop_write;
>   	}
>   
> @@ -3774,6 +3809,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
>   	ret = btrfs_limit_qgroup(trans, qgroupid, &sa->lim);
>   
>   	err = btrfs_end_transaction(trans);
> +	btrfs_put_root(quota_root);
>   	if (err && !ret)
>   		ret = err;
>   

