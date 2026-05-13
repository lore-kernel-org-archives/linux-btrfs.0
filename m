Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA01229BD88
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 00:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778633625; cv=none; b=lXQLDTJYMItr3boLYhA3mozAXhWNSIqbPwl8AnHMCwgiglyLysVwS799sYMU2dSWL9w+8iZp1mCIkRteUMlcBAqFX+/3Lg+bOzahMkSdLZmFOyg3f15zXPMhDAfA8qNLH7cza8YufX7Ln55t1qs1P4CzFUBqPXcrGIkDVCl7qaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778633625; c=relaxed/simple;
	bh=kCaKoVAiv6AIdC43R/vQBzpDhm5KvVJGaMCX3HoOKKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nExVeZE25J4IqAXKwepHNYxZpByEegPSiT092eNNdKJl2D7wnCyAjV4+TbhOT1nR36PepOo0HVw3LYwTh6SHXzA2xd4kizQMWs4i77TdB583N0hNJHnHbP50dx2/8tgTX4fZoJ3i1Xd/eowXRJ5u1fTg9AMRYJz7Jq7GkMolz0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=a9ojuySy; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="a9ojuySy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1778633608; x=1779238408; i=quwenruo.btrfs@gmx.com;
	bh=8phlFs4l/aicmRRG1mzyo7KgnvOToIaqw6yZhBOXCf0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=a9ojuySy0o9OLG1MiMQqcF3NewSG7kbNvJJT6+AZ/U2T4JczEhQb+Ujs9JcEx6oz
	 Xqw89ZLWr7fFNM328YzVuS9yjdcKlZCNRkTrPmilRD5iFexkuz2DYUJ4S234TcAlb
	 Hwans/oqK49001rzQ2ksy1P++lCIA/PFi54TSPQW7MQQ5gYxMaKOlwbNy6Gpj1/br
	 eQ/LspRicQQuw9HYem2Wbwwu+iu4wyZa65JYwQ49dhwk3V4tCskYM1s0RINb805sr
	 rJFCanyu9MMI0XyqqpyKx3OECi78r0TF2we3BVe9Wl2GgoMiIyKhYhsWAZGNfE5rD
	 aknfQ7IqS++4YUeMqA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MnJhU-1x5xim0jSe-00aEQz; Wed, 13
 May 2026 02:53:28 +0200
Message-ID: <acddd455-be08-47c0-b4d3-18e8e294713a@gmx.com>
Date: Wed, 13 May 2026 10:23:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] btrfs: clamp to avoid squota underflow
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: marc@merlins.org
References: <cover.1778613519.git.boris@bur.io>
 <de66dfbdf8abcaba1b16b1779f8718f1583c8f5b.1778613519.git.boris@bur.io>
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
In-Reply-To: <de66dfbdf8abcaba1b16b1779f8718f1583c8f5b.1778613519.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:G355mEMNzU7dTPxYH1oX+nnZxq+Am1sIXAqv7cL1vDnB+RKUzOY
 mVNdKFAp0YH8JUHoifeEs0AD2eGYR2S/ck7vhCTzkdAlQZkvAj9h6+wVLEZklXM/+b+O6XY
 7/AKTa6jdRJ3vGh3n01vnHJNFNoWgCPtcqabw98usP+Eq/EzXB6ytTzKYryNNaceZl4zWFf
 nZ8U/nCkbmuPVj7Tb1XKg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:IV7iHheAS7I=;XDyvy/9UKMWQqIuDNfjig1MBu4X
 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
 oiVBuQNX436BfqWSHF4XVJ/SGSoqsLf4QhoU=



=E5=9C=A8 2026/5/13 05:04, Boris Burkov =E5=86=99=E9=81=93:
> Simple quota accounting can undercount metadata tree block allocations
> in certain scenarios. When an undercounted subvolume is deleted and its
> tree blocks freed, the free deltas decrement rfer/excl past zero,
> wrapping the u64 to a value near U64_MAX.
>=20
> Once wrapped, can_delete_squota_qgroup() sees non-zero rfer and refuses
> to delete the qgroup. The qgroup becomes permanently orphaned in the
> quota tree, since there is no subvolume left to generate frees that
> would bring the counter back to zero.
>=20
> While we ultimately want to fix any mis-accounting at the source, it is
> also helpful and worthwhile to mitigate the damage by clamping rfer and
> excl to zero on underflow rather than allowing the u64 to wrap. This at
> least allows us to clean up the messed up qgroups on subvol deletion.
>=20
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>   fs/btrfs/qgroup.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 96746ca19e17..a93d49015fc7 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -4968,8 +4968,19 @@ int btrfs_record_squota_delta(struct btrfs_fs_inf=
o *fs_info,
>   	list_for_each_entry(qg, &qgroup_list, iterator) {
>   		struct btrfs_qgroup_list *glist;
>  =20
> -		qg->excl +=3D num_bytes * sign;
> -		qg->rfer +=3D num_bytes * sign;
> +		ASSERT(qg->excl =3D=3D qg->rfer);
> +		if (sign < 0 && qg->excl < num_bytes) {
> +			btrfs_warn(fs_info,
> +				   "squota underflow qg %hu/%llu excl %llu num_bytes %llu",
> +				   btrfs_qgroup_level(qg->qgroupid),
> +				   btrfs_qgroup_subvolid(qg->qgroupid),
> +				   qg->excl, num_bytes);

This may not be noisy enough for fstests to catch.

Maybe a WARN_ON_ONCE()?

Thanks,
Qu

> +			qg->excl =3D 0;
> +			qg->rfer =3D 0;
> +		} else {
> +			qg->excl +=3D num_bytes * sign;
> +			qg->rfer +=3D num_bytes * sign;
> +		}
>   		qgroup_dirty(fs_info, qg);
>  =20
>   		list_for_each_entry(glist, &qg->groups, next_group)

