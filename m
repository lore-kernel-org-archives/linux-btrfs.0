Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794517553;
	b=Q49xexkit0FxkLP0vcttuGA+9ttcxVQbKNOGeb/mCHq6NTIEnmLYNLq/tF/WOXYLlBOl
	 i/dmnWtFJY4qFSDAe2mYHGRwbuZN0DPA1wOMKV2bJ8JvJu78XVET0cP7Dc/3eBDpZKKMl
	 ker5qt7gHFzDm3QS+FuGwQ68/Ox7emWKFKoKdJtSgYQ3DxXzPvUhFXb2mkFpA12egZbhJ
	 BzjLLIV/FeorSgPKjZIBGJoQaSscvrFwFtvibYx6cCQwCsB1kJjJ7LEMM9aQ6ovmL5UA4
	 ONbv7O3AvbsUzfVpVDyxvgRCAW5d7tCp+96oOU90M3y6vVza2RoQbBS+rsAMHBfLoVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794517553;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ith1VFjm0va2v/dGr0DBN7U2J8uUzjCO7s6W742aQpg=;
	b=eVIWU9WjMB8Mbi/6Y2oJmoiYNkTuO+p+qZT199/+BVfIFZg4Jg4l3xRAxzBKhdqChGYH
	 AADCnSXWQSu6wOqOoYPCkkMPbWQHIjoyot3tSCLxre9Jycr0k3IMvd4u9gg2Ezl9PZ63G
	 Xz1yYc1mR9YOyIEFUnZNtgcipQ1/T3v2R1nB0GWYwLtHxSrwnaO62SUzuLW+P0dsqWfC8
	 gdBv2qtWPEDr/Brg7bxLlwFFxxjLlYF0fSIuGoIZbRVl/Cnvsv1zg6TbesXp7F9f+rKS4
	 qs9CLu6Pd0FQIuwUXRTbgPCRNtTT880wWhfuj+Lfgyx3G2p6L69J+s0pbfjiOoSLWNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=JZIN9jqt;
	arc=none smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01207606A321
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 21:05:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01207606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=JZIN9jqt
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b7221c0f2cso411627a12.3
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 13:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794517551; x=1795122351; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ith1VFjm0va2v/dGr0DBN7U2J8uUzjCO7s6W742aQpg=;
        b=JZIN9jqtAYe1E7N1f7LwbMN1I5UGd9BeASVzzu9TXllwjuaAH0+AjpMuGDfQ+cy4g4
         mEiLpECDtGxqLuFISwIsaNWY8RO19CzDEGM3ldLvqyLAbrYfJASvoMvkFgj9bLgfij2T
         4KG2Vcp8oRTfB0SiXYAeZz6wYmqul+r0cgCMRBZKOj5JnaqqljiXD6/4sUaqdxUP2JCC
         9Q8l2rHRjyXMLU4sO5dIL12784Eyy2ESbWfPiaw3lr/nJjiwVbRzVg2IEM1Ss3gxOIva
         0y9C0I6NRJxc03zdSSGBxFvLNhvxpPnp/oMdv5xN6xc3M2nitXeSWcN3EzRVPNl1QXLZ
         OLxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794517551; x=1795122351;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ith1VFjm0va2v/dGr0DBN7U2J8uUzjCO7s6W742aQpg=;
        b=vyT7T3B1lN0jm4ofH6OHnFIq0g9Ef/kOzUQ1ztxvtEb9Ip4HCCI8JItbt2DB3pVDG3
         dyF8Sc1hnz2fO8Z+HHD9ao4BBBSDbVEGgMQHDtU30SMhlGija8Qqu/vJnH4WvjIBHPzc
         fMhjGNIbb5OGEpmvklw1OHJ63uzno0wnvWw2lFfFQmcD8jeloo4b+nsrwMqFD8gXRXj7
         ac+alrtuGphleMrVE+1hZb9R1JkPqa6eREe9ON87dxYZTLMFY9+iAr3BF45nZMjjFRAG
         9V2sZpOQwQpH7z3PwvyfNNUqfbpyVkgnaY9gKVtU53Pa7WXCPaVDYXvF4e6GOX79WNi4
         ixsg==
X-Forwarded-Encrypted: i=1; AL+hErH3ny4w6Ku2ItQwW7W+nwu5YAGICVol8+v8P6TIu7KFXimM2G0bSjEzce7X3qQxH/ufpQWJM+lUKX09Ng==@vger.kernel.org
X-Gm-Message-State: APuU4Z8NOIobw7YWK3bI3loXar3I3lY+guJfMZkZqFPKjZZIPb6CDCKb
	iLrVmMFt7jTRPK3QoAWVYOPqVxnPR/SYgk48fTjEN2Gbsr6J/eFoh7yvme6o91GMeWk=
X-Gm-Gg: AYBFou3ABTgQv6Hj4SBUei2uUzPwuftdU88tHFdWbURt+Yp0rVa/QMg/eTY4hozupvG
	RPN59/0k1KqFPTDYmw5nlrvkJRK94IIGh8dFVkVa+whyh3Al6dDxYvwiO/aGVkupAShoxVFcIBc
	ULgKgjnNrRrDY4gdJo2pmHWcRdNp9hB+DeH3mm++6e2tCDYVdYxqvU7RAl+qkFnBMvra5mwaP4H
	YWsC4GxE2zTDcSIemM6yHH7mqiOJ0xV/nJe4xvVeMmtalUbT4dDaHXKAyurYZMHViPqdQAOkeM/
	wlxwiaKW1V5vOT+ypdAgg2dYAht31rVm/C4yRZGqfJNiZ0r1y7uGg4RItwlBm8xwF5wkutYiKeX
	V3MQPeuIQFxunRto2x263K/FLVhYCiLuJqQJQ+AFa5LABGHfjpVvyy9zEJ2yXffrPR7kPG9zD82
	8WDVDpcZxu5JyMMWKgWhsZsHWqSYVczg+w9YNr9L7nztLEQlUQcYASwMpy2Jw2TtrxOvHJ4V6wn
	OS/brFkgw4A6SFTTMNb+kNBavOmUjvLu0UH1LUhcQ1ZNVUYJ78MxNItLgZu2XJ1nZndoJvpwhj7
	Yny2HTm6dJBcqBbBktHq1Q==
X-Received: by 2002:a17:907:7b93:b0:c29:f5d5:5a9c with SMTP id a640c23a62f3a-c509654de57mr33892166b.38.1794517551259;
        Thu, 12 Nov 2026 13:05:51 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed12a8114sm138084b3a.12.2026.11.12.13.05.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 13:05:50 -0800 (PST)
Message-ID: <94f4e7fc-0aa6-4cf1-876a-e41c0c1a2523@suse.com>
Date: Fri, 13 Nov 2026 07:35:44 +1030
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
Subject: Re: [PATCH] btrfs: fix off-by-one max tree level bound when replaying
 log trees
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <b8a17190faf5846c5d843cef9c0887a050eaf98f.1794513725.git.fdmanana@suse.com>
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
In-Reply-To: <b8a17190faf5846c5d843cef9c0887a050eaf98f.1794513725.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/13 06:36, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> In walk_up_log_tree() we are bounding the loop iteration to 7 levels
> instead of 8. This is a bug since the maximum number of levels for a
> tree is 8 and they go from 0 (leaf level) to 7, so the loop condition
> should be:
> 
>     i < BTRFS_MAX_LEVEL (which 8)
> 
> and not
> 
>     i < BTRFS_MAX_LEVEL - 1 (7)
> 
> This means that in case if we ever get a log tree with 8 levels, which
> theoretically should be impossible specially because they are very
> short lived, we would miss replaying large parts of the log tree.
> 
> Link: https://sashiko.dev/#/bug/linux-8d5b7229-3920-47fa-ad36-3a7ddd02f0e7
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/tree-log.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 85ef3c26e0e4..399414ae67c8 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3067,7 +3067,7 @@ static noinline int walk_up_log_tree(struct btrfs_path *path, int *level,
>   	int slot;
>   	int ret;
>   
> -	for (i = *level; i < BTRFS_MAX_LEVEL - 1 && path->nodes[i]; i++) {
> +	for (i = *level; i < BTRFS_MAX_LEVEL && path->nodes[i]; i++) {
>   		slot = path->slots[i];
>   		if (slot + 1 < btrfs_header_nritems(path->nodes[i])) {
>   			path->slots[i]++;

