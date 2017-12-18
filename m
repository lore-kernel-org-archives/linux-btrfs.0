Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57652 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757508AbdLRBUQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Dec 2017 20:20:16 -0500
Subject: Re: Unexpected raid1 behaviour
To: Dark Penguin <darkpenguin@yandex.ru>, linux-btrfs@vger.kernel.org
References: <5A357909.8010206@yandex.ru>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4d526204-a30e-8a41-124e-f639cdbe5ba7@gmx.com>
Date: Mon, 18 Dec 2017 09:20:10 +0800
MIME-Version: 1.0
In-Reply-To: <5A357909.8010206@yandex.ru>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iQXMeXbHG595JMj1F1w5V9E7FjGTGukn2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iQXMeXbHG595JMj1F1w5V9E7FjGTGukn2
Content-Type: multipart/mixed; boundary="JWQEmvNr7gvpfraBilCs072oG2xotjmXo";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dark Penguin <darkpenguin@yandex.ru>, linux-btrfs@vger.kernel.org
Message-ID: <4d526204-a30e-8a41-124e-f639cdbe5ba7@gmx.com>
Subject: Re: Unexpected raid1 behaviour
References: <5A357909.8010206@yandex.ru>
In-Reply-To: <5A357909.8010206@yandex.ru>

--JWQEmvNr7gvpfraBilCs072oG2xotjmXo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8817=E6=97=A5 03:50, Dark Penguin wrote:
> Could someone please point me towards some read about how btrfs handles=

> multiple devices? Namely, kicking faulty devices and re-adding them.
>=20
> I've been using btrfs on single devices for a while, but now I want to
> start using it in raid1 mode. I booted into an Ubuntu 17.10 LiveCD and
> tried to see how does it handle various situations.
> The experience left
> me very surprised; I've tried a number of things, all of which produced=

> unexpected results.
>=20
> I create a btrfs raid1 filesystem on two hard drives and mount it.

Initial info like "btrfs fi df" will help us to dig this further.

>=20
> - When I pull one of the drives out (simulating a simple cable failure,=

> which happens pretty often to me), the filesystem sometimes goes
> read-only. ???

Please provide the kernel message.

> - But only after a while, and not always. ???
> - When I fix the cable problem (plug the device back), it's immediately=

> "re-added" back. But I see no replication of the data I've written onto=

> a degraded filesystem... Nothing shows any problems, so "my filesystem
> must be ok". ???

Needs extra info like "btrfs fi df"

> - If I unmount the filesystem and then mount it back, I see all my
> recent changes lost (everything I wrote during the "degraded" period).
> - If I continue working with a degraded raid1 filesystem (even without
> damaging it further by re-adding the faulty device), after a while it
> won't mount at all, even with "-o degraded".

Please provide kernel message too.
Although I doubt about the usefulness, it's still better than none.

Thanks,
Qu

>=20
> I can't wrap my head about all this. Either the kicked device should no=
t
> be re-added, or it should be re-added "properly", or it should at least=

> show some errors and not pretend nothing happened, right?..
>=20
> I must be missing something. Is there an explanation somewhere about
> what's really going on during those situations? Also, do I understand
> correctly that upon detecting a faulty device (a write error), nothing
> is done about it except logging an error into the 'btrfs device stats'
> report? No device kicking, no notification?.. And what about degraded
> filesystems - is it absolutely forbidden to work with them without
> converting them to a "single" filesystem first?..
>=20
> On Ubuntu 17.10, there's Linux 4.13.0-16 and btrfs-progs 4.12-1 .
>=20
>=20


--JWQEmvNr7gvpfraBilCs072oG2xotjmXo--

--iQXMeXbHG595JMj1F1w5V9E7FjGTGukn2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo3F8sXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhP4ggAsBCBWZDZGCufMRrFGgEbp7gc
n86glBoJnIKXz2kFmyYZRocGlEzQ81GNu6wDCCM8GQ46yE0JLHEUkVZTc+FoT+A7
nyjGytpFrp4iXnclsBoVtcupHXqWpPFRzgy/HwBkpf1GKxmS5bbfqk+V+F2VeoJH
2jWioOOa31S1N/48PU3UhTifJjiMzvFp8jyw6NeXVc3Czs4k+0gT2N+2nLNB8nDc
8YiTX9+oaHaqQtrPBhh4llKxpv4wMWYUK8C4HPIfmlPMzXly2rJbJnRpViqHMbbz
hk8INCcoBgAgWSrQY5DaGAU9P0FNa0kHIDvoyhTfB8EBjUJrupcpfRCYr/52wg==
=oNy1
-----END PGP SIGNATURE-----

--iQXMeXbHG595JMj1F1w5V9E7FjGTGukn2--
