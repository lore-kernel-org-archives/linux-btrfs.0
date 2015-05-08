Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44918 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752214AbbEHNV0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 May 2015 09:21:26 -0400
Date: Fri, 8 May 2015 09:21:02 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Recipe for creating unlink deadlocks
Message-ID: <20150508132101.GE18025@hungrycats.org>
References: <20150507222034.GC18025@hungrycats.org>
 <CAL3q7H5XsorEcdG+OdPEz=YaqVoNcmM5GXzs_DFY0yzLQNmaXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7DO5AaGCk89r4vaK"
In-Reply-To: <CAL3q7H5XsorEcdG+OdPEz=YaqVoNcmM5GXzs_DFY0yzLQNmaXA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 08, 2015 at 11:32:07AM +0100, Filipe David Manana wrote:
> On Thu, May 7, 2015 at 11:20 PM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> > This is the simplest repro recipe for this that I have found so far.
> > It takes only a few minutes for the rm processes to get stuck here:
> >
> > # cat /proc/28396/stack                                                =
                                                                           =
            Thu May  7 18:13:05 2015
> >
> > [<ffffffff813c8a2d>] lock_extent_bits+0x1ad/0x200
> > [<ffffffff813b5dfa>] btrfs_evict_inode+0x17a/0x5e0
> > [<ffffffff8123fc68>] evict+0xb8/0x1b0
> > [<ffffffff81240813>] iput+0x1f3/0x260
> > [<ffffffff81233c68>] do_unlinkat+0x1d8/0x360
> > [<ffffffff812346db>] SyS_unlinkat+0x1b/0x40
> > [<ffffffff8190024d>] system_call_fastpath+0x16/0x1b
> > [<ffffffffffffffff>] 0xffffffffffffffff
> >
> >
> > Run these three scripts in a directory that is the top of a subvol:
> >
> >         # Script #1:  randomly create or delete snapshots
> >         while sleep 1; do
> >                 if [ $[RANDOM%2] =3D 0 ]; then
> >                         btrfs sub snap . snaps-$RANDOM
> >                 else
> >                         for x in snaps-*; do
> >                                 btrfs sub del $x
> >                                 break
> >                         done
> >                         btrfs sub sync .
> >                 fi
> >         done
> >
> >         # Script #2:  create a bunch of files of random sizes
> >         while true; do
> >                 d=3D$[RANDOM%9]/$[RANDOM%9]/$[RANDOM%9]/$[RANDOM%9]
> >                 mkdir -p ${d%/*}
> >                 head -c $[RANDOM%1024]k /usr/share/doc/chromium/copyrig=
ht > $d
> >         done
> >
> >         # Script #3:  read and immediately delete all the files
> >         while date; do
> >                 sleep 1
> >                 find -type f -exec cat {} \; -exec rm -fv {} \; > /dev/=
null
> >         done
>=20
> Tried that for over 3 hours, on a 4.1-rc2 kernel with a few patches
> from the list, with several combinations of mount options (compress,
> autodefrag, nodatacow, etc) and didn't got any issue.
>=20
> What kernel version are you testing? Any specific combination of mount op=
tions?

I've seen it on the field on versions from v3.15 to v4.0.1.  The test I did
yesterday was v4.0.1.

Mount options are rw,relatime,compress-force=3Dzlib,space_cache.

> >
>=20
>=20
>=20
> --=20
> Filipe David Manana,
>=20
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--7DO5AaGCk89r4vaK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlVMuD0ACgkQgfmLGlazG5xCdACfR3J5dR+bVdl1n8fa2Qxs8hss
JNAAoLFTvjl+vw0Hwp8tZe0ClO6Uddv4
=vFbt
-----END PGP SIGNATURE-----

--7DO5AaGCk89r4vaK--
