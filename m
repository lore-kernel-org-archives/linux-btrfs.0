From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Announcing btrfs-gui
Date: Thu, 2 Jun 2011 09:41:08 +0100
Message-ID: <20110602084108.GB8002@carfax.org.uk>
References: <20110601232058.GA22619@carfax.org.uk>
 <BANLkTin_2u0VmmAJXVKnA_s3LuCkoKt29Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTin_2u0VmmAJXVKnA_s3LuCkoKt29Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 02, 2011 at 03:31:16PM +0700, Fajar A. Nugraha wrote:
> On Thu, Jun 2, 2011 at 6:20 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > =A0 Over the last few weeks, I've been playing with a foolish idea,
> > mostly triggered by a cluster of people being confused by btrfs's free
> > space reporting (df vs btrfs fi df vs btrfs fi show). I also wanted an
> > excuse, and some code, to mess around in the depths of the FS data
> > structures.
> >
> > =A0 Like all silly ideas, this one got a bit out of hand, and seems to
> > have turned into something vaguely useful. I'm therefore pleased to
> > announce the first major public release of btrfs-gui[1]: a point-and-
> > click tool for managing btrfs filesystems.
> >
> > =A0 The tool currently can scan for and list btrfs filesystems and the
> > volumes they live on. It can show the allocation and usage of data in
> > a selected filesystem, categorised by use, replication, and device. It
> > can show and manipulate subvolumes and snapshots: creation, deletion,
> > and setting the default.
>=20
>=20
> Some comments:
> (1) Currently it needs to be run from the directory where it's
> downloaded, even after a "python3 setup.py install". When run from
> other directory, it bails with
>=20
> Traceback (most recent call last):
>   File "/usr/local/bin/btrfs-gui", line 5, in <module>
>     btrfsgui.main.main()
>   File "/usr/local/lib/python3.2/dist-packages/btrfsgui/main.py", line
> 24, in main
>     subproc =3D init_root_process(options)
>   File "/usr/local/lib/python3.2/dist-packages/btrfsgui/sudo.py", line
> 31, in init_root_process
>     stdin=3Dsubprocess.PIPE, stdout=3Dsubprocess.PIPE)
>   File "/usr/lib/python3.2/subprocess.py", line 736, in __init__
>     restore_signals, start_new_session)
>   File "/usr/lib/python3.2/subprocess.py", line 1330, in _execute_child
>     raise child_exception_type(errno_num, err_msg)
> OSError: [Errno 2] No such file or directory: './btrfs-gui-helper'
>=20
> Is this intentional?

   No, and will be fixed later today. I forsee an emergency 0.2.1
coming shortly. :)

> (2) When showing space usage for a single-device FS, selecting "Show
> unallocated space as raw space", why is the top and bottom graph
> different? Shouldn't it be the same, since there's only one device?

   Good question. I shall investigate what's going on.

> (3) Not directly related to btrfs-gui, but I've been wondering what's
> the correct way to SHOW the current default subvolume?

   The btrfs-progs tools don't have a way of doing this. It's
relatively easy to do: use the tree-search ioctl to search for a
DIR_ITEM key in the tree of tree roots with the name "default". The
corresponding FS tree is the default subvolume. It's just not
implemented yet.

   Thanks for the feedback.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Welcome to Rivendell,  Mr Anderson... ---             =20

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN50yjIKyzvlFcI40RAhRmAKCjGGzlp2LgTDa3Em6tzf5QJWjEJACeNaFy
FqlwIZlUe2egvWt4nrBH7zo=
=OIwa
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
