Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1602B7E0FF
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 22:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777587868; cv=none; b=f82FRHPdSu59rSfymI7yfft7A8nAlArDAfdQMejuMXmSUelfm8uNHYdFfjUigY5DW2TQhwCnBFR0Rwr2dwccbl15woEoAkzDG/rQV55FPwEy+5bl9Qwlb1bCZYrrfLYua4AUoK1fVbg21xNLcaam+7ZLpCD6szuRVjjmPXXrdJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777587868; c=relaxed/simple;
	bh=LakY05XnMW0fAGTeb3Gy05OtZxMTz6IX4KdHSjFLJLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ugf4txScU7if/8HH0mUh0WpGX/AeUbcnS2DRPOgWvk2sx8hjngM7AoCh7FafkkwpHGvoq5w+/fhNce/fGj3SmIG3Er7pvEK1C/SLRQFKnjeDOrlmCm9v+HQfAPKJnk51CM+CMTlR23SZkx5PkvyzwtJf6WKTzHnO8bEwULMddfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Hygig7GC; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Hygig7GC"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488ff90d6c7so13634305e9.2
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 15:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777587865; x=1778192665; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FN3i6cz2Qte2ZCDZ54xgcA+upoRK0MuKDC+sH88fU6E=;
        b=Hygig7GCs8xp1hceWUdgOrXnwn4OA8EyPKFeXXZJWKwfHVP8zLZWkfzd0ARjR0jECb
         B5redG9xtrjR2gkZczjzuK/jMNmOXD+EiSCNQkBF1asaMEbUeriSKIP7+4D4RocVvKxN
         Qwn8sxF0PlDVWo/bGe4U5tY5htXsYSLx+1pcJCmC2LOKx6JTwTlmnbryJAXIM2ltUoC8
         9hAel1lYELL3vl1RSzyTuie+k/dl3NAZM8GtheI09H9Nk0Brgu1JjMmXfN/Gp6wS4xjH
         k1ORinbLd0d82MF87IkGAU2I/0r1IRfHJRO/P1eQT2z5VRihwwX5U1JGhsuoBWZux0Q/
         7t0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777587865; x=1778192665;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FN3i6cz2Qte2ZCDZ54xgcA+upoRK0MuKDC+sH88fU6E=;
        b=Ji8pF+snEGGcMgIott9mDhdSLIA1muX+kh+LzkopoxPnXJxdU6MECR8WIgHfcDTBzS
         h0svlD+Gq6FJ/i0uZO52KdfYuPiuPCVgYWHjnqZ2oJJf8WDAW1HJ+CFMbW0pBQ81uEdZ
         PHtk5fPMh/w0E/FiYiOufyrc4MFbS0gWy/AqRdC3sazOcBMfE5wpYQvzzmESPebtF/yb
         dEtxwTeGJQP7jClYQVMDaQmMhvRt0pb6kdqOTtCdAcLGA72yXNjK9s0rMA26v+nOcCZ5
         IvFBoGvMjemsUOIRKoVRdeFx1HU8WV5Djo36XBU597jKzRfHnjrQxJWHYzBGOZ5wJ5QR
         30fA==
X-Forwarded-Encrypted: i=1; AFNElJ/S50Fh9zlS1nyiz9sjkFWS3nZA7gLBTA8nGASI91/TwsGpBIoAjRJBlOud2leo8/kFAWIn0aoYPFoF+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwnqVknJ6s+H7WLDVtmhsa53J3HAyN9GCM08H7dEl9JE/FeOGGI
	yxywUXPmLL2JOw+x7YoaUrvi/bUivT0lEikG3vSIHjko+oPBR+TnZ28CTi7bK9mul7c=
X-Gm-Gg: AeBDievDeN5hLvz0khASTU96+GxBftl/9/E7hgHP7F90NP1w5elLJIJUxp7fxYz7RfE
	SA80YDGZzQ8XBI9ZC9pyIcQp3WYvlTUUeULDCxaFqgp82PIHRrRKfMnGTJGsOO0zfCWXfseBHTA
	SQON1214Gc8DZmxbdGMmvNKEPZWfS5WtoYkWQ1TxRDBC8NTOdL5EVIJs+YQ4gP/MNQzhRh5koan
	TNmoeM/cD6gX3Zrb+JUTIkBtwPM9qpQbj0K1H4EsSGfhxNtOC7yMuLFoxiKmwUSL2wl3kFU4G1g
	adSgK3+IuT79vDGwn3Nvf+YlFaMaWd3vNSWEA+7q7P9y6S0DUxSmLAbgIuybVPxyYhASUxeIl9C
	jSGvrIM0awEHmqafBvNWAYoB18fsReVsf63os+Svas7uYtOpk7AuBa9pQ2KuH3ygWuwOroH92zJ
	+AkDb4Ts6vu+a7Vn9It4gDCFabi4M8DWdvbM5Q1450xrcZfdqCcqZveXxlefvANy8AUPMfccq20
	AT6I87HjAq2YCdAJKg30f780/ZnFRNRW47dXEzgUnahc/Yc7Rd1k9Q4Ew==
X-Received: by 2002:a05:600c:8b04:b0:48a:5821:5ffc with SMTP id 5b1f17b1804b1-48a83d6a89bmr82628605e9.2.1777587865362;
        Thu, 30 Apr 2026 15:24:25 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364ec0f06e7sm177974a91.2.2026.04.30.15.24.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 15:24:23 -0700 (PDT)
Message-ID: <0247f301-39ed-4e29-9a68-3a8ff3619006@suse.com>
Date: Fri, 1 May 2026 07:54:19 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: simplify how first hit is passed to
 __btrfs_abort_transaction()
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20260430141851.14332-1-dsterba@suse.com>
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
In-Reply-To: <20260430141851.14332-1-dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/30 23:48, David Sterba 写道:
> Optimize the btrfs_abort_transaction() for size as it (by our
> convention) must be put right after the error condition is detected.
> The exact file:line is reported so there's a portion that must be
> inlined. As this is cold code it bloats functions. In previous patch
> "btrfs: move transaction abort message to __btrfs_abort_transaction()"
> the error message was moved to the common helper, saving like 20KiB of
> btrfs.ko and several instructions per call site and some stack space.
> 
> There's little left to be optimized, we need to keep the atomic
> test_and_set_bit() and to convey that as 'first hit' to
> __btrfs_abort_transaction().
> 
> Right now it's a bool, which takes 8 bytes on stack for each call but
> it's 1 bit of information. We can encode that to some of the other
> parameters.
> 
> For that let's use the 'error' parameter, by convention it's negative
> errno so we can reliably detect if it's the first hit or a later error.
> Also the negation is usually implemented by a single instruction (NEG on
> x86_64) so the resulting object code is kept short.
> 
> This reduces btrfs.ko by 8K and stack in several functions by 8 bytes.
> 
> Cumulative effect with the other commit is -30K of btrfs.ko. While the
> encoding is an implementation detail, it's contained within the API.
> Making the transaction abort calls very light is desired.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/transaction.c | 13 ++++++++++++-
>   fs/btrfs/transaction.h | 15 +++++++++------
>   2 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 01f66328966f..bbef3ae86ac4 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2723,12 +2723,23 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_fs_info *fs_info)
>    *
>    * We'll complete the cleanup in btrfs_end_transaction and
>    * btrfs_commit_transaction.
> + *
> + * Note: the parameter @error encodes whether the transactin abort was first hit
> + *       (setting the FS_ERROR state bit in btrfs_abort_transaction())
> + *       - positive number - first hit
> + *       - negative number - abort after it was already done
>    */
>   void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
>   				      const char *function,
> -				      unsigned int line, int error, bool first_hit)
> +				      unsigned int line, int error)
>   {
>   	struct btrfs_fs_info *fs_info = trans->fs_info;
> +	bool first_hit = false;
> +
> +	if (error > 0) {
> +		error = -error;
> +		first_hit = true;
> +	}
>   
>   	WRITE_ONCE(trans->aborted, error);
>   	WRITE_ONCE(trans->transaction->aborted, error);
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index f1cb05460cec..e1d4e7330198 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -243,20 +243,23 @@ static inline bool btrfs_abort_should_print_stack(int error)
>   }
>   
>   /*
> - * Call btrfs_abort_transaction as early as possible when an error condition is
> - * detected, that way the exact stack trace is reported for some errors.
> + * Call btrfs_abort_transaction() as early as possible when an error condition
> + * is detected, that way the exact stack trace is reported for some errors.
> + *
> + * Error number must be negative as it encodes wheather it's the first abort.

What about an ASSERT() for it?

It's not that rare to forgot the minus sign for immediately error code 
like "-EIO".

>    */
>   #define btrfs_abort_transaction(trans, error)		\

And I do not like to use macros when inlined function can be used.
There is no special requirement for things like #name, thus this can be 
converted to a regular static inline function.

Not sure how an static inlined version would affect the text section 
size though.

Thanks,
Qu
>   do {								\
> -	bool __first = false;					\
> +	int __error = (error);					\
> +								\
>   	/* Report first abort since mount */			\
>   	if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,	\
>   			&((trans)->fs_info->fs_state))) {	\
> -		__first = true;					\
> +		__error = -__error;				\
>   		WARN_ON(btrfs_abort_should_print_stack(error));	\
>   	}							\
>   	__btrfs_abort_transaction((trans), __func__,		\
> -				  __LINE__, (error), __first);	\
> +				  __LINE__, __error);		\
>   } while (0)
>   
>   int btrfs_end_transaction(struct btrfs_trans_handle *trans);
> @@ -294,7 +297,7 @@ void btrfs_add_dropped_root(struct btrfs_trans_handle *trans,
>   void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans);
>   void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
>   				      const char *function,
> -				      unsigned int line, int error, bool first_hit);
> +				      unsigned int line, int error);
>   
>   int __init btrfs_transaction_init(void);
>   void __cold btrfs_transaction_exit(void);

