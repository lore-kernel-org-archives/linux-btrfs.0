Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49853 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2F2Iq6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 04:46:58 -0400
Received: by wibhm11 with SMTP id hm11so696530wib.1
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 01:46:56 -0700 (PDT)
Message-ID: <4FED6B7D.5000800@grimmer.com>
Date: Fri, 29 Jun 2012 10:46:53 +0200
From: Lenz Grimmer <lenz@grimmer.com>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Error compiling btrfs-tools from git (undefined reference to
 `pthread_create')
References: <4FEAF872.10507@grimmer.com> <CAE5mzvhc-6S6AdY5uDxVqEegiTY_Sa3uFS-=1Ckit2T7rY4GOg@mail.gmail.com>
In-Reply-To: <CAE5mzvhc-6S6AdY5uDxVqEegiTY_Sa3uFS-=1Ckit2T7rY4GOg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8C04FA6A352DEB169497FAB5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8C04FA6A352DEB169497FAB5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

thank you for your reply.

On 06/27/2012 02:20 PM, cwillu wrote:
> On Wed, Jun 27, 2012 at 6:11 AM, Lenz Grimmer <lenz@grimmer.com> wrote:=

>> On Ubuntu 11.10 "Oneiric" with gcc 4.6.1, compiling the btrfs tools fr=
om git
>> fails for me with the following error:
>=20
> Which git repo?
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> builds on ubuntu just fine (just checked on a fresh checkout), and
> likewise the integration repo (but note that the integration repo's
> master branch is not useful to build; you need to check out one of the
> actual integration branches as described on the wiki).

That's likely the issue - the following commands reproduce the compile er=
ror
for me:

git clone http://git.darksatanic.net/repo/btrfs-progs-unstable.git btrfs-=
progs
cd btrfs-progs
make
[...]
gcc -lpthread -g -Werror -Os -o btrfs btrfs.o btrfs_cmds.o scrub.o \
		ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o
dir-item.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o
extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o btrfslabel.o  -=
luuid
scrub.o: In function `scrub_start':
/space/tmp/btrfs-progs/scrub.c:1342: undefined reference to `pthread_crea=
te'
/space/tmp/btrfs-progs/scrub.c:1360: undefined reference to `pthread_crea=
te'
/space/tmp/btrfs-progs/scrub.c:1374: undefined reference to `pthread_join=
'
/space/tmp/btrfs-progs/scrub.c:1430: undefined reference to `pthread_canc=
el'
/space/tmp/btrfs-progs/scrub.c:1432: undefined reference to `pthread_join=
'
collect2: ld returned 1 exit status


However, using the integration-20120605 branch compiles fine. Thanks and =
sorry
for the noise!

Bye,
	LenZ
--=20
  Lenz Grimmer <lenz@grimmer.com> - http://www.lenzg.net/




--------------enig8C04FA6A352DEB169497FAB5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk/ta30ACgkQSVDhKrJykfJlAQCfYK4ETkupcmlqypsssBEjsL1R
pFAAn3ECV/Xrkl8LKbclGTYLNAkbotHy
=lEN/
-----END PGP SIGNATURE-----

--------------enig8C04FA6A352DEB169497FAB5--
