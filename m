From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: ENOSPC at 94% full -- and causing BUGs elsewhere?
Date: Tue, 13 Oct 2009 17:09:09 +0100
Message-ID: <20091013160909.GB5393@vlad.carfax.org.uk>
References: <20091003122109.GB3116@selene> <20091003215531.GG4350@dhcp231-156.rdu.redhat.com> <20091004120630.GA19916@think> <20091012140935.GA8550@vlad.carfax.org.uk> <20091013103145.GC8830@think> <20091013145007.GA5393@vlad.carfax.org.uk> <3d0408630910130758h7963d85fx5343c531632fa79@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630910130758h7963d85fx5343c531632fa79@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2009 at 10:58:12PM +0800, Yan, Zheng  wrote:
> On Tue, Oct 13, 2009 at 10:50 PM, Hugo Mills <hugo-lkml@carfax.org.uk> wr=
ote:
> > On Tue, Oct 13, 2009 at 06:31:45AM -0400, Chris Mason wrote:
> >> On Mon, Oct 12, 2009 at 03:09:35PM +0100, Hugo Mills wrote:
> >> > On Sun, Oct 04, 2009 at 08:06:30AM -0400, Chris Mason wrote:
> >> > > On Sat, Oct 03, 2009 at 05:55:32PM -0400, Josef Bacik wrote:
> >> > > > On Sat, Oct 03, 2009 at 01:21:09PM +0100, Hugo Mills wrote:
> >> > > > > =A0 =A0I've just had the following on my home server. I believ=
e that it's
> >> > > > > btrfs that's responsible, as the machine wasn't doing much oth=
er than
> >> > > > > reading/writing on a btrfs filesystem. The process that was do=
ing so
> >> > > > > is now stuck in D+ state, and can't be killed. The timing of t=
he oops
> >> > > > > at the end is also suggestive of being involved in the same in=
cident.
> >> > > > > This is the only btrfs filesystem on the machine.
> >> > > >
> >> > > > Patches have gone to Linus to fix the enospc problems. =A0You ca=
n try running the
> >> > > > enospc branch of Chris's git tree and it should behave better fo=
r you. =A0Thanks,
> >> > >
> >> > > The right tree for this is the master branch of btrfs-unstable for
> >> > > 2.6.31.
> >> >
> >> > =A0 =A0Thanks, Josef and Chris. I've now found the time to check out=
 and
> >> > build the btrfs-unstable tree, and it is indeed handling the ENOSPC
> >> > condition much more cleanly.
> >> >
> >> > =A0 =A0However, it seems to have got into a position where I have lo=
ts of
> >> > free space reported by df (over 10% of the size of the volume -- 185
> >> > GiB free of 1474 GiB total), but still refuses to write anything to
> >> > the filesystem. Do you have any suggestions for what I could try?
> >>
> >> You've probably got most of that 10GB free allocated as metadata. =A0Y=
ou
> >> could try btrfs-vol -b.
> >
> > =A0 I moved some 13 GiB of data off the filesystem, and ran
> > btrfs-vol -b. As I reported on IRC, I then got this in my syslog:
> >
> > Oct 13 13:16:19 vlad kernel: btrfs: relocating block group 140122469171=
2 flags 1
> > Oct 13 13:17:02 vlad kernel: btrfs: found 123 extents
> > Oct 13 13:17:10 vlad kernel: btrfs: found 123 extents
> > Oct 13 13:17:11 vlad kernel: btrfs: found 28 extents
> > Oct 13 13:17:21 vlad kernel: btrfs: found 28 extents
> > Oct 13 13:17:25 vlad kernel: btrfs: found 28 extents
> > Oct 13 13:17:26 vlad kernel: btrfs: found 27 extents
> > Oct 13 13:17:36 vlad kernel: btrfs: found 27 extents
> > Oct 13 13:17:39 vlad kernel: btrfs: found 27 extents
> > Oct 13 13:17:48 vlad kernel: btrfs: found 27 extents
> > ... repeat forever (or at least for 50 minutes or so).
> >
> > =A0 The btrfs-vol -b process didn't respond to ^C, so on advice of
> > yanzheng on IRC I rebooted the machine. I'm currently running a
> > btrfsck on the filesystem, and will try btrfs-vol -b again when that's
> > done.
> >
> don't do that, It will run into infinite loop again.

   I got this from the btrfsck:

hrm@vlad:~ $ sudo btrfsck /dev/media/scratch=20
root 5 inode 3949 errors 2000
found 1366552736241 bytes used err is 1
total csum bytes: 1336783032
total tree bytes: 1944158208
total fs tree bytes: 20267008
btree space waste bytes: 462357950
file data blocks allocated: 1368865824768
 referenced 1368851816448
Btrfs Btrfs v0.19

   I guess that means that there were errors found -- is the btrfs-vol
-b still going to cause an infinite loop, or is it worth trying that
again?

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Quantum Mechanics: the dreams stuff is made of. ---        =20

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFK1KYkIKyzvlFcI40RApswAKCUt3JsUqgXc0lq9hoM9x0rmj6SygCeK46l
5b/md+nyWOJr+5aEfgb8vtg=
=uOMW
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
