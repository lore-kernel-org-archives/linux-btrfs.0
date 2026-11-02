Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793662972;
	b=Alv70CBFWzHni9O6h4k61RlolFm2kWwa2uxGbrLrJuLIRUNLK45tHKNVah+o2HOmas/X
	 WUDbq25S/bum1VCQCMDK+m1FQGTuhER69rpec4Aryh+NZz9P5TcLV9yi0DgIp6v5PyHXn
	 L34kKHDUAC8vmnpq+W6TcW5fJjPS3VJMdYN6UePyrrcamhmO58hYYdRJY0+5vc+dsi4Pn
	 A5zIk0DVW+kBdyOQnU6BW6iO9+sYmKpXtQaEPzPntEBIpBmLjato/QJnzcxD3LrAqQbfa
	 O+0avMtTT+nQW2AuH59SD+tm9wGoBukk4QxVQwppmU5j10pQWENsjELaBM2R1ecxsbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793662972;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=JnQy500MsWrFun+T9a78f9QVRMeORY0a/XfwWvPhYUQ=;
	b=TvpEe72CGa9GVGlbzCogazLtXm9UsIpbxURIaZPgMyUeAMcZUNNG7VlrSW6bhzsXV/QQ
	 atNapuU5suGCwRFQq3E7WMXTERyerIXdB0uJ6edoiau46BiwVLADNm+UJBDugm1Bk8Eh4
	 83PPdJx82M7YN6aJ7abgIfQaO5xO45im05fJY6apPqCG0mStuM9WHRQR3q/vIamF89ic7
	 +4GyKR5Yfs07aWZu9DC+nw7TkUPiMD98CEseMM2SlMVB2rRPjtmwrW79OKVsOZht765Mt
	 NQYKsHyf0QRtvL+bB70QzpZigjm3EMxbiZB92kmbzbTzeMOJD3Pf7TmA8IEjwopHeDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Nhk2wPqv;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB503606A334
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 23:42:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB503606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Nhk2wPqv
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso22488705e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 15:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793662969; x=1794267769; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JnQy500MsWrFun+T9a78f9QVRMeORY0a/XfwWvPhYUQ=;
        b=Nhk2wPqvSQrkiK/roTjKBer5PwoOjEZcUOiCTWZQflUNI1lHbA/yywr5hMwC4geZRo
         /nQsIvO5rfSDbIjA77jp/JC2zJbvv6gA7lT7iyi0UpvRFcKxu2zmc8pmeIOaa2Yuj2cc
         OifvuTw2PdxQxtkAyBWPS8z91JdzqQXhQ9E1kMmGqpqvE/UFlD9QHFr4hv2uECHobPeZ
         I1I7vvMTxiKtviazNZh/URE7e2Ybhu69FANtbZEcsLCykFcM1UZ/zQVXpJAjilti3kjA
         jQaIARJ4CsBE0ndIX0ro9nlfcUzDy+jTbPh/k5WL0h8d6hMrU/QYdWarlce0ISAWWs+2
         4T1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793662969; x=1794267769;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JnQy500MsWrFun+T9a78f9QVRMeORY0a/XfwWvPhYUQ=;
        b=RXcO5Jx/3vZGJY2d3mYC/OborLpcOYHqmkUDxOjakEKFxKUgtMEIT9A2EoQ2mJ4F4e
         +7QOmjQPStcaXdsJEKXpC1xRZNHLbIHt9+a1Dn23/x0RfaSbOxsDzhvmxYe1bAq8yp80
         x5Y2svO1jcqTUJeZnrzlHEuVW23wEB8VtWh3lMI+vQnZpYp2NjTHqP6FH/AZ78vnrCsy
         R3uuLX1tQchJ32WvgIjqte6o70Vhof3LW0GbHSLuHXEPO2gMrgyo1SgeGUm/NE4eeXED
         7TzfEskHupdug1yxoEMd1ZhinWjg60c1adAw5NB3xdv/ZjNqbssow0a5sXRpuEsFxmwM
         9FUw==
X-Forwarded-Encrypted: i=1; AKwUvByv8T18FWdCs4aKwRulLjGDZVu9B6C7JCFTZMk1HCNkXjuq+DN7sG12RO1gn7zDyHHqTKaoFiQZAgKdKQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLNsZWNlhbGktLM2GxRT7w6/VYwjb/ygIfi0avmZalDC0MeuJQW
	m+HhaJ/ZDYJQU0yjVV3SMIqp76MSQ8jaNmDnuSVwb3lc1jYQ1brIwrECWvnWpE5Tu6Q=
X-Gm-Gg: AYBFou21dfO+r0k4ZjS/DzxFnOAq8O1OKP7KtrnpWF5KPYpeMY8Vlzp2t1E9LDH4w6C
	VcTyIlfTljIw+4C+M9kwebgXr4KtmvEyO82yefWQOw+ljjPjfwtcjfv2IXX1YZB7VtdqOtYMvnH
	GnAfSvRKRACQt5Tj1s6DdoWWeOBV/s2Dbg7KLj61WZ7k/iHe7+XgvtrHtxBcXxKF1htMdzYTsGd
	RKi0khnfl6XulTy829RP9uRqStosgGO052QIU0tEvK82byhBoheNFy7oBIwnxlFwWI4DZ+6RuDJ
	/+pZbByElYwWjMfCxVzFUgZbqi6zvffsjoXGUtGHu3XpDJ9gJwvvK13RLBn70O1BiNlT4VrMUzI
	qNzNroZAnI95A8H/lEu+A8LuarN3YerFJ+oA4/ELGWKrTnV+x55F1eEsg1zFeixML5VI5skdVJg
	0bPl8U/UtEMgyCWoUfNRhV2otjg6g+ZiS6swOdhrFooQUTPMT0AmkbDPr3H/6DNdsg/v/OPoFAS
	cArVvhMVKlD0cEozxFxV+v1oCjxnrHVdo9029LQi+byR0JsTXXmEeHTTkXZ/jZga+ZpndAIWzhx
	KJgwHjUqDelOubFZrAAI
X-Received: by 2002:a05:600c:3b09:b0:4b1:4017:c4f4 with SMTP id 5b1f17b1804b1-4b14017c507mr86691865e9.20.1793662969331;
        Mon, 02 Nov 2026 15:42:49 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42a6eabbsm41517207eec.24.2026.11.02.15.42.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 15:42:48 -0800 (PST)
Message-ID: <a12db355-d677-4656-9715-a537980e928a@suse.com>
Date: Tue, 3 Nov 2026 10:12:42 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: do not check support for an invalid sectorsize
To: Siddharth Mishra <smish149@asu.edu>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Siddharth Mishra <brightprogrammer@asu.edu>,
 stable@vger.kernel.org
References: <20261102233041.310900-1-smish149@asu.edu>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <20261102233041.310900-1-smish149@asu.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/3 10:00, Siddharth Mishra 写道:
> From: Siddharth Mishra <brightprogrammer@asu.edu>
> 
> [BUG]
> Mounting an image whose super block has an invalid sectorsize (for
> example 4097) on a kernel with CONFIG_BTRFS_ASSERT=y triggers a BUG:
> 
>    BTRFS error (device loop0): invalid sectorsize 4097
>    assertion failed: is_power_of_2(blocksize) &&
>    blocksize >= BTRFS_MIN_BLOCKSIZE && blocksize <= BTRFS_MAX_BLOCKSIZE,
>    in fs/btrfs/fs.c:137
>    kernel BUG at fs/btrfs/fs.c:137!
>    Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>    RIP: 0010:btrfs_supported_blocksize.cold (fs/btrfs/fs.c:137)
>    Call Trace:
>     btrfs_validate_super (fs/btrfs/disk-io.c:2525)
>     open_ctree (fs/btrfs/disk-io.c:3507)
>     btrfs_get_tree.cold (fs/btrfs/super.c:2133)
>     vfs_get_tree (fs/super.c:1943)
>     fc_mount (fs/namespace.c:1282)
>     path_mount (fs/namespace.c:4337)
>     __x64_sys_mount (fs/namespace.c:4542)
> 
> [CAUSE]
> btrfs_validate_super() rejects the sectorsize because it is not a power
> of 2, but it does not stop there: it goes on to report all invalid
> fields.  The next check passes the same sectorsize to
> btrfs_supported_blocksize(), which requires a validated value and
> asserts it since commit d728f2e5f8a0 ("btrfs: simplify support block
> size check").
> 
> [FIX]
> Only check whether a sectorsize is supported after it passed the
> validity check.  An invalid sectorsize is still rejected with -EINVAL,
> and the misleading second message "sectorsize 4097 not yet supported"
> is no longer printed.
> 
> This bug was found by fuzzing. The cause was analysed and the fix was
> written with the help of an AI tool. Tested on btrfs for-next
> (d6f76ca0a70d) and on v7.4-rc1, with KASAN and CONFIG_BTRFS_ASSERT=y:
> without the fix, mounting the image hits the BUG above; with the fix,
> the mount fails with -EINVAL and only "invalid sectorsize 4097" is
> printed.
> A crafted image (22 KiB, xz) and a C reproducer are available on request.
> 
> Fixes: d728f2e5f8a0 ("btrfs: simplify support block size check")
> Cc: stable@vger.kernel.org # 6.18+
> Signed-off-by: Siddharth Mishra <brightprogrammer@asu.edu>
> ---
>   fs/btrfs/disk-io.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8e8fb942d..b348591f8 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2520,9 +2520,7 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
>   		     sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE)) {
>   		btrfs_err(fs_info, "invalid sectorsize %u", sectorsize);
>   		ret = -EINVAL;
> -	}
> -
> -	if (unlikely(!btrfs_supported_blocksize(sectorsize))) {
> +	} else if (unlikely(!btrfs_supported_blocksize(sectorsize))) {

If you want to change this, you should touch all callsites.
Not only this one, but every unlikely() branch to return immediately.

I do not like the ad-hoc fix just be cause you can trigger an ASSERT().
>   		btrfs_err(fs_info,
>   			"sectorsize %u not yet supported for page size %lu",
>   			sectorsize, PAGE_SIZE);
> 
> base-commit: d6f76ca0a70d0c814731394a625ff0dc1feb390e

