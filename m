Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0562411F93;
	Wed,  2 Sep 2026 21:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788385883; cv=none; b=hdoNh87KidxD/0NARW1SOUUvvs9u4PWhElybe0bWCIx8QdAPF2tXYNEDCpjqleOivrzbVTCkKRXuiAzlTLBqfw0ZlFlVXbngv/FKcAg3Lv515nnUs7LBOgHbz7P6DhSe37CtMi7C2kzF8c3k+9Cgn4zoorih2CT0hP3QyhkiiJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788385883; c=relaxed/simple;
	bh=m9dOTHbWmlS0KCBsbW/tuHkdmZSSvIgBYXg4YZKtYbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=stS8bgpgpb2YSYEcOvCTtqQMfUyw7J6E1MOvvZ6fTlzOmCGYP6ukTeUYKj/E4Rwtyn1rr84bIlZuF1FwlOKRonfEFJpdaXk1N67BQ9IYhBKL9j/MzqBK5PYQacmDszotIyIM4HThk9Ga9lxncgm6L3jhKH7nZhMVd0zUCHXrkKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=GZlRJdce; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="GZlRJdce"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788385872; x=1788990672; i=quwenruo.btrfs@gmx.com;
	bh=h1c9SIUY77t9O2DncCMQVWaVtz1rRyUAK41y38ImKw8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=GZlRJdcetiSxJLbOY/BFiz5R1sgScsYNDHXpd4CTth8SNYEMDqxglTq9J6lNPm6r
	 aQtbtSib5zK/pGdNSI0+BqOqL4Ghiof4ui3OMo5yHCFKWqwytKFCZ3H1zLWfxM/H8
	 ZINSVCyPWX8TUr4OEZ9kPy8mENrzgULpksItVzlPTKhilkGxW9+KkvhuhUXr6qItZ
	 XE9PtNNRtB2ZP2WiC/Dw5Z64Wyk4NbsJjGy1myGxD9nsdXez14eIUxFxOEydfOzoY
	 P6OBz2+WDepanKql6T1hP7yusJWkllXFFUVZKrj23rKZW9DKm2F+zVbZvpYzcam8b
	 VFDHLCa4yvDaQL2+hg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mof5H-1wV29u2UDh-00muxo; Wed, 02
 Sep 2026 23:51:12 +0200
Message-ID: <afeb40a2-5996-4e36-bcc6-db8c7973db7f@gmx.com>
Date: Thu, 3 Sep 2026 07:21:08 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: consume the given iter directly instead of
 copying in csum_one_bio()
To: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Qu Wenruo <wqu@suse.com>
References: <20260902165137.3781696-1-neelx@suse.com>
 <20260902165137.3781696-2-neelx@suse.com>
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
In-Reply-To: <20260902165137.3781696-2-neelx@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:mVcE2Qj98EJIR7ip8uyyLRM5/nGMaqFC1h/r48mkm895v7nEBH9
 XDtF0ocJf0PbdsizzmC9Xi38wBh2Kzm9/q2bOwAw5iF58GU10kG4iMIluqhGcw81XVOIpD5
 OQ4JjlSYGlq94IhVajltLtUqYpCFfSa95Bsl+ks9gRKYKPwZEZ1Jz53fEG9HC3bJrbYCW3T
 VKkFUHuP/liB8oDdzN1VQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:C3N704LebzE=;zepi/OWGAUhZLJVu3zNhOYyUBk3
 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
 A9TPOGkRD2Y=



=E5=9C=A8 2026/9/3 02:21, Daniel Vacek =E5=86=99=E9=81=93:
> This is just a small cleanup to avoid copying the iter twice in async ca=
se.
> We already have a copy csum_one_bio() can consume directly. No need to c=
opy
> again the second time.
> In the sync case we can copy in the caller (as we did before dd57c78aec3=
9
> ("btrfs: introduce btrfs_bio::async_csum")).
>=20
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
>   fs/btrfs/file-item.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 581ca5653be9..5a5cffb18922 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -797,18 +797,16 @@ int btrfs_lookup_csums_bitmap(struct btrfs_root *r=
oot, struct btrfs_path *path,
>   	return ret;
>   }
>  =20
> -static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *src)
> +static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *iter=
)

Since we're here, what about adding const prefix to iter?

>   {
>   	struct btrfs_inode *inode =3D bbio->inode;
>   	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>   	struct btrfs_ordered_sum *sums =3D bbio->sums;
> -	struct bvec_iter iter;
>   	const u32 blocksize =3D fs_info->sectorsize;
>   	int index =3D 0;
>  =20
> -	for (iter =3D *src; iter.bi_size; bio_advance_iter(&bbio->bio, &iter, =
blocksize)) {

I'm thinking the opposite way.

What about still keeping a local bvec_iter copy, but remove=20
csum_saved_iter completely?

Since at bio calculation time, the bio is not yet submitted, so the=20
csum_saved_iter always match bio.bi_iter.

I think removing csum_saved_iter would also reduce the size of btrfs_bio.

Thanks,
Qu

> -		btrfs_csum_one_bio_block(fs_info, &bbio->bio, &iter,
> -					 sums->sums + index);
> +	for (; iter->bi_size; bio_advance_iter(&bbio->bio, iter, blocksize)) {
> +		btrfs_csum_one_bio_block(fs_info, &bbio->bio, iter, sums->sums + inde=
x);
>  =20
>   		index +=3D fs_info->csum_size;
>   	}
> @@ -851,12 +849,14 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, boo=
l async)
>   	btrfs_add_ordered_sum(ordered, sums);
>  =20
>   	if (!async) {
> -		csum_one_bio(bbio, &bbio->bio.bi_iter);
> +		struct bvec_iter iter =3D bio->bi_iter;
> +
> +		csum_one_bio(bbio, &iter);
>   		return 0;
>   	}
>   	init_completion(&bbio->csum_done);
>   	bbio->async_csum =3D true;
> -	bbio->csum_saved_iter =3D bbio->bio.bi_iter;
> +	bbio->csum_saved_iter =3D bio->bi_iter;
>   	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
>   	schedule_work(&bbio->csum_work);
>   	return 0;

