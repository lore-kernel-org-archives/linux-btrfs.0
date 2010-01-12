From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: Re: snapshots of directories
Date: Tue, 12 Jan 2010 06:44:07 +0100
Message-ID: <201001120644.13182@fortytwo.ch>
References: <20100112031243.09e072b0@simplux> <4B4BDC36.4000304@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1540635.j6nzMq2W99";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: mniederle@gmx.at, linux-btrfs@vger.kernel.org
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B4BDC36.4000304@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1540635.j6nzMq2W99
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday 12 January 2010 03.19:34 TARUISI Hiroaki wrote:
> In btrfs, snapshot is a clone of subvolume, not arbitrary
> directory.
> You specified '/root' directory and it is not subvolume,
> snapshot is created for parent subvolume, root of filesystem.

=2E.. hence my proposal (haven't seen a comment so far) to have snapshot=20
creation fail if the specified directory is not a subvol root.

cheers
=2D- vbi

>=20
> Regards,
> taruisi
>=20
> (2010/01/12 11:12), Michael Niederle wrote:
> > I try to take a snapshot of a single directory, e.g. root:
> >> btrfsctl -s root.2010-01-12 /root
> >
> > operation complete
> > Btrfs v0.19-4-gab8fb4c-dirty
> >
> > Then I take look what's inside the newly created snapshot:
> >> ls -l /root.2010-01-12/
> >
> > total 0
> > drwxr-xr-x 1 root root 1192 2010-01-03 20:32:12 bin
> > drwxr-xr-x 1 root root   76 2009-06-25  0:40:35 boot
> > drwxr-xr-x 1 root root 1756 2010-01-12  2:33:07 cmds
> > drwxr-xr-x 1 root root    0 2010-01-06 12:21:46 data
> > drwxr-xr-x 1 root root 4356 2010-01-12  2:07:00 dev
> > drwxr-xr-x 1 root root   42 2010-01-04 12:29:45 downloads
> > drwxr-xr-x 1 root root 4528 2010-01-12  2:12:12 etc
> > drwxr-xr-x 1 root root   52 2010-01-11 12:57:47 home
> > drwxr-xr-x 1 root root    0 2007-11-10  4:44:07 initrd
> > drwxr-xr-x 1 root root 4490 2010-01-05 20:15:53 lib
> > drwxr-xr-x 1 root root  124 2008-04-27 14:53:39 mnt
> > drwxr-xr-x 1 root root   62 2008-01-08  0:21:58 net
> > drwxr-xr-x 1 root root    0 2008-04-09  3:19:16 objects
> > drwxr-xr-x 1 root root  316 2009-12-28 23:23:13 opt
> > dr-xr-xr-x 1 root root    0 2007-11-10  3:35:28 proc
> > drwxr-xr-x 1 root root 7676 2010-01-11  0:35:41 root
> > drwxr-xr-x 1 root root    0 2010-01-12  1:56:17 save
> > drwxr-xr-x 1 root root    0 2010-01-12  1:55:58 save2
> > drwxr-xr-x 1 root root 3804 2010-01-06  2:36:08 sbin
> > drwxr-xr-x 1 root root    0 2007-11-10  3:35:28 sys
> > drwxr-xr-x 1 root root  358 2010-01-11 18:44:29 tmp
> > drwxr-xr-x 1 root root  176 2009-12-29 17:08:37 usr
> > drwxr-xr-x 1 root root   72 2010-01-05 20:03:00 var
> >
> > It seems that always a snapshot of the root is taken instead one of the
> > specified directory? Is this by design?
> >
> > Snapshotting the root works fine, but if you take several snapshots
> > it's a bit "recursive", because every new snapshot contains all
> > previous snapshots.
> >
> > Greetings, Michael
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

=2D-=20
Most scientists think that the not-fossil theory is a red herring;
indeed, they think that oil is lots of herrings (and other things)
compacted over time into sticky black mud.
        -- Prospect Magazine, March 2003, p. 6

--nextPart1540635.j6nzMq2W99
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAktMDCdgGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l6lOUAoKMbv9jY/zm4JToAVWBC7T2H
aXh5AJ0QNT7vD3uy1KIUifPLEg1UkVEE1w==
=gP0D
-----END PGP SIGNATURE-----

--nextPart1540635.j6nzMq2W99--
