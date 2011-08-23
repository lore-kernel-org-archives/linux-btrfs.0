From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Suddenly, a dead filesystem
Date: Tue, 23 Aug 2011 15:28:07 +0100
Message-ID: <20110823142807.GC4172@carfax.org.uk>
References: <CAEbWaipxhyMf2VQRdfnpMcXwyf84YupLOm8hQRf4Q8wJu060ng@mail.gmail.com>
 <20110823142727.GB4172@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c3bfwLpm8qysLVxt"
To: Avi Kivity <avi.kivity@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110823142727.GB4172@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 23, 2011 at 03:27:27PM +0100, Hugo Mills wrote:
> On Tue, Aug 23, 2011 at 05:15:46PM +0300, Avi Kivity wrote:
> > I've been using btrfs for a while as my /home (converted from ext4;
> > encrypted lvm) when it died on me. =A0Mounting it crashes immediately,
> > here's a log:
> [...]
> > [ =A0 =A06.456117] Call Trace:
> > [ =A0 =A06.456117] =A0[<ffffffffa005646e>] add_inode_ref+0x2e6/0x37c [b=
trfs]
> > [ =A0 =A06.456117] =A0[<ffffffffa00493f6>] ? read_extent_buffer+0xc3/0x=
e3 [btrfs]
> > [ =A0 =A06.456117] =A0[<ffffffffa0056e14>] replay_one_buffer+0x197/0x21=
2 [btrfs]
> > [ =A0 =A06.456117] =A0[<ffffffffa0054e94>] walk_down_log_tree+0x15a/0x2=
c1 [btrfs]
> > [ =A0 =A06.456117] =A0[<ffffffffa005507a>] walk_log_tree+0x7f/0x19e [bt=
rfs]
> > [ =A0 =A06.456117] =A0[<ffffffff8123a8d9>] ? radix_tree_lookup+0xb/0xd
> > [ =A0 =A06.456117] =A0[<ffffffffa0058148>] btrfs_recover_log_trees+0x28=
b/0x298 [btrfs]
> > [ =A0 =A06.456117] =A0[<ffffffffa0056c7d>] ? replay_one_dir_item+0xbd/0=
xbd [btrfs]
> > [ =A0 =A06.456117] =A0[<ffffffffa002a192>] open_ctree+0x10f1/0x13ff [bt=
rfs]
> [...]
> > Tried btrfsck, immediate segfault.
>=20
>    Yes, it does that,I'm afraid. (It also doesn't fix anything).
>=20
> > Both kernel and btrfsprogs are stock Fedora 15. =A0I still have the
> > logical volume and would like to recover it. =A0Its fairly easy to try
> > out things in a virtual machine, so if you have a patch you want me to
> > try out, I'm here.
>=20
>    It looks like you've got a corrupt log tree. The quick and easy fix
> for that is on the wiki in the problem FAQ page [1].

   ... or use Josef's fix first. :)

   H.

>    Could you give a bit more information about what happened in the
> crash immediately prior to the FS being unmountable, and how your
> storage is configured?
>=20
>    Hugo.
>=20
> [1] https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_can.27t_mount_m=
y_filesystem.2C_and_I_get_a_kernel_oops.21
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- You stay in the theatre because you're afraid of having no ---   =20
                         money? There's irony...                        =20

--c3bfwLpm8qysLVxt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOU7j3IKyzvlFcI40RAq3AAJ9evqCqDQUlUfcK8WSohocgF1IX0QCdGKbt
XloxRWx4F9kLNQO5aQefpgE=
=eMeJ
-----END PGP SIGNATURE-----

--c3bfwLpm8qysLVxt--
