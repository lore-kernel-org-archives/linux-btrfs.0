Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5185C41D121;
	Mon, 14 Sep 2026 09:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377375; cv=none; b=BtK94Jppb9AgRoKWigZQrxHhijTYBM/jrbezyWr/jVFHQXytU0p3ZROCkRUh6Ke30GxHGvDFbZPLv2ZDIKRH7ysal2hLmzaG4w5uTcDxe3qu5kd+Pr/FynFb56gxwCxJlWMEqI05eBE8z3QQD19tNbKXtHi+1eHKawKSWDKjjXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377375; c=relaxed/simple;
	bh=AoTcsmamqvxgQCxbyT/SxP2x69qehoPWVJ5jpnpRwP8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=n3zGvkzMlF4mS1zQVNWlJAAjn5fMrg1jOfqxYPEvMv3Z7ht3A2hPG685dA4KzpkGh6gZi37OOm3iX1lo7gdSAc++3mjWhEYz+rfkcDTTguJZPpOc3VOLDbvgAgNuVJ3k2p6Pw4/8Y6O8jl1ec5YDurTRxagT3FBFeXEC80xJzHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=XBpzyMPu; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="XBpzyMPu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789377359; x=1789982159; i=quwenruo.btrfs@gmx.com;
	bh=AoTcsmamqvxgQCxbyT/SxP2x69qehoPWVJ5jpnpRwP8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=XBpzyMPuF9XnOa8Wi9yLS2EaSo/tbedscXKuP0LR8l2T8FmZphMHMpvAbkuDJbLu
	 1BUUr3IXnfHg9sN9hV0MChACynYyY89vY2WYYMwQSp+KG+FBxfFqo8acpCLv8M2Yl
	 qXwVuK198qG+sKy5KXl9HEZCD03/YaAN6qIAi9zHc7S4DG9oyngOY5Mc0nrHFEI4G
	 gUq7V/KlROM/L90/eU/4RWXupl0GKbYPat0P7am/2guSWLodQpFuSSe6GdIPZvlNQ
	 wbI7fY92djYZhw2sv5m5aRqvvcr/qkMf/BTifC/cDDsYasSU1P9I2FnJbXpE6y8dF
	 15eDgbm6CILAnQsxIQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MQvD5-1xQAbx3xdH-00K2Wf; Mon, 14
 Sep 2026 11:15:59 +0200
Message-ID: <af99a1d5-25b0-4e39-9f66-a2dd8e1425c5@gmx.com>
Date: Mon, 14 Sep 2026 18:45:55 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: don't force the filesystem read-only on
 EDQUOT/ENOSPC verity rollback
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Daniel Linjama <daniel@dev.linjama.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 linux-kernel@vger.kernel.org
References: <20260914062459.3889313-1-daniel@dev.linjama.com>
 <2107e9f8-2bc6-42e5-98e2-30e25be016dd@gmx.com>
Content-Language: en-US
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
In-Reply-To: <2107e9f8-2bc6-42e5-98e2-30e25be016dd@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JYsmSfLoSiFgJKG+ZiLB2aClyr58pUiaJWY//0StRuqPbagMhdm
 pKnkqe3QG1BbDHqZd9+65TfkkEBTtjneN31oc+6MMHUCfzYCovoxK2xxuh9tUuNIVTCtkQJ
 bUFPxuNcmMAQ3rvBy37vh6ddd0ralmscknrMkgzVF0KEajEZ0jqBGEPgXQEdSUV6no2YcWu
 +ovG/3gnezZQ3GMg9Zd+g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dhysHFNtL7E=;jdcfzZhCCDf48EfGt8xTwDdfigc
 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
 063UIu2tjZSDC



=E5=9C=A8 2026/9/14 16:02, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/9/14 15:54, Daniel Linjama =E5=86=99=E9=81=93:
>> When enable_verity() hits the qgroup limit, rollback_verity() needs its
>> own metadata reservation. When the qgroup limit refuses the rollback,
>> the whole filesystem is forced read-only even though the qgroup limit
>> was for one subvolume only.
>>
>> Skip btrfs_handle_fs_error() for -EDQUOT/-ENOSPC and just return the
>> error. The verity orphan item is left in place but the orphan cleanup
>> from commit 705242538ff3 ("btrfs: verity metadata orphan items") will
>> remove it at the next mount. fsverity enable still correctly fails but
>> the filesystem is not forced read-only.
>>
>> Fixes: 146054090b08 ("btrfs: initial fsverity support")
>> Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
>> ---
>> Verified on a virtual machine with a mainline kernel (08df884136f1) and
>> a loop-mounted btrfs, with either a qgroup limit on a subvolume or a
>> full filesystem. On the unpatched kernel the whole filesystem was force=
d
>> read-only. On the patched kernel fsverity enable returns -EDQUOT/-ENOSP=
C
>> and the filesystem stays read-write.
>=20
> Please also submit a fstests case for it.
>=20
>>
>> =C2=A0 fs/btrfs/verity.c | 22 ++++++++++++++++++----
>> =C2=A0 1 file changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
>> index 4e0ab5842274..8d0f9eea4c39 100644
>> --- a/fs/btrfs/verity.c
>> +++ b/fs/btrfs/verity.c
>> @@ -441,7 +441,9 @@ static int del_orphan(struct btrfs_trans_handle=20
>> *trans, struct btrfs_inode *inod
>> =C2=A0=C2=A0 *
>> =C2=A0=C2=A0 * We try to handle recoverable errors while enabling verit=
y by=20
>> rolling it back
>> =C2=A0=C2=A0 * and just failing the operation, rather than having an fs=
 level=20
>> error no
>> - * matter what. However, any error in rollback is unrecoverable.
>> + * matter what. Failing to delete the verity items for lack of space i=
s
>> + * tolerated, the orphan item ensures they are removed on the next=20
>> mount.
>> + * Any other error in rollback is unrecoverable.
>> =C2=A0=C2=A0 *
>> =C2=A0=C2=A0 * Returns 0 on success, negative error code on failure.
>> =C2=A0=C2=A0 */
>> @@ -456,9 +458,21 @@ static int rollback_verity(struct btrfs_inode=20
>> *inode)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS=
, &inode->runtime_flags);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_drop_verity_items(inode);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_handle_fs_error(root-=
>fs_info, ret,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 "failed to drop verity items in rollback %llu",
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 inode->vfs_inode.i_ino);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * -EDQUOT and -ENOSPC=
 mean we could not reserve metadata to
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * delete the verity i=
tems. That is not a consistency problem,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * so don't turn the f=
ilesystem read-only. Leave the items and
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * the orphan in place=
, orphan cleanup on the next mount will
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * remove them.
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>=20
> EDQUOT is fine, but I'm not sure if ENOSPC is really recoverable.
>=20
> Even if we ignore ENOSPC for now, we may have really exhausted the=20
> metadata, and the next transaction may be aborted anyway.

Sashiko also mentioned even if we ignored EDQUOT for now, the next mount=
=20
we still fallback to call btrfs_drop_verity_items() on the inode cleanup.

And it will return -EDQUOT again, so the inode will not be cleanred up.

Considering we're only delete items, I think the better solution would=20
be calling btrfs_start_transaction_fallback_global_rsv(), which will not=
=20
enforce qgroup, thus should not return -EDQUOT in the first place.

>=20
> I believe your test case is only utilizing qgroup limit, or did you hit=
=20
> a case where btrfs_drop_verity_items() returns -ENOSPC and the fs still=
=20
> works fine?
>=20
> Otherwise the idea looks good to me.
>=20
> Thanks,
> Qu
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret !=3D -EDQUOT && ret=
 !=3D -ENOSPC)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btr=
fs_handle_fs_error(root->fs_info, ret,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 "failed to drop verity items in rollback=20
>> %llu",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 inode->vfs_inode.i_ino);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btr=
fs_warn(root->fs_info,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "failed to drop verity items in ro=
llback %llu: %pe",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode->vfs_inode.i_ino, ERR_PTR(re=
t));
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20

