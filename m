Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55792 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753000AbdKWAl4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 19:41:56 -0500
Subject: Re: uncorrectable errors in Raid 10
To: Steffen Sindzinski <stesind@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
References: <a61eeda7-af07-e140-ccd9-d288931f07fb@gmail.com>
 <CAJCQCtSLG5hXikEiBD4OF5G+EfKgyALaynqivBvCaWLpEYQjEw@mail.gmail.com>
 <1c612777-77eb-1b83-101b-a9e0a53ee8be@gmail.com>
 <CAJCQCtRwO5E_xN-7u22uBQ57sYpUf8qQ7O0Abz2m+K8e9+DgdA@mail.gmail.com>
 <384b4a21-e74f-c52e-c6e2-f7930f187c94@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ee15f3b3-43b2-ee68-91b4-3a00af93b447@gmx.com>
Date: Thu, 23 Nov 2017 08:41:48 +0800
MIME-Version: 1.0
In-Reply-To: <384b4a21-e74f-c52e-c6e2-f7930f187c94@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gbhBLshgMRkUqoqEpUKWqWxLR3fGoVdrS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gbhBLshgMRkUqoqEpUKWqWxLR3fGoVdrS
Content-Type: multipart/mixed; boundary="dChnR4rDUSXjb0LpoiVAjsQXqmpIx6pDp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Steffen Sindzinski <stesind@gmail.com>,
 Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <ee15f3b3-43b2-ee68-91b4-3a00af93b447@gmx.com>
Subject: Re: uncorrectable errors in Raid 10
References: <a61eeda7-af07-e140-ccd9-d288931f07fb@gmail.com>
 <CAJCQCtSLG5hXikEiBD4OF5G+EfKgyALaynqivBvCaWLpEYQjEw@mail.gmail.com>
 <1c612777-77eb-1b83-101b-a9e0a53ee8be@gmail.com>
 <CAJCQCtRwO5E_xN-7u22uBQ57sYpUf8qQ7O0Abz2m+K8e9+DgdA@mail.gmail.com>
 <384b4a21-e74f-c52e-c6e2-f7930f187c94@gmail.com>
In-Reply-To: <384b4a21-e74f-c52e-c6e2-f7930f187c94@gmail.com>

--dChnR4rDUSXjb0LpoiVAjsQXqmpIx6pDp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8823=E6=97=A5 00:38, Steffen Sindzinski wrote:
> Hello,
>=20
> I did btrfs check --readonly on both disk without finding any error. To=

> reconfirm I did a scrub again which still has found 2 uncorrectable

Still metadata corruption?

> errors. I had to boot into Arch Linux 4.13.12-1-ARCH
> btrfs-progs v4.13 to run btrfs check.

Well, btrfs-progs v4.13 from Arch is out-of-data for a while.
Even ignoring the latest v4.14 release, there is no v4.13.x releases for
Arch.

>=20
>=20
> Checking filesystem on /dev/sde2
> UUID: 4fafd0d4-7dd9-4dcc-9a33-5f1ad9555358
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 1598669742080 bytes used, no error found
> total csum bytes: 1540740308
> total tree bytes: 19391266816
> total fs tree bytes: 9844703232
> total extent tree bytes: 6808731648
> btree space waste bytes: 3471512438
> file data blocks allocated: 2124703174656
> =C2=A0referenced 1454353633280
> sudo btrfs check --readonly /dev/sde2=C2=A0 2708,20s user 594,58s syste=
m 15%
> cpu 5:45:40,36 total
> ***********************************************************************=

> sudo btrfs check --readonly /dev/sdd2
> Checking filesystem on /dev/sdd2
> UUID: 4fafd0d4-7dd9-4dcc-9a33-5f1ad9555358
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 1598669742080 bytes used, no error found
> total csum bytes: 1540740308
> total tree bytes: 19391266816
> total fs tree bytes: 9844703232
> total extent tree bytes: 6808731648
> btree space waste bytes: 3471512438
> file data blocks allocated: 2124703174656
> =C2=A0referenced 1454353633280
> sudo btrfs check --readonly /dev/sdd2=C2=A0 2655,23s user 626,48s syste=
m 15%
> cpu 5:56:16,85 total

Just as Chris mentioned, if the scrub is reporting metadata corruption,
please try "btrfs check --mode=3Dlowmem" to see if lowmem mode can detect=

such corruption.

>=20
>=20
> I mentioned that I cannot access 2 directories anymore. Permission is
> denied, not even as root I have permission nor I can change ownership.
> This happens in Ubuntu 17.10, kernel 4.13.0-17-generic. It looks like t=
his:
>=20
> ls -la The*
> The-Wire:
> ls: Zugriff auf 'The-Wire/.' nicht m=C3=B6glich: Keine Berechtigung
> ls: Zugriff auf 'The-Wire/..' nicht m=C3=B6glich: Keine Berechtigung
> <...>
> insgesamt 0
> d????????? ? ? ? ?=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ? .
> d????????? ? ? ? ?=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ? ..
> -????????? ? ? ? ?=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ? The Wire S1E10.m4v
> -????????? ? ? ? ?=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ? The Wire S1E11.m4v

Normally this means DIR_INDEX/DIR_ITEM missing or points to incorrect ino=
de.

> <...>
>=20
> Oddly in Arch Linux, 4.13.12-1-ARCH, btrfs-progs v4.13, I can access
> this same directory, permission is set correctly.>
> The debug trees for both drives you may find attached to this mail. The=
y
> were done in Ubunutu.

Not really helping.
I don't know how you take the dump, but it is only a leaf of subvolume,
full of EXTENT_DATA without any useful info.

Thanks,
Qu

>=20
> For reference here the scrub report on Arch linux.
>=20
>=20
> Steffen
>=20
>=20
>=20
> Am 20.11.2017 um 21:26 schrieb Chris Murphy:
>> On Mon, Nov 20, 2017 at 1:36 AM, Steffen Sindzinski
>> <stesind@gmail.com> wrote:
>>> Hi,
>>>
>>> I did btrfs-debug-tree for this block on both devices. The result is
>>> attached to this mail.
>>>
>>> It is really weird, same block, different drives, different sector. I=

>>> have
>>> no problem with bit rod. Btrfs worked perfectly fine with this both
>>> HDDs for
>>> so long on Raid1. The drive sdf1 which I attached to form a Raid 10
>>> was also
>>> in a different Btrfs in the same machine for years flawlessly.
>>>
>>> I have not found any other checksum errors than the ones from this
>>> scrub.
>>>
>>> Is there no way to just safely recreate the checksum of this particul=
ar
>>> block from the disk contents?
>>
>> I'll cc Qu because I don't understand what's going on. It's the 2nd
>> case of both copies of metadata being bad in as many days, which could=

>> just be coincidence.
>>
>> I also don't understand the specific error "checksum/header error"
>> which sounds to me like Btrfs knows the leaf is otherwise OK, but
>> there is some kind of problem with either the leaf csum or its header.=

>> In which case I'd like to think that btrfs check --repair can fix this=

>> kind of problem.
>>
>> What do you get for btrfs check without --repair?
>>
>> Curiously, your scrub complains about this "checksum/header error" but=

>> btrfs-debug-tree gives no indication that leaf has any problem at all.=

>>
>>
>>
>>


--dChnR4rDUSXjb0LpoiVAjsQXqmpIx6pDp--

--gbhBLshgMRkUqoqEpUKWqWxLR3fGoVdrS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloWGUwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiZwgf9EaA5ySaIN0+XoUUtViVDjkW2
JrJx0AvcFEZnqswWbHXQdriKq6U8PC5bHPiOaFh9ZZFA39oNNDxYBUQkIPGKFAGM
tOXzGJf01wdtoA7nuxmQQAFtNqhU+rxFhoKC8mhtZWA9JvY8jo8SnSs3aRJFAUho
Cr9fxyabsy4vIKS8sdqLPHS7DewkVHevEDr5hEPMrtsUnnA9g4VK3GNSjZ02PD9s
ZyYa3Q5/dqx/59gFcYWhipuUbkpyeIHRuQI5NxQkLfevxhXVWEB3mTfI+7uZeksr
7iqpfNGVCzYiT+a4GLRw/1GQNkzu6Irv5u8dBd9XNFCNMbrPbjXC+fDSVhpp3w==
=j5ep
-----END PGP SIGNATURE-----

--gbhBLshgMRkUqoqEpUKWqWxLR3fGoVdrS--
