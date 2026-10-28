Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793223014;
	b=H07/ogo/UWBn4h/imeWiV4KUgUiVU/jIV7tqj7LqxQQArUAM20tEYCrkzIF71p9SQ6qL
	 LY1Mdepoydg8wrpLdjPh/pbQTVMlkoNIQeZKcU891Ry7Ed2+eOc1lcM8tQJ5F7IE80FQk
	 Gx+OpouqOX4Ssx0yOb9h6Bev+OSCLEsbpKlZuxGi4wcMVrKYE5gMX+jHFLU7/+sbCk6Az
	 6i52xlO9Gsp+jqIKhagTD1ALZLR0JkbhF5UfXIIRMc2qe8WyDqYZITXIjBwpCbXy2W2SL
	 bBjkK2RAmsdiCvnd0o6KEISsbpy9Jj7yeLVnOdIsDUzeFX1XNF3Wbk7PQcmtXpCf+Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793223014;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=k6NKEhRpgnQ/t1wv9GeOUJo/LkdrhgjkTUxIizCdmdk=;
	b=gjmlquqnkuFxZ/AhSLIQ0I/p9ijQSJM5RXKMeW4lZEhmiRlF2lxZICxIwDYlX1Ai+NT7
	 QCDGsQ8mucTnK8Vzdwdrq7xSKrfmqOFdlZ9gLPAirJFgaK6reW38E9AHbVXlVhAuvHa/0
	 BHQNtI//S531cFlXi2nUY4CF/0dZzm+0CHoeegYSmhVXrSv0KnLuzUBjLE7cNVXd41MlV
	 fqvBT/WRRuUNtFMhRyrs8ze12GEcvWMyPTeg3pZolurIBpimg499zgiaXIFv77aFWnUZk
	 AvDN2LA6atI42E2d6b4WgL1/buBOJZF1JQOv/+7mEuw4tX1lwLcS2WgUkOFIuzJ0Ghg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=V5HPXscF;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A493C606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 21:30:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A493C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=V5HPXscF
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a215e64962so16391815e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 14:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793223012; x=1793827812; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=k6NKEhRpgnQ/t1wv9GeOUJo/LkdrhgjkTUxIizCdmdk=;
        b=V5HPXscFzvjZ98kBkT1vTSTZPqkMEPRKV36YgDBdyY6t9SktEjAldUZagGvdID2+6H
         LeAwAattyjOgb1cEELwAxzla83kEPrsJ16iTURvaUYxnDsOFvrkO4ealH+uA0/Wa5AUX
         S3U8LdYa2u/xxO2xMyBS4OPbcWEkDlMHi5VDhX2DWGr6o8GLmTt3ILJEXnjJB5y27PQX
         K9MZFS4WvznTa+JJPPWSlx4XiK3okHujJ4QjRShHJT89+nUGMxU1j+Ce9BmKH1kvB6RG
         2YOuR6NJ8o4HG5QEDG3F2EvoboS2Na0/qWpPJhecE/MGLa1wIspfOreWnHUXFJeQxsg9
         +vLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793223012; x=1793827812;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k6NKEhRpgnQ/t1wv9GeOUJo/LkdrhgjkTUxIizCdmdk=;
        b=dE0rC6gYw3PdAUHExb/hWzdQtUcRfY2n3HiiGJCjaD+wfLZjskz51rcGB0jiLaz6/N
         QnHtfYzKhJ93GHVL2Yd88l/8v91MFrIPsI1hLyzNsvKRfrcWJYQPLMFM3VngyrJQ/Z43
         +JNbakLwfZO2KM3nDhyYrz+SKQTWF+bpEXMdeYVU3D1Vw8BzPBSe/9Va6K0tjp8o/rYM
         BBSC83nXneQH90aQ9ieC1DVNNF1+JNVjs1Da4/9rahdjRKjPZjsIqqr8J35eqwxfMiT8
         5UG2P+ZbD32IWnH8t3wvomj8YmwFUWjGDP+ewBdJZpeSYHEuMEjW9NrxGJY5Xpn1FeWs
         3QDg==
X-Forwarded-Encrypted: i=1; AKwUvBw2Gr+8zICUVr19Ns17kIRDgUwJdssLu/wZcmtyxWl6sHkqlBLj9eJZBVBi7vqdS1gqN4f4B/E/A1qYrw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLpO3X6KjbBKmYuEjQhvJZ6umxcZ8IzNT947nw833I+kr1mHTrX
	vg5RWMJ80gBwBT3EX4JaZm7qjQz8aix9m2TGPOsUvcdVLFjyuehD2KH1PJT1kvAu5rTrzZZ7/Mw
	dCfWytAvYbg==
X-Gm-Gg: AYBFou06HOiwYdqmSRojUThsua8yf1qZeCpM0PNJ5XAkwSVowXljn1DxIG9mepWkVsG
	R8KqT5VhESkRZ3jytl8SlKhyCcLC+jbqO7NTsb9ZN0dhi3qOB4CIyV9Zx63ysH02X6g0rkThz8A
	LOAqXpMHJrcCCiFzR46ZXgiXv3+V/sEn+baLq2ZlIFiAL3HZ5bsAckdQke2UfY0axEw3dfGATi0
	lAeN21B4cmKRdNo6YueolpsCoHNKfwen5LMDkDsBUO31RZ4xqW4xRvz5Sm2QrXrT3AZEf1Ld783
	R8TtGdD02/+x4ka6tp6tPy75Oq2FYNKiXA8qoB6AwuGzcwiKYe+3I6lXKL1JtS7WLCTrkm69F8n
	Hrf0C1Vm39cMORUOehtM231d8B+hdGJEiV6c7FLSCT56UbZOK/acLZe/ZgHkXWohN8gjBm1/W/g
	3JDSfYGmlRmPXH2mooBJtkH0nYRsgkdjLK07VOndX4JAAPKzdpSuJd4jrDcGxlMH1kTx/gE6XtT
	S6zsLlYZg0SKtYxZWoLo0N85K2mk0WRd031hfmXJnlJtP1o+8n/twa4mBVspslKcJzFPZd5rPz8
	vPAgrMm4nIotJMJYgQBTbw==
X-Received: by 2002:a05:600c:1c17:b0:4a3:59c9:a756 with SMTP id 5b1f17b1804b1-4a965dd3247mr84799675e9.6.1793223011668;
        Wed, 28 Oct 2026 14:30:11 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e7d429fsm1049632a91.2.2026.10.28.14.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 14:30:10 -0700 (PDT)
Message-ID: <e192962b-4a9c-49fe-ae6f-4015c74391af@suse.com>
Date: Thu, 29 Oct 2026 08:00:06 +1030
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
Subject: Re: [PATCH] btrfs: zstd: pass fs_info to btrfs_warn() on failure to
 allocate workspace manager
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <10b9e2d858daf0143a1b7f200989a59857272389.1793205219.git.fdmanana@suse.com>
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
In-Reply-To: <10b9e2d858daf0143a1b7f200989a59857272389.1793205219.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/29 03:03, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The workspace manager is per filesystem and we have access to the fs_info
> structure of the filesystem in zstd_alloc_workspace_manager(), so pass it
> to the btrfs_warn() call so that we get a better log message (including
> the device, state, etc).
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/zstd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index cc92d0b1b948..9235aa7b922e 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -200,7 +200,7 @@ int zstd_alloc_workspace_manager(struct btrfs_fs_info *fs_info)
>   
>   	ws = zstd_alloc_workspace(fs_info, ZSTD_BTRFS_MAX_LEVEL);
>   	if (IS_ERR(ws)) {
> -		btrfs_warn(NULL, "cannot preallocate zstd compression workspace");
> +		btrfs_warn(fs_info, "cannot preallocate zstd compression workspace");
>   	} else {
>   		set_bit(ZSTD_BTRFS_MAX_LEVEL - 1, &zwsm->active_map);
>   		list_add(ws, &zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1]);

