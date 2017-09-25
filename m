Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47438 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933433AbdIYHw4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 03:52:56 -0400
Date: Mon, 25 Sep 2017 07:52:50 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Marat Khalili <mkh@rqc.ru>, Nikolay Borisov <nborisov@suse.com>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: subvolume: outputs message only when
 operation succeeds
Message-ID: <20170925075250.GC25529@carfax.org.uk>
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
 <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
 <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>
 <095397b6-4865-1ea3-ae0d-6725b84c447c@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
In-Reply-To: <095397b6-4865-1ea3-ae0d-6725b84c447c@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 25, 2017 at 03:46:15PM +0800, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B409=E6=9C=8825=E6=97=A5 15:42, Marat Khalili wrote:
> >On 25/09/17 10:30, Nikolay Borisov wrote:
> >>On 19.09.2017 10:41, Misono, Tomohiro wrote:
> >>>"btrfs subvolume create/delete" outputs the message of "Create/Delete
> >>>subvolume ..." even when an operation fails.
> >>>Since it is confusing, let's outputs the message only when an
> >>>operation succeeds.
> >>Please change the verb to past tense, more strongly signaling success -
> >>i.e. "Created subvolume"
> >What about recalling some UNIX standards and returning to NOT
> >outputting any message when operation succeeds? My scripts are
> >full of grep -v calls after each btrfs command, and this sucks
> >(and I don't think I'm alone in this situation).
>=20
> Isn't the correct way to catch the return value instead of grepping
> the output?

   It is, but if, for example, you're using the command in a cron
script which is expected to work, you don't want it producing output
because then you get a mail every time the script runs. So you have to
grep -v on the "success" output to make the successful script silent.

> If it's some command not returning value properly, would you please
> report it as a bug so we can fix it.

   It's not the return value that's problematic (although those used
to be a real mess). It's the fact that a successful run of the command
produces noise on stdout, which most commands don't.

   Hugo.
=20
> Thanks,
> Qu
>=20
> >If you change the message a lot of scripts will have to be
> >changed, at least make it worth it.
> >
> > =C2=A0--
> >
> >With Best Regards,
> >Marat Khaliili
> >

--=20
Hugo Mills             | If you see something, say nothing and drink to
hugo@... carfax.org.uk | forget
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                 Welcome to Night V=
ale

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZyLXRAAoJEFheFHXiqx3kcgMQALgQKyYLzfORsWNlwPZZOCVQ
snwyTpDT0krPi1VupP0Sf/7Ga+BAgM0qfX3wD/9HCl29TDFpV9HDTPtXvukiz184
tetPVog6wd4wjuCt2fX/4ImDsXNccJNXIQwRcWJDnCX429nRWoRzEpI6Hbt4D6fe
T/lnJq1ngHCe8gTta7GUOjUIMNGADqnVV9OI2cS2RgYCtYaLlp2o5bzcxM7snUwY
6S6iFz0Ll0LLFAX3XBvC0dwD8n1gcYsE3lRtXhTHCpyDyYsgLZplS94RrB7wr6Ki
v/VeJRfWncT4ngiAc3DcuHmUxNn50/rgiZGKKmR/4oF/uujd/YtaQP0X86GoNVbi
A+DY+BekeiRiYK2oh4FKFfTO600We3DX0/Z8Wwolge6yxHjCKFVvFTMC77QnJ/+V
tFu2MdQvLIzblO3ksWtt2ETQ0dM4Etbp5PTXVfrQJvMeI1WYSXy7TVcAvFzeeq2w
+Pyutk2/4ngHPm2Y3WC67mDx4PqLpoJB4hMlHU/580cv1b1f6/Daw57rHXv6YLWD
6/rBsSGDNWYk7Rk+y9Rkmt2O8vH9GLoTV+biMvuQE1EsdmkbGy4OMzEOpodTYe3t
oA0aWONVHXCOsoILpR69x9uj1c0dKTQXC2Tbk7SaHk4JMP5DandDaNWs5nOuIayM
H5tlw+557tYH3gyYMdFV
=v+xJ
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
