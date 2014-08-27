Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39823 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbaH0KA4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 06:00:56 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Liu Bo <bo.li.liu@oracle.com>
Subject: Re: BTRFS claims that empty directory is not empty and refuses to delete it
Date: Wed, 27 Aug 2014 12:00:48 +0200
Message-ID: <2394955.49iCTHlx01@merkaba>
In-Reply-To: <20140715100125.GA4834@carfax.org.uk>
References: <5988448.153L8540y0@merkaba> <20140715100125.GA4834@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart46973659.xJNS4rncbs"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart46973659.xJNS4rncbs
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Dienstag, 15. Juli 2014, 11:01:25 schrieb Hugo Mills:
> On Tue, Jul 15, 2014 at 11:09:53AM +0200, Martin Steigerwald wrote:
> > Hello!
> >=20
> > This is with 3.16-rc4 =E2=80=93 stepped back to this one after havi=
ng two hangs in
> > one day with 3.16-rc5, see other thread started by me:
> >=20
> > martin@merkaba:~/Zeit/undeletable/db_data> ls -lid akonadi
> > 450598 drwx------ 1 martin martin 1232 Jun 22 14:11 akonadi
> > martin@merkaba:~/Zeit/undeletable/db_data> ls -lai akonadi
> > insgesamt 0
> > 450598 drwx------ 1 martin martin 1232 Jun 22 14:11 .
> > 450595 drwxr-xr-x 1 martin martin   14 Jun 22 14:11 ..
> > martin@merkaba:~/Zeit/undeletable/db_data> LANG=3DC rmdir akonadi
> > rmdir: failed to remove 'akonadi': Directory not empty
> > martin@merkaba:~/Zeit/undeletable/db_data#1> LANG=3DC rm -r akonadi=

> > rm: cannot remove 'akonadi': Directory not empty
> > martin@merkaba:~/Zeit/undeletable/db_data#1> LANG=3DC rm -rf akonad=
i
> > rm: cannot remove 'akonadi': Directory not empty
> > martin@merkaba:~/Zeit/undeletable/db_data#1>
> >=20
> >=20
> > Whats this?
> >=20
> > I had this weeks ago already and just moved it out of the way at th=
at
> > time,
> > just now stumbled upon it again.
>=20
>    That is symptomatic of a bug from a couple of kernel versions ago
> (now fixed, so it won't happen again). It it is that bug, then btrfs
> check will report something along the lines of "directory isize
> wrong", and the problem can be fixed by running a btrfs check
> --repair. If you get anything else from btrfs check (or it checks
> cleanly), then let us know first.

Thanks, Hugo. Just a heads up I was able to fix the issue and how btrfs=
 check=20
improved from 3.14.1 to 3.16 :)

Some time ago I can btrfs check 3.14.1 and while it fixed this undelete=
able file=20
it was able to fix another issue with that BTRFS fs:

enabling repair mode
Checking filesystem on /dev/msata/home
UUID: [=E2=80=A6]
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated=

checking fs roots
reset isize for dir 435395 root 256
reset isize for dir 435397 root 256
reset isize for dir 450598 root 256
reset isize for dir 2654270 root 256
btrfs: volumes.c:948: btrfs_alloc_chunk: Assertion `!(ret)' failed.
zsh: abort      btrfs check --repair /dev/msata/home


This one was still there:

Checking filesystem on /dev/msata/home
UUID: [=E2=80=A6]
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated=

checking fs roots
root 256 inode 5759476 errors 200, dir isize wrong
found 37709498062 bytes used err is 1
total csum bytes: 130574180
total tree bytes: 2897543168
total fs tree bytes: 2396323840
total extent tree bytes: 309051392
btree space waste bytes: 538971257
file data blocks allocated: 2757585866752
 referenced 135559811072
Btrfs v3.14.1

And it didn=C2=B4t want to fix it at all, asserting all along.

enabling repair mode
Checking filesystem on /dev/msata/home
UUID: [=E2=80=A6]
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated=

checking fs roots
btrfs: volumes.c:948: btrfs_alloc_chunk: Assertion `!(ret)' failed.


However

merkaba:/home/martin/Zeit> rm -r undeletable/

worked okay.


And now btrfs check 3.16 also cleaned up the last error:

merkaba:~> btrfs check /dev/msata/home
Checking filesystem on /dev/msata/home
UUID: [=E2=80=A6]
checking extents
checking free space cache
checking fs roots
root 256 inode 5759476 errors 200, dir isize wrong
found 51387055905 bytes used err is 1
total csum bytes: 128640084
total tree bytes: 2901934080
total fs tree bytes: 2398830592
total extent tree bytes: 306806784
btree space waste bytes: 547937419
file data blocks allocated: 2744207491072
 referenced 129598066688
Btrfs v3.16


merkaba:~#1> btrfs check --repair /dev/msata/home
enabling repair mode
Checking filesystem on /dev/msata/home
UUID: [=E2=80=A6]
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated=

checking fs roots
reset isize for dir 5759476 root 256
checking csums
checking root refs
found 51387055905 bytes used err is 0
total csum bytes: 128640084
total tree bytes: 2901934080
total fs tree bytes: 2398830592

I made sure the error is gone by doing another check and it is gone ind=
eed.


BTW I find "found 51387055905 bytes used err is 0" a bit ambigious. Whi=
le one=20
can say "err is 0" means no error, people may wonder whether there is a=
n error=20
or not. I assume that this is display a mismatch between the found byte=
s and=20
the bytes that are *supposed* to be there.

This all was on 3.17-rc2 with fixcompwrite patch v3 from Liu.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart46973659.xJNS4rncbs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlP9rFUACgkQmRvqrKWZhMcKmACgjv2YPkPk82D3GqEkbzVbpxU0
xRUAn0NI2Ys0wevFXv9p160q8Bnl7kWu
=uq0e
-----END PGP SIGNATURE-----

--nextPart46973659.xJNS4rncbs--

