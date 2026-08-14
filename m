Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9DB33AD9C
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 22:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786745324; cv=none; b=BUFVq92k2+tfE4CuMbvaxG6wyLnHRhNh+kglZWNluxKQI2KPqwxGyqWr6MyMcC7qJbWxQia++5RoYI3LVJmIoX6gMpWBLS7oxQPz41sn33A1vnExTx1lo79FsSqnvzonK/ViNvNoPaE2Sc9NKh1fSKxRcUjMYi+t+IOvJjSdyN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786745324; c=relaxed/simple;
	bh=3y6/s3vi0BGky25MZpnzrFycQ7HgqDaDXgtPxNs31Mo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rOxHoz6+NoQcIkIGhGNhJ0kk4IYPf5quVcaq0Vli7t5x9r/ZehHFI1z9AdHEcelYFzW2X5rlqbRHPKaO7PVuO5wJwQFFeCHpEyoCe0rozFVrs81DrslPXa9FiQ8pzZRVU5l9pjwItTujr/NGjcw+Dguf1NhpGJfHvZltlsk6GhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=uWZhcelc; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="uWZhcelc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786745320; x=1787350120; i=quwenruo.btrfs@gmx.com;
	bh=QVrIQsEbg/+FQtU8g3iXI2+WwbjhYTYEG7giZVV33RE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=uWZhcelcHTS5RvyJXIIroBLmmwUPkNRMCGQdiKHry4Jt5dtSrOOHIaBJAZBCpyWU
	 62w+cKe5NYogA1b3qSSFnB+JlQ1/+T2YSkCw5UH2dp+6ZIJPtXbtVbaBO4Yt62jZe
	 nYzsqlGXUEisgP/ZQ1AV5aTV1jbr+nR5toEZpcIqjvkDL5F6Kn36WGSS+b9OHULkM
	 DyeN50QMYD932QTS9CLmDRWp5v6FLjnTfpiTV5Eb7KxARxudcbvSFxttwMUkt+ErJ
	 tbOocsv/7noyFsS1ZKUs6d1s/576pzwQ5Vh2AOp60zWgrfw4rAnjvmmoMhRt5WFFU
	 i+kHaPtMFjxbRnFYtw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mirna-1xOY0R2VHA-00dVX7; Sat, 15
 Aug 2026 00:08:40 +0200
Message-ID: <311f8dae-550a-4619-8857-e9873b345f0e@gmx.com>
Date: Sat, 15 Aug 2026 07:38:36 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: preserve the compression property when other
 inode flags change
To: Sam Ho <samho@synology.com>, clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <20260814051406.1244006-1-samho@synology.com>
 <20260814130111.1258093-1-samho@synology.com>
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
In-Reply-To: <20260814130111.1258093-1-samho@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NhFoJkQ4htBYHKhPAapdIVPird+7vSneOfpJn4/ujjSM1jAws05
 caZ6LrZHyJX2LAYlvXugMr7KiQd3c1TBw2H+Cgg3mqtBZ3CooklTr5DFIAOzCG8/6ivYHPO
 8Cx/8ukQEflVspdwz6wnHuBVqTSB24hnXm25oOdX25DuQhs9imFfCrSM1kx4EfNhdk/R8ZP
 41F/ztDYdSL6OPQiAU/0A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Ly8sHuMxLyI=;gyzCr8OL0wnT6KH/n/m5sMDnKBL
 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



=E5=9C=A8 2026/8/14 22:31, Sam Ho =E5=86=99=E9=81=93:
> Setting the compression property on an inode also sets BTRFS_INODE_COMPR=
ESS
> on it, and btrfs_inode_flags_to_fsflags() reports that back as FS_COMPR_=
FL
> to FS_IOC_GETFLAGS. chattr(1), like any other FS_IOC_SETFLAGS caller, re=
ads
> the current flags, flips only the bit the user asked for and writes the
> whole set back, so a request as unrelated as "chattr +i" reaches
> btrfs_fileattr_set() with FS_COMPR_FL set.
>=20
> btrfs_fileattr_set() takes that as a request to enable compression and
> overwrites the compression property with the algorithm from the mount
> options, falling back to zlib when the filesystem was not mounted with
> -o compress. The algorithm the user selected is silently replaced:
>=20
>    # btrfs property set /mnt/foo compression zstd
>    # btrfs property get /mnt/foo compression
>    compression=3Dzstd
>    # chattr +i /mnt/foo
>    # btrfs property get /mnt/foo compression
>    compression=3Dzlib
>=20
> Every chattr operation triggers this, not just +i, and directories are
> affected as well, so files created afterwards inherit the wrong algorith=
m
> too. On a filesystem mounted with -o compress=3Dlzo the property is repl=
aced
> with lzo instead. Recovering needs a chattr -i first, because the immuta=
ble
> flag rejects the setxattr that "btrfs property set" issues.
>=20
> Prefer the algorithm recorded in the compression property and only fall
> back to the mount default when there is no property, so that unrelated
> flag changes no longer overwrite the user's choice. Inodes that have the
> compress flag set but no property still get the default, so they behave
> as before.
>=20
> Signed-off-by: Sam Ho <samho@synology.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> v2:
>   - Pick the compression type first and convert it to a string only once=
 at
>     the end, instead of going through btrfs_compress_type2str() for ever=
y
>     candidate, and check inode->prop_compress directly rather than testi=
ng
>     old_fsflags for FS_COMPR_FL. Suggested by Qu Wenruo; the two are
>     equivalent, since prop_compression_apply() only leaves prop_compress
>     set while BTRFS_INODE_COMPRESS is set.
>   - Reword the last changelog paragraph and the comment to match.
>=20
> v1: https://lore.kernel.org/linux-btrfs/20260814051406.1244006-1-samho@s=
ynology.com/
>=20
>   fs/btrfs/ioctl.c | 21 ++++++++++++++++++---
>   1 file changed, 18 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index baa645e98812..343d089aa5c3 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -377,6 +377,7 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
>   		inode_flags &=3D ~BTRFS_INODE_COMPRESS;
>   		inode_flags |=3D BTRFS_INODE_NOCOMPRESS;
>   	} else if (fsflags & FS_COMPR_FL) {
> +		enum btrfs_compression_type comp_type;
>  =20
>   		if (IS_SWAPFILE(&inode->vfs_inode))
>   			return -ETXTBSY;
> @@ -384,9 +385,23 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
>   		inode_flags |=3D BTRFS_INODE_COMPRESS;
>   		inode_flags &=3D ~BTRFS_INODE_NOCOMPRESS;
>  =20
> -		comp =3D btrfs_compress_type2str(fs_info->compress_type);
> -		if (!comp || comp[0] =3D=3D 0)
> -			comp =3D btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
> +		/*
> +		 * Keep the algorithm recorded in the compression property,
> +		 * otherwise changing an unrelated attribute would reset it to
> +		 * the mount default, since FS_IOC_SETFLAGS callers write back
> +		 * the whole flag set they got from FS_IOC_GETFLAGS and that
> +		 * includes FS_COMPR_FL for any inode carrying the property.
> +		 *
> +		 * Inodes with the compress flag set but no property keep using
> +		 * the mount default, so they behave as before.
> +		 */
> +		if (inode->prop_compress)
> +			comp_type =3D inode->prop_compress;
> +		else if (fs_info->compress_type)
> +			comp_type =3D fs_info->compress_type;
> +		else
> +			comp_type =3D BTRFS_COMPRESS_ZLIB;
> +		comp =3D btrfs_compress_type2str(comp_type);
>   	} else {
>   		inode_flags &=3D ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
>   	}

