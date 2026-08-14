Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847C5373BF6
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 08:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786697918; cv=none; b=jLXu0wjfEpDEZVYlS6X/xa0QWJ0Xv/foV6y+5kOZymAfBIBoLtLiKqOCXXA2K1MhOC1wNhFNjKe0Be1svGP2/dHFAEHFkQ4q6pK0/GI04CyhGbNNWYkiI/o//HoOTg7wePy0MyKDs1sw7GSWhsUC6yZAS3eQ5cHxASsHWeTn0so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786697918; c=relaxed/simple;
	bh=ISTKlWwqn316XK+ringyP3U840xcJ+oT3kxAD7ZV+iM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c2fValt2iSBRAapf7dV5nLeVgQrgFvux37k0evaEoN+kktNLg1yWnjw/JlINOqkiRU4P/feBm0FVYsiqh3Lq322mdlVo4e0KSwfqIdsfUGxiFp9s0DdfvF7QSzpIVVNVdbCAyw0sHH0sYgMbfyEJH1aUIAmPMUbEBBthxaaZ0R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=ezON4c6w; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="ezON4c6w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786697910; x=1787302710; i=quwenruo.btrfs@gmx.com;
	bh=f85/rf1T4PaItnpWGb/4ssPtqzNK94Sd5oCzd5OIV98=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ezON4c6wl002KgrEThCd+rRCh8X0iVtXmuoBsRphI/z2PekREqj6veqdlQX73OOp
	 WzVqNOPs+AH9wTwUIl3s9A7UZUw0XvhvMtaIEEMDzG7Tq10CnbNTVRhDOsxJ/KIZx
	 qjMm11u5jhrUHyo2Qaj3k4ZzEax8g0MNcRtd9900lmWXFS8PYGHl0+S+liVEp393u
	 6fMF2AyDDesEC0JNA9EKfdqz7D4fSK671u5jZy3IJf0r64JVW6a9w7Rbw+pkAcmmc
	 HyVvl7eLjM9FDH97udqFWzKBIaoemBsCMwO7q/jsYwexYa2IxUOWXayylT2FwotYI
	 Wu0C+O1wtpXQd397vg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1McH9i-1xQYav136K-00fitU; Fri, 14
 Aug 2026 10:58:30 +0200
Message-ID: <f13ee8ae-aae1-4877-b4e9-5ff82ec075d5@gmx.com>
Date: Fri, 14 Aug 2026 18:28:25 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: preserve the compression property when other inode
 flags change
To: Sam Ho <samho@synology.com>, clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <20260814051406.1244006-1-samho@synology.com>
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
In-Reply-To: <20260814051406.1244006-1-samho@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Wx+Ff2XzWlWtfbDg0TkHQ6Uo8VnqxRmwpq9cichu5jzWlxKd597
 t55lUQVD4BfgYeU9Ly/X2VbOR7X70BNDhau1J6PTEHEFt/0qTtZN0ED6EFCFHIHpM7srVDz
 Ou0WmRf2bK/8tGo6vSx6GlQiA1ispKZmTLCB3PhMRbPHYk6h8Lpq5wsjBbA5PvedUErmFdc
 Bd/KMk2XYOgP0vx5uAFZg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:TD64IFXxs6k=;2cnhmGsvrcoVcw865SBvYlap7sx
 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
 qak8dPC7EtO2mdG19rY=



=E5=9C=A8 2026/8/14 14:44, Sam Ho =E5=86=99=E9=81=93:
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
> Only pick the default algorithm when compression is actually being enabl=
ed
> by this call, that is when FS_COMPR_FL was not set before, and otherwise
> keep the algorithm recorded in the property. Inodes that have the compre=
ss
> flag set but no property still get the default, so they behave as before=
.
>=20
> Signed-off-by: Sam Ho <samho@synology.com>

The analyze looks good to me.

Although a minor nitpick related to the compression checks.

> ---
>   fs/btrfs/ioctl.c | 22 +++++++++++++++++++---
>   1 file changed, 19 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index baa645e98812..2e54694f06f7 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -384,9 +384,25 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
>   		inode_flags |=3D BTRFS_INODE_COMPRESS;
>   		inode_flags &=3D ~BTRFS_INODE_NOCOMPRESS;
>  =20
> -		comp =3D btrfs_compress_type2str(fs_info->compress_type);
> -		if (!comp || comp[0] =3D=3D 0)
> -			comp =3D btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
> +		/*
> +		 * If compression was already enabled, keep the algorithm that
> +		 * is recorded in the compression property. Otherwise changing
> +		 * an unrelated attribute would reset it to the mount default,
> +		 * since FS_IOC_SETFLAGS callers pass back the whole flag set
> +		 * they got from FS_IOC_GETFLAGS.
> +		 *
> +		 * Fall back to the default when compression is being enabled
> +		 * by this call, or when the inode has the compress flag set
> +		 * but no property, which is possible on filesystems touched by
> +		 * kernels that did not keep the two in sync.
> +		 */
> +		if (old_fsflags & FS_COMPR_FL)
> +			comp =3D btrfs_compress_type2str(inode->prop_compress);

I do not think we need to always use the string.

We can directly use the compression type and convert it to string at the=
=20
last second.

And we can skip the old_fsflags check and directly check=20
inode->prop_compress.

E.g. something like the following will be a little easier to read:

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ebfb258161c8..befc0df0d5ab 100644
=2D-- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -384,6 +384,7 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
                 inode_flags &=3D ~BTRFS_INODE_COMPRESS;
                 inode_flags |=3D BTRFS_INODE_NOCOMPRESS;
         } else if (fsflags & FS_COMPR_FL) {
+               enum btrfs_compression_type comp_type;

                 if (IS_SWAPFILE(&inode->vfs_inode))
                         return -ETXTBSY;
@@ -391,9 +392,13 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
                 inode_flags |=3D BTRFS_INODE_COMPRESS;
                 inode_flags &=3D ~BTRFS_INODE_NOCOMPRESS;

-               comp =3D btrfs_compress_type2str(fs_info->compress_type);
-               if (!comp || comp[0] =3D=3D 0)
-                       comp =3D btrfs_compress_type2str(BTRFS_COMPRESS_ZL=
IB);
+               if (inode->prop_compress)
+                       comp_type =3D inode->prop_compress;
+               else if (fs_info->compress_type)
+                       comp_type =3D fs_info->compress_type;
+               else
+                       comp_type =3D BTRFS_COMPRESS_ZLIB;
+               comp =3D btrfs_compress_type2str(comp_type);
         } else {
                 inode_flags &=3D ~(BTRFS_INODE_COMPRESS |=20
BTRFS_INODE_NOCOMPRESS);
         }

Thanks,
Qu

> +		if (!comp || comp[0] =3D=3D 0) {
> +			comp =3D btrfs_compress_type2str(fs_info->compress_type);
> +			if (!comp || comp[0] =3D=3D 0)
> +				comp =3D btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
> +		}
>   	} else {
>   		inode_flags &=3D ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
>   	}

