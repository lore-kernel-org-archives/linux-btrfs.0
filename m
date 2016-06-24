Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:32804 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750847AbcFXCHO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 22:07:14 -0400
Date: Thu, 23 Jun 2016 22:07:12 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160624020712.GC14667@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org>
 <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org>
 <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <CAJCQCtT57k7Mirq=d6wTewY6EzvJE0g28EbmG9wLk+6cTASEEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
In-Reply-To: <CAJCQCtT57k7Mirq=d6wTewY6EzvJE0g28EbmG9wLk+6cTASEEg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 23, 2016 at 05:37:09PM -0600, Chris Murphy wrote:
> > So in your example of degraded writes, no matter what the on disk
> > format makes it discoverable there is a problem:
> >
> > A. The "updating" is still always COW so there is no overwriting.
>=20
> There is RMW code in btrfs/raid56.c but I don't know when that gets
> triggered.=20

RMW seems to be for cases where part of a stripe is modified but the
entire stripe has not yet been read into memory.  It reads the remaining
blocks (reconstructing missing blocks if necessary) then calculates
new parity blocks.

> With simple files changing one character with vi and gedit,
> I get completely different logical and physical numbers with each
> change, so it's clearly cowing the entire stripe (192KiB in my 3 dev
> raid5).

You are COWing the entire file because vi and gedit do truncate followed
by full-file write.

Try again with 'dd conv=3Dnotrunc bs=3D4k count=3D1 seek=3DN of=3D...' or
edit the file with a sector-level hex editor.

> [root@f24s ~]# filefrag -v /mnt/5/64k-a-then64k-b.txt
> Filesystem type is: 9123683e
> File size of /mnt/5/64k-a-then64k-b.txt is 131072 (32 blocks of 4096 byte=
s)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..      31:    2931744..   2931775:     32:             las=
t,eof
> /mnt/5/64k-a-then64k-b.txt: 1 extent found
> [root@f24s ~]# btrfs-map-logical -l $[4096*2931744] /dev/VG/a
> mirror 1 logical 12008423424 physical 1114112 device /dev/mapper/VG-b
> mirror 2 logical 12008423424 physical 34668544 device /dev/mapper/VG-a
> [root@f24s ~]# vi /mnt/5/64k-a-then64k-b.txt
> [root@f24s ~]# filefrag -v /mnt/5/64k-a-then64k-b.txt
> Filesystem type is: 9123683e
> File size of /mnt/5/64k-a-then64k-b.txt is 131072 (32 blocks of 4096 byte=
s)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..      31:    2931776..   2931807:     32:             las=
t,eof
> /mnt/5/64k-a-then64k-b.txt: 1 extent found
> [root@f24s ~]# btrfs-map-logical -l $[4096*29317776] /dev/VG/a
> No extent found at range [120085610496,120085626880)
> [root@f24s ~]# btrfs-map-logical -l $[4096*2931776] /dev/VG/a
> mirror 1 logical 12008554496 physical 1108475904 device /dev/mapper/VG-c
> mirror 2 logical 12008554496 physical 1179648 device /dev/mapper/VG-b
> [root@f24s ~]#
>=20
> There is a neat bug/rfe I found for btrfs-map-logical, it doesn't
> report back the physical locations for all num_stripes on the volume.
> It only spits back two, and sometimes it's the two data strips,
> sometimes it's one data and one parity strip.
>=20
>=20
> [1]
> https://bugzilla.kernel.org/show_bug.cgi?id=3D120941
>=20
>=20
> --=20
> Chris Murphy
>=20

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldsldAACgkQgfmLGlazG5ycYwCg0byWgxKfFty6l27ZeV6sDUUv
NZkAn3NzZKh8bDZo7V11044Fqg6U6VTS
=iSg3
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
