Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793997092;
	b=5ds9s+wh2tf36MZ9sa4avv8weMPy1b6D7RgOfSMXE0A0VNwBBouYVdexIF6tatjqOO0o
	 q1y5WiWgcn9D5MMf2BAsavoA/SEfr5DKigzoY3I0LWrccWnEDSAogD9CBCG7fu/yzoF4P
	 L5VkmzxiZGcY8P2JRKlC7mopnfXJ6QNsoXjbfsOQ7Sls5Z8f6rHh0hPecqZhhW3fa8JML
	 vqWV7RoaUQi0yW2NX6OUIBqU8MbhVT4whvbVSfS/qVjKsuVpO1M0EyIBifGKh+Z4R64vr
	 PswGkmCDrIjLKZxbNNsYzWHxlUdkVJ5VuT8XdZag13fpVzzbj5ayjiq+uRGEN8AJEfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793997092;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=4HyrTuXbst7br9sKPrZkGgpeMygeiy7Zv+e9Aez/n68=;
	b=VtqeD5PJZH+CPb117QkllJSsyc3EKK0P0g32bFwIWNTo2EnjN99aEJ1e9QpJuyMa2sM+
	 zeDwtcPtuvdMYdCDGe/XIckNTc0tEbXuWPSKNf+7aRMjHQqsmKx9qbUZRiHtuEH7VAfCa
	 619vt47WjtkzPGYTn1KxU9hNEKnB/y12iF0P+VS8hZlEQifdM4jFZzo0hljlAVffYjKrc
	 pMEGrrGkvarZ29Tqdi31CCYMgHwc/u6KotOcz5lQHuUFcpsB4608fW2MWGU8a0A1MCKAV
	 Z5CuwqOTnfSSKUq0GVHWPZX3OP+U7Cp8aMvxKzix+9sW/jPLl/aIfmSgHh2VQ+QsEaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=N1vkDgrp;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6B7606A32E
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 20:31:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A6B7606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=N1vkDgrp
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso11763235e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2026 12:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793997091; x=1794601891; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4HyrTuXbst7br9sKPrZkGgpeMygeiy7Zv+e9Aez/n68=;
        b=N1vkDgrpLaQ9xLrpsgl0rQ2gsKFKWXvc5hs/hI3K0WYl/rYitmtzT21QLf/eHO8SNY
         FHEuJKtgPQsE0lDQWfUgPbh7vh4jF4DjcoVGh3Pg7tA8kj/xO7C/3SLtwUetdDB0CfcR
         Wbo2O1AxPVN+RUgcGIXkMQUTyEgSxy4np9OV4BZ/7cJXl3pQjYCe9Y1LxTHSa//dvKid
         WgCOsKMBVSK3WuI8XGBhZtVzROvAMScab04zrcsc9LEm+r5pxXxgkUJWq6aDzOSIpDSf
         O+feNhDbru7WIWDtATogsL43clJaUhlJlfZbodVXhbcHTeRl80mwk+7zByWiS8RlFbo6
         +aug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793997091; x=1794601891;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4HyrTuXbst7br9sKPrZkGgpeMygeiy7Zv+e9Aez/n68=;
        b=j9FCrsg1o+oHEy17fJ/crl6nn6RrP9cv0bk/2ZjfE0lxqmMs4Y2FUA3LivoMMLEVCa
         BdJgvWiwmhrJSN3DUY9zaDMENbJv4psomzdpiVDf3F8xZ3r5IwCA0ww2x75xxIx0c33q
         Lr7GSewQIjVCijQBc+dr1l52feNISovIWs4nuQR+7vnAB16ayXXerD7g+kXmaNaeM141
         TGTEMAIOvTADlZ5vIweOLNGSexSZsT98Hj8Mttgltt5O0Z3IGba9wpW+KLbxAxHRb6JN
         p5Zla094XQ+XmARF/O3uFuE03tOLdN4HqlkCj3VPZ6W+17dzSk1pQSSY1kRSHo2fvu2x
         RMnQ==
X-Gm-Message-State: APuU4Z8v5GeIqRQ7yIuw+cnaodXvuA8rPDBec8/eMrToYEG0fQfkypJc
	CgayblTb5BImMHFavggT/qUFraIVDMwm6aOqVILupS/QKSxnpTPihdhsRG4RajuMSzs=
X-Gm-Gg: AYBFou2tYVHyWGC30lSos+/HXeGpQ41gVlAAJyTrCmUBCitOqvqRplXYp0EBXsHbiUb
	7sdIM4479NtWDSGB6F5BaASqzPC6jGiJp+HfrLK9i7uYjwMnMYYQ90O/3A3dJKubmjiIK8Xs/Qo
	YjL2wC/XbHL2RRkz+Jx68g03vk6EPIktSHb2Ak5rk2KWFu0C/L9K0MRagNFUfJamnAv9A7RAOZf
	H5gXVcquJLvPnrNwMX4de0ZX7wrk0b0kSrzSAkGyJg/xjj3alp5F72aIP9eKeMCFApYqkVI6gkB
	MlClfGs4qx9kU6NbVD0q1DeN00s4PDS/PWAS9Jb64CjKE4LzIKp7RfRazFaObezfUOt+2abwsju
	gINBnYJPNO/4MVIGqR5aTKBRn9AwscxUkctiTJs3X6HGqZwgy5rQS6VBl7DBO2W7c0hVFZe64oI
	poqRR7CX4uI0TjtiKpBlk+AGCtgOgWyhL2v1HFu0hcnd0uYiIzF4cFXqb52OZq7QYykVaJC1/Rt
	lcke/cRFUCkKEd2NKHKnKu+iJWmffjMnjQLpa+6HdzScHSRXvgA6xAg7BygBgmiuCRL7R2c/Rhd
	WB9EILbuWro00Guei3qI
X-Received: by 2002:a05:600c:1d0c:b0:4b2:612d:908c with SMTP id 5b1f17b1804b1-4b6df9beb91mr65943695e9.34.1793997090920;
        Fri, 06 Nov 2026 12:31:30 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b26294289dsm8635276c88.4.2026.11.06.12.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 12:31:29 -0800 (PST)
Message-ID: <a09d7471-111e-42fd-8ae8-42afce6df000@suse.com>
Date: Sat, 7 Nov 2026 07:01:23 +1030
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
Subject: Re: [PATCH v2 1/2] btrfs: tag tree block repair writes with REQ_META
To: socketpair@gmail.com, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261106-btrfs-sb-read-req-meta-v2-0-71c1afaf5c67@gmail.com>
 <20261106-btrfs-sb-read-req-meta-v2-1-71c1afaf5c67@gmail.com>
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
In-Reply-To: <20261106-btrfs-sb-read-req-meta-v2-1-71c1afaf5c67@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/7 04:03, Mark Korenberg via B4 Relay 写道:
> From: Mark Korenberg <socketpair@gmail.com>
> 
> When a tree block read finds a bad copy, btrfs_repair_eb_io_failure()
> rewrites it from a good one through btrfs_repair_bbio_failure().  That
> rewrite is a plain REQ_OP_WRITE | REQ_SYNC, while the read that found
> the bad copy and all other tree block writes carry REQ_META.
> 
> Tag it with REQ_META when the bbio belongs to the btree inode.
> 
> Signed-off-by: Mark Korenberg <socketpair@gmail.com>

This part looks fine to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/bio.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 2e12a6d7e16f..efbce4d549ff 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -951,7 +951,8 @@ int btrfs_repair_bbio_failure(struct btrfs_bio *bbio, const struct bvec_iter *or
>   	}
>   
>   	repair_bio = bio_alloc(smap.dev->bdev, max(1, length >> PAGE_SHIFT),
> -			       REQ_OP_WRITE | REQ_SYNC, GFP_NOFS);
> +			       REQ_OP_WRITE | REQ_SYNC |
> +			       (is_data_inode(inode) ? 0 : REQ_META), GFP_NOFS);
>   	repair_bio->bi_iter.bi_sector = smap.physical >> SECTOR_SHIFT;
>   	while (cur < length) {
>   		struct page *page = bio_iter_page(&bbio->bio, iter);
> 

