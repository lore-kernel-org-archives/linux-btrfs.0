Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9850813790B
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 21:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774386360; cv=none; b=bgKHLR71iYwYdZVs7Na04uAirVQw1rc4qKEJ8puH0dJRXiH3FCorzVPIjT770KDFd+fdGtQa6KOrxv1zCAyBAtAEFsNCoc99zYuZDPt3gZoaLBY6ysaN0UkxSUC4/xOExoTI/avyJ+Sox4Yy9KiJFbhEJgYSSG5rzxVIFm/iKlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774386360; c=relaxed/simple;
	bh=G0+y1yw23E1qWl6xOYU5tUnvr6RohCiXmi/H2J46QCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VdNfr4NDgp8QhL0vAEeddRsTqcH9QiRw2RDq/Bx0dxPdCF3jXQBk9E75gu8DzRelWz43DFUL6zmdfYUlCAUPtfYqH3jSLLvdspBdru/6AMCzqKgzECdAK+0ave6lCNvrsYzqh3xZ2DoqRccNZAX9UvI6gUsaSDn96B+foYpOAhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eQ424I0d; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eQ424I0d"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48704db565eso35225045e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 14:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774386357; x=1774991157; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CTIC6/Y7DWJ9OaxSisLGv+cmlCJv+8LQ0inRrUin7sE=;
        b=eQ424I0dHrJgYN7IGP4Lh+lNsrQegPo/WjDvnI/txa1i3g/g37Uf9GA7y9kyN2+ERU
         F0gfx+DNWNkPD6f5AHPV68exMhPPZnVlWfLqtwLb0lPtmVUg5yeScP7+Blbo1RBqMn/3
         3ErGMOBNkyYEErquKE2DLi4eLlHBX1lqUb839TZ86jRdLzEGHXrNMe4OT5hA4CPAX3Ii
         ACruDbBv6fbNTAaybknEpR8iZQsZ1OB8w3HM4xBVOBFLrcNOwJlDuaNndbXi+dTybNap
         sK9jy4tljVb7AgI/2Y1dIiL28rlLOns6kLI4eibNFrU3wl2qTxxUa5+yQdfJAo3cXccw
         /O0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774386357; x=1774991157;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CTIC6/Y7DWJ9OaxSisLGv+cmlCJv+8LQ0inRrUin7sE=;
        b=H/fm+KMhigGbF+EHQ4FKxU1VUUhRSxsgzZ7KI5hBtFbApG9la1mMYLIsjAtwFHSwKD
         K+xy1s7hR7scdXbCTiqz+HOiH+gsXwSy+dyQcNvvi0FN+oT0H9R0Sklqb8jFdmbjUg5D
         5u7Il71CWF9hYl50b5i+m+xyMPn7/SCAWfnaGFfr1BdezGFkgfohmVisVorj368zCbFZ
         dWMOPqoDBL11PJYkRP8obh2OErlbz7jLs+XIDFOsVxs6Tech8GRBvkkU3ysD4awNgWIG
         uEm5wj/+idDMgSDkTloUXQb5n/5pMD1aXgEA64FCHOfhsDcxpiajOxttUCZbaBBvtWYX
         hNXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVco+TNHA2UZlvXqTwwmzRFprsPvLBSCcV421rZJwUWUkmldruA8JebLlzGcN0Xn7xR9meN+XNHqYK0Wg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLmleNEMJWS/iG3USaTbtJha90y2i/7gInTXNpjA3y/rILuWBg
	/F9WXr9f91ca/PvZfN2KGBRPeXT/g5iP1bUWIheMNEDkHAFPOxGLI4V0H4RcQkoewFo=
X-Gm-Gg: ATEYQzy9BV8WX1BYOzyFqF+x279haNwTIkhnbo3k8DBrBuHn0W9E4Bj1vLfKoA0h1TV
	kf37bcV2H9EuhVmaDSI55BPc2u5nUbDBgHorisy41wzeUnI8i9jRd5lq5fwa9q8P0MFzf6XxLec
	E1pp/zObHLFXWN2ei/NytdYtUiGh+H2ikJBXeEFBjx0gqKEvi4xk93j4yjcrqGVYpwPUUou++3e
	2+k35RjIqvVdK6H0eE7VXz0NJnl8JoAmq+S9sixGiUQhMkZ3W+vL7omEpZ0kDHTOgekHv1mcEgI
	he1vCgn8E9wb7VUurGGkpQ9mg2kjz+oM+gO18H7ysa61zi6aqSXu7WGGgRoTG9hd6u11z4qP6Z/
	B20Mxzz4vO43KyGqOQ63EDNS9/i6NyRB1iX5E1x30M2ISFuUBd0qZ9TNTnAgQG2nGv7NlDCJjjR
	KOrFolarSYZw6ls5Tkj8hPsW+TjQfd9+ONy1FXDZbhXPe3bN2UeSY=
X-Received: by 2002:a05:600c:350f:b0:485:40c6:f528 with SMTP id 5b1f17b1804b1-487160a213bmr15602385e9.30.1774386356803;
        Tue, 24 Mar 2026 14:05:56 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08352ae70sm164690755ad.23.2026.03.24.14.05.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 14:05:55 -0700 (PDT)
Message-ID: <9cb65b37-5f5d-4ca0-b1eb-8c89d942759b@suse.com>
Date: Wed, 25 Mar 2026 07:35:51 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs-progs: check: recognize verity item keys in
 original mode
To: Leo Martins <loemra.dev@gmail.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <77723ae3c51bb05723123a15b869cdee921727e2.1774378180.git.loemra.dev@gmail.com>
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
In-Reply-To: <77723ae3c51bb05723123a15b869cdee921727e2.1774378180.git.loemra.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/25 05:22, Leo Martins 写道:
> Commit 4e88bb6e ("btrfs-progs: enhance detection on unknown inode keys")
> added stricter validation for inode keys in the original mode checker,
> flagging unknown key types as errors. However, it did not add cases for
> BTRFS_VERITY_DESC_ITEM_KEY (36) and BTRFS_VERITY_MERKLE_ITEM_KEY (37),
> causing any filesystem with fs-verity enabled files to fail the check
> with:
> 
>    ERROR: unknown key (257 36 0) found in leaf 30621696
> 
> Add the missing switch cases so that verity metadata items are
> recognized and silently skipped during the check, matching the behavior
> of lowmem mode which already handles them.
> 
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

And I'll merge the PR in github.

Thanks for spotting this,
Qu

> ---
>   check/main.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/check/main.c b/check/main.c
> index c96969fd..4fdd8867 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -1895,6 +1895,9 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
>   		case BTRFS_XATTR_ITEM_KEY:
>   			ret = process_xattr_item(eb, i, &key, active_node);
>   			break;
> +		case BTRFS_VERITY_DESC_ITEM_KEY:
> +		case BTRFS_VERITY_MERKLE_ITEM_KEY:
> +			break;
>   		default:
>   			error("unknown key (%llu %u %llu) found in leaf %llu",
>   			      key.objectid, key.type, key.offset, eb->start);

