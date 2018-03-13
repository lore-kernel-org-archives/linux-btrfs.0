Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58771 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932274AbeCMC1f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 22:27:35 -0400
Subject: Re: Btrfs broken in massive transfar
To: MASAKI haruka <yek@reasonset.net>, linux-btrfs@vger.kernel.org
References: <20180313065743.c3ec9ade3e90dc4fc4b5adc9@reasonset.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f4e1a551-fc29-f7e8-a738-76365af403f7@gmx.com>
Date: Tue, 13 Mar 2018 10:27:20 +0800
MIME-Version: 1.0
In-Reply-To: <20180313065743.c3ec9ade3e90dc4fc4b5adc9@reasonset.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="N1G9RIMT8YOTnVtT2DNHCH7aZIO0Ume5L"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N1G9RIMT8YOTnVtT2DNHCH7aZIO0Ume5L
Content-Type: multipart/mixed; boundary="mS5Bh5Iy7orRNtmErrCK5Lt0SFk1ZPJ6J";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: MASAKI haruka <yek@reasonset.net>, linux-btrfs@vger.kernel.org
Message-ID: <f4e1a551-fc29-f7e8-a738-76365af403f7@gmx.com>
Subject: Re: Btrfs broken in massive transfar
References: <20180313065743.c3ec9ade3e90dc4fc4b5adc9@reasonset.net>
In-Reply-To: <20180313065743.c3ec9ade3e90dc4fc4b5adc9@reasonset.net>

--mS5Bh5Iy7orRNtmErrCK5Lt0SFk1ZPJ6J
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 05:57, MASAKI haruka wrote:
> I'm trying to clone 18TiB data between btrfs,
> but it will crash anyway.
>=20
> This probrem is occured even how to clone (btrfs send/receive, rsync or=
 cp.)
> I experienced same probrem in Linux 3.9 and Linux 3.10.

Did you really mean *3*.9 and *3*.10?

That's too old for btrfs usage IIRC.

It would be *4*.9 or *4*.10 for a relative new kernel for btrfs.

Would you please try some latest mainline kernel again?

>=20
> What happen:
>=20
> 1. Failed to write because I/O error (read only filesystem)
> 2. writing to the btrfs succeeds and fails randomly.
> 3. The btrfs unable to unmount (resource is busy.) Unable to umount eve=
n forcely, so cannot halt.
>=20
> Example:
> ---
> mkfile o7784-11-0
> rename o7784-11-0 -> .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5=
xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw
> utimes .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/=
XDGOWpbx,5zYWEi0L5LHdWBo
> truncate .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK=
3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw size=3D1073698824
> chown .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/X=
DGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw - uid=3D1000, gid=3D1000=

> chmod .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/X=
DGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw - mode=3D0600
> utimes .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/=
XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw
> mkfile o7785-12-0
> rename o7785-12-0 -> .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5=
xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/lSABmfoArm9pAtade-gHmS6X
> utimes .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/=
XDGOWpbx,5zYWEi0L5LHdWBo
> truncate .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK=
3/XDGOWpbx,5zYWEi0L5LHdWBo/lSABmfoArm9pAtade-gHmS6X size=3D864067592
> ERROR: truncate .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOc=
XhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/lSABmfoArm9pAtade-gHmS6X failed: Input/=
output error
> btrfs send 180310235348  0.09s user 11.98s system 16% cpu 1:14.42 total=

> ---

In that case, we need kernel message to investigate.
(And of course, please use at least 4.x kernel)

Thanks,
Qu

>=20
> Tries:
> 1.
> Connect between host A (btrfs, 4disks) and B with socat (TCP).
> Host B write to iSCSI disk (btrfs, single).
> clone with btrfs send/receive. Linux 4.15.
> -> Crashed at transfarred 1.78TB
>=20
> 2.
> Delete snapshot and retry.
> Connect between host A and B with SSH and socat (UNIX).
> Host B write to iSCSI disk (btrfs, single).
> clone with btrfs send/receive. Linux 4.15.
> -> Crashed at transfarred 90GB
>=20
> 3.
> Recreate btrfs.
> Host A write to iSCSI disk.
> clone with btrfs send/receive. Linux 4.15.
> -> Crashed at transfarred 260GB
>=20
> 4.
> Recreate btrfs.
> Original disk attach to other computer (having more resource.)
> clone with btrfs send/receive. Linux 4.15.
> -> Crashed at transfarred 120GB
>=20
> 5.
> Recreate btrfs.
> Clone with rsync. Linux 4.15.
> -> Crashed at transfarred 100GB
>=20
> 6.
> Recreate btrfs.
> Try with Linux 4.14, btrfs send/receive.
> -> Crashed at transfarred 3.98TB
>=20
> 7.
> Recreate btrfs.
> Connect between host and NAS (iSCSI) with GbE cable directly.
> Mounted with options relatime, spase_cache, compress=3Dlzo.
> clone with btrfs send/receive. Linux 4.14.
> -> Crashed at transfarred 2.13TB
>=20


--mS5Bh5Iy7orRNtmErrCK5Lt0SFk1ZPJ6J--

--N1G9RIMT8YOTnVtT2DNHCH7aZIO0Ume5L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqnNwgXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiiyAf+Ng+OoCvfmH3ut+0k5z/tmVyu
PGFjanS31SCFkAegko1kVoBveClu9XzzmDMUEOFB1QHU44n3dHrfzn2bhsuOTjo2
hXE2ulo+g/CY7LFdZsqDMspPdSVZs4QuBaJcdX01pG1tmyuZnoVBIGBnk5HTQ6gG
IkbJgcwa3ccKV4znHaPYTSL78QvKFVFy8QdWGGYyyCa21xHgHI8Sl1iUEQ2hklaF
+P/7X1wT2a5HT+kprfNYMEM/0P4nZSBE38Ih1CYKOHNgzcpie+czJuYtgxDtzFAa
RRS/Zzbfr59tYqs1R3fio8GhTEyuJCIqNjMar0nbrL7bTyNKmOrzv0bPxAS3UA==
=ac6P
-----END PGP SIGNATURE-----

--N1G9RIMT8YOTnVtT2DNHCH7aZIO0Ume5L--
