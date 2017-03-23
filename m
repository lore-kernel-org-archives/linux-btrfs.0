Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38763 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932644AbdCWRMY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Mar 2017 13:12:24 -0400
Subject: Re:
To: Ilan Schwarts <ilan84@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAJUuSvHkhpFSf_5V_KDev4i2AosQcgZTUvuF57YMng2kGpGVaw@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <c1750806-7329-9abb-c3af-35b4e021b73a@suse.com>
Date: Thu, 23 Mar 2017 13:12:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAJUuSvHkhpFSf_5V_KDev4i2AosQcgZTUvuF57YMng2kGpGVaw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="opnv7Asgv1iBqRNPO70RHlut5b8CtQTvU"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--opnv7Asgv1iBqRNPO70RHlut5b8CtQTvU
Content-Type: multipart/mixed; boundary="w1jrKQ1iTUJbgTpFLNuo67igmRRRwa3Uq";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Ilan Schwarts <ilan84@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <c1750806-7329-9abb-c3af-35b4e021b73a@suse.com>
Subject: Re:
References: <CAJUuSvHkhpFSf_5V_KDev4i2AosQcgZTUvuF57YMng2kGpGVaw@mail.gmail.com>
In-Reply-To: <CAJUuSvHkhpFSf_5V_KDev4i2AosQcgZTUvuF57YMng2kGpGVaw@mail.gmail.com>

--w1jrKQ1iTUJbgTpFLNuo67igmRRRwa3Uq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/19/17 11:00 AM, Ilan Schwarts wrote:
> Hi,
> sorry if this is a newbie question. I am newbie.
>=20
> In my kernel driver, I get device id by converting struct inode struct
> to btrfs_inode, I use the code:
> struct btrfs_inode *btrfsInode;
> btrfsInode =3D BTRFS_I(inode);
>=20
> I usually download kernel-headers rpm package, this is not enough. it
> fails to find the btrfs header files.
>=20
> I had to download them not via rpm package and declare:
> #include "/data/kernel/linux-4.1.21-x86_64/fs/btrfs/ctree.h"
> #include "/data/kernel/linux-4.1.21-x86_64/fs/btrfs/btrfs_inode.h"
>=20
> This is not good, why ctree.h and btrfs_inode.h are not in kernel heade=
rs?
> Is there another package i need to download in order to get them, in
> addition to kernel-headers? ?
>=20
>=20
> I see they are not provided in kernel-header package, e.g:
> https://rpmfind.net/linux/RPM/fedora/23/x86_64/k/kernel-headers-4.2.3-3=
00.fc23.x86_64.html

I don't know what Fedora package you'd use, but the core problem is that
you're trying to use internal structures in an external module.  We've
properly exported the constants and structures required for userspace to
interact with btrfs, but there are no plans to export internal structures=
=2E

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--w1jrKQ1iTUJbgTpFLNuo67igmRRRwa3Uq--

--opnv7Asgv1iBqRNPO70RHlut5b8CtQTvU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWNQB9B57S2MheeWyAQjr9A//dd6pj+hf3vn3127gVVXhgmqJ2m6ToGB9
afqWEZhF0Lsa+TjMias9mmaFduXjxz6R2DA5X0hFBm1QopDvfGAoBEvxYDxu1NAh
FnNtOzNtU2MyV09MKEC9Cxfv0yvI+ys9c/Hg89bDIevKNSRI4crYJG3ZEgcIiqgM
XMn1omnuPbNPHapGmfDdQtS8zW0tRrcqugxcStOQyKs746Ky79RW/ujaL6VdRUWQ
pgcV6TGBje8ENSkFh6OBZiGnRnamaLFkqSob1MS/GvAVvBBdBZ/djs+CFjq73BJC
DghKJxlSNvCecrOkO7CEebg9ymLn5/+Dw34ieQxcuIyRS4Ll7dZCE8ozvoZwaE56
7M/qercJqHp5OVJ73QrvnroquL8Y5KHpL7q8TN8LGU3KuUiXFviAkx6HMhpyte+x
wgCA6gGEOs8z9RZLDkFv9734wcoxvZYqw/+pIQvTS+LVYOQkzbCy+chSd7QOgiKi
qJUi++QFOyaHTGMmVoh9CNfnq7po2YVzazwkNUoo4bBIoFDGgXWbd7lWjuehjiQo
vDffuMB9USzeIdISFPMas6c3v6IDco+p2ArdBDGz7OhWStFMzPxD1ai+lp+8z9ct
/PeI0D9ENY2UASp6bM5LULTjK4kjmnKNOAPUhZtDU8h5rlZSVPOI2qm3UDsmtMyB
V96ffNxKFnQ=
=pv+L
-----END PGP SIGNATURE-----

--opnv7Asgv1iBqRNPO70RHlut5b8CtQTvU--
