Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965210AbaFRJoh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 05:44:37 -0400
Date: Wed, 18 Jun 2014 11:44:31 +0200
From: "Dr. Werner Fink" <werner@suse.de>
To: Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Cc: systemd-devel@lists.freedesktop.org, linux-btrfs@vger.kernel.org
Subject: Re: [systemd-devel] [PATCH 10/11] Avoid doubling the efforts for
 /var/log/journal
Message-ID: <20140618094431.GA6795@boole.suse.de>
References: <1402670470-6225-1-git-send-email-werner@suse.de>
 <1402670470-6225-10-git-send-email-werner@suse.de>
 <539F08D7.1070608@opensuse.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
In-Reply-To: <539F08D7.1070608@opensuse.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2014 at 11:10:15AM -0400, Cristian Rodr=EDguez wrote:
> El 13/06/14 10:41, Werner Fink escribi=F3:
> > That is: set NOATIME, NOCOW, and NOCOMP for the journal directory
> >=20
> > ---
> >  src/journal/journald-server.c |   29 +++++++++++++++++++++++++++--
> >  1 file changed, 27 insertions(+), 2 deletions(-)
> >=20
> > diff --git src/journal/journald-server.c src/journal/journald-server.c
> > index eda5dcf..37d6dc3 100644
> > --- src/journal/journald-server.c
> > +++ src/journal/journald-server.c
> > @@ -21,6 +21,7 @@
> > =20
> >  #include <sys/signalfd.h>
> >  #include <sys/ioctl.h>
> > +#include <linux/fs.h>
> >  #include <linux/sockios.h>
> >  #include <sys/statvfs.h>
> >  #include <sys/mman.h>
> > @@ -920,7 +921,7 @@ finish:
> > =20
> > =20
> >  static int system_journal_open(Server *s) {
> > -        int r;
> > +        int r, fd;
>=20
> _cleanup_close_ ...
>=20
> > +                /*
> > +                 * On journaling and/or compressing file systems avoid=
 doubling the
> > +                 * efforts for the system, that is set NOCOW and NOCOM=
P inode flags.
> > +                 * Check for every single flag as otherwise some of th=
e file systems
> > +                 * may return EOPNOTSUPP on one unkown flag (like BtrF=
S does).
> > +                 */
> > +                if ((fd =3D open(fn, O_DIRECTORY)) >=3D 0) {
>=20
> O_CLOEXEC...
>=20
> > +                        long flags;
> > +                        if (ioctl(fd, FS_IOC_GETFLAGS, &flags) =3D=3D =
0) {
> > +                                int old =3D flags;
> > +                                if (!(flags&FS_NOATIME_FL) && ioctl(fd=
, FS_IOC_SETFLAGS, flags|FS_NOATIME_FL) =3D=3D 0)
> > +                                        flags |=3D FS_NOATIME_FL;
> > +                                if (!(flags&FS_NOCOW_FL) && ioctl(fd, =
FS_IOC_SETFLAGS, flags|FS_NOCOW_FL) =3D=3D 0)
> > +                                        flags |=3D FS_NOCOW_FL;
> > +                                if (!(flags&FS_NOCOMP_FL) && s->compre=
ss) {
> > +                                        flags &=3D ~FS_COMPR_FL;
> > +                                        flags |=3D FS_NOCOMP_FL;
> > +                                }
> > +                                if (old !=3D flags)
> > +                                        ioctl(fd, FS_IOC_SETFLAGS, fla=
gs);
> > +                        }
> > +                        close(fd);
> > +                }
>=20
> I agree that this should be done, however I remain unconvinced this is
> the right place to do it..

IMHO this is the correct place as it helps to speed up systemd-journal
on BtrFS.  This was the reason for this patch and is tested even if the
patch does not use _cleanup_close_ and O_CLOEXEC ;)


Werner

--=20
  "Having a smoking section in a restaurant is like having
          a peeing section in a swimming pool." -- Edward Burr

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAABAgAGBQJToV9/AAoJEFDpDVUdwWsu6q8QANIyy4aPLe4Y4r32VxIgOoG2
yvWatVuA6ur+RcuUn3UNdOv2JMB9BgBZfOFAOduSU7pi0C+GxRbEfwBw68TAyiCL
lIF3B0aXUD9VVGB45zB8fZncLxP79wlsYDr5+fDXXRMGPHdMMP6NhYieexq8MNJo
rxArO1M5zTIW28t5pG1hzuw8ZwqNwlvl/Pg9lPkDKJTG/aru5wRhx1G7JV+dAvsh
5L6i1PTZEBGqfYgPVW/yrWOHKTQPyQgzvgaqUGy3P44ogjAuLISwfcHHUE6AvQvk
wY3ElE77MrycxQTrYBlTixMBiTJuaZXeBlmWqOi6NkSMqDSruYC1dl7fQtVjQbRJ
VOisyolMvP6nr5AzDhjuqQsnbJAJJQNFm84zl4FaLC3wfa7DaWbZGjQsJWbJb2WY
2fLZFRhY57I9mdgoeGCTxMiQ/PV+vsCaZ9Cgp+xTXF8cphxKF9mMDjwAexXwWZ6p
SmTyZprfkiW0qxT1c8e+Q5/m6trfzm8w7p2rUCuBddnNwsCn3U7py1fjKgHRXWA3
CbR8U1SsOis5mj9uiLpgQoQ5brXqchcYP2KPF6n/f5AnEm/xztXtIDqXF0sXotvi
WgWG1gDy3WrlCzkcHSLeroqIClOJ4sE7v4UaPA6VMy8bb+dRogTlw5PT1EUWE7lv
tMGmcsRjURCXkG/uuVAd
=vn9x
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
