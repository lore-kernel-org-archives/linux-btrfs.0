Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8C2420E9D;
	Tue, 15 Sep 2026 06:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789455291; cv=none; b=katxR8XsF5bl4El8Dw6BJOvUTWprkKrt+9PTEFBLPOFmCXvB7yeiNnymcmBahN0A3otFlPhXJ9HO1lWGYYAzPxDdGr/+5s8RfRVUYsKfSwt0LfZtkxwjes2FXLSuFHa/rMujHTLhDVil1/rFUYJC33loIVULjxaZh3j6laE2n2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789455291; c=relaxed/simple;
	bh=21ITHYNdrdwNFn4tMRrnGSQdHzLsocFpK0jbt/qXF4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OBJM7n1QZaWRqNKSBztTitP6ohbmg2dZTkB+ZfFDM7EptvTBDsPzxvnFkAgNqXowYdoIjOWJ+J6wVrmCp8FpP3fkw+cNFOq5ZVH4fWmVRzopkO1nQ5au4GhC99XJL6sAEIyFXfAxFem9tX6BJtBNpSwsAbwH1ezbdB8kV0n+ecA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=iwjjegEz; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="iwjjegEz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789455283; x=1790060083; i=quwenruo.btrfs@gmx.com;
	bh=1BtNuU1I97QZqwkryELsx5Hju7Sg115+8qe9P2CcPwk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=iwjjegEz1x5XhLLw0QI9mx+aHom0ZNAQz0HzBKjV6aBdzErSysNZkAUL4OY60b6D
	 7tqvTVsF7SNCReBa776LQh7JXd8mWbU2GiLV5uLi67ZLMt1kJm7zvCYh5/CjbKcDT
	 9W+rC11rSB42Rdd+etkAEASWgUlPOVO925A2ZkT+hURHx1O5CWla9HcZUilB7ZolX
	 gHIvxw1CsWA2UJxJTlTD3tu1QNt7ydQEAAb0cS3dBiJwCQYBh5auy8fP6yFlJj31a
	 l5jbWjT36ccMnq+B4S6yT0hyFQSqIMyE7qyiJ6kU7vdLBn6j5aGFsn4mZ2FK1ndlz
	 /SKY9Wx4Nvjy0yOdRA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N1wlv-1wdnUB1Wcz-0104m3; Tue, 15
 Sep 2026 08:54:43 +0200
Message-ID: <7ba35a69-3a68-441a-bcd9-4bc600cb7846@gmx.com>
Date: Tue, 15 Sep 2026 16:24:38 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: handle lack of space when cleaning up verity
 items
To: Daniel Linjama <daniel@dev.linjama.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 linux-kernel@vger.kernel.org, Qu Wenruo <wqu@suse.com>
References: <20260915055109.311839-1-daniel@dev.linjama.com>
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
In-Reply-To: <20260915055109.311839-1-daniel@dev.linjama.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:49ayneixesPNWReTz9Ro5aPQCNwPLyiq2Q5whW6yeEk4X5FF84Y
 +HzWgEKId6+Us0QxSs+feMEnva+TfEZq9A1GlKTSe4YNZTCRg9MIXSjytTLywuKZmU5rWke
 0Kh6UdFqP1qZ0pt22p7+C4n0634AqTguBLYHLNq4q8I9yq/+5ncnvlek94WCgEt9ADxk2Wq
 XtMd6WOIU5otWWMQg1D+g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:NR581Cnnf1E=;peqGHbEkaUlVbML8ubXTq9qe3PQ
 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



=E5=9C=A8 2026/9/15 15:21, Daniel Linjama =E5=86=99=E9=81=93:
> When enable_verity() hits the qgroup limit, rollback_verity() needs its
> own metadata reservation. When the qgroup limit or lack of space refuses
> the rollback, the whole filesystem is forced read-only even though the
> qgroup limit was for one subvolume only. Also orphan cleanup at the next
> mount fails the same way, so the leftover items are never removed: with
> -EDQUOT the subvolume stays unreachable, and with -ENOSPC on a full
> filesystem the next read-write mount fails.
>=20
> Start transactions with btrfs_start_transaction_fallback_global_rsv() in
> btrfs_orphan_cleanup(), drop_verity_items() and rollback_verity() to
> resolve the situation.

The fix looks good to me, but please add some basic explanation on why=20
we should use btrfs_start_transaction_fallback_global_rsv().

It's the same behavior as unlinking inode, we are dropping items which=20
should release some space in the end, thus we're allowed to use global rsv=
.

The same also applies to the quota reservation part, we're deleting some=
=20
items and should eventually free up some quota space, so here we should=20
not be limited by qgroup limit.

>=20
> Fixes: 146054090b08 ("btrfs: initial fsverity support")
> Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
> ---
> Changes since v1:
> - Revert the v1 change and fix the reservations on the cleanup path
>    instead, as Qu suggested. Sashiko was right that v1 left the orphan
>    for the next mount.
> - Cover the three transactions on the rollback and cleanup path to
>    handle -EDQUOT and -ENOSPC correctly.
> - fstests: btrfs/354 (qgroup at its limit) and btrfs/355 (full
>    filesystem), sent separately to fstests@vger.kernel.org:
>    https://lore.kernel.org/fstests/20260915053815.307674-1-daniel@dev.li=
njama.com/
>=20
> v1: https://lore.kernel.org/linux-btrfs/af99a1d5-25b0-4e39-9f66-a2dd8e14=
25c5@gmx.com/T/#t
>=20
>   fs/btrfs/inode.c  | 3 ++-
>   fs/btrfs/verity.c | 9 ++++++---
>   2 files changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 93ef3cec191e..d377f4ca5207 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3877,7 +3877,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
>   				if (ret)
>   					goto out;
>   			}
> -			trans =3D btrfs_start_transaction(root, 1);
> +			/* Only deletes the orphan, must not fail on a full qgroup */

I think you may want to slightly change the comment, not only focusing=20
on the qgroup part.

And to reduce duplication, you may want to follow __unlink_start_trans()=
=20
to introduce a helper just to call=20
btrfs_start_trans_fallback_global_rsv(), so that we only need one=20
comment for the reason, without duplicating it for every caller.

Otherwise looks good to me now.

Thanks,
Qu

> +			trans =3D btrfs_start_transaction_fallback_global_rsv(root, 1);
>   			if (IS_ERR(trans)) {
>   				ret =3D PTR_ERR(trans);
>   				goto out;
> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> index 4e0ab5842274..189b36e5fc29 100644
> --- a/fs/btrfs/verity.c
> +++ b/fs/btrfs/verity.c
> @@ -119,8 +119,8 @@ static int drop_verity_items(struct btrfs_inode *ino=
de, u8 key_type)
>   		return -ENOMEM;
>  =20
>   	while (1) {
> -		/* 1 for the item being dropped */
> -		trans =3D btrfs_start_transaction(root, 1);
> +		/* 1 for the item being dropped, must not fail on a full qgroup */
> +		trans =3D btrfs_start_transaction_fallback_global_rsv(root, 1);
>   		if (IS_ERR(trans))
>   			return PTR_ERR(trans);
>  =20
> @@ -465,8 +465,11 @@ static int rollback_verity(struct btrfs_inode *inod=
e)
>   	/*
>   	 * 1 for updating the inode flag
>   	 * 1 for deleting the orphan
> +	 *
> +	 * Must not fail on a full qgroup either: the reservations for the
> +	 * items dropped above are only released at commit.
>   	 */
> -	trans =3D btrfs_start_transaction(root, 2);
> +	trans =3D btrfs_start_transaction_fallback_global_rsv(root, 2);
>   	if (IS_ERR(trans)) {
>   		ret =3D PTR_ERR(trans);
>   		trans =3D NULL;
>=20
> base-commit: 08df884136f1c1197bab2a27814404fd329d9aac

