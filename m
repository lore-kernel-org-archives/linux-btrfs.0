Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DE2241695
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 03:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774321407; cv=none; b=jo5ndBpOUAM+wFYdWWpt3bBpuvKvH+0lvu/hLg4e0ycq/50nPkz18TKLJtGY3XrvXjxrDEbA4WMFO5JCqQmKMff9MEOrSKIQTTuQI9LRXNEe87PzW/NEERC+b/IMebfMwPKD7kpn1VoWp/iYKH6YHDr7vQGQWEpRj+y6JhHHv9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774321407; c=relaxed/simple;
	bh=uyWeVkKouyf6PAkSsSHmvOuO1ZPES4PsRnMWB+S8dKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tCj00FopYZ/y1szqP9h/jVYxJu8DHUYzW/WOun1lcHuOKhSYOxESfA9ESiwFHatQG2JWdUTNOemgKOhR7PGVCv7iIsxNOqkjQrtyQ1FSD2KToBMopUMUX+WeiyR4to93C0ko+g0Z3cQGamFBEXN2hVsUU5xfaDguH5wvlR7AyoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=efn1fEbM; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="efn1fEbM"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-486fb112c09so30726005e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 20:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774321404; x=1774926204; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BxiEcWyCIh5XLpAJedlFixpaeU6wHAd7UwWrKLcC3s0=;
        b=efn1fEbMhJMbZWjVi+/P10kA/iz1kewyjfEsMMcfk3mUGHDenP08ukOwCBLOj3vRS0
         EUR6TViBG3Iy7YcWuf7KZRs0h0jTdpdbFNR9H7KJ38eWqFLQHsuIKIgI0tadL8rhoIx7
         sRG39eIWcpjsY0RcePhmxGgAtmhvAv6EsBxKR2y1uSp22z3q+T7oHqycAkR74iC5eOLs
         0Izt2pN8vnanSt0DovRzMtGnlQ8RSdplpb0a+RceKbO/wHQ2uvb25dYwa+MrhkqXAWUV
         6ewVobHdSPaQA1b5FhI+QMgkufHvbX+BQxcwH5ls8FQGrdirG5Yzd9lSzHmZa1q8biA1
         ul7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774321404; x=1774926204;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BxiEcWyCIh5XLpAJedlFixpaeU6wHAd7UwWrKLcC3s0=;
        b=lFj/plVPIPKE2gFkCVC8sZcjTiN0pbDtaO9j+iXQ0VXc2a9pFftoiUQU8lI9I+JZtL
         gJUzeq7fhxGod34Cfq9WkrZQr1SomuDuXj9f9NNmnetYzf15u7kwNemRnFz9P0L3gQWS
         JqPJfMuF3KEuGoDOdplgtPrbongwyjgplM19ysR7HkeSAvRR5JkZAGTSccvrI/2duJkZ
         EO5UcsazifZZvVl20qi1zpPnrArKJvI10/ryKwljiEbNuDB02ssUZ9SJS8VffsC2ftTm
         nGwhZMmY+R9O+qVDkFV5RsPCJRnN3uaxsJm3jVvS/2JOAsnhH8BESXoK/JzF2h4xyMiI
         rhyg==
X-Gm-Message-State: AOJu0YyLauaM2hGTM2m8AxXHDHWha9NMJ5P8+CNkScJfpwZCp30z+3so
	UGUHQaXSRRYmQd9tAbFAW4YqABJEvbgCHyNPibpdg9DU8ZPrkTIyrPlvjrhp/2ldamRJOlKni69
	r6lbHhNQ=
X-Gm-Gg: ATEYQzyWZn5XW1bG9kBJaNrPzP/+3X/QXA2MOlnOi5mW+X2K4iGZBZB2TADXeEfb9f3
	Tx68MDGY1cqtTNyi2mGgcw4JToPLxfBBSJN+RjG60Za3KtqMfWbe1RzNtvBrvTqSDJpiPGatLFd
	iWSPey7rfaWTWBt7aaf7IyokN0okwaUNa5BC54ZJbcdwNbQoRACcOuFbnh7dnx9As/mGLVFFchf
	1dHeH22hg3ZvWTXo+vEKVb/aAMsLVD/9kZj3lzU/8xRcrKJVlFJJXWr+f+OubAdqupgC9vB+xts
	NQzwl3oCLbn7KVq/zvgaSEDSkjmwrQ1ijlRmpRakGkSh1wh+4sXTxllBtGfiNflhTCNeKNzuG3m
	nWg3WdLn3bS89SvVB+rhrZjDWMs1QHmBVSw4UNI8hHOTr7g6gsWxWRG4C0JLycBkzscZxos05+B
	BNMe60bDHIgOflwNqBrONu4W0p+MyaXXbBLjl8xxrgU3+xRNhU8xJy8ysuwXht9A==
X-Received: by 2002:a05:600c:3b07:b0:485:419c:4eab with SMTP id 5b1f17b1804b1-486fedab40emr193853785e9.6.1774321403780;
        Mon, 23 Mar 2026 20:03:23 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08366b9aesm160508875ad.58.2026.03.23.20.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 20:03:22 -0700 (PDT)
Message-ID: <4a10806f-27ce-4162-a2df-142e6b670d15@suse.com>
Date: Tue, 24 Mar 2026 13:33:16 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] generic/301: flaky failure on btrfs after metadata
 overcommit change
To: Leo Martins <loemra.dev@gmail.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
 "Darrick J . Wong" <djwong@kernel.org>
References: <20260323201533.2648753-1-loemra.dev@gmail.com>
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
In-Reply-To: <20260323201533.2648753-1-loemra.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/24 06:45, Leo Martins 写道:
> Hi,
> 
> generic/301 has become flaky on btrfs after commit 0dc118b3c327 ("btrfs:
> be less aggressive with metadata overcommit when we can do full
> flushing") which landed in btrfs/for-next. Out of 30 runs, 8 fail with:
> 
>      +file2 badly fragmented
> 
> I bisected this to the above commit, which reduces the metadata
> overcommit limit from 1/8th to 1/64th of available space for
> full-flushing contexts. This is a legitimate fix for -ENOSPC transaction
> aborts on small filesystems, but as a side effect it causes more
> frequent transaction commits during writeback. The reduced batching
> means the extent allocator has less opportunity to coalesce adjacent CoW
> extents, resulting in higher extent counts that sometimes cross the
> test's threshold.
> 
> The fragmentation check in question is:
> 
>      test $new_extents -lt $((internal_blks * 2 / 3)) || echo "file2 badly fragmented"
> 
> The 2/3 threshold was introduced in 9184ca155d7c ("xfs: test
> fragmentation characteristics of copy-on-write") as part of a series
> testing XFS's CoW extent size hint (cowextsize) mechanism. For btrfs,
> this threshold is arbitrary — btrfs doesn't have XFS's cowextsize hint,
> and its CoW extent allocation depends on factors like transaction commit
> frequency and metadata reservation behavior, which is exactly what the
> overcommit commit changed.
> 
> I see two possible fixes and would appreciate input on which is
> preferred:
> 
> Option A: _notrun for btrfs
> ----------------------------
> 
> Skip the entire test since the fragmentation threshold is not applicable
> to btrfs:
> 
>      test $FSTYP = "btrfs" && \
>          _notrun "CoW fragmentation threshold not applicable to btrfs"
> 
> Option B: Skip only the extent count assertion for btrfs
> ---------------------------------------------------------
> 
> Keep the CoW + data integrity portion of the test (the md5sum checks
> after random CoW writes and remount are still useful) and only skip the
> fragmentation assertion:
> 
>      if [ "$FSTYP" != "btrfs" ]; then
>          test $new_extents -lt $((internal_blks * 2 / 3)) || \
>              echo "file2 badly fragmented"
>      fi
> 
> I lean towards option B since the CoW write + remount + md5sum
> verification is still a reasonable smoke test, but option A is cleaner
> if the consensus is that this test isn't adding value for btrfs.

I also agree on the option B.

The fragmentation behavior is really specific to each fs, thus leaving 
the number of extents test to xfs, and keeping the contents check looks 
good to me.

Thanks,
Qu

> 
> Thoughts?
> 
> Thanks,
> Leo Martins
> 

