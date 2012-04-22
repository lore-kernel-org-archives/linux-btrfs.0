From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Sun, 22 Apr 2012 10:59:19 +0300
Message-ID: <20120422105919.28b027a0@sf.home>
References: <20120410151645.GC2296@localhost.localdomain>
	<CAFDW0j+=qe49pX3frjEoozOMz-gKKxqJ+jeeTgyXEskDL_9W8w@mail.gmail.com>
	<20120411170422.GA2506@localhost.localdomain>
	<CAFDW0jJZ16jPn766fdn3Hm=WWkR71n0kJapfPZzgHd3o71b1hQ@mail.gmail.com>
	<20120412133747.GE1924@localhost.localdomain>
	<20120412142349.GI1924@localhost.localdomain>
	<CAFDW0jJq46TXa_a1soYESgjZosBDM8razvT271S3_SoyQeBbSA@mail.gmail.com>
	<CAE5mzvjJ+fuixm=OpKua6t6s6sncz1RGwXem8D6ZS=jDRDQ3+g@mail.gmail.com>
	<CAFDW0jL4TTWtqMw4f_1WpQuEU7Q1SoTUo_rBVGcdHt008Sx1Zw@mail.gmail.com>
	<CAFDW0jKMEQ+oMN41euh1cMy4h+6Qntt5UL9+0HZw4r9SpDJVvQ@mail.gmail.com>
	<20120413134716.GB1923@localhost.localdomain>
	<CAFDW0jKRig6GTB4Oq4VG8xZQN4ArUnft1X9ST7cfyLHFTUs4NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kJjDkKw.HdZ7_3hnIPH/3WF"; protocol="application/pgp-signature"
Cc: Josef Bacik <josef@redhat.com>, cwillu <cwillu@cwillu.com>,
	Calvin Walton <calvin.walton@kepstin.ca>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAFDW0jKRig6GTB4Oq4VG8xZQN4ArUnft1X9ST7cfyLHFTUs4NA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/kJjDkKw.HdZ7_3hnIPH/3WF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Apr 2012 22:54:41 +0200
Ahmet Inan <ainan@mathematik.uni-freiburg.de> wrote:

> On Fri, Apr 13, 2012 at 3:47 PM, Josef Bacik <josef@redhat.com> wrote:
> > On Fri, Apr 13, 2012 at 02:26:19PM +0200, Ahmet Inan wrote:
> >> On Fri, Apr 13, 2012 at 1:22 PM, Ahmet Inan
> >> <ainan@mathematik.uni-freiburg.de> wrote:
> >> > On Fri, Apr 13, 2012 at 8:49 AM, cwillu <cwillu@cwillu.com> wrote:
> >> >>> dmesg and fstab attached as requested.
> >> >>
> >> >> Need dmesg after you've hit alt-sysrq-w a couple times during the s=
low period.
> >> >
> >> > here.
> >> >
> >> > i guess i should also increase dmesg history size next time.
> >> > other than the slow boot, everything seems normal after 10-20minutes.
> >> >
> >> > fyi: the space_cache option is not really helping with those
> >> > twenty computers. the one thing i observed is, that sometimes
> >> > they reboot fast and only to reboot slow again after that.
> >>
> >> sorry for spaming the list with my dmesg files,
> >> please tell me, how i could do better.
> >>
> >> here a more complete dmesg.
> >
> > Hrm so you are getting blocked task warnings just trying to mount the
> > filesystem, so either your disk is really really really slow or there's
> > something bigger going on. =C2=A0Let me think about this some and I'll =
get back to
> > you.
>=20
> Josef, i finally found out something:
>=20
> btrfs in kernel =3D> fast boot
> btrfs as module =3D> very slow boot
>=20
> and here see the results:
> http://aam.mathematik.uni-freiburg.de/IAM/homepages/ainan/bootchart_btrfs=
_in_kernel.png
>=20
> this is much, much better!
>=20
> I dont understand why btrfs as a module performs that bad on rotating dis=
k.
> On SSD i had no issues and also i never used space_cache before.

There is a suspiction that putting space_cache (or anything else) to fstab =
for rootfs
does not get applied due to a bug:

    http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16039.html

Do all of your affected computers run 3.4.0-rc kernels?

--=20

  Sergei

--Sig_/kJjDkKw.HdZ7_3hnIPH/3WF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk+Tul0ACgkQcaHudmEf86oUGACfXAnQ3dwky031SgeYaav+w7IO
oEEAnjVZSJXoMbDQhn6kj0OPyGlsuGvO
=KWID
-----END PGP SIGNATURE-----

--Sig_/kJjDkKw.HdZ7_3hnIPH/3WF--
