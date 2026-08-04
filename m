Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D3B23BD05
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Aug 2026 23:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785885502; cv=none; b=KNo6fQTrobeQwOxtoplqpe7rSp3CFO5rTl0O4zzGJuFMyhrtDA56eC0rsSAQbIhpWQDIpf6QF2mBq2XVgrwKRaXxeUJJaSIpsLIy+Bw0bNRXMc5kQosyhjzTlgWgWcRriXyfOfH6CZau0zU7LXh/T60HrekVRnOrjFLzPnd+T+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785885502; c=relaxed/simple;
	bh=I+lgaBA85h8J99T8MHdGP8NlaUYcL95D/kRLqVNFUdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ik5arpu7FRv+PX19bfB+ywwjNMPj7Koy8FSWzmC9pA4FblZc/kAR5dwou+B1CTiNyqi7NzMztkH2LTQA7olaAFlR3jSXccQzvbyL4uyb0LTpXG3+1YOevICRmf/TuoOfWLwLNAlC3V2cqguOl/6mPvWEsS3qiAVaDdYybfx0MGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SWJrmKTL; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SWJrmKTL"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4954d29264cso1600575e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Aug 2026 16:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785885499; x=1786490299; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YHwHYlq5VfGWNZu147Ty1cv4AG8AVPubvVw/ikXfOWs=;
        b=SWJrmKTLNlnSJ44Loo/nht/XfM33Iu2EoSkztTPXm1qQcpwuR7CiID9peu9gd274eM
         NY/8uSf44f+MCYDC6EmnOWct6X2XHb8syl1yk7fPtgtlEZLQ/nahh6Qo+1i8GPvKUbf2
         8zfHEv/IS7KZzp3UOeZMrdrnvj6iEAI/qejvJw/uAaRnUtZcL6P1Ib5en2UFlwyIopLe
         og0ghxpzvGiwZ37AZ1BUPbGYAywJ4DrPDQ7oT8U17g2snImjHoIEQLzwonMW6rCx/Bmu
         cREwIzv9itAnHiRyoBUrSqMjH2O2ZJP2NNC0ekoY3xjJcg/+cx+vgKXzFpAdEDtFIj/l
         Haiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785885499; x=1786490299;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YHwHYlq5VfGWNZu147Ty1cv4AG8AVPubvVw/ikXfOWs=;
        b=r3aT7i/VJ0L2XIDl88qQxxTTr01IqjXZoohE+HEvTB67U4oUb3//y6q5YIcSbu8d09
         HSy8L1NQNbJQhV7vz9SDOK8xqejQGKpG/sHMrNLPmj0K69gJ0ttAJZxkwmLVr45zGaR+
         p+hZaWf9ueppA03GuPtCkgvr/z/fgEL+n6vIzC5krrkgdy4bkOAIPdX3MYIzvw/jJcQx
         pw5HmsLuAtknMxCNIrKsMlq6pfZijW2kE5pwTXgvoL/2Sqb8ARAHZ64kwW2QfbIVgpAt
         82TVCt+NeHOpEaY+jwjyq6ZKYTPtQ4cSkICSoBTFxxPu/iFwyA+xhaZY/JdBoaieRoDV
         AsJQ==
X-Gm-Message-State: AOJu0YxcYVZUodcKuq6SwUwTj0ZCitkBievGiXePrpiZW20mqefF9Yu+
	PM9740Op3kM22oMyp7ufX1r3ArlGtgPtVAMkuLWPKx7mgGTkUqHXVxrvGYbKiCnEZ8M=
X-Gm-Gg: AR+sD10bYzN7i5oX0BfgMMEFIM9HBRKGEk00m86QnFjXszsHTo4tSvMXAiwoOv/psXF
	haxo4qvRpH/tnPHH/vFBpwYpfyIqYqEt2KBLlfCSU8V7beHiGOT6o4KY7zIYagAbQF0IMBShXVB
	0BuIm4I/FKmqUYRixStpXLdb1pAnYBHKbgzE0umTzK/QzmhGFB27pIEMCjSVNPgb5Jbin2wKA2t
	mloN1Q9G0/8qSJfC0TiOLJgHHG1kYKKGAFQ9pk4d8gW8B+QePe3QxlaVHi1hjTw7agBJ0ffoGVW
	z3g+umppCtwYhAvHqI7gdwxohdHQvaaZXnChdtQyzF+WYd7LAioapaNkHuV9+WjGsNDFGeAJ0WC
	VYgDQfU8Phghpze26uFBjx5ykgFG9ShdNj4u4AaOl5Wvr4gCE20Wp64+2qZDOTNqqFwbdf6Ikzj
	X+NipZDIKMRwCxow1hJs1SPIBCsok7/U8KR1CDDVJ0zXYqErlikfvkMQ==
X-Received: by 2002:a05:600c:c043:b0:495:7a5a:d96c with SMTP id 5b1f17b1804b1-4994e7d89cfmr15280285e9.18.1785885498983;
        Tue, 04 Aug 2026 16:18:18 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fca8df88csm6564257c88.11.2026.08.04.16.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 16:18:17 -0700 (PDT)
Message-ID: <9df1c3fd-b647-4460-88e4-1930ae85b440@suse.com>
Date: Wed, 5 Aug 2026 08:48:12 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] btrfs: use an on-stack path in
 btrfs_insert_orphan_item()
To: Jeff Layton <jlayton@kernel.org>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@fb.com
References: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
 <20260804-btrfs-enomem-v2-1-4d923170e8c1@kernel.org>
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
In-Reply-To: <20260804-btrfs-enomem-v2-1-4d923170e8c1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/5 01:14, Jeff Layton 写道:
> btrfs_insert_orphan_item() allocated a btrfs_path with btrfs_alloc_path()
> which returns -ENOMEM on failure. It is called from btrfs_orphan_add(),
> so a path allocation failure there turns a recoverable error into a
> transaction abort.
> 
> btrfs_path is only ~112 bytes, so allocate it on the stack instead.
> 
> Assisted-by: LLM
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/orphan.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/orphan.c b/fs/btrfs/orphan.c
> index 9f3ad124104f..72e1adec39d8 100644
> --- a/fs/btrfs/orphan.c
> +++ b/fs/btrfs/orphan.c
> @@ -9,18 +9,17 @@
>   int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
>   			     struct btrfs_root *root, u64 offset)
>   {
> -	BTRFS_PATH_AUTO_FREE(path);
> +	struct btrfs_path path = { 0 };
>   	struct btrfs_key key;
> +	int ret;
>   
>   	key.objectid = BTRFS_ORPHAN_OBJECTID;
>   	key.type = BTRFS_ORPHAN_ITEM_KEY;
>   	key.offset = offset;
>   
> -	path = btrfs_alloc_path();
> -	if (!path)
> -		return -ENOMEM;
> -
> -	return btrfs_insert_empty_item(trans, root, path, &key, 0);
> +	ret = btrfs_insert_empty_item(trans, root, &path, &key, 0);
> +	btrfs_release_path(&path);
> +	return ret;
>   }
>   
>   int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
> 

