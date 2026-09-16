Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF1A48CD5B
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594029; cv=none; b=sfH+/MjYPvdsLcUWpg77qYyE6e0WISY+zzIbd+GHtzOV8X01XTF891kezFCASVr5WQLMB25I1Eqzicr/X7qEi+8Dsmuw5bDnkD1qbYV1O/j5lVpNKFlaKGfuAzRE16P9SPST4gKcXPbn5QX9jHVPNey44YSDwA4ZrfCCQ0r8t94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594029; c=relaxed/simple;
	bh=HOL3d4hB2K5tlD4mnWZ1fDxH39k4Ir5VssG57nbzJy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZKcm8b3lmC6DXJBHDpXUu4XcOm3qZyGDj/4nJtH9kHxDAezoeOMaYSEVyFeOn7VD3pETgJQhYd+ika//fz3+LwyITpIfb9LmzZpo4uwwsBoLbQki97h0+o3wfOYkeG/9BoXxlXH1glJtTBsXASBqMXaGWVJZwH8zmFVlS+ZjFBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gi4kRNRt; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gi4kRNRt"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254fa650c8so35954866b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 14:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789594016; x=1790198816; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MfLNR2szLVElL2kVS/OY02263O0ABtaCK4IJADJJp0M=;
        b=gi4kRNRtrinjvgy4kkA1j4f1MVTIgpWjfHYuH613Fi/SvfFjRB5Dps/1QCos27TVGn
         RCVR7CZZYjcowoPRtkfsuCwf+RR8s55Gn/jtNsA5TjgSDIQrmqtGyU0s6jhxSzW44APO
         yaDy7zNyYJIO3pTLqRK0UAeKGU/bD27U2ECbUBlQ9OvIdEOj0nXIoPsLRwt6UaOTL7hV
         nw2qXVgVmc5QcDSUuI4xO2z/ZNnZfgEA9K0naRzTUPYqoVWj+wql6W9r1NHIoK4B1FPe
         Jua4Lm9KgtcqlcD7LDZX18/10O9ExV1kloif1xW+RD4hCbPaCQmWyjFJsJJGYLKgcKZg
         flYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789594016; x=1790198816;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MfLNR2szLVElL2kVS/OY02263O0ABtaCK4IJADJJp0M=;
        b=GnnVl0aWUmaNGZBEDMNAeRGxUoornuymWIgwwZG33NRAPBtbdbiUGa1/FBccsbW7zH
         C8MwaZ2Jq+KtUgX83FJXtG1XLW6RzjWs+dRUWksVFzjBTAUv/tUGmshB8WXPdMrrBplj
         wDaWFsdJR3T9UjoCc4bkjJfJi5Jxhwln/mIqmdFINUeAphXoYj81uIjjE+1tVi54EcvB
         N5WjNFYzc7HgoL72vACmbwQYSV6t8DMDsHYMDuljhX8o5pkWmhmdYLzD4kjPrHQ5Mypr
         QYI7m4tURnxCwOoJO8IZHB6SGNgxxpogsqbuIeM4tpdXJL5vWrEM2AM/jAQbXu1TiRu5
         Z5Nw==
X-Forwarded-Encrypted: i=1; AKwUvByrJKk34Rv/hNMojW3pmoIyUe0Bd5vyUC+GxStHadANFdyqJOsVCya/P4bbQZqa+qfjiWZwOtLX3Qg22Q==@vger.kernel.org
X-Gm-Message-State: AFuF++l7Ri/aY92bIK+gBdpW8j95II5P9KRc9lNo4pTQMRBtA3wbgfKA
	E/emoUMwetABzwds6+bSkEHeOiaEnCUEa7hZDMfjfcPnFTYugOFOnw9pw53yJvLoz9s=
X-Gm-Gg: AYBFou0qejWniqcYXqoxxwIvgaqKttP5AyeOqoHmPHEQJifP3InNhsH1fPP52W0RDjy
	1nZNpN/01zqVIwXr+qKVqb7t+prvzO4tCvOLSlla+mkQiUuYyWzOQzPGX4zQ9XudzFaixoDaE/c
	4pRCO4HMgGd2/Hh/dzseGkiij3OHTD3bBllvmAYA3XIaVlRPabtJzg1w5YMgY0Dhuw88rLrzGS8
	3wNOV7adEdVCChE22/itV/3fW7Tvll3VGybgErtb1aycxFv9A9UB8d1xUjixLxBpBRRVzFFpaE6
	8Sxl9+YFsy+/J2WK4qhwT7IAm3E70xUUUn3XNFcZDKpLflClqWxqMLK84yedGTN5zVu/l0k1jN2
	5QRXb8lOFpHQqhHJ2UFhXYGV9zkK0kPCI5+qbzWm7LRXXB0mLLNN07Td71L+CxFWZ6vYELNXqNs
	Ut1hczbzE79UWlRJw/B1Td0+hIjGoymAz1+I+TmkN44GQt7Y8hO4Pz9FhJZ/04Irw=
X-Received: by 2002:a17:906:6a12:b0:c28:f9e4:836c with SMTP id a640c23a62f3a-c29e52ff409mr327776666b.28.1789594016188;
        Wed, 16 Sep 2026 14:26:56 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc50acb8b5asm2212905a12.31.2026.09.16.14.26.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 14:26:55 -0700 (PDT)
Message-ID: <4530c488-d7cc-44da-aab2-dfb7564d4fbd@suse.com>
Date: Thu, 17 Sep 2026 06:56:51 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: abort transaction on failure to update inode for
 hole punching and reflinking
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <5eaff5e851684919160420f975c26574d05d4c44.1789570705.git.fdmanana@suse.com>
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
In-Reply-To: <5eaff5e851684919160420f975c26574d05d4c44.1789570705.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/17 00:32, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we fail to update the inode we error out without aborting the
> transaction, which can result in a persistent inconsistency if after
> the failure the transaction is committed, as we have dropped file
> extent items from a range and either punched a hole or insert a new file
> extent item for that range (for reflinks).
> 
> So add the missing transaction abort.
> 
> Fixes: 2aaa66558172 ("Btrfs: add hole punching")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu> ---
>   fs/btrfs/file.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 20e15dc30bfb..f978c6524aa0 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2509,8 +2509,10 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
>   					      inode_set_ctime_current(&inode->vfs_inode));
>   
>   		ret = btrfs_update_inode(trans, inode);
> -		if (ret)
> +		if (unlikely(ret)) {
> +			btrfs_abort_transaction(trans, ret);
>   			break;
> +		}
>   
>   		btrfs_end_transaction(trans);
>   		btrfs_btree_balance_dirty(fs_info);

