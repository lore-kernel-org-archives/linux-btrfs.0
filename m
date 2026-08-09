Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8AE2B9BA
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 04:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786248337; cv=none; b=AdA9+sQ5iP6ui0QRE7qESVG+d98KTzmL8XmmWPyP5nNWE9XAq/+04V6X4addwUm57uR9vvboqNovmGgtJdFEvi8pET6NN5yz8JlnmbRsP7Cv1UfxPvxIRL6biebtlbhkPUikm6cYOyqLAjh5vCCSkBrS3JIzKTgGpkTWVTPzdcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786248337; c=relaxed/simple;
	bh=Dt1PPDi4Eo8kRwy7/yVFZwUMR0Dts5yvu0VqgHd1j48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tKTntkAlKt0wzz5cPIJgZ5D0HcUT4jrO7gfGgaJBDASoxp+Jfdq/GSwQM/lLZ0zl/YmBY8xfyDLmkQZYBevr1thQ7OCf5cUUvAoMN9PbQRie5WA1WsiJmBCcNK1dcDGWu8wr8roL8SRj78PE1ALlW6y19vEVRcLuFHTVVRRVKz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Pd3FFTuL; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Pd3FFTuL"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49557167508so5994215e9.1
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 21:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786248334; x=1786853134; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VocB4syPhp1OTUzQPnyffGCYGU4N0nkNbxlQ5tZI09Q=;
        b=Pd3FFTuLDJq8A241adIDIX1yQZNQPzadNfpHgxtMfQMueUjufGPMvAD+/K91lE1H7N
         hAjeJzGDfUzXzgztH8LdRR0pQIR9Wrk0PTs+oQ+SIAgmouK0Tf3vOgwE2vRLzZEoZeeD
         u5Z51ETaTg35wE2ErWtyc+bazOsAcr5163aq0HUCo0e62YR6vSKNszn5Z5IqAh/Wq+29
         V/OizqBTTMgmXjpQtr81gikeeaCusveiVna1/8iAbe1k6jYw3MebVK0F+eONWoVv8Ruv
         5TvV0LbuUwjfGPf5bolpwOjtvQxsC3Qj/FkNLVbZSVlhGW+kQ9O+veqdUBwWUH8RwE7O
         4gTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786248334; x=1786853134;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VocB4syPhp1OTUzQPnyffGCYGU4N0nkNbxlQ5tZI09Q=;
        b=Ut46U3/0mp27VEwU+S05KM2V7z2OwcCGPpE8q4kbKNDahfnMN5a2S8d3oKfLeIjOog
         jyRYY4edLB4MBZ/WCMYT4KfcwSAcC0Ij+nYjsRLYlOyCbx1vdTKVMJGcw4eYTtx+z75n
         sywHoLAOHw4apswvZBfCyGce7PUqaBgbCSjjLT56NuXETz/zy5GnAOHJDqwvSLcwjCOc
         9NzZ8/ui0o68odUkTTMoI5J+mydhT+IZUM7eYhVKjLHQsrVnng7k69eN4qdnVeBEDmxN
         fCMyJdUDj/kAIPH7Gy2lZEX27yVGM7w/0IC4Gfq1JftNrXbeGRv9iOeNh9U7ZxAuv6LW
         /Ygw==
X-Forwarded-Encrypted: i=1; AHgh+Rq/Bo3XKGh1O3HyE0bUz6M7tmg2CUgKPCxU9UI5mZP2kwqWyD5MFqWC+N+rHfUrB5m/4htiXnoHmXG3kA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxX3hDgguydIj1pbJ4uZfsyfRsFjEn2islXlPm6WaZd+1hNNnp
	ybKdrZFYbDo6lRmjpBUpwLuGpeEfV0DAjAxc8AkQJPckCtU/hZqB8Iyg2TtNHYUGrdc=
X-Gm-Gg: AR+sD130rj3Eh4eH0RVicQnIlTXua73UCMDiWRDXUrwXqXCrGdkboWuvZS6PWcJPTTe
	Qm3TWihiXgVEm0DaLcpU0A5NiQgYH+B7OcwZFYJbSwx2E+T0d48gnIXEbmchPTRrvmpNXPZI/q1
	jH/YoUDMS8GNCaXFg13r+/UtAc/5O3MnM6r0cQ585rgYRFMscOgKZrsbHijmNyWpzj0+Atm/2Eh
	8iVotZsB4s6vojLtsX/XFFGlRF/RFoZ4jAaaj1Ad4xsu5Vxs8oyOq6SDgeGohpaeB8w00JquzNu
	ME+iLN+Ws0Ye1V/75L14DOa04mHogOhLHf0/Kvuq+HvUwcz0DSiwycSaj6grg+02tMSRFhcX+Qj
	K20nNk2FokmtyNl5cm2yTy5R+CfwAjQwl0cfZii2CGsTGn7lCWmK7G1D8FhmcqeyXPGJyRO6xIE
	hd0BbTnzBPOQM3aUASgyXbSUwC0pIYF2asXQRO+Nt891kP0k7CLV4G5H9CTMups7kuSA==
X-Received: by 2002:a05:600c:19d2:b0:496:bbce:fc with SMTP id 5b1f17b1804b1-4994e7c10c6mr435677885e9.12.1786248333954;
        Sat, 08 Aug 2026 21:05:33 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315be8a706fsm25140087eec.8.2026.08.08.21.05.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 21:05:32 -0700 (PDT)
Message-ID: <7123117a-2483-487c-87de-397a8c14bead@suse.com>
Date: Sun, 9 Aug 2026 13:35:27 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] btrfs: add per-inode compression levels in xattrs
To: koraynilay <koray.fra@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, linux-btrfs@vger.kernel.org
References: <20260809015054.779137-1-koray.fra@gmail.com>
 <20260809015054.779137-4-koray.fra@gmail.com>
 <870d7e1f-3e87-4eac-86fe-107af7336101@suse.com>
 <DKK3UWEQ1P6G.JHCWEPD1M09Q@gmail.com>
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
In-Reply-To: <DKK3UWEQ1P6G.JHCWEPD1M09Q@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/9 13:20, koraynilay 写道:
>> I'd prefer to have a dedicated patch to set compress_level to the
>> default value 0, as a proper bug fix as the first patch of the series.
>>
>> As you mentioned in the cover-letter, this is in fact fixing a bug in
>> the old behavior (mismatched algo and level).
>>
>> So it's definitely worth a dedicated fix, so that we can backport the
>> fix without pulling in the full series for older kernels.
> 
> Ah yes of course, although, would it be better to have a single patch
> that looks like this[2], which would also need to add
> prop_compress_level's initialization to 0 as per [1] (that would
> probably be good anyway) or simply a:
> 
>   compress_type = inode->prop_compress;
> +compress_level = 0; //level in xattr isn't supported yet
> 
> in the 2 relevant places?

Personally speaking, I'd prefer only introduce prop_compress_level when 
we really need it, aka, only when we introduce the extra level in the XATTR.

So I'd prefer the fix to be as simple as the following one.

Thanks,
Qu

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 50c6640543b9..bea2d1409fac 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -942,6 +942,7 @@ static void compress_file_range(struct btrfs_work *work)
                 compress_level = inode->defrag_compress_level;
         } else if (inode->prop_compress) {
                 compress_type = inode->prop_compress;
+               compress_level = 0;
         }

         /* Compression level is applied here. */
@@ -2338,6 +2339,7 @@ static int run_delalloc_inline(struct btrfs_inode 
*inode, struct folio *locked_f
                         compress_level = inode->defrag_compress_level;
                 } else if (inode->prop_compress) {
                         compress_type = inode->prop_compress;
+                       compress_level = 0;
                 }
                 cb = btrfs_compress_bio(inode, 0, blocksize, 
compress_type, compress_level, 0);
                 if (IS_ERR(cb)) {



> 
> Thanks.
> 
> Best,
> koraynilay
> 
> P.S. I also noticed that defrag_compress_level too doesn't get
> initialized to 0, so if we choose that approach a separate patch that
> adds it would be in order IMO.
> 
> [1]:
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e057aceaa68d..aec977f47cfb 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7896,7 +7896,8 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
>                                                BTRFS_BLOCK_RSV_DELALLOC);
>          ei->runtime_flags = 0;
>          ei->prop_compress = BTRFS_COMPRESS_NONE;
> +       ei->prop_compress_level = 0;
>          ei->defrag_compress = BTRFS_COMPRESS_NONE;
>   
>          ei->delayed_node = NULL;
> 
> [2]:
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 1082fa92c145..0a4e567d0109 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -130,6 +130,7 @@ struct btrfs_inode {
>    
>    	/* Cached value of inode property 'compression'. */
>    	u8 prop_compress;
> +	s8 prop_compress_level;
>    
>    	/*
>    	 * Force compression on the file using the defrag ioctl, could be
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 2534cd9284d5..cff4b3e97559 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -938,6 +938,7 @@ static void compress_file_range(struct btrfs_work *work)
>    		compress_level = inode->defrag_compress_level;
>    	} else if (inode->prop_compress) {
>    		compress_type = inode->prop_compress;
> +		compress_level = inode->prop_compress_level;
>    	}
>    
>    	/* Compression level is applied here. */
> @@ -2326,6 +2327,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
>    			compress_level = inode->defrag_compress_level;
>    		} else if (inode->prop_compress) {
>    			compress_type = inode->prop_compress;
> +			compress_level = inode->prop_compress_level;
>    		}
>    		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
>    		if (IS_ERR(cb)) {

