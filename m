Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D600B1AA1F4
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 22:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792188732; cv=none; b=EtgRbN52BI8bDa/7HDJqQN5Tqt0SZM7ZMuRrbO8oYwr2rNFWEDdChJotmbdmQCvuU68LaiygilXfZMyOHBW1FrnZzoD0405TUK/A29PxizqG/PNFxRqQWwyHCxBRnh5dlqqMwJDIH0L7UbDQ4NdUo095hKc6dkfhMUAFaqvXUw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792188732; c=relaxed/simple;
	bh=mgwv/XY7fjXELhaREWeynCGvairRogto+bGeI2K6DU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gHUv38rXRi3LRRJiU/xFeS4BbGnu5/7BSNrH9+070QjUFYYKvsPHFSinugopXQydiPJ/WRlWZqLzQ6O43of/ZfitqGzEHv2kuQ3moB54FnPrtZWnSNyuaMbFfYgHQV0Ks52w8dg+XL0BEtkL7lTWDGbo10nl0iCvcTz1Y8+5O0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=lrCZIzOA; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="lrCZIzOA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792188728; x=1792793528; i=quwenruo.btrfs@gmx.com;
	bh=Br2LEsTrsqyUW0CGCeb4mr4LACSsQcykV/HS8Hb+BIM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=lrCZIzOAKg8SSq7ftAprKwVSjPR07yJaiqPEghPyyF7YeYk1hutffHisyIOQFwtS
	 5LzIQ5lk4f3aV1TWOZo2J2Mw5X3uiBEm4R+vNnv/R66AHWJnLq2dJQb7Uyd6G4J1q
	 NDaLv1bgjOmC5z8CVI0UEqoNexf/HfSpEZrSiQmk0qph89ruZVQ7ifQb/5EUxR0LD
	 it1Aqm07tXzhEZ2i4WGIN/zx+yRLvQJiwW9S3PkJ0tffX9GlkVR4PVra5Oal+3u97
	 P42WUsO/tcdtmpvzgWD6w37p5NaFluPyybmN123nzDn3XuCNvgc1sxHm8OBoX7VmR
	 qu+4u5izEzpMlznWGg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mw9UE-1wS51143zI-00zoeB; Sat, 17
 Oct 2026 00:12:08 +0200
Message-ID: <52de3034-7e53-44bb-86f4-497830f45589@gmx.com>
Date: Sat, 17 Oct 2026 08:42:04 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: scrub: allocate stripe buffer with GFP_KERNEL
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <b0a3de02865070789659fb5613150de53cb3b9a2.1792168516.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <b0a3de02865070789659fb5613150de53cb3b9a2.1792168516.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RzQ+UEdjxsxrw1SRRlQR+5t727w82K9IxElhxJssJvdIK+PSjmn
 n6Ravej9jiaGKfRq1M7e15cLwZaQMy74u/LgpHNvpQ0nlwwN2tv57bCL1dCQo4zkfVWI8kw
 t/LUKTFTDeslsWXPajIhIkxuxVvPJC5HdNJ11jDzD75cWiWIIWYIqd3Zv7AOyFuJ1iuKLmq
 PMXa/KmFFnotbdee5gzdQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZFXJFm3to0g=;+UBuSHknvDl5WueL3Wy/XXqlljY
 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



=E5=9C=A8 2026/10/17 03:05, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> In init_scrub_stripe() we are allocating a stripe's buffer with GFP_NOFS
> but we can use GFP_KERNEL instead since we are not holding a transaction
> handle or any locks that could cause a deadlock if GFP_KERNEL triggers a
> transaction commit.
>=20
> So switch to GFP_KERNEL. We are also doing GFP_KERNEL for the allocation
> of stripe->csums just a few lines below.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/scrub.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index ba2e27cc5351..8c7404bb9636 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -356,7 +356,7 @@ static int init_scrub_stripe(struct btrfs_fs_info *f=
s_info,
>   	atomic_set(&stripe->pending_io, 0);
>   	spin_lock_init(&stripe->write_error_lock);
>  =20
> -	stripe->buffer =3D kvmalloc(BTRFS_STRIPE_LEN, GFP_NOFS);
> +	stripe->buffer =3D kvmalloc(BTRFS_STRIPE_LEN, GFP_KERNEL);
>   	if (!stripe->buffer)
>   		goto error;
>  =20

