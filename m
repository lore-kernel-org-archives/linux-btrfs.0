Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60778 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750915AbeANJNx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 04:13:53 -0500
Subject: Re: Fwd: Fwd: Question regarding to Btrfs patchwork /2831525
To: Ilan Schwarts <ilan84@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAJUuSvFtEG=CZPjhACCvp8hVA83xFuFpJcScx4xAj4tPkW8uCw@mail.gmail.com>
 <CAJUuSvHo6N+esmjX8+Ly+kV+Nm1bUB=f85Mv=_xoyiLaUFA-ug@mail.gmail.com>
 <20170301180817.GJ4662@suse.cz>
 <CAJUuSvHpP-GV50P9dDJxX-WyzqtoHZLiuOVdLTMvR8k9EL_08w@mail.gmail.com>
 <CAJUuSvFUFnxuoXDE0+ykTXYN4B4GOWps7rAYAiHom6NKMX2nFA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e9ccb880-dfb3-aba6-d05a-869c53ec69d8@gmx.com>
Date: Sun, 14 Jan 2018 17:13:46 +0800
MIME-Version: 1.0
In-Reply-To: <CAJUuSvFUFnxuoXDE0+ykTXYN4B4GOWps7rAYAiHom6NKMX2nFA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hyZp83VgHOc8p7Te47lOGW25IqI3GX9AW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hyZp83VgHOc8p7Te47lOGW25IqI3GX9AW
Content-Type: multipart/mixed; boundary="NECeTTwWSyqxcwgWnP1eb40nYN16sjiBy";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Ilan Schwarts <ilan84@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <e9ccb880-dfb3-aba6-d05a-869c53ec69d8@gmx.com>
Subject: Re: Fwd: Fwd: Question regarding to Btrfs patchwork /2831525
References: <CAJUuSvFtEG=CZPjhACCvp8hVA83xFuFpJcScx4xAj4tPkW8uCw@mail.gmail.com>
 <CAJUuSvHo6N+esmjX8+Ly+kV+Nm1bUB=f85Mv=_xoyiLaUFA-ug@mail.gmail.com>
 <20170301180817.GJ4662@suse.cz>
 <CAJUuSvHpP-GV50P9dDJxX-WyzqtoHZLiuOVdLTMvR8k9EL_08w@mail.gmail.com>
 <CAJUuSvFUFnxuoXDE0+ykTXYN4B4GOWps7rAYAiHom6NKMX2nFA@mail.gmail.com>
In-Reply-To: <CAJUuSvFUFnxuoXDE0+ykTXYN4B4GOWps7rAYAiHom6NKMX2nFA@mail.gmail.com>

--NECeTTwWSyqxcwgWnP1eb40nYN16sjiBy
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
(For newer kernel, as I'm not familiar with older kernels)

Or from superblock:
btrfs_inode->root->fs_info->super_copy->fsid.
(The most reliable one, no matter which kernel version you're using, as
long as the super block format didn't change)

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


--NECeTTwWSyqxcwgWnP1eb40nYN16sjiBy--

--hyZp83VgHOc8p7Te47lOGW25IqI3GX9AW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpbH0oXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhjvgf7BsMrdup/xabjKkgO5SaDZWuT
ya/bIUPqWSQgx8IUBM5rl23juTEsOi1hdiZCbN3eV8lfmxsJXYsi7upncCh2h70g
aOPkx0aQ7b2yZOcrqpHWsk+xKPGrO0c7pwpI93VBskd8GhGSxqvjlgeXCjQoRfD1
QHvsccqmw77IShYlLdpipC9ANcQdgleermxIEbCFsiG16aaDWOy+bG8m0/aCchOA
5pWLAxIBNzIAcIsuRKLjxikfYVLLErtLl7oP6NhYBKGXxPNVS0QnzTrHRUh9K4H6
5aVTxpPwnxbJ5IU9t/1zrxf5hdkZsax6zwbaPCiQ3M2Yv5WQ3kWBoPnH2xlxDg==
=hcFs
-----END PGP SIGNATURE-----

--hyZp83VgHOc8p7Te47lOGW25IqI3GX9AW--
