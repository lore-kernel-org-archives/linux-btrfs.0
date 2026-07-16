Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E9841B8E2
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 11:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784201836; cv=none; b=XpdhzhNq4GNp1vl2GC+SnB/KgcCqI1YTJDNmIRNv8xF3lo9r3NPAsT1kUAIkEl++rFNFio1hHf6SD0Tu0rLukxuDe6/8LUpFbK1djF8Zmn7pxAssLfdAiASMGftEwrka6M2DcXkmu7lPQLmlO7K4/0FmfLrfBugY6wiX6/VRe7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784201836; c=relaxed/simple;
	bh=riLjfX87aaTrkVnGGKoaj6TZJx4KATQ8lmB8wS4Tfnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d1ZbGKj5E2zEXOOlLda1U7gIAfrEAtuWDtibP6f7cAi9LVBAZ4uIwCJ+ofUYRUiHFmMqJAz/cvM4AZDEThMgnbgs/ojVCinR+MNEYkXK1Cs9DjHztkTLRijS4DnSzEWrFZwhwLay34YCpAhOMKd5y4CdbZ6OkBVNCg0ZIuXcTiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=SSX8zHxg; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="SSX8zHxg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784201829; x=1784806629; i=quwenruo.btrfs@gmx.com;
	bh=ieu6WT5y0g5MVCz8t09SpluI1H0zG/eh7FzyYEWY59w=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=SSX8zHxgmhjgFcDgw7LoKVBzYVnWMwya73C/uB16L20AwjTG9F3UvbmM8t+Rd1TH
	 n67OLbJhDn4hzbgQBSaHHN7tNdLzYNYmYRldWIjfKJu7muPwWeNF7xaRnaey5ngw9
	 vxHibRV25bFaMdtJ0H8oFQ5Gfm0rdHbyfUKBSCghe15gVSDvfvDLWYyCz42cAjVnl
	 1WjNw70er71xiPVCiEQFsyJ4A6YaPdGa4K954NXUH6r4n0Y8bk0smjnwsQi+p0XbY
	 tM1eMVDla34qVLbMncGK1AfH6ptwhirs9wWMny31LSqcE4vQSY85NyyZqbF5x+ClV
	 mLK6TtmaiLwqki19bA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MCbIn-1wtzAV1ngx-0066Gr; Thu, 16
 Jul 2026 13:37:09 +0200
Message-ID: <d92523f8-38c1-4b84-b4e1-82288f8de3fa@gmx.com>
Date: Thu, 16 Jul 2026 21:07:05 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs-progs: zoned: open host-managed devices with
 O_DIRECT for read-only
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>
References: <20260716112819.1315467-1-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20260716112819.1315467-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EvikhHmT6JG98fx8/ezbaLLEZGtO/+ySivB+IwgHkaMpqDeJx51
 nf8md6bZ42EX/H8aCpqHW1JsKVp/VVlDhbEDGQWglE29i/aQZ3T2+doqmaXdJq4LmzYb7KI
 AgzRbvEzcQLQB7ii0hndeJOaHYO3Nv0ozAX1kOfyMgCYMizhrPI4AEbglzAB666z2xr9bPr
 kDu5W/cDTakIXrakZxBCA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:eezQCts9tXM=;DN3L9MhWBOtJDtTK3c/qJ4F76Bp
 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
 kONeKqgPZc934oGtQaYUM



=E5=9C=A8 2026/7/16 20:58, Johannes Thumshirn =E5=86=99=E9=81=93:
> On host-managed zoned block devices the page cache cannot be used for
> writing to the device because it does not guarantee ordering, therefore
> direct I/O is used to write any on-disk data structures.
>=20
> But reading in btrfs-progs is still performed using buffered I/O. This
> mix of direct and buffered I/O can lead to stale page cache entries
> being handed off to btrfs-progs and tools like "btrfs check" can report
> spurious errors like:
>=20
> 	checksum verify failed on <bytenr> wanted 0x00000000 found 0xb6bde3e4
>=20
> even though both copies are intact on disk.
>=20
> Drop the O_RDWR condition so host-managed zoned devices always use
> O_DIRECT, matching btrfstune.
>=20
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Changes to v1:
> - reworded commit message
>=20
>   kernel-shared/disk-io.c | 2 +-
>   kernel-shared/volumes.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel-shared/disk-io.c b/kernel-shared/disk-io.c
> index 7f87e567f0b1..8b9c6dcac967 100644
> --- a/kernel-shared/disk-io.c
> +++ b/kernel-shared/disk-io.c
> @@ -1722,7 +1722,7 @@ struct btrfs_fs_info *open_ctree_fs_info(struct op=
en_ctree_args *oca)
>   	if (!(oca->flags & OPEN_CTREE_WRITES))
>   		oflags =3D O_RDONLY;
>=20
> -	if ((oflags & O_RDWR) && zoned_model(oca->filename) =3D=3D ZONED_HOST_=
MANAGED)
> +	if (zoned_model(oca->filename) =3D=3D ZONED_HOST_MANAGED)
>   		oflags |=3D O_DIRECT;
>=20
>   	fp =3D open(oca->filename, oflags);
> diff --git a/kernel-shared/volumes.c b/kernel-shared/volumes.c
> index f35b59bcc20e..e2b6708ad872 100644
> --- a/kernel-shared/volumes.c
> +++ b/kernel-shared/volumes.c
> @@ -697,7 +697,7 @@ int btrfs_open_devices(struct btrfs_fs_info *fs_info=
,
>   			continue;
>   		}
>=20
> -		if ((flags & O_RDWR) && zoned_model(device->name) =3D=3D ZONED_HOST_M=
ANAGED)
> +		if (zoned_model(device->name) =3D=3D ZONED_HOST_MANAGED)
>   			flags |=3D O_DIRECT;
>=20
>   		fd =3D open(device->name, flags);
> --
> 2.54.0
>=20
>=20

