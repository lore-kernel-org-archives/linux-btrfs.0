Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98153F8ED8;
	Mon,  7 Sep 2026 06:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763009; cv=none; b=FFEhSyJt3W74lIhFuunZr8TT9qwIsynBLEVZ/assQaPSNve+Lhs65WOor5lzgMstpRzmRbWrS6IYM64XZwrhTOOlapPzj1sbr5sCRpBwN76CkPQ8JL2Gt0YCXG7gJ+LFeV+ag9v0yPs2fiAsIqXADVtKPZ80DnhZ55KfEeOGRbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763009; c=relaxed/simple;
	bh=mFatGbPVM5M40P/+V/w1PV/XJ9AkgUOZKM3wx5Lbcfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YqQiJR/a4Tsn1FEnQzkNTanhaFFJJ3URlYY3nBkzSU3+asT/q2yTrjcJZH6IdFbX5XM+Ii5hoUZs10ZD3W3mQHlntK+rh+vP7eeG0OKLBSr22VjwF6vZ86P3gLKodkVtanDzSnjWVsw/r487o88RheA13nSFwR7UdM5gulGmu1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=fk8nHXDm; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="fk8nHXDm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788762995; x=1789367795; i=quwenruo.btrfs@gmx.com;
	bh=3A6a2iL2xH2CH/06nEahMzT6Uh/qlvdkIE2E810HsaE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=fk8nHXDm+59STyzOh7Pwbvx6L/+QhsPG/zJOgUD0Po+P5B1tU3kadip4w4cGQZ6I
	 5SmwQbZ3kE7gzpgNGI2gmJZpkDgp0NcD1N3x2NVAhPYIlCbQULYoB7oqlqbvqS/Xt
	 DygUirWoQlc6hyzEJJQg/KS50+UR4cKXuxxwq94kWsnJYZSuzDaOD2ktLNv3SgXlB
	 dAwuMaQzgKxmzB0xC3x7giU54Tdup5C24xwZh0IZzxmSu4Sd1ECaIvn5V2Fur5wbE
	 e4dTCiCIwZfuIyIKX7tpWTj+2sYzI7ze1qyzb0xbgZcvFoOxIs63qniHNyszem/s4
	 k8vOtmscbiUequ/GBw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MbivM-1wQYBQ0ydi-00b4lY; Mon, 07
 Sep 2026 08:36:34 +0200
Message-ID: <0e8d396f-d72a-4cd8-b3d4-890917802c47@gmx.com>
Date: Mon, 7 Sep 2026 16:06:29 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] btrfs: convert btrfs_compr_pool_scan() to use
 folios
To: Tal Zussman <tz2294@columbia.edu>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
 <20260906-btrfs-folio-conversions-v1-4-834b9d7b06f5@columbia.edu>
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
In-Reply-To: <20260906-btrfs-folio-conversions-v1-4-834b9d7b06f5@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:j5wgqmmosV091tR/FML4dT9ukvPCNoHWUZHPHhAixW7IhhJC2XC
 WN1ykh7zxef/VijdXSmbjK9KPWMnYNVrYljnuqF4kX7zy5T6M177xNS5iqIzybLbsDkRles
 ecg43pJhqpaniGiMbAIMGTanxO4GCud0ns7mkwtmJGM4XHM91d8JXsAjBaInQJzGIBQA2Tw
 QDrFshN93yTh0QZwtOBLA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ScQC5WsxLGs=;639eMfumIXZR22V9EvKEKAK3TsZ
 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



=E5=9C=A8 2026/9/7 07:59, Tal Zussman =E5=86=99=E9=81=93:
> The compression pool holds order-0 folios, but btrfs_compr_pool_scan()
> walks it as struct page through page->lru. Walk it as folios, matching
> the other compression pool functions. This removes the last use of
> page->lru in btrfs and saves a call to compound_head() per freed
> folio.
>=20
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/compression.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index c62b5148d5ac..979b2ffbd8fc 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -168,10 +168,10 @@ static unsigned long btrfs_compr_pool_scan(struct =
shrinker *sh, struct shrink_co
>   	spin_unlock(&compr_pool.lock);
>  =20
>   	list_for_each_safe(tmp, next, &remove) {
> -		struct page *page =3D list_entry(tmp, struct page, lru);
> +		struct folio *folio =3D list_entry(tmp, struct folio, lru);
>  =20
> -		ASSERT(page_ref_count(page) =3D=3D 1);
> -		put_page(page);
> +		ASSERT(folio_ref_count(folio) =3D=3D 1);
> +		folio_put(folio);
>   	}
>  =20
>   	return freed;
>=20

