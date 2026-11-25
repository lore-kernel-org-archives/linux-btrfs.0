Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795637662;
	b=HkDf5D+t7KLusG6i615vG+V9jNv6tbcPBeayfI7vT/dO7gvHA+B58PTd9+1oGaB/WDAI
	 lTuuGTzUmIt9HGmM4+AQ3MQzmcxEOV2QB7FTiX2lveyd/UTC60I+kTt4duH4+BiP+nt/U
	 oI3ryLCa+qnwtQc7JLJ+sd5govtYeuutR3Sz6V27z+ztOcsqxBn6i+ACeBD7daGLSzyek
	 cW4Jbz/r7gX6RXtdK5AohlukJJfh/39hmItzFXWagI46bcmcesjdjjs0VBMv09dMhPkSK
	 CHzNVJYCNNJps6N5BQPEYR+3z0Kr2vHJWfs+2qOUSx2DxKjw7Mo0DZPZEosaxf/Uqqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795637662;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=CHzlAEKEhKAcoRx6ZR9OpUH0lTyUbeq8rOmcJLHcMYs=;
	b=h5tHm1tsSIvx9VSe1eDzRrwztVWMiodY0PAWLsh9Roajc9JO/UUpl28JVH9A9mPqlOIj
	 LVii8uPmsBSS+Hq/UBCSVTTqZlmOxiMk20O+XsDbGG4GlqtSlTCl5DP4rUndXTKQie4dx
	 PdF/W3exzrvGlOVarIGyaSfY6IolKBsNisZdwfORorqUyTkimzH76ade/76OAqLSJ9Chy
	 rdkB39cMySJohXYgQRKz9thv6Y1zObhKKci/Qg6PMu20oeYzKtL+gF2lqG51fsvYfu6oB
	 3GowXpLwaTE4PG8jK6eF+YiO1EGHHxw7IJMbHqO2xUTxGe9/jnB4aj1n8tZDD18Gx2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Tj9fkOAT;
	arc=none smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1F8606A321
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 20:14:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D1F8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Tj9fkOAT
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6bb06dc1fd5so3091174a12.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 12:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795637660; x=1796242460; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CHzlAEKEhKAcoRx6ZR9OpUH0lTyUbeq8rOmcJLHcMYs=;
        b=Tj9fkOAT57U5pJygKRYclP6qHGySV9wdNcw1q7fVZPA08+VtdimfLAaGp4cxOh1GZi
         jTaVi0JCNV5v/J33QcQ+UM9Xt/hmZv6ck3ADyFYfKsTHuvJyQ8HoLcHvVorfURN99jAr
         LIPpMf2KzPOPxGQnLNIlXeoze7bc5POWU2PkFdl6HbohxrFmKBv2wI11Z2+0SpJT1sg2
         Jzyf3bs7t/J3xGxivo6+De3+J4GDAeIcZBRnnFnxhH0ntloykUPCfToJ3g6EnxkPSSPb
         6yZiV/iXVOoVA22eeN1MC3IO3gToO7BMcv8NHlcwNsrLQi3ZbF5C7iBFO66D7vE7VMej
         GOOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795637660; x=1796242460;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CHzlAEKEhKAcoRx6ZR9OpUH0lTyUbeq8rOmcJLHcMYs=;
        b=YszzKBi+Sjh763pd4JASwHzhlJI3zkLNseL6yMlAaKsoojpGf1gfqaEtLKRFNUtNLR
         3dIqP2AShsgFCHGrKVOsRFZTJMsHdFU+XhmJh+Hl1iNQUiPyk2HRtNNwiD2WgQwCjS+u
         s/Irng3OMjWHHvUPHLcGLtAgc0Pjdr1ax0+NKN17I6Aziq52LeV8/pIfK79pBGTyV+nI
         JlN6qSvtdgvLe+Mdx6rQxZx/IwcLPLBkxoeK/9wGTG3Oy3BiYsJ2fAnDA8MqP1obhY/6
         q8LXeJKdWpLkd07bQ2K4JYMdc87Rc0d6mr8DaxsGx47dFtr5EAqxjyEc7wuIoZjkeyGc
         JtQw==
X-Forwarded-Encrypted: i=1; AL+hErHr7vx2Op8cPDMp5NhmCI+/eNZWHIveLJZ1WifUYNaATQLEG+4P/SnwHSRsJAph+AdfW9EXaxMu7tdW5w==@vger.kernel.org
X-Gm-Message-State: APuU4Z+AECkdkY99vNgMuJ+pR3zPOxt8fbSUwVlgU0hRuYY8PNvVcMUw
	F2BDi5Zgd9QfVOzHBVZPbVVuf7TJxQ5dE1Ht32AtSZ97K4vzHOuPy4IQaBqEG16Oss4=
X-Gm-Gg: AZFdTZdiOuOk9IufPZCBLJhLsLlu6UHWEhLWc5RWo4pA3kmFh3eUeAjIezJIb6H9dvq
	5csdRwKoFw+We1u0lijlbMki+Xm1hU4HOT/EbsHPPMEytd9h07vQRa1u2yN97o4QsFGjI3BUG3t
	Hl4T4cXHKLL6Tz9RmWwlVr8QvPDXJcTx5IgmrkROMGEFFupRjmD6N1GMEXmfHfF0bLXu8JPNyOT
	xrM4uICfya42taqLLzyv7tblW/9DKCS7mpus/VyW2qxkGEe/UaTOivwpQwy4VFcw1dpFQAjRzeJ
	DprrcUA14YMpHLLAiu7ZQUlbV5dmdMBoQsRZ4BJXAMJ07DvSuXkGh44yCUKFZPgljFSGyDqB6G+
	37umXB9qBY2ACRWCVmDwjGRi6e8YB1E4nSpSslltQhKRTNrAd+csOSXBB+Yz44omIduOxDyyeHJ
	Zo3WG4hUISM5f27z6Z7+MBsov0Ys3VmEGt6kMJYy7xzqTLiks0GmWOcVdk5Gkuf1u0wTSeM7N+p
	yvFSyGQsDdF5lLj97qOwHeJiDismyPiy4gon5KmaZkZVo+5KU3uH8N7HlhJiYUPgr3uaHtZI6Sb
	BdqYVeHEhLsXqyYs/hI/8k6R/Qzd+mZgZk3IihIJb38=
X-Received: by 2002:a05:6402:1941:b0:6ba:7b46:78c3 with SMTP id 4fb4d7f45d1cf-6ba7b46833cmr10286360a12.22.1795637659120;
        Wed, 25 Nov 2026 12:14:19 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0dc13fsm92440295ad.29.2026.11.25.12.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 12:14:18 -0800 (PST)
Message-ID: <56a63ebc-1d33-425d-a11f-6d7c73e820be@suse.com>
Date: Thu, 26 Nov 2026 06:44:11 +1030
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
Subject: Re: [PATCH 5/6] fs: btrfs: Remove the unused dev.c
To: Josef Schlehofer <pepe.schlehofer@gmail.com>,
 u-boot@lists.u-boot-project.org
Cc: Tom Rini <trini@konsulko.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Bradley Morgan <bradley.morgan@linux.dev>, linux-btrfs@vger.kernel.org,
 =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>
References: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
 <20261125124259.95636-6-pepe.schlehofer@gmail.com>
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
In-Reply-To: <20261125124259.95636-6-pepe.schlehofer@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/25 23:12, Josef Schlehofer 写道:
> Nothing uses btrfs_devread(), btrfs_blk_desc or btrfs_part_info, which
> are all that fs/btrfs/dev.c defines. On 32-bit PowerPC, GCC turns the
> u64 '%' in btrfs_devread() into a call to __umoddi3(), which U-Boot's
> private libgcc does not provide.
> 
> Remove the file.
> 
> Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
> Cc: Marek Behún <kabel@kernel.org>
> Cc: Qu Wenruo <wqu@suse.com>
> Cc: Tom Rini <trini@konsulko.com>

The removal looks fine to me, however since there are only 
__btrfs_devread() callers, it would make more sense to rename 
__btrfs_devread() to btrfs_devread().

Thanks,
Qu
> ---
>   fs/btrfs/Makefile |  2 +-
>   fs/btrfs/dev.c    | 25 -------------------------
>   2 files changed, 1 insertion(+), 26 deletions(-)
>   delete mode 100644 fs/btrfs/dev.c
> 
> diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
> index 31b426d572a..79d96c6e0ca 100644
> --- a/fs/btrfs/Makefile
> +++ b/fs/btrfs/Makefile
> @@ -2,6 +2,6 @@
>   #
>   # 2017 Marek Behún, CZ.NIC, kabel@kernel.org
>   
> -obj-y := btrfs.o compression.o ctree.o dev.o dir-item.o \
> +obj-y := btrfs.o compression.o ctree.o dir-item.o \
>   	extent-io.o inode.o subvolume.o crypto/hash.o disk-io.o \
>   	common/rbtree-utils.o extent-cache.o volumes.o root-tree.o
> diff --git a/fs/btrfs/dev.c b/fs/btrfs/dev.c
> deleted file mode 100644
> index e27a032c9f6..00000000000
> --- a/fs/btrfs/dev.c
> +++ /dev/null
> @@ -1,25 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0+
> -/*
> - * BTRFS filesystem implementation for U-Boot
> - *
> - * 2017 Marek Behún, CZ.NIC, kabel@kernel.org
> - */
> -
> -#include <blk.h>
> -#include <compiler.h>
> -#include <fs_internal.h>
> -
> -struct blk_desc *btrfs_blk_desc;
> -struct disk_partition *btrfs_part_info;
> -
> -int btrfs_devread(u64 address, int byte_len, void *buf)
> -{
> -	lbaint_t sector;
> -	int byte_offset;
> -
> -	sector = address >> btrfs_blk_desc->log2blksz;
> -	byte_offset = address % btrfs_blk_desc->blksz;
> -
> -	return fs_devread(btrfs_blk_desc, btrfs_part_info, sector, byte_offset,
> -			  byte_len, buf);
> -}

