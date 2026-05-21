Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588113101A9
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 22:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779401589; cv=none; b=rC8DVAKgL9gSDyBcVfZdvLGbjfUb7/vKg1UDg6bFsuGO6L9t6ERbghVfesAVRCS3uQ0NA0Z6jIoYnf4rYt86vVvXvZ9NvyG3M5B7sWImoQbJJDBGuMgFwYR0uf0C/r2eTXMlxp0pQsx+BRtXibpQ6uYPkYLEVBNcH8sEYoESWbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779401589; c=relaxed/simple;
	bh=2EeiUXAUN4tvRrcNwl/0rVeUKKrFhH9uUB7997mQHB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=btI6whz3hBAJwTPzT5nqftWDFTqSC/Ad4yECQkdd0EoFqmuMfcnnrBioKH0mvdheY0UhqpDfWDvnRhk+dGjEmWWS2GaYXCORv6SaeWBzbwEBgUerkytvlSfsYOyJ4qfjdGnS1hjMtQs/dxyol52oFLuoaBEU9AyBtRW6GC7kMfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CKiQW+k0; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CKiQW+k0"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4903997fcb5so12105215e9.2
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 15:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779401586; x=1780006386; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QfAJTrbQ2q08pMIJiapcZukE2eS8PWPzwmmzdILC9r0=;
        b=CKiQW+k09svsU6nAPJRGaywJ7/Z8yLM9DvKckRTF48Jtgxo3sufaF05Hn7glnDH+KM
         2zb6Vcb+fHXsNKyZHp74HobApXlz+x6LBoZBC21QetVYV9LI7dOA7q/iPCdLYFgukwRq
         NOgH6UH35BdHyuC7RYdz8k9SC3Lk7s231FusPJpMecSztB8C7IcPapnJiZ6SKzM9vDDV
         3NdVRGzZwoFnVExuqs2Py3ukpvJYpF+FTkbirlw2Y52x3y5k+Qdi3+yIym8Qyi1kWJHO
         7Hbj3K6Y9ASE+On0EjUgPtPjPQmpOXXDyTmOZBQ/UBJxvVTMeXQ2Kj2AHOBuJ9hMTzxd
         iDNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779401586; x=1780006386;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfAJTrbQ2q08pMIJiapcZukE2eS8PWPzwmmzdILC9r0=;
        b=CeEhMYCKu7KQwTazooxSlGDbek/bcZuCl7L8Ll1rmW9y4KHUPcurMYxSGAJZRKXHZV
         /pdCOWFH73P1f09b/rAScBMxG3BFQXIKKTaS5kQVazQdK0Btgx301Oq0p9UmSlBSa18f
         nGrqi5ijIq7iLDfn6gyZUYrtiz8jHfTErlER6v1ez49H6LIwKZseO2E50ZqAd1rgK/iI
         w0wPbkyd84rd2HklkUpJghooeCa5nAoJC1zPnUKf3XZPNDW5ED1KQJnvfKVAIx8M0XrS
         aejmAg4W3GjXFrCWpXgT+oJQpek+Le4ZD7EBECNe6BqqPvmpYwtlrLJI1V85Huywou9f
         Gdrg==
X-Forwarded-Encrypted: i=1; AFNElJ9vhq8JJNPyWgn7YRdmcfJzTVAjvFPYF7/3UqG7KGTEXcGZiFwFlXxXqG9cMHsP7FAfcPpostUmuUhidw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxrqxXbF4fMmnRcQMU1Hj03FPRg7zGvr2Q/M+0TtV+EuiD/VPgn
	/3IRZEgaD61dlA+av6uJb4JrSTk/sXj5yiuCIV+Cw3Gm+0Nj3vSr4AQvExY7U1Xxpc4DsAlVs6R
	CglSO
X-Gm-Gg: Acq92OEX5hvdmogce1rurS6RWqblJF6AeNTnmB/k+fE31rvmmG7mJGSI48AadxKNdMl
	fHDh0ULuO74UVB61kkSa4l0hFczQT6j3696HcBBvEum3XbxJjTFU2aEd4f4eSEEpbI8lWOYjhJN
	H7sMtEHH1itSeLRcIUjCWOBfgYffgfVSyCpBO9SZFzOpXMWWnfeElZpfJwCGuPsPP2hXXPH3Up4
	cFnwMkuHKoyNxz8F8km2/0bCTRhtLV6kQ7VeuiyUCHM+VwnuHzmNrE3KCEuNogDQpUCZi/ObyDU
	QKknbBMttZ5EVqF/SoazRWT+ZN2lxOYSHrQUWIndx6xSy7i7rsjH3XmJSwAAfFyGJSdHnXfgrfe
	9OYUPCFJND92xkbdZQVNli+t1OvPHQf7O+kjX8zluXkhONG1cna99+Lt4hE+xptbHjEqU7jysR/
	KYUTotONqUAyzCp6Y7HZl6aWc4Y6e7URof8EVKWVXQI6ck7ibBc6f39+qrX89NVnRM122rhqp4K
	ZxdDm7kazFiTQnks8sBU4J9N+3MWNpuHRmcBQ/tPPdCEFY=
X-Received: by 2002:a05:600c:4510:b0:48f:e230:c3fa with SMTP id 5b1f17b1804b1-490428ddc9fmr7537045e9.32.1779401585689;
        Thu, 21 May 2026 15:13:05 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb0e64b96sm2596605ad.17.2026.05.21.15.13.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 15:13:04 -0700 (PDT)
Message-ID: <bb91f646-6ccd-427c-b6aa-4e945dc39f07@suse.com>
Date: Fri, 22 May 2026 07:43:00 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: fix invalid pointer dereference in
 __btrfs_run_delayed_refs()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <f33f040f3ced4b3813dba4ddb0b5377ab5aeac29.1779374308.git.fdmanana@suse.com>
 <f81a69124ba44ff062f13e6287be7f0f5cf56072.1779375954.git.fdmanana@suse.com>
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
In-Reply-To: <f81a69124ba44ff062f13e6287be7f0f5cf56072.1779375954.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/22 00:37, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> In the beginning of the loop, we try to obtain a locked delayed ref head,
> if 'locked_ref' is currently NULL, by calling btrfs_select_ref_head(),
> which can return an error pointer. If the error pointer is -EAGAIN we do
> a continue and go back to the beginning of the loop, which will not try
> again to call btrfs_select_ref_head() since 'locked_ref' is no longer
> NULL but it's ERR_PTR(-EAGAIN), and then we do:
> 
>     spin_lock(&locked_ref->lock);
> 
> against a ERR_PTR(-EAGAIN) value, generating an invalid pointer
> dereference.
> 
> Fix this by ensuring that 'locked_ref' is set to NULL when
> btrfs_select_ref_head() returns ERR_PTR(-EAGAIN) and incrementing 'count'
> as well, to prevent infinite looping. We do this by doing a goto to the
> bottom of the loop that already sets 'locked_ref' to NULL and does a
> cond_resched(), with an increment to 'count' right before the goto.
> These measures were in place before the refactoring in commit 0110a4c43451
> ("btrfs: refactor __btrfs_run_delayed_refs loop") but were unintentionally
> lost afterwards.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/ag8ARRwykv8bpJ87@stanley.mountain/
> Fixes: 0110a4c43451 ("btrfs: refactor __btrfs_run_delayed_refs loop")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> 
> V2: Use a goto approach to jump to the bottom of the loop, that already
>      sets locked_ref to NULL and does a cond_resched() too.
> 
>   fs/btrfs/extent-tree.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index ecc1acb1e340..6030cdbdb742 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2108,7 +2108,8 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>   			locked_ref = btrfs_select_ref_head(fs_info, delayed_refs);
>   			if (IS_ERR_OR_NULL(locked_ref)) {
>   				if (PTR_ERR(locked_ref) == -EAGAIN) {
> -					continue;
> +					count++;
> +					goto again;
>   				} else {
>   					break;
>   				}
> @@ -2156,7 +2157,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>   		 * Either success case or btrfs_run_delayed_refs_for_head
>   		 * returned -EAGAIN, meaning we need to select another head
>   		 */
> -
> +again:
>   		locked_ref = NULL;
>   		cond_resched();
>   	} while ((min_bytes != U64_MAX && bytes_processed < min_bytes) ||

