Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0BD4137A7
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2026 06:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786602855; cv=none; b=AuGFcEUQbVsjoPLzkamt13WHg9M+t7TBRbLaBC2xBM3+LWdSwHl3BL0rVdT4PjqTh1LQKh0dM+A93ZcgQKQz8AYEfZ7lmbXxfH9QNHhWw7repfGSD+9Q3dI631mJb8vtflkqH+lsCQSj/vOr80wcycR82tLkGtpVE6/mpupSJGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786602855; c=relaxed/simple;
	bh=H+hFoYvKGCSPDDX/N+csVvj1asWuxFl1s+Y8P5H56zs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gevR1LW2Tv+uLRZ3L6LkPdoLeQgBebv0UH2tFLRBf4Lqwc5AebXjQENFRgmOqJtqz1ZgwaCKrZbWzLCwvF7CvggnYqucEu2gyz5R6x2wC62ti/kThlN/hnVLCHzi4Q7O49vlIT5d7Il8JktD7MhTF27JhiAJbCvn9fxYPk8Sdho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dCSg6bz9; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dCSg6bz9"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so15678495e9.0
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 23:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786602852; x=1787207652; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IR19d7dz25eJhpnRyH/IxVmhKX79dV80a3exCVUcmjw=;
        b=dCSg6bz9gc6meAXVfM/nA+eeqiB8LSy8o8MpmJwcvs9F9GufKiaAOpLUg+MQ/UB/1X
         b6craTYkgR9LPOxREYNP18BtvqadnGriC5tCaLmKgDcTUqzIYIYl70ekP5AUlc5ZRROv
         oYCUFNVfId1bl+Cx8QXnvwWb54F5jFhh4etuY0culAxSOUEiaMggCCV8QaIrzTub6NaN
         ypA1YzIk0MrVoRwZhAtDIZcMrdSTdd9+j40utIQlr4zfuSkLUj4gZftPA9m9CmGtXs3p
         31YjdKtWpEDwXRFaJhvv3DxUAdgtTw/Rp7DuyAVa2nq8hRbV2PDSvOF6cjQG3ET2xFNr
         hMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786602852; x=1787207652;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IR19d7dz25eJhpnRyH/IxVmhKX79dV80a3exCVUcmjw=;
        b=cqCzn0VAHvGwmDvk3vtXk3IEXvY0S/8htlfbn6lnYp4JIg7v8ql59LPslSb+FcgUx6
         +HkzFnkqMAZ4WFHIOtvISaV+CTfCKeFlibRt8MelJAcco3qBa0ZjXraHhzw8LHWCbW5u
         ZlpahAgW5WJsR7zLsMpnwLSEvLQV6qNndJN0eet30f1uV46e5pV0ZqX9StryQT959c0X
         B+0YvKuUFiB6u9Sq2+HpjPJWdikdnoHPfEWs5l9G3xFJR+j9z68hTBuEs3655X6FYxEz
         N0ABoJbq/zSHQQSkBJFVPmxeSjZb93Nb3MvCEkXDyNSpwTod7D1i0lJzOxOtSUYS0don
         oWcg==
X-Forwarded-Encrypted: i=1; AHgh+RpGfJw5Drap2uhiR3Mn+mCr9+5F2BCwWgMlf3Bl2dSLg1Eh3AvLAeA7uQ0IlI9UwWlTjXSycycnSGYwkg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxNNuHhVMe1CG93eKoLCgRbusA0/3x4cGw53MlQ5hDnB29AcLB
	byHEy4pyBlkW34QuzQO/j41RHenhC+lLTZNVZuUyOnq5BPxnDdI3vdIfvlkuLo+bPGU=
X-Gm-Gg: AR+sD13IN1OovR2ODhjOVLaS6kaEayFimbSg+rysXdRakBv0Qs/eo+157R7S99lNlgK
	iF6rX8OQCO7Nu/Crjx7jx1tJpxoCS2QiLQ4+X+/StKq/DkXEC17xQVwnOOi3k1ctNsSq5qjMuKJ
	kw9N7pbRs1ReEF++ellDuniRGPaH97/inr1pqiNSgXJ/nW6+toVovO4FZb3A2hS0/wsH92Z3816
	bzeUp+ZPane5oAN/HnJidmbFR91EkVWMg7pAaLX2odHNZ8rRaxR41R73JwecmXUl5mNeeqNMPxb
	UcBq+H7amS+XXQiNXN7+RJ6f7wC1WYZx8qg0KpyA2K9DCt0uDf8py+2BglHsq0FD8gHIS5929wf
	ZTa+Pm6120Ai5iIHpMTrvFvN8Xea4Z9tC3u3T2yqs2PJXOiyNAd9yLb1HyEHs5c5WoZ+a2l51Im
	SUO7Fm0121u3GYFu1QIiznScVMiwXzDI/EZzsGK5YDI9NKtyCVyKd9FA==
X-Received: by 2002:a05:600c:1f83:b0:497:fecd:5b00 with SMTP id 5b1f17b1804b1-499821c67c3mr30803175e9.9.1786602852419;
        Wed, 12 Aug 2026 23:34:12 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1412d961bf7sm5379585c88.10.2026.08.12.23.34.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 23:34:11 -0700 (PDT)
Message-ID: <bd66065f-bae5-482a-84d6-a78850c9cebe@suse.com>
Date: Thu, 13 Aug 2026 16:04:05 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use mount idmap for defrag permission check
To: Tao Cui <cui.tao@linux.dev>, clm@fb.com, dsterba@suse.com
Cc: josef@toxicpanda.com, brauner@kernel.org, sforshee@kernel.org,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
References: <20260813034146.1207640-1-cui.tao@linux.dev>
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
In-Reply-To: <20260813034146.1207640-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/13 13:11, Tao Cui 写道:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> btrfs_ioctl_defrag() checks MAY_WRITE with nop_mnt_idmap, which skips
> the mount idmap.  On an idmapped mount the owner comparison then uses
> the caller's fsuid against the raw on-disk uid, dropping the mapping.
> Every other permission/owner check in btrfs ioctl uses
> file_mnt_idmap(file) (e.g. :1152, :1310, :1946); this one missed it.
> 
> Switch to file_mnt_idmap(file).  It equals nop_mnt_idmap on a normal
> mount, and the check stays behind !capable(CAP_SYS_ADMIN), so only
> unprivileged callers on idmapped btrfs change.  The RO-fd note in the
> comment above is about the file descriptor, not this inode check, and
> is unaffected.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

Fixes: 4609e1f18e19 ("fs: port ->permission() to pass mnt_idmap")

Otherwise looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/ioctl.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 72bc9d4f7708..607329dedd50 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2458,7 +2458,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
>   		 * running and allows defrag on files open in read-only mode.
>   		 */
>   		if (!capable(CAP_SYS_ADMIN) &&
> -		    inode_permission(&nop_mnt_idmap, inode, MAY_WRITE)) {
> +		    inode_permission(file_mnt_idmap(file), inode, MAY_WRITE)) {
>   			ret = -EPERM;
>   			goto out;
>   		}

