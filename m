Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46191 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750972AbcFXQcO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 12:32:14 -0400
Date: Fri, 24 Jun 2016 12:32:12 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160624163212.GD14667@hungrycats.org>
References: <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org>
 <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <CAJCQCtT57k7Mirq=d6wTewY6EzvJE0g28EbmG9wLk+6cTASEEg@mail.gmail.com>
 <20160624020712.GC14667@hungrycats.org>
 <CAJCQCtSt832VcaKanj9cn9wY6+FZ68G9mOuSS=8i-AzmGQuV9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FFoLq8A0u+X9iRU8"
In-Reply-To: <CAJCQCtSt832VcaKanj9cn9wY6+FZ68G9mOuSS=8i-AzmGQuV9g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FFoLq8A0u+X9iRU8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 23, 2016 at 11:20:40PM -0600, Chris Murphy wrote:
> [root@f24s ~]# filefrag -v /mnt/5/*
> Filesystem type is: 9123683e
> File size of /mnt/5/a.txt is 16383 (4 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..       0:    2931732..   2931732:      1:
>    1:        1..       3:    2931713..   2931715:      3:    2931733: las=
t,eof
> /mnt/5/a.txt: 2 extents found
> File size of /mnt/5/b.txt is 16383 (4 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..       3:    2931716..   2931719:      4:             las=
t,eof
> /mnt/5/b.txt: 1 extent found
> File size of /mnt/5/c.txt is 16383 (4 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..       3:    2931720..   2931723:      4:             las=
t,eof
> /mnt/5/c.txt: 1 extent found
> File size of /mnt/5/d.txt is 16383 (4 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..       3:    2931724..   2931727:      4:             las=
t,eof
> /mnt/5/d.txt: 1 extent found
> File size of /mnt/5/e.txt is 16383 (4 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..       3:    2931728..   2931731:      4:             las=
t,eof
> /mnt/5/e.txt: 1 extent found

> So at the old address, it shows the "aaaaa..." is still there. And at
> the added single block for this file at new logical and physical
> addresses, is the modification substituting the first "a" for "g".
>=20
> In this case, no rmw, no partial stripe modification, and no data
> already on-disk is at risk. Even the metadata leaf/node is cow'd, it
> has a new logical and physical address as well, which contains
> information for all five files.

Well, of course not.  You're not setting up the conditions for failure.
The extent at 2931712..2931715 is 4 blocks long, so when you overwrite
part of the extent all 4 blocks remain occupied.

You need extents that are shorter than the stripe width, and you need to
write to the same stripe in two different btrfs transactions (i.e. you
need to delete an extent and then have a new extent mapped in the old
location).

--FFoLq8A0u+X9iRU8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldtYIwACgkQgfmLGlazG5wS8QCdFibpVTveDkGyPAbMJ5gOwA9Z
ITMAoMN/Uf/Cj6peNmRgzAqlpj2aJzTG
=Cww0
-----END PGP SIGNATURE-----

--FFoLq8A0u+X9iRU8--
