Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792747654;
	b=3iP6bT4idMatA2zy+9ZksiURIhCcZ2GxftOBhdZgeIrnn7JbzFviE7K4umgzi/0FcaOL
	 fSHG7JcSURburtl4bbJdhumR6NGh2KsnSRPj3VnyrSQvnkxR7JEuaa4iVLLf/b7H/hFVP
	 /ZnpG8NQxtULc/Wetfm073STa2M0Vie9LRamGc7TktHmM3cNyGweJazR/oKnlcZ+ou/j7
	 ksuH5BzmD/xg62ndSn3rVqR1sbJjdqyOO3PLFv1VB62h+WJGOenXnqLmYuowiQlQ7zzWB
	 KTqvwMvUjgqe3sotwarAWnzljeYULn3XqcyZB2fPb0SlJGhSlD8LoxDTQbCNOtumjcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792747654;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=FYzrI+M2wIgQPYRq8VaJQ6a+UxI3FbIe6h/rWTPHB5I=;
	b=yMC1ATSHynqFrXfdt1Mbq57ukJOdBG3DTV8vyWssFmfO2J2ucj3OyJrJ+wtljiIYWzOX
	 EC5PU01E+YlSG3GakFqbr9D2PhDeJuTbIfcBi+U39v3mQpZj609sfeVcMmhRw9fT4sXf8
	 RDRmu9jbCoX4zwQkftESUotmdwtJwbsEYjCNJ5EYBRpxln8vzWTznhsH4pi/0qxXrfI2D
	 OoAPLlOg2QQtB1vl/zSoKVedAfrUb+tfUq2q68MotuTwRVQfbg68wgn14yt8fVKCNaPwH
	 ZzRc0PxLWL60zDc6f6XrbLmXTzwOI3+dSGVrhm2Ds7Kyk4myS9DvRHtULEZlOfsvZBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Gn3WH21L;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26A7606A322
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 09:27:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A26A7606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Gn3WH21L
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so3450845e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 02:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792747652; x=1793352452; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FYzrI+M2wIgQPYRq8VaJQ6a+UxI3FbIe6h/rWTPHB5I=;
        b=Gn3WH21Lc6gg0lmp7rGn9vke8VfU0BguxHrVzyaRbW34vv0Iga6zmCQk0DXb156jeM
         f9AXqwPEv6WGEZKuxNSQns86o01Hqp5RJ3Mp2q+qMAc87yo5nUHShsvI7YJfxuH7iOlP
         ELDiejSwFyO3O9iKJzMgTjJxjXgqsM8GKEPMXsBkpR15O7sZdv0qRx5v8YcuRMHQtKCy
         LPNjvYNevmp9RRz6Cb/S1tpYTihah3u5BoAnNyDXP67IJPlC6PnYJjb/A5TY4QtkvChu
         d78w2gEJgk+cPSYnEHrUoBuFFAMEouAkgI0yo776PdSHPUCWjnfzh2kL0IwUmN7+CHds
         xvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792747652; x=1793352452;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FYzrI+M2wIgQPYRq8VaJQ6a+UxI3FbIe6h/rWTPHB5I=;
        b=OQDg22Iej51hv7GMA1+DgNudqSf8r0l7ZlftvCYLhljZgnFp7kNTv30eA7J0EKoacf
         f4ERjoPpPN8R5zQDfuuszfptzM+65DNiequKkSrOxx3Qc2Vxbsy7nc/XqRHdgtypOCfJ
         t1dnbIMVNIMmfJCZ2OysD564p8A9Ip8XKZy2WRaC090ew66/v0fR/8NmBN9T/U638Qxb
         YnNsHcyjfb1gWjVyTw85lzLB1yBR8foJxKGEfTA2nrfMZonKAMy0GOd/EFz9eZpMCsa2
         xUw8vmeIlARtqU7xfFPbl/mzAD2WTfkLVyKSBFOVoXHd2so/oi6ypJo12ObP4MHXxwsG
         hpKA==
X-Forwarded-Encrypted: i=1; AKwUvBwBlZ3Vl5/cEyVvortUqQp5hPGGbNkWFUyUnlixwN5ohDYqQbcu+lZE6NSFBFUxHa1b3TvtFvdQ3afDIA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJJWx/cfai4Ni4dvWz5ZuZNPe8gqEB/Uf2aEn0upviOdAsuywkI
	jXlme0Inbxrqia1FxlM+rl5vuxAmlSu4Ld9GfA3Ihph6+R/PbyWIH/82COj9nSQl6KSpcZzYq48
	coLTQbnC1Bg==
X-Gm-Gg: AYBFou0dVb82HpAAYG+lNSnK0slfh6UkLz2XlYb4kzGNEfbMTmxvwITNkIAewbioGk5
	UN7h5KNn3B7Ey1lAW1nonJ473nPhVKsaEzDEeF7MLqP3vFU0kZ2IT1iEx6SAZPWHq1Za7DUQvKL
	m8A4UWgbChyW/1kVPVnOI7+++e6CHwSce8hwe7muh0VMAC2jDdyojf9hReHUjj2tMc9uGybewiu
	YGeE/vAs6XS61rxgidNPpfaovhuCswgsdoUYGdKxJjI7baqZgXfkPHp+SoX5nMV7r/E9otwLq4P
	BomEm0hroqEoRyTb7aY0sAPnBKxaR/9AbVBD4zLst1CFJuo5R97qv1Qcy4aaRevQRkW5lZ0ivbN
	sGC6DhqMMIity2tnZawsWzQd9aFZ56AMWd275qqoPs1rlCtC9FwzcAevph6FLohANCrlM4ReXOB
	lctUic1uXMdV8KqSGn9kNHjI4DvfGBw42SdSUX1nMQ+eu3qMRgbEZGHi7CkiVN9bHDcYKeZw1A5
	xBxqAtzR2wtnvUVe00xJlXoUP7F+jwYfZ66NJ8OQi424nrU
X-Received: by 2002:a05:600c:c11c:b0:4a2:167a:c93b with SMTP id 5b1f17b1804b1-4a2167acde3mr10553625e9.30.1792747651981;
        Fri, 23 Oct 2026 02:27:31 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adcb1f983csm2809409a91.17.2026.10.23.02.27.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 02:27:31 -0700 (PDT)
Message-ID: <498652ed-c6c5-4b91-86c0-fa75b4be63f8@suse.com>
Date: Fri, 23 Oct 2026 19:57:27 +1030
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
Subject: Re: [PATCH] btrfs: remove redundant space_info assignment in
 btrfs_add_bg_to_space_info()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <b8eccd4aecfa8a9e4417f06fbd306b14391f81e6.1792747129.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
In-Reply-To: <b8eccd4aecfa8a9e4417f06fbd306b14391f81e6.1792747129.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/23 19:50, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> There's no point in setting the block group's space_info member as the
> space_info was extracted from the block group early when the variable was
> declared and did not change.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/space-info.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index 82d4ac418a2d..4a19ffef5ea7 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -404,8 +404,6 @@ void btrfs_add_bg_to_space_info(struct btrfs_fs_info *info,
>   	btrfs_try_granting_tickets(space_info);
>   	spin_unlock(&space_info->lock);
>   
> -	block_group->space_info = space_info;
> -
>   	index = btrfs_bg_flags_to_raid_index(block_group->flags);
>   	down_write(&space_info->groups_sem);
>   	list_add_tail(&block_group->list, &space_info->block_groups[index]);

