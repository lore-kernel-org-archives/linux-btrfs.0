Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793049168;
	b=4ZNWufi7on87fssOcJ8hccLcR/5rRXAMSq3vKvAYk7o0CVo0gFdvDQH9Q1EumlP6ooQH
	 hZ5Q5pi9dl8DDqUHGQgNYpbSMHROQ/K9/dCTx0yc7qUEhOTDFmH0Vaf6NfgzCmqJfPZyv
	 VS1NeaCWynfFQaibx/AvJUO0Blk5UggVFumaHPOBWBO6D5RE1PQfQour5MB5k1+S4qz5c
	 HjW7B4/1NltmM21vCvM3+XuVjrbZCnKy8Shfwh08feZrq465d+xOtLx0WlGgjDoNMh1S2
	 lWlO+P/MMYyNqUohDra7RO1Zq6ZMhXFK0NsCrm46KPWwOv+9ufHUfZ5sVXW1YpOcStg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793049168;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Ob/G/cZqfDeP4+ed/iJ8tLZrAN4vU1mQnqkMavM5Kmg=;
	b=dMEhW570in5eN5iOaqYVnCAw5AqXPKkiRGb8b5Tp3Iu4xtbaxRLJkgPqOkQiut+ROQAI
	 rOugzV2PeEPeYOgDkbu2zodiLB06Ag67Auvvewu0SoNJxVUk95Qum1x8C+u6iz+kOanNJ
	 zGkKDRfAc/EokTQKqWA2c+6qMZGrdnCY/wwVD6Eza6Fa0RAkVje8VroH+F6D5jWjk/n6g
	 Cg7BHBVZ1+icKrcyF8TfMHp2l724ucXE7GFbMwaZQqrfaSqJZQYHvqXo5h9Aot4FnPjug
	 xxslfyO7EdC45u5uBUFaHA2Gbu9gmFdU7msdqiGeb/J0QdzKhbFJRlZXY2Aex3iJ11A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=fouuTf+V;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA88C606A31D
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 21:12:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA88C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=fouuTf+V
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so23616665e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 14:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793049166; x=1793653966; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ob/G/cZqfDeP4+ed/iJ8tLZrAN4vU1mQnqkMavM5Kmg=;
        b=fouuTf+VRjvvNUu6CeOr+M7KtmpXubOlq/fabzul3/Eru7GYcQVBqOcvih0caAolNF
         yY6vUDXwlV/zWPiHB782lF2tz9cY+5lqjC5NdOLw51vgktHkAW84Vb6L0NUwyKtY9Glj
         7kzQyw5Q1aaBoXhaM/GihgGoU7DjHbkCW0sj2P9RJVpT1fXM3jHoA1whAlFJHRXx5UOU
         6GlEu/tmvRM0yTNOXWh/ZwF0BJCg0ut4v89o6BHlEKeYr57cMD5J0hqgAkfMgW2GUWhz
         jVjwBsGOlD7TI23Tf79CxtV0jrmpVA+VV7kqHnUa8DiNvyj804Gqt8qYayDqVpwV9rGg
         8Biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793049166; x=1793653966;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ob/G/cZqfDeP4+ed/iJ8tLZrAN4vU1mQnqkMavM5Kmg=;
        b=Lvs/e2ZFVLvsXvfU3TAPaHJKFDUPO6WLtjoImBthIr16ULjCyOgmCTHPogM30CBGzz
         MvbD/KEZnHlF3EumAhQWv2WabqglHxpHTxZNAO338haLzZvAnYB2f+M1b8zLtiHIAnUN
         8F9djRYvnFl0EK0aXF9MLAiE15OzBmmnCGywp+2ul9ACUHBVWwB/vP2LtNz5aON5QtQE
         bNLTB+CUoRUdfNerWXvCncF/tXQnxl47zY/X5/M9cRDQyZzfnednRySY76KdZqoCxgvD
         fBUMYNuPjp3nMHg28NVwz9g/6vVfquu+GKjBCBVPuHI55sBhRPkpKugSswS4D/QCIwM2
         60Dg==
X-Forwarded-Encrypted: i=1; AKwUvByJbgAEShaubUCoUkLBoa9ftrW1gVeh+GpKqd3isz1un6rSGJ7xGb1F7nvRDteNSh+weCVDmYnN+ck+kQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJwdhdbxALqsV6bodLR5/qkygAm64F9j+a11cunuYqLIIN2o3pV
	hGzkU4EL/djOhfbLU79JXjGJvmKddzdB1k1kAaYgnU4cd8W6Z9RQPp+4lzL01uRiQeZfQ9NUQzl
	pxuxhucw=
X-Gm-Gg: AYBFou1Bqp2dINLrq/M5/Ad1VLRovmBNQmpbMECwG1stZtllvUCHnMF5SNke9D1rOeW
	3VkoWkVTbc7Qmzb22s/9JoCqTFsjM1XiTHenRsIlYrMe9n8Bh1w8M+acDfIN0lL01WeSyowr7m0
	T/eQFphpFJ/z92QimM0mFhAWt6UIBt/01Tc9KIfDOTk8P4zVKKk6kXyC7tZYJkoXWNBQxGGvh68
	6vGAJlHb/JQFU2ikSu3uSNsHr6cgTDpseGTEsf8xb5cSJblCT39y4ipBE+kxEYnl+BNRPSjTYu/
	rAFQGk6DnSBm0gK0E9z8EaZ7v5dTPQ+VT35gX0HTfjEn46s4oIFDx60O/ADyx25Fyewi/UZYU0w
	DOCVjPZOrJyEP24yMaYcWmskWMDMo+6mdXIHC+Tm+DbLVRvWxysmMB/3qACiWb87reTT/52VFss
	Ipb690eqcW4wPvcGdWDwlK35Bc1DpUMwDDYu3gzwXHA15sAEK/Esc0gJ5L+E5XDxkUT8BNlutKe
	m5EjhtTg7ZH9Q221uy7ihziB971gHYn6LFPJSYZN/nv48WmTeynHAaRfro5AzMPojP3NQ==
X-Received: by 2002:a05:600c:138b:b0:4a1:e7ce:10a4 with SMTP id 5b1f17b1804b1-4a35acafcfbmr147841755e9.29.1793049166131;
        Mon, 26 Oct 2026 14:12:46 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae406519fesm825649a91.12.2026.10.26.14.12.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 14:12:45 -0700 (PDT)
Message-ID: <e724bacc-cd99-4f29-a58f-590988f236c4@suse.com>
Date: Tue, 27 Oct 2026 07:42:41 +1030
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
Subject: Re: [PATCH] btrfs: lzo: use memcpy_to_folio() in
 copy_compressed_data_to_bio()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <2f15acc9dd04f6a3ea6d0895f9e47ff20886df7f.1793036279.git.fdmanana@suse.com>
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
In-Reply-To: <2f15acc9dd04f6a3ea6d0895f9e47ff20886df7f.1793036279.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/27 04:09, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We are manually mapping the folio, copying to it with memcpy() and then
> unmapping, but this can all simply be done with memcpy_to_folio()  that
> is provided by the MM layer. So use memcpy_to_folio() instead.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu> ---
>   fs/btrfs/lzo.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index 0b2d9a825543..00d3dffa1657 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -234,9 +234,8 @@ static int copy_compressed_data_to_bio(struct btrfs_fs_info *fs_info,
>   				return -ENOMEM;
>   		}
>   
> -		kaddr = kmap_local_folio(*out_folio, foffset);
> -		memcpy(kaddr, compressed_data + *total_out - copy_start, copy_len);
> -		kunmap_local(kaddr);
> +		memcpy_to_folio(*out_folio, foffset,
> +				compressed_data + *total_out - copy_start, copy_len);
>   		ret = write_and_queue_folio(out_bio, out_folio, total_out, copy_len);
>   		if (ret < 0)
>   			return ret;

