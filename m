Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50796 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750936AbeANJM2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 04:12:28 -0500
Subject: Re: Fwd: Fwd: Question regarding to Btrfs patchwork /2831525
To: Ilan Schwarts <ilan84@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAJUuSvFtEG=CZPjhACCvp8hVA83xFuFpJcScx4xAj4tPkW8uCw@mail.gmail.com>
 <CAJUuSvHo6N+esmjX8+Ly+kV+Nm1bUB=f85Mv=_xoyiLaUFA-ug@mail.gmail.com>
 <20170301180817.GJ4662@suse.cz>
 <CAJUuSvHpP-GV50P9dDJxX-WyzqtoHZLiuOVdLTMvR8k9EL_08w@mail.gmail.com>
 <CAJUuSvFUFnxuoXDE0+ykTXYN4B4GOWps7rAYAiHom6NKMX2nFA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <baec6e41-0481-6407-18a6-ebaefda5f86b@gmx.com>
Date: Sun, 14 Jan 2018 17:12:20 +0800
MIME-Version: 1.0
In-Reply-To: <CAJUuSvFUFnxuoXDE0+ykTXYN4B4GOWps7rAYAiHom6NKMX2nFA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iyJZs0S31tjWQQEt2kzP9p6KUk3Ud1Cwt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iyJZs0S31tjWQQEt2kzP9p6KUk3Ud1Cwt
Content-Type: multipart/mixed; boundary="eKxrXHA1lqJ7QF32Kv6ZsNc9mWQ3Noqxz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Ilan Schwarts <ilan84@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <baec6e41-0481-6407-18a6-ebaefda5f86b@gmx.com>
Subject: Re: Fwd: Fwd: Question regarding to Btrfs patchwork /2831525
References: <CAJUuSvFtEG=CZPjhACCvp8hVA83xFuFpJcScx4xAj4tPkW8uCw@mail.gmail.com>
 <CAJUuSvHo6N+esmjX8+Ly+kV+Nm1bUB=f85Mv=_xoyiLaUFA-ug@mail.gmail.com>
 <20170301180817.GJ4662@suse.cz>
 <CAJUuSvHpP-GV50P9dDJxX-WyzqtoHZLiuOVdLTMvR8k9EL_08w@mail.gmail.com>
 <CAJUuSvFUFnxuoXDE0+ykTXYN4B4GOWps7rAYAiHom6NKMX2nFA@mail.gmail.com>
In-Reply-To: <CAJUuSvFUFnxuoXDE0+ykTXYN4B4GOWps7rAYAiHom6NKMX2nFA@mail.gmail.com>

--eKxrXHA1lqJ7QF32Kv6ZsNc9mWQ3Noqxz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8814=E6=97=A5 16:33, Ilan Schwarts wrote:
> Hello btrfs developers/users,
>=20
> I was wondering regarding to fetching the correct fsid on btrfs from
> the context of a kernel module.

There are two IDs for btrfs. (in fact more, but you properly won't need
the extra ids)

FSID: Global one, one fs one FSID.
Device ID: Bonded to device, each device will have one.

So in case of 2 devices btrfs, each device will has its own device id,
while both of the devices have the same fsid.

And I think you're talking about the global fsid instead of device id.

> if on suse11.3 kernel 3.0.101-0.47.71-default in order to get fsid, I
> do the following:
> convert inode struct to btrfs_inode struct (use btrfsInode =3D
> BTRFS_I(inode)), then from btrfs_inode struct i go to root field, and
> from root i take anon_dev or anon_super.s_dev.
>         struct btrfs_inode *btrfsInode;
>         btrfsInode =3D BTRFS_I(inode);
>        btrfsInode->root->anon_super.s_dev    or
>        btrfsInode->root->anon_dev    - depend on kernel.

The most directly method would be:

btrfs_inode->root->fs_info->fsid.

Or from superblock:
btrfs_inode->root->fs_info->super_copy->fsid.

For device id, it's not that commonly used unless you're dealing with
chunk mapping, so I'm assuming you're referring to fsid.

Thanks,
Qu

>=20
> In kernel 3.12.28-4-default in order to get the fsid, i need to go
> to the inode -> superblock -> device id (inode->i_sb->s_dev)
>=20
> Why is this ? and is there a proper/an official way to get it ?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--eKxrXHA1lqJ7QF32Kv6ZsNc9mWQ3Noqxz--

--iyJZs0S31tjWQQEt2kzP9p6KUk3Ud1Cwt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpbHvQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiagAgAgEYbRQWa+KRC/LzobFMyLZ4N
Rj7+7L47Eic/nzPlv9J8lDAhvuizssRYXfSVAv7bElbgTONo+OskprLYqGdCq45b
T4sZBeDlT5oZ4zIgGbmSnLRM7VM+JRuXJ+EiZi2iHKWQJ4LXOW8Wk7id/SD5zFeG
Xy1pDw/ub0FmCDzruwe8qRYg6GHav1VEtPLR8EKAsMgKHhgvZ/Jxth1kYhUT6Lkg
C2+k1kB+DtgVKAJtnndiYuZiZcaXR4DtFsSNLpgSCkJqJchdT1avxteleI0p/tKY
3MLrQRmdF0EZINRiOuay6Bw8XwJYdnX4p8rYHYpZHK541Y2nfz/HNLOcXO5ViQ==
=6gkR
-----END PGP SIGNATURE-----

--iyJZs0S31tjWQQEt2kzP9p6KUk3Ud1Cwt--
