From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: RFC: Btrfs snapshots feature proposal for Fedora 13
Date: Tue, 17 Nov 2009 19:52:04 +0100
Message-ID: <200911171952.14346.kreijack@libero.it>
References: <m3lji59jcu.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2992689.g2FJWdx5UG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3lji59jcu.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2992689.g2FJWdx5UG
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 17 November 2009, Chris Ball wrote:
> Hi,
>=20
> I've written up a draft of an Fedora 13 feature proposal for
> filesystem rollback using Btrfs snapshots that are automatically
> created by yum:
>=20
>    https://fedoraproject.org/wiki/Features/SystemRollbackWithBtrfs
>=20
> It'd be great to get feedback on whether this is a good idea, and how
> the UI interaction should work.  We're also discussing it in this
> fedora-devel thread:
>=20
>    http://thread.gmane.org/gmane.linux.redhat.fedora.devel/123695
>=20
> Some comments I've got already received, from the thread:
>=20
> * People want the UI to allow independent active snapshots per
>   filesystem (i.e. btrfs /home is the live filesystem, and btrfs / is
>   an older snapshot).

On the basis of some empirical tests, I discovered that in btrfs a snapshot=
=20
doesn't doens't affect the other subvolume(s). If / (root) and /home are=20
different subvolumes, a snapshot of the / (root) doesn't affect the /home=20
content, and viceversa.=20

So if the root and the /home directory (or better the userS directories) ar=
e=20
separate volumes, you have the required behavior.

>=20
> * Several people think that the ZFS Time Slider patches to nautilus=C2=B9
>   look good, and want that for btrfs.  Sounds plausible, but I'm
>   more interested in first working on ways to let developers feel
>   comfortable upgrading to the development version of Fedora each
>   day with the possibility of reverting.
>=20
> * Instead of inventing a new system-config-blah, this should probably
>   be part of Palimpsest=C2=B2.
>=20
> * Perhaps we should encourage people using the Fedora installer with
>   btrfs to create a rootfs separate to their /home, so that they can
>   rollback rootfs snapshots without affecting their homedir.

On the basis of my tests, I think that is sufficient to create a volume for=
=20
the root ('/') and on for the /home (or a specific subvolume for every user=
).=20
Then it is possible to snapshot and "time sliding" every subvolume without=
=20
affecting the others.

I would like to add a my comment: in btrfs I think that "snapshot" (for the=
=20
btrfs snapshot) is not the best name. I think that a better term is "branch=
".=20

=46or example the btrfs snapshot capability may be used not only for recove=
ring=20
from a mistake, but also may be used for maintaining different=20
configurations...

> Thanks!
>=20
> - Chris.

BR
G.Baroncelli
>=20
> =C2=B9:  http://blogs.sun.com/erwann/entry/zfs_on_the_desktop_zfs
>     http://blogs.sun.com/erwann/entry/time_slider_screencast
>     http://blogs.sun.com/erwann/entry/new_time_slider_features_in
>=20
> =C2=B2:  http://library.gnome.org/users/palimpsest/stable/intro.html.en
> --=20
> Chris Ball   <cjb@laptop.org>
> One Laptop Per Child
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.=
it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart2992689.g2FJWdx5UG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLAvDVvwTxYT3FBRIRAtZPAJ95Py1cq5d8ETvrLE9phMLkqpcYfwCdGQp6
swDNsiD/CF1JFYaMM/wUeQQ=
=6x2T
-----END PGP SIGNATURE-----

--nextPart2992689.g2FJWdx5UG--
