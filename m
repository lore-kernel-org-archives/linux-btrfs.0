Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7544A395AD8
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 10:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780308836; cv=none; b=sVuTihxRYTbbFzH/Vcnkdv+SVxnOSBfm5lngiN+Skrpf0nIR1THdvz64k9/dADg18BIj6O5VZvop5AmQ0HNwbTwtQVaD5nREcfIFBiyO10ttyxdzlfiJHbaBPa6k6F5WdXKELBgPqUQr0WcUnTiP6AuXWEt+xMATRYJecC1Cbq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780308836; c=relaxed/simple;
	bh=1UrDiubNi3I7TRCzKnMZD8mHXq4tneZHpBHvZout/2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rLiHOe2ZWQkJgstfY4Ns+oXDssRD6gTSdZbDL05Yvvo+2xsfebaib4y1ISpaOK33GDph1EgB+fQMvEAjdZjgQR8GXgJtAy+ollNks/Y3/TdWwrG1+AfKxHUod8mEdHLLjoXvbtApeK0VfVvG04vQI7bQMPUvh51oF89yfyFcM6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cAIWJVsJ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cAIWJVsJ"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490a7678b2dso9855295e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2026 03:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780308831; x=1780913631; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4DKy0z8XhGoPRaNeDkRrbV8URevTqDUYQCR6lqhnU/0=;
        b=cAIWJVsJyGMTfD7ITWefmBziBOw8gaZL/xawnIwhxJPBYjXThpaenf2esxbfEEvHyc
         Qs4QVTkofmnJPixv3Gu2wNr36tBvGPdLq7jOzxvmlNYWrz80Cd+ZZmYtqe/ox7qU6Ygt
         c8i8SOZEhcsxiCLy/lDjIn25pkSeD35PaKJc01Sq8TaMz0UfSdDGT/zEoLYeU0J1F/wk
         1r5Ovgd9bWXQL2xTOZat9tvGBnW3pRK8X1UM6omxc4nDo4JUWYNGxRhSLYmS3iHQwPQt
         NmaKLgxS2zoUpykkvGCrMNOlaNV1WaAc/Nw5f47xvs6E7slSr4tuCdAWdz/uyyWKi6yL
         8uKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780308831; x=1780913631;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DKy0z8XhGoPRaNeDkRrbV8URevTqDUYQCR6lqhnU/0=;
        b=I1PulXOpfSKnVysRuf0soquxI5BZlo0YIhuhas6Wm0Hpg2dgEY8UvH6qXlBIsHGT6e
         nSRmgnIKGchElL+uQgN283kb5BXHn4ElQ06Q06kQCLx98uIISY7lQF6wn19WOZHRUByD
         b00rUu1c75NPZyEeFz+sUF95aw9fP82hVNr/v1wkPeQnh5MgmrrOUfZ1WwZwPcLmZ61f
         P4YPqYMr855Xn0uCrw58QvsptozJkHXPYEN67q7l2JKkSH7Gm8GW4kJQ42Y9PUsQ4uAn
         x5ZPf+8sMkstG5ZP6pKr6z7Ci2GesEDmqz/yn9Kp1xjRizJA6KS1tPPo4MCqf2D7ps69
         WaGQ==
X-Forwarded-Encrypted: i=1; AFNElJ+99isn57oOoBW8nyGJvhyvH/8SNqpGXi533lGzSBbzdlGaxGdQSw1Bz5sEm7ANNYlHOzgTiVclUfaagw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyY6blj5z8nr63qkORw31+Rpj9YKgwqsIiYdE5CV/Et3Q+iFzNl
	07OhxeZGuLFBfEqsBzkrB6P0UzCyLYMurm40+CjVhvf2Cr6JP1/UuRUViXidqiDg1VrIRQqWahl
	r1zcr
X-Gm-Gg: Acq92OGgcKKufUw3xAj9vTS2HyHw9IIJLDKl8TPqdFlZJ9dwreKISAoIeLR6S975vJm
	nlINwTNLIUkY2oydbYh/+7zznJSpkfkg9J5+CjA0TENyx5tE+5rg0MP1jm+1YBOFbmUstrvCIhQ
	c8nmtYKmNB9uPx12nFKPCAk2TTDI1XJcpZCY1jNGMBDkymIERqexnS4ahux4V7HkauMpdg4tQGS
	jPQmNQhy3hpekM6kfbuUzxeS5DlMwLnBqAivjDgLiw4+3N9Y9QdxdNCul1eCFJnG0VwgGs/btS/
	AmhMuej8VCL6SSAEr8FBJgbBMBp+NMmb86V+RtQry1gBZBru8AW1YpGMLFO31NSm+wKYWyXXHR+
	l43w/qgYBCt3HW+81ys6ecQ14NhTaKyhWYYGJl52k680+/nX4C9QpBX/hilh1qLNaosVAQAHkHT
	o9PMeCSBzCI8Li3lqVguo1BPql+8bqs+qjTSkLCLE4Vsj5Aj0QTHwaN1B7w18eXMQcoevLoQwJ6
	dd+1l9DdbvTm2sKxL00y7N5tG9jO9pPR7hOSb8QMPpv+ZcxIfSJTaR80A==
X-Received: by 2002:a05:600c:34cf:b0:490:5e2a:f924 with SMTP id 5b1f17b1804b1-490a2900e81mr162977365e9.7.1780308830040;
        Mon, 01 Jun 2026 03:13:50 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239e7024sm103054715ad.6.2026.06.01.03.13.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 03:13:49 -0700 (PDT)
Message-ID: <67915c6e-5a5b-4909-a124-3330459f7d39@suse.com>
Date: Mon, 1 Jun 2026 19:43:45 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: return real error after lookup failure in
 btrfs_ioctl_default_subvol()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <e8443af84991f7c4cc6ebea885b850a1c51dc554.1780307495.git.fdmanana@suse.com>
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
In-Reply-To: <e8443af84991f7c4cc6ebea885b850a1c51dc554.1780307495.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/1 19:21, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we fail to lookup the dir item, we are always returning -ENOENT but
> that may not be the reason for the failure, as btrfs_lookup_dir_item() can
> return many different errors, such as -EIO or -ENOMEM for example.
> Fix this by returning the real error, and also fixup the silly error
> message, including the id of the directory and the error.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/ioctl.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 561f4a90981b..9d47d16394fc 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2829,9 +2829,13 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
>   	if (IS_ERR_OR_NULL(di)) {
>   		btrfs_release_path(path);
>   		btrfs_end_transaction(trans);
> +		if (di)
> +			ret = PTR_ERR(di);
> +		else
> +			ret = -ENOENT;
>   		btrfs_err(fs_info,
> -			  "Umm, you don't have the default diritem, this isn't going to work");
> -		ret = -ENOENT;
> +			  "could not find default diritem for dir %llu: %d",
> +			  dir_id, ret);
>   		goto out_free;
>   	}
>   

