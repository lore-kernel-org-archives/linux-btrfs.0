Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4800B269D18
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 22:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782254304; cv=none; b=gwLenr8VM2YVlMdmfZIVbHQKp5zzrkAuj7cRjGvmkoGmJ0INjHzqKIWTJ68vD34JngHZ5ek/GfefYxHCtvOiUcAXzTaEvxPjOGZjRdDt0A4mYByNSehjFDgLQTdFjJNGB3wDS5fvv/K+T3YKAsR+cnjPNMfi86t2RGX+oanCc2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782254304; c=relaxed/simple;
	bh=GSCMdA1WxEOxqx0pJvYpw35eXKjjFwaWuoOeg2vt9SE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NA6EX1Y0mkd7nHeeFhusCj74X8HsiXRmthBNf3z0B9tiXqDxflEHeUWcmx9Exd5DoSfrb3if0mcpVbeYCuGKt4MouUYmxFoNMkzFQH1YvRWeSsPdIFVNzbG7MraoJ1aVN3Xewq33hHs/MVK9IKcuiUjNuDHQQmAJrC8rBx3AtI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MUWOJWRU; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MUWOJWRU"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49241dbf9c1so2663715e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 15:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782254302; x=1782859102; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=nbVgEpAnyIv1It7ff99CDZnXnhgqrW4meMNyO91Xj9c=;
        b=MUWOJWRU2uoLh/2TvMSjFPCNJ8K8uisurYk0US38AWE596wgf0SKRYjogV5bDtfP9X
         2ZQ1JImvt+a0crHaDK9u6HpO6n3TBdAR+Vn22AXpR8Wsnsxg9fcDRUWt1oJgIvi1l/W+
         m5Bf9bqFgyMVRQVvAKVWDSNBNU0tV/0V4zEXyFyAhduPh/DLpxrs/tAk5ZqRXhDcxmEw
         bHgit61jWDeId2BjNqbpdMhFL3VlSELlkw8wMs2sZNWtbp9pE8XmfmFysa6NBDjc6IZH
         KdRtHOD5PwrfyyCo9E3AAweKKZ6aurAsbuSMaZd0PPe0rYbKRV5XmBYoAUtwQYPlFaIz
         9g8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782254302; x=1782859102;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nbVgEpAnyIv1It7ff99CDZnXnhgqrW4meMNyO91Xj9c=;
        b=eWuqcqn9lNNOvbuV1tfPBaktTu/6VEIYUiJcQYFycUcmykoQHiJ2P6FDgLIGq/wwQ3
         yB2ez5uOmyu6UCn8yF2QiehaW/m5A/G9JfsntHeIdedOLauyaQEewOegHXC2BSxKPbvI
         Hit4jdNmj0tHXeDwRbLw0ztKlgHOAItA82N60YPRfC2E5HGABtYSZ8lPp4XX+HplKzyh
         RsBDIXJp66SElKJsYlLphkv4o5DTcYoSM7U+uDCzXCSSpg6t/rxovhs6w0n3jcgFgULr
         uxm7usRitMXR2zbqMN1vLUg6vz1teeTMIgii0nmSMFpIxGV0PQMRjR81gB2Y3gvleztl
         tung==
X-Forwarded-Encrypted: i=1; AFNElJ/+z4tqW4//1lQ3vkfwB1QaT8//iQgEBKibbjOXTPx8yGIruRRU3plzK9tLdDiX4Ef1siCDEuFOhmZ2pw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwnGaxQ4FxaCXzR4iXHKtV0j8gN36WpFtr8eMGULYwznkCabecz
	OS7Fo8IPKrhjFIVTXuypuzkJPnsWBtX5wqsHTGsj/96nJNqebnlnDTJfsEwG2Z1WQkI=
X-Gm-Gg: AfdE7ckF77mlovJFgyyqcQscK997hNLB+osD36LFHXPIlYnIyqlhLRzX6pZIeZ6jfQ4
	cA4MSh1ITKHp8bal57OKuDgkz0QLj9DWUQHbfocLgXmTv5xTvnqup0fJTy916OWpDCro2TKBZkc
	ry5+xPc8awUyud3KpQfw29eiCx99gBl/0SfjlzT/l+P9Baf8pDM+h5utkgjNClT81I30slAqDgz
	EDaSUuGUpsN+RES7bWFBwFASFdqYS1fgOcePsfITv/onbNROyG4Iso5ewmxoad9Afe8tKSDhbo+
	i2qocFoE/9ytlTECmafbfNBuVSU9eRLdc3x1KnCEBFNh7HOuWfwSuK8UG1zoq/ClZ8BwDeAdnYA
	U7Vj3hnjC30mhcs6oVslZAWRzlcCrripcKy5N7aTPM8zKslgl9x6FhgwFDwtfNGPv9hzWZwCGEU
	3vI3S+Qu7PIhVkqNzvX6uAULl75JYjyCuV0fIE0eoMHy8qtkQqgNPSIGRSloO1Wy1ELlx3qqABD
	6mPGkTWCZGlx22Jyf2/q7v33gHIeeYX9dE=
X-Received: by 2002:a05:600c:4504:b0:490:469c:556b with SMTP id 5b1f17b1804b1-49260852a7fmr7507445e9.12.1782254301665;
        Tue, 23 Jun 2026 15:38:21 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c1ba1f14fsm18638400eec.5.2026.06.23.15.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 15:38:20 -0700 (PDT)
Message-ID: <243935fe-6c73-422f-901f-c2a26b010c6d@suse.com>
Date: Wed, 24 Jun 2026 08:08:16 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: send: fix is_current_inode_path() to avoid path
 resets for common prefixes
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <4402ee2dd45308bdcfade989e0fb5a917cfc3f6a.1781541942.git.fdmanana@suse.com>
 <ef59cdc332942f989bda1448b95007c6c2d55f82.1781543363.git.fdmanana@suse.com>
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
In-Reply-To: <ef59cdc332942f989bda1448b95007c6c2d55f82.1781543363.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/16 02:44, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> In case the current inode's path is a prefix of the given path, the helper
> is_current_inode_path() will return true, which causes the single caller
> to reset the current inode's path. While this is not a functional issue,
> it makes the caller recompute the current inode's path later. It could
> also become a problem in the future in case get new callers for
> is_current_inode_path() in more sensitive contexts.
> 
> Example: the current inode path is "/foo/bar" and the path we compare
> against is "/foo/bar_xyz".
> 
> Fix this by returning true only if we have exact matches.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Simplify and avoid false positives in case of something like
>      "/foo/bar" vs "foo/bar/xyz".
> 
>   fs/btrfs/send.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index a3c8f2d889bb..d664e470fd77 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -627,7 +627,14 @@ static inline bool is_current_inode_path(const struct send_ctx *sctx,
>   {
>   	const struct fs_path *cur = &sctx->cur_inode_path;
>   
> -	return (strncmp(path->start, cur->start, fs_path_len(cur)) == 0);
> +	/*
> +	 * Path may be a prefix of the current inode's path, so return false if
> +	 * the lengths are different.
> +	 */
> +	if (fs_path_len(path) != fs_path_len(cur))
> +		return false;
> +
> +	return (strcmp(path->start, cur->start) == 0);

Can we just use strcmp without string length check? It looks like 
fs_path is always NUL terminated.

E.g. fs_path_prepare_for_add() always reset *p->end to 0.

So we can just use strcmp() to compare two NUL terminated paths.

Thanks,
Qu

>   }
>   
>   static struct btrfs_path *alloc_path_for_send(void)

