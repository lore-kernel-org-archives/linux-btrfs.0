Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44ED9463B61
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 11:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786708197; cv=none; b=nxckleQyv80KDUJQevNClSmylJjZk+11hhAC0y/2RdedMCv2orrTx4gFU3mOkZ7xFJ78IeqIvYp9QnGGPb0IRNeugRHxUU5GbKIAJM06p+bpftwAPRCGjLRb7kcHhlB50G8zp5TSkhQaiL938BSCe5OTkKq75xfFm9BZw7IK8Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786708197; c=relaxed/simple;
	bh=uW46YNSfbhhjQYeIT1VzWCFBi5XxUEpgXvKyedK76YU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hg2T8uOkKvRdeFEdaRo9I060Tw5gxubu3XcwRfyrkbbnQXoXpnVy/kaVp/RzlOA7G4w6Lk9Qhhw7kJTfp09TxeCbmJkM3FPZVx9CmGNIpXwjaXdd8laxHUnNJdXuTcPV26r09nibvFi9gPr5N3NXullZbPVpJtIj9nV0xqN1LIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FsMJ92oy; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FsMJ92oy"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso6716585e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 04:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786708191; x=1787312991; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UamCmCJHowCyVONDNB+dcVsOFTBvr9OczutcteOGBjs=;
        b=FsMJ92oyGtal/Y00baO+6U9Q0oPglSbRwOeoV+RmNCUd4PJCb+tggh9YngTAnoR3i0
         pkv9PUATDvyCmXpzCY8+vC8S/14RoeA8NJHUX9l4+fqRqS5I1J/T/45pgbhSKzGWvZVq
         3oKXRZbOQtKF/ZEM+X3lJAVURqyKbsjU4Oyc5eudQlkslHts5nU088CJTpP3R+nvMc3U
         0wTjiJUler3UdRQEqKPL4LEZBfV+R5sJGCR3hu4VzX5ba/Ur4mLCVu81VqlWGW7d2/I+
         dhOf72BEsXHEzXFgj/dtXQ27eMph++QlKw68d3rpxCfwsDj5RDx6BPnXmowTdmMC6/hM
         dAiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786708191; x=1787312991;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UamCmCJHowCyVONDNB+dcVsOFTBvr9OczutcteOGBjs=;
        b=FNFxZVyBWgMgJl6x/4Bkw5dCBT1Tjq/5FW1U1PMvntPVOkc5CMadsizh4u4/9tg+eJ
         zm5JdL6o/xhGdZNf942BVNTCTo5WF/Y60dZ8T5I9mAbjcGDDDSP4udTCBQxMhxnLmnRc
         iN0JpzG9n9SZkByf4RisPnVYYMQ45C0EVItwngE0KvFMV+0EYQWg6wn+6WIiN3qucFsJ
         PXdmcKhd6igbq9MJGJD2n3AqavcT9tyWlaJEYbz1FoAHgnxdv1PsmDXepEqYUuEMCOlT
         IXuGLPwNmgU6F8B1VBP7yPiLj3xL6AgkEokBJ/NlVLwe1XB9WvDBK6uQd9qEmeTmiPWw
         dchQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro8fOfQ9BUEaZNo9ER48qENt/H1EzfAAt7ycdQsCNM63XE5R0qtz5bghhr6jThAI0+raUR0QqQsvC7QtQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywton3aCX/z31lW3kWBijcPyaaWZXox8KnXGwawmoD+V4EXH4Ug
	CEXSZWPEvqDxyDCNF4Od5XNvPC4kOhkZG/a7w795Uv8fMyRWMiuIgaJHWIZ6bMFZnC8=
X-Gm-Gg: AR+sD13ISW/3fqGJffFL1le+rB79QIKdgyOFU1Zs5j2DPk++0lQ5Lnuut8CaFuNj56f
	6JL63uuU8Pt0tz6FbzuiQhmJac96pzhbwpV1ApdimLx+Q2DV8EBN1VMcMbzTxyfKJmOjDv/eeuz
	G8HlsRMm8u/cmzATPZN4kVRQtxUehkjGqmwU1UM8iIzgrgTOX5zomW2EO6/FB5KWbwjzOPF7dEt
	Veql6UkcddkdtYoHiFU5P1gEkwjnmtjxFLRbocvibPrNeh+R5h6r+pVZUS/TfNjCw3DEQRSESLO
	H3Z+sx/yIz6I1IGOjxrQMEgOvLDGnORpKv/UAuc+zLj+6nLoUu8woOYELuwunOpzTNu7dE4Tt1y
	y7tZ9/B5CRQo63/4FxuSfNbLq4JL+Q1DJ2/rEcyTS9XJHJnVxomE9Lr7zMK6OAsoQQDGtSHueJE
	pjrxggQ05kk26Ss9BTkSIuzN3+LxV2Zh+BIeBaYE58oZwTb5uYhDrvrg==
X-Received: by 2002:a05:600c:1f91:b0:497:fecd:5b00 with SMTP id 5b1f17b1804b1-4998797c6dbmr63971415e9.9.1786708190927;
        Fri, 14 Aug 2026 04:49:50 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3218d3f398dsm3059960eec.22.2026.08.14.04.49.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 04:49:49 -0700 (PDT)
Message-ID: <694e88fd-a165-4518-88d4-cb2f22e8925b@suse.com>
Date: Fri, 14 Aug 2026 21:19:44 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: free qgroup configuration when quota enable fails
To: Guanjie Chen <jk.chen1095@gmail.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com, fdmanana@suse.com,
 linux-kernel@vger.kernel.org
References: <20260814112240.93514-1-jk.chen1095@gmail.com>
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
In-Reply-To: <20260814112240.93514-1-jk.chen1095@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/14 20:52, Guanjie Chen 写道:
> Quota enable adds qgroups to fs_info->qgroup_tree before the operation is
> guaranteed to succeed.  On failure, the current error path removes only the
> sysfs entries, leaving the qgroups and their relations in memory.
> 
> Use btrfs_free_qgroup_config() instead.  It is the existing qgroup teardown
> helper and removes the in-memory qgroups, their relations and the sysfs
> entries.
> 
> This is safe because the failure cleanup runs with qgroup_ioctl_lock held
> and before quota_root is published or quota accounting is enabled.  Qgroups
> already added to the tree are freed by btrfs_free_qgroup_config(), while an
> untransferred preallocation and quota_root are still released by the
> existing cleanup code.  Transaction handling is unchanged.
> 
> Signed-off-by: Guanjie Chen <jk.chen1095@gmail.com>

LLM disclosure.

In fact, for anyone who doesn't have any previous btrfs involvement, I 
have a strong feeling such error handling bug is fully exposed by LLM, 
not yourself.

> ---
>   fs/btrfs/qgroup.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1292,7 +1292,7 @@ out_free_root:
>   		btrfs_put_root(quota_root);
>   out:
>   	if (ret)
> -		btrfs_sysfs_del_qgroups(fs_info);
> +		btrfs_free_qgroup_config(fs_info);

And the error handling, no matter the older or the newer one, is 
incorrect in the first place.

In fact, the newer one is worse.

We can reach this out branch if btrfs_start_transaction() failed, but 
the fs_info->quota_root is already setup by another process.

In that case, the older code only removes the sysfs files, but keeps the 
qgroups in the rb tree.

But now all qgroups are removed unexpectedly.

>   	mutex_unlock(&fs_info->qgroup_ioctl_lock);
>   	if (ret && trans)
>   		btrfs_end_transaction(trans);

