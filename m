Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4BA1EE7D5
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2026 02:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776737956; cv=none; b=L2ZEdgmg4sHBQeH3UEx2HjO+8gIV/xRLQxJZN8b8mc1wT10UyQZD2kxfNgKYL9QSRvsnvWs96l7btLeMTqD00I4y4Ta/WzgfqOUcfcOPwuLOPFq5aLvMk0Zc8LTrw7QC9091pjdptqHfJi0QU6QLl02Ig7zv+15zua9TZzB5dhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776737956; c=relaxed/simple;
	bh=d/hWi/AexsaP3FYTwMygJVy0ABIRgFuM9lZ29UNfce8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GluWhx8tKXZHl+cYy/390bXS6YXnPRQ1KxVK+vwYZIdHJVS43RZZoy7ZxaN7C+EAmVV+Ak9urghNpbSFvN+bl0WLZOzkxvErmM2lG63S/ix+CHrv3iRoAF0qizMPks8Pw+s4qJJ6JinvOW3SGqfLn8z3ErYbveRxXdDDOU0ZNi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X+QZzekI; arc=none smtp.client-ip=209.85.216.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X+QZzekI"
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-35e1eb7a70eso556670a91.3
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 19:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776737954; x=1777342754; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0tkHOrU2Jba7+kNHEppomLcRXSUmV8UXaE+Psj7J19Q=;
        b=X+QZzekIjyqCGKicHm+s4odwP0O62V+nKuI1NgRWLSschIepmYy6KFQD6Ru08Ehh4u
         3zIVo30RXRxsEVNittkTFqaJyn+i52+0wWylmAtKDXFFVCMLgrtrXHKQcwiw4OcxCO57
         SB6h/8tLwmiRLMTpQEsyon3dUomeKjpPbv5zVQQodAiBlKYoBgqNpzrnV0vBcaGA4bTD
         M+HxHaopQkEIu9l5oGYI1uwySqgHOHsNXV6vZG8yTLbVsWCqWajyFooh3U6DWfl4LP7G
         sKvT6eKWkcDfJpm/tBXoX5NIiucF2LvVF3XVFvdj9TTanvXznOxGKFDzGMxZnBQtBD1N
         EZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776737954; x=1777342754;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0tkHOrU2Jba7+kNHEppomLcRXSUmV8UXaE+Psj7J19Q=;
        b=phrxwzKrGRsg39UJeMo7is0Nl4iEdKHi7WeyoLkpg3s5mVPIPPN5VYtTu/yUCErBqX
         56iVqSDkVVlhCEIEQFCHSZeO+wDcbF15yCPX4hTgcrfxP0xkWEcfOBNZgfTciT41XoXY
         cWBI+7CnWKje9aIhJQvlNzaMsYAKx2DjCfOLkN9DZIx1o2vm2Qgzwm3T7seogqWRQYDe
         prORDImEMOeAX5OEV9Im0JF4QFTxoEfzMbga8jqwJ6wYk28aVYAj0eqibARfRnyxS8bc
         sAyPIvHTwIYRUCm8KgPJRQs/pxCyqT4PHWMc9zIR9tYIFqF9pO6aLulJXFzojdSt1Swp
         aR3g==
X-Forwarded-Encrypted: i=1; AFNElJ/z0k5jvq54iE/gdIUTnp6Mg5KsHKX97DlZgd/VILtu+MwNLkbaKQp7k1Up8PNgHEyJVMOEbSmx7PB38g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKlOH0VboAuVuVgFC0d+Jz4kX5sZfHkmi6o9WOa3w16N9Al6CQ
	PKcGGQKSsiGqX7L+UIlJV3iskCUHnBtoSejJ5FLn4+tR9NjBoVcnz5mF3rzT9laQtng=
X-Gm-Gg: AeBDievNq9upeWRVq289ww3b/MuerbRX8fykms0RqsOQgac/Fz8hDY/6kUsduIgEx5I
	dshF/afxZySGjX00LHvT99Q72qT2GBx79C/snleaE8ku5Z83Zbxj/+qe+/CpDog/3ZT2bOUlIDs
	f/ELIpsSX3AkngxLMbrIM6y1j7M+8m8eaxQnolz+YGe1id7nBd+J8OB6BrdW5Z514xv2RyELzHf
	FlV4VkQ6TTVo1PkNayVTn6HuJ08O/Z4MAJSfhW6bX3YDRCq9/EXM2ajKcUhvjdQZbyFuXxZT1XL
	uXB4mVjddBCKsKWo4DfhTBirdky/+BGBQCGfDcyUR0dZ+Y9mjjC4cr61uqF9I6SSyzl8rFlMp9G
	onSctoRbvF5wXUX5N7dHJV8sxqxVaMo0rHniaaHguLqLmobE/MqLc2mCvsDNIDJclUsQ9AuMTNI
	6RTRQAvpBNHr+3RacNOO4HqLJeTMdvG41Pt8Ar1UPYGGpr8YOp0V28urQ/+8hkLk1a0Fubm1kLi
	q2qbiHhBYjun0MR
X-Received: by 2002:a17:90b:1d52:b0:35f:b204:c62c with SMTP id 98e67ed59e1d1-3614022c036mr9133298a91.0.1776737953612;
        Mon, 20 Apr 2026 19:19:13 -0700 (PDT)
Received: from ?IPV6:2408:8239:502:5512:b45e:e467:d05d:289a? ([151.241.129.36])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-362bbf963c9sm275172a91.16.2026.04.20.19.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 19:19:13 -0700 (PDT)
Message-ID: <d761c9e0-0fa8-4468-91b8-4b09ec863776@gmail.com>
Date: Tue, 21 Apr 2026 10:19:07 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use the enums instead of int type in struct
 btrfs_block_group fields
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <085942c2ba1ec8fec438f49c6f8e2d6bb2011eb1.1776693204.git.fdmanana@suse.com>
Content-Language: en-US
From: Sun YangKai <sunk67188@gmail.com>
In-Reply-To: <085942c2ba1ec8fec438f49c6f8e2d6bb2011eb1.1776693204.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/20 21:54, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The 'disk_cache_state' and 'cached' fields are defined with an int type
> but all the values we assigned to them come from the enums
> btrfs_disk_cache_state and btrfs_caching_type. So change the type in the
> btrfs_block_group structure from int to these enums - in practice an enum
> is an int, so this is more for readability and clarity.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Sun YangKai <sunk67188@gnail.com>

Thanks
> ---
>   fs/btrfs/block-group.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
> index 60a3b1c0a8ab..790c2d467af5 100644
> --- a/fs/btrfs/block-group.h
> +++ b/fs/btrfs/block-group.h
> @@ -171,10 +171,10 @@ struct btrfs_block_group {
>   	unsigned long full_stripe_len;
>   	unsigned long runtime_flags;
>   
> -	int disk_cache_state;
> +	enum btrfs_disk_cache_state disk_cache_state;
>   
>   	/* Cache tracking stuff */
> -	int cached;
> +	enum btrfs_caching_type cached;
>   	struct btrfs_caching_control *caching_ctl;
>   
>   	struct btrfs_space_info *space_info;

