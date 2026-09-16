Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEE9409624;
	Wed, 16 Sep 2026 07:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789542731; cv=none; b=E4iytMTHSqjW0ILNKGS55PpTcyFh0yRnPQGsGbw0FC0luxGqKwDbvQ+i70lW+PIOkgtFjDhTOsdhX755DDfuHwWhcnto9Wq9rUIYprbH1YrNvifmBiRoDbIS5FN+WFrk+giZ8dVVzqi99kfeuF01HSX95SjWjTcuqTqXl7IBHxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789542731; c=relaxed/simple;
	bh=Nz2DUgKvPw+kDFrG7zBiuVkX8LYnyJdQeryLRizeQPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pYJBTotexT/47ZB7NqSJm9aAGjNqWwQS8aYUEKJIFyybm/WQYu0lSX0O+/A/rvyd5nAYBTUT4BfIaFWKl5Mm48xQ1G8hKWiP0FqH3ROOestFz1CEkNgzS9QbytfrtYIATNgVtTOzqd3BSq3gn79DMf/nk0SNdRSo2Up4UCswzSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=brrwPOi+; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="brrwPOi+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789542709; x=1790147509; i=quwenruo.btrfs@gmx.com;
	bh=zumu+c8TvMefuq2PIBfzilCSbdr+TplkhGeufvgYQiQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=brrwPOi+AJgl2zs8PEbzlh0U3VPHD4pWC5DX0AZaCu19FXSYx1SUPspN13LeTGcG
	 wObm2V21e9QW7v2gF6KcTBZJqITixUhIdA1qXU9DqWukRx33By0G7+mBVm7Rdrzoh
	 SIu/j49sqPVyxk8xRqW5IWneTQyD3qcimcmB02X8uryZ7pDJuT4RNHUoyxz4RELeQ
	 HbeGS6v+OU9yGjnqQuhw9zuJAen6WACgY3bb+zFHRbmlO1CDUDvhNbb0UTuqVkOZH
	 w/mqRiWK8T+yRK4YcwtNM/usLU+JfMczU7EUchldtg63TFG1+wZJr/978avGHhhcH
	 bbwwhyloB7yISsaNOg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N9dsV-1wmEpq1285-017kyb; Wed, 16
 Sep 2026 09:11:49 +0200
Message-ID: <1e6c8092-604e-4242-9bb7-11788c4540ca@gmx.com>
Date: Wed, 16 Sep 2026 16:41:41 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: handle lack of space when cleaning up verity
 items
To: Daniel Linjama <daniel@dev.linjama.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 linux-kernel@vger.kernel.org
References: <20260916061556.683136-1-daniel@dev.linjama.com>
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
In-Reply-To: <20260916061556.683136-1-daniel@dev.linjama.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7GgfUGpRX+q/6hpO153WMsHrjM+/UZQ9NVkHTOKn6zsQI4eFjmD
 99Ha7Q1sfOZnDXovGdY5kYXzfhbQS5UWPZU8SEr8uvJW3zFBx5s3YI3XWeOKpSEethwyFPY
 Q10FEuVtg/0Tp+U/2EldVB17lnY8YmSuFlefaTieVJmskblJFT9IU9DmubmVKMzxYxOYXF+
 vSSVz8DtC82T3+aP2dIEQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:fKLzTQLGTnc=;BMIOeQRnaNdwf13gZ1RN07c8TWR
 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



=E5=9C=A8 2026/9/16 15:45, Daniel Linjama =E5=86=99=E9=81=93:
> When enable_verity() hits the qgroup limit, rollback_verity() needs its
> own metadata reservation. When the qgroup limit or lack of space refuses
> the rollback, the whole filesystem is forced read-only even though the
> qgroup limit was for one subvolume only. Also orphan cleanup at the next
> mount fails the same way, so the leftover items are never removed: with
> -EDQUOT the subvolume stays unreachable, and with -ENOSPC on a full
> filesystem the next read-write mount fails.
>=20
> Start transactions with btrfs_start_transaction_fallback_global_rsv() in
> btrfs_orphan_cleanup(), drop_verity_items() and rollback_verity(). Those
> calls only delete items and free the space in the end, so they may use
> the global reserve and skip the qgroup limit, which avoids -ENOSPC and
> -EDQUOT.
>=20
> Fixes: 146054090b08 ("btrfs: initial fsverity support")
> Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Changes since v2:
> - Explain in the commit message why the global reserve fallback and
>    skipping the qgroup limit are right here, as Qu Wenruo asked.
> - A helper in verity.c for the two verity call sites carries the one
>    comment, as Qu Wenruo suggested; the orphan cleanup call site only
>    notes what it does.
>=20
> v2: https://lore.kernel.org/linux-btrfs/20260915055109.311839-1-daniel@d=
ev.linjama.com/
> v1: https://lore.kernel.org/linux-btrfs/20260914062459.3889313-1-daniel@=
dev.linjama.com/
>=20
>   fs/btrfs/inode.c  |  3 ++-
>   fs/btrfs/verity.c | 18 ++++++++++++++++--
>   2 files changed, 18 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 93ef3cec191e..84dc44af17d7 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3877,7 +3877,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
>   				if (ret)
>   					goto out;
>   			}
> -			trans =3D btrfs_start_transaction(root, 1);
> +			/* Only deletes the orphan */
> +			trans =3D btrfs_start_transaction_fallback_global_rsv(root, 1);
>   			if (IS_ERR(trans)) {
>   				ret =3D PTR_ERR(trans);
>   				goto out;
> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> index 4e0ab5842274..18b9d14f2e8c 100644
> --- a/fs/btrfs/verity.c
> +++ b/fs/btrfs/verity.c
> @@ -93,6 +93,20 @@ static loff_t merkle_file_pos(const struct inode *ino=
de)
>   	return rounded;
>   }
>  =20
> +/*
> + * Start a transaction for removing verity items or the verity orphan.
> + *
> + * Like unlink, this only deletes items and frees space in the end, so =
the
> + * reservation may come from the global reserve when the filesystem is =
full
> + * (-ENOSPC) and is not subject to the qgroup limit (-EDQUOT). Otherwis=
e a
> + * failed enable could never be cleaned up in either situation.
> + */
> +static struct btrfs_trans_handle *start_verity_cleanup_trans(struct btr=
fs_root *root,
> +							      unsigned int num_items)
> +{
> +	return btrfs_start_transaction_fallback_global_rsv(root, num_items);
> +}
> +
>   /*
>    * Drop all the items for this inode with this key_type.
>    *
> @@ -120,7 +134,7 @@ static int drop_verity_items(struct btrfs_inode *ino=
de, u8 key_type)
>  =20
>   	while (1) {
>   		/* 1 for the item being dropped */
> -		trans =3D btrfs_start_transaction(root, 1);
> +		trans =3D start_verity_cleanup_trans(root, 1);
>   		if (IS_ERR(trans))
>   			return PTR_ERR(trans);
>  =20
> @@ -466,7 +480,7 @@ static int rollback_verity(struct btrfs_inode *inode=
)
>   	 * 1 for updating the inode flag
>   	 * 1 for deleting the orphan
>   	 */
> -	trans =3D btrfs_start_transaction(root, 2);
> +	trans =3D start_verity_cleanup_trans(root, 2);
>   	if (IS_ERR(trans)) {
>   		ret =3D PTR_ERR(trans);
>   		trans =3D NULL;
>=20
> base-commit: 08df884136f1c1197bab2a27814404fd329d9aac

