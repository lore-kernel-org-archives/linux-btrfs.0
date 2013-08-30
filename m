Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56353 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab3H3Oyf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 10:54:35 -0400
Date: Fri, 30 Aug 2013 15:54:24 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Chris Murphy <lists@colorremedies.com>, Zach Brown <zab@redhat.com>,
        Nick Lee <email@nickle.es>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Question: How can I recover this partition? (unable to find
 logical $hugenum len 4096)
Message-ID: <20130830145424.GX3115@carfax.org.uk>
References: <CAGURm2FS=YTuBpbrg7BV=Un8ZCp9xYZae-WuqhjV29xXA7e0jw@mail.gmail.com>
 <E76A410A-0CEF-47D7-A501-E2DDF0230735@colorremedies.com>
 <20130826193110.GO3115@carfax.org.uk>
 <20130829173519.GN26818@lenny.home.zabbo.net>
 <528DF163-08F5-412D-8351-ACC853AC418D@colorremedies.com>
 <20130829194049.GR3115@carfax.org.uk>
 <0E1979CF-25EC-47B2-B74E-9870F3D9C626@colorremedies.com>
 <20130829195322.GS3115@carfax.org.uk>
 <2D27D640-86E0-4E49-8874-81249DF9919A@colorremedies.com>
 <5220AFCC.5080701@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NAuYj0K7Umiq33rm"
In-Reply-To: <5220AFCC.5080701@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NAuYj0K7Umiq33rm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 30, 2013 at 09:44:28AM -0500, Eric Sandeen wrote:
> On 8/29/13 3:19 PM, Chris Murphy wrote:
> >=20
> > On Aug 29, 2013, at 1:53 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >=20
> >> On Thu, Aug 29, 2013 at 01:44:54PM -0600, Chris Murphy wrote:
> >>>
> >>> Certainly, if known for sure it won't be more than 30 seconds?
> >>
> >>   Mmm... it'll depend on the setting of the commit period, which up
> >> until a couple of weeks ago was always 30s, but someone posted a patch
> >> to give it a config knob=E2=80=A6
> >=20
> >=20
> >=20
> > "Proceeding will roll back the file system to a previous state, and
> > may cause the loss of successfully written data since the last commit
> > period (30 seconds by default). Proceed? (Y/N)"
>=20
> Is it just loss of data, or might this also result in a filesystem with i=
nconsistent metadata, which then requires a fsck?

   No the metadata is always consistent (well, in theory, barring bugs
and out-of-band corruption).

> Above sounds like it's "just" reverting to a previous (consistent) state.=
  Is that correct?

   Yes, it's dropping the log of accepted-but-uncommitted work. This
is a Bad Thing in the sense that something that's reached the log is
reported to the application as being successfully written. If the
application critically relies on that (e.g. databases), then we've
discarded durability from ACID. (Can you guess I've been marking
Databases resit exam papers this morning? :) )

   Hugo.

> -Eric
>=20
> p.s. fwiw when the xfs_repair zero-log option "-L" is used, we say:
>=20
> "ALERT: The filesystem has valuable metadata changes in a log which is be=
ing\n"
> "destroyed because the -L option was used.\n"));

   That's a reasonable wording too.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- We teach people management skills by examining characters in ---  =20
            Shakespeare.  You could look at Claudius's crisis           =20
                   management techniques, for example.                  =20

--NAuYj0K7Umiq33rm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUiCyIFheFHXiqx3kAQLnEg/9GLSuKWjwSqAAX1RoeXWi9FjAfxc06usE
XY1Cconqxet8NfNqlsiXcoKJ/MTWbTwj3RoG+VqAETE4HhZoOCiKxCy6k3GJuhbY
bRSFgIkR+0Zcn5ZBGSmYN0+aLRBn6sIRflPC7cXCgT4zqOqJBWl7ii9FoGlpp5ro
EH8uOiICMAio9X290nHRibF41uq9zDGqtmUW5FCUuaJvH6ovkA96K6rCOGp+zaTK
5HXR9m2d0PIFUKaa5uyGGiwZOs1u9iQY8KU7JtDgAZeaVrK8IPrMXMlA3l41ImOO
XVX45vLWHkcZ3HOIpa03gHlKTofXlS5jQ3eWiCl+BaYMCkBPA9F++y3luBO+GY+b
Z6i9okdhJcDc1kV2jTMN79Opbj37gkS2U9JTmlXTXN2+AyDjwzA8+/VeeL+cui90
dAqw+phRaWkzfyBrSnP1GF61w/Lx5rkg9ITp8tSnRWKRsKw86ZVGv3FMDzY0CcyG
02I9m646/5ZF2nhi0YAW/Jw/YbbP1TvMQbpSPmkniGI2w6c/AA55bi8pl8xvG8Hi
/WZdjaXxGhNdJYGu6FUeyt0CWuXeW8zoJ1aTp2Qjfqw065ordFB7O+k1re8+gJEo
EYFDOEeGGsUCvb+aDlKcygRKO8Fgn5IwtY8nNZA6iL1VNKNRg2Cx+zwwnDRIJvQM
RH+GQ/rjKbs=
=FbPo
-----END PGP SIGNATURE-----

--NAuYj0K7Umiq33rm--
