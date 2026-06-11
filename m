Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9FA399003
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 22:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781218603; cv=none; b=axTfNun99xstG2CvhOrkL6Slai1kdvhjVz4s7zJyZqkV7Mm1IAn0f+HHfphLwBLA5/4rHMkbVQYmbOG6jGBLCzJM6rDgO/iNU21+ele1uxBkhSv8VHRMMW6O0sY/KaUkxuqfw+1EeRYzJuUidwsYDodK69+2ie3gAbeI9/oSU0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781218603; c=relaxed/simple;
	bh=kDAIqXWz1E/I0LK0cVdx/EYaIgPxvlGOf46EX9S5tyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Luoi0yq6CbWUXU419yohOrDciAAX2Hs9F+I7sBTDuu4DNHwa12FFH1Hr94S0ij9oWbBHGmuw3+hPHERNOLLYQxv4P8y2KOQg87e6WV+a0GSJnLqZO2DVrA+yzhHEJjTA4jiK7+OXuLUa6A0ivlK0HfioFAvoswe7mNX4p9HPWGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IByxDIx7; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IByxDIx7"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490cdae130cso1652335e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 15:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781218598; x=1781823398; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=oXcZK8qp7QLk+DdLmv6M/5Jfzy4SnHpAz6K348JDz18=;
        b=IByxDIx77UsOmqHWuzyl5cPeUDEFHZdDjEq40WBQeVuVuKnWEbJC2rsW9s0gtsJfqG
         8PgXJDJHWUkYeIU8KMGdzIWSEYrvEB8IW2jmLz1pi8VwBNOcjiNbbafcTxq2S/pmwg/u
         1A8sHCQXVU1zviNvv2w4DzTh1M9XN0tmQ2ymJvZdNlb/kPhkXckYsAHFtKl7KChXzkF1
         reaWppjoljIgBI02/NrkJIncQ4Ur+ix3Kmtajc5YdpbtZp3qgiCo0gfvrvAyoIACpzzu
         RwWqvpHNDRaFFJbslhgG9+FYJm1kfE9v/fmuyDAh9fCKRJZWZncNmWGDlPT6MqjAyndv
         Rcpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781218598; x=1781823398;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oXcZK8qp7QLk+DdLmv6M/5Jfzy4SnHpAz6K348JDz18=;
        b=rATsOh3C6FXsFNJLDi5R6+PahZzed90SM8dArsa1Gzs6vJvbzB4bQlZXXwgedkbcFY
         /063Wkw9U5fGOZI1CVmj64hTnt9OwoDGGFq2UTIJB8zImFEq2RWOkenpoKlVqijIBe2F
         Ck1/gnRgzEwhtVjLPWdP0UKTVfDFKBu3zNMXbnJw9TCGPkG0YVtjMYuw3hALYuhTIcG6
         i2Y2jhan08qUmNkYQqBIlc683pPHlLf8xi/vKcKn6inO+qpRjEjD+lQvEhYYzo+N4woK
         1vQ8208zsVVLVm5dVepp3EvxPGbDu3ID8GxMdrLWUG7HhtEzvuuQh+vw10zDP52kW+jY
         1XGA==
X-Forwarded-Encrypted: i=1; AFNElJ/Wi9HTC8iID/rnSz7D5M+EPh157StleRDPY9Cxc9uPePMzHF74m1DaJfL71xFbplh1F0JorG96pWtOaA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwESoR8XYUpLkP1nR75S9jbVIzpYZMqxH2X/n5KwYcwEsHKSG86
	+j81JQyVY5OxTSYpBgI+xAJY3LUXYD6WTw6+XybQzqMeL/K4s3yaVM5WUa/DBvcrbLo=
X-Gm-Gg: Acq92OHSzTZ0IOqjzysbaqNE2e8Zv857R/GmsqbU6RwytRd358GewNYR+cg/PlkiWTP
	dfATf95mM4e5y3iAPr6oMXieANTOvVF+82xEmpF1A+TmRsjYMVub1pcP3kA3i7tTZL8fzucftfB
	SQNe3VdBUhCxwE/i1a1m/Sity3MtZWqTzJCCcBckGb3+wWkuluECqLeeeyEgYIRUDXOb7mXTX+X
	OJRrUWMFVXEWMD+CXW/UQi6EgavtJt36YuA+d4mInEbl4w5ldwzs591U518DxQ6nbVfiWGuv3NN
	sxiWyxzXHwqDdw+v5y9AcXshTkdw8W1Z8lBULnW47cr/TzFsedkPfNmxmjbYglR7rBl/ystizw/
	JsqyYXOhE12eSXpg7DJAVDbf13yZgEGBAvj4+oHtnS17/n4RiLAXHCDMc2s97VhFk4n5x0voKfe
	TauSxpL3jPTPZWFI0LDwzebZrPBgxwq158tB81IOhpEsHpUhh6Wy1KjM+qj6hzKVwd+TG0um6Ji
	mFZp/tMVMDCQHyS8+9APH816U+hYSE5J+b+uAklLNaL4A==
X-Received: by 2002:a05:600c:314a:b0:490:4e3e:b483 with SMTP id 5b1f17b1804b1-490ec502cacmr416665e9.22.1781218598274;
        Thu, 11 Jun 2026 15:56:38 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e52a9sm87765ad.11.2026.06.11.15.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 15:56:37 -0700 (PDT)
Message-ID: <dbb8c9d8-346a-486e-9e23-f200f6bebb5f@suse.com>
Date: Fri, 12 Jun 2026 08:26:31 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: validate root ref item size and name length
To: Kyle Zeng <kylebot@openai.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 outbounddisclosures@openai.com, stable@vger.kernel.org
References: <20260611212445.4848-1-kylebot@openai.com>
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
In-Reply-To: <20260611212445.4848-1-kylebot@openai.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/12 06:54, Kyle Zeng 写道:
> ROOT_REF and ROOT_BACKREF items contain a struct btrfs_root_ref followed
> by one variable-length name.  The tree checker validates only generic leaf
> geometry for these item types, so corrupted metadata can expose a root-ref
> item whose item size does not match the embedded name_len field.
> 
> Several readers later trust the item size or the name_len field when
> copying the name into fixed-size buffers.  For example,
> BTRFS_IOC_GET_SUBVOL_INFO subtracts sizeof(struct btrfs_root_ref) from
> the item size and copies that many bytes into the 256-byte subvolume name
> field.  A crafted ROOT_BACKREF item can therefore trigger a kernel heap
> out-of-bounds write.
> 
> Validate root refs in the tree checker before other Btrfs code consumes
> them.  Reject items that are too small for the fixed header, names larger
> than BTRFS_NAME_LEN, and item sizes that do not exactly match
> sizeof(struct btrfs_root_ref) plus the embedded name length.
> 
> Fixes: 23d0b79dfaed ("btrfs: Add unprivileged version of ino_lookup ioctl")
> Fixes: b64ec075bded ("btrfs: Add unprivileged ioctl which returns subvolume information")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Kyle Zeng <kylebot@openai.com>

Tell you stupid agent to grab the correct branch.

All it's doing is just a worse version of the existing check in for-next 
tree.

> ---
>   fs/btrfs/tree-checker.c | 38 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 1f15d0793a9c..fb072045ca18 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1915,6 +1915,40 @@ static int check_inode_extref(struct extent_buffer *leaf,
>   	return 0;
>   }
>   
> +static int check_root_ref(struct extent_buffer *leaf, int slot)
> +{
> +	struct btrfs_root_ref *rref;
> +	const u32 item_size = btrfs_item_size(leaf, slot);
> +	u32 expect_size;
> +	u16 name_len;
> +
> +	if (unlikely(item_size < sizeof(*rref))) {
> +		generic_err(leaf, slot,
> +			    "invalid root ref item size, have %u expect >= %zu",
> +			    item_size, sizeof(*rref));
> +		return -EUCLEAN;
> +	}

Your stupid agent doesn't reject name_len == 0 case, meanwhile the 
for-next one does.
