Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6932B403EB9;
	Mon,  7 Sep 2026 06:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763504; cv=none; b=nHsXoO7NhybPzqtd41csLut+O4JiZignGoLsbjFL9Gksa3HTV5s0W/63OajHHgje8sDsYZ7PEGtEYo3mvbQcX1irqbJx8yURyOSyajZBnjWFYIpgifQLr+8EartZioR9tYLQ00yiYKq0F4TrX8feeeGr6tsaCvkOJb0HkK+e6mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763504; c=relaxed/simple;
	bh=MWtT9TRkOq2y2VB3LpkD7k+jWywsBiB6JWqB7k3NxJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HgSuyoI2woEI5v7IkBwGK6dlq+jY6xcAaVRNucnj0+/U7c7fHZ6oBHae/x4SMHB9JPfpkfKSVcrp2Sm4OD6bID63youR7QRLAdazV1cfIbhtEnzzo356MhrGBakFg/bhiDvb9MzuDpNobA8PXlAtICVlM9cnR18iBjSeoaWTds4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=hIv62FoN; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="hIv62FoN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788763500; x=1789368300; i=quwenruo.btrfs@gmx.com;
	bh=ho+g6EHecWRn5KcG+LFmKZflf3Rx3rNFpNIch+3nSaE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hIv62FoN32tDOzZKHu1r1Kq2Wq5vHDBXBPaodS5KMVtbhU0lKymmifK4P8bDtTtX
	 JEnza7vJ33HlEtSaToUCmMO7l7Xp4wuSIn+Fvn2VMQ8GuKa1tiZ2ri9hmU2V4b/R/
	 MYTIrtSe+ScoZskKu4u0M/P4OLvQK12+6ZegSVE0DgG1+mt7XkgH1u56Xat+IbXfL
	 P1QIAtdffdwDb7XtRoBmSAbdGrRPer+dObcBInBLHKNBEVSfiz+F2eBf3UMaEMHg9
	 U3gka2/3ky6LWEE9tzXL1hI70sKKVcBT0IQwHknFYlfOeLjyftAh0dAUDFC+IEf6O
	 e1/4KTvFlApXp0+gHg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MxlzI-1wdf3F2vni-00yRGT; Mon, 07
 Sep 2026 08:45:00 +0200
Message-ID: <25b9ca20-38cb-43ac-851e-0d0ac60df9cd@gmx.com>
Date: Mon, 7 Sep 2026 16:14:55 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] btrfs: fix stale function references in compression
 comments
To: Tal Zussman <tz2294@columbia.edu>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
 <20260906-btrfs-folio-conversions-v1-6-834b9d7b06f5@columbia.edu>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <20260906-btrfs-folio-conversions-v1-6-834b9d7b06f5@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:WxiiFlHqV106OtdXIAs0+sLgUmhv7Y3OoKkO7CKbA1wN/Ubsyhv
 S03YUINXxBIEcNoc3eXUHri2inZ5aThPptAhb9Da3wjDlxQWnuT4W5g0mX/h+c3RrQoVF/L
 uMvQcMZQFjAzZVTYBBnztm1YwQYeUGEOElOj55HNpV+O7DNKMgY1UPcQA/7T1A2JklIJfgL
 HLrRuXPC7TXf/dSoy92qw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dcmIBpkc8SA=;GHA6xdv6W+ojGzUfs+1zKtdihSt
 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



=E5=9C=A8 2026/9/7 07:59, Tal Zussman =E5=86=99=E9=81=93:
> add_ra_bio_pages() was renamed to add_ra_bio_folios(), and
> btrfs_compress_filemap_get_folio() wraps filemap_get_folio(), not
> find_get_page(). Update the comments accordingly.
>=20
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/compression.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index fa8b92592321..20169d028961 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -431,7 +431,7 @@ static noinline int add_ra_bio_folios(struct inode *=
inode, u64 compressed_end,
>   		}
>  =20
>   		/*
> -		 * Since add_ra_bio_pages() is always speculative, suppress
> +		 * Since add_ra_bio_folios() is always speculative, suppress
>   		 * allocation warnings.
>   		 */
>   		masked_constraint_gfp =3D mapping_gfp_constraint(mapping, constraint=
_gfp);
> @@ -960,7 +960,7 @@ bool btrfs_compress_level_valid(unsigned int type, i=
nt level)
>   	return levels->min_level <=3D level && level <=3D levels->max_level;
>   }
>  =20
> -/* Wrapper around find_get_page(), with extra error message. */
> +/* Wrapper around filemap_get_folio(), with extra error message. */
>   int btrfs_compress_filemap_get_folio(struct address_space *mapping, u6=
4 start,
>   				     struct folio **in_folio_ret)
>   {
>=20

