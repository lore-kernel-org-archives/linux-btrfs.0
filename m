Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56844 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbbLVUao (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 15:30:44 -0500
Date: Tue, 22 Dec 2015 20:30:41 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Donald Pearson <donaldwhpearson@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: defrag vs autodefrag
Message-ID: <20151222203041.GD1586@carfax.org.uk>
References: <CAC=t97A1S6599aHWCCin7KnFWARs_ebfK6GptAXZQbFnSio7eA@mail.gmail.com>
 <20151221081432.GR26782@carfax.org.uk>
 <CAL3q7H6TGU2rz+zP8hcHxaDGx47nTrCndYvP9ArS+Z0HmZ86=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sgneBHv3152wZ8jf"
In-Reply-To: <CAL3q7H6TGU2rz+zP8hcHxaDGx47nTrCndYvP9ArS+Z0HmZ86=A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--sgneBHv3152wZ8jf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 21, 2015 at 09:28:37AM +0000, Filipe Manana wrote:
> On Mon, Dec 21, 2015 at 8:14 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Sun, Dec 20, 2015 at 07:26:07PM -0600, Donald Pearson wrote:
> >> I read an implication in a different thread that defrag and autodefrag
> >> behave differently in that autodefrag is more snapshot friendly for
> >> COW data.
> >>
> >> Did I understand that correctly?  I have not been doing defrag on my
> >> virtual machine image directory because I do use a snapshot schedule
> >> and the way I understood things, a defrag would basically decouple the
> >> live data from the snapshots and greatly increase utilization.
> >>
> >> It sounded like autodefrag does not have this problem?
> >
> >    Correct.
>=20
> Hum?
> How is that so? Snapshot-aware defrag was disabled almost 2 years ago,
> and that piece of code is used both by a "manual" defrag (ioctl) and
> by automatic defrag.

   A couple of days ago (it's been a busy week) I started writing a
rebuttal of this based on the behaviour of filesystems with autodefrag
set on. Then I realised that actually, we're both right. :)

   If autodefrag behaves as you say (and I'm sure it does, since you
know the code), then when you write data to a file, a piece of the
file around the write(s) can be copied and written elsewhere by
autodefrag. That's going to be the same as the manual defrag. However,
it's a relatively small separation effect that's likely lost in the
noise. If you rewrite the whole file, then it'll separate the file
completely -- which is what manual defrag does -- but then, you'd
expect that behaviour without autodefrag, too.

   So, ultimately, autodefrag *does* separate reflink copies, but only
near where writes are made to the file, so the overall effect is very
similar to the effect you'd have from writing to the file without
autodefrag.

   And I am now better informed than I was before. :)

   Hugo.

> >> If that's true, is there any case where it would not be best practice
> >> to mount with autodefrag enabled?
> >
> >    When you are already tight on I/O bandwidth for your application.
> > autodefrag increases the amount of I/O the disks do (because it's
> > rewriting parts of the file near each write, as well as just the piece
> > that's being written by userspace).
> >
> >    Hugo.
> >

--=20
Hugo Mills             | If the first-ever performance is the premi=E8re, is
hugo@... carfax.org.uk | the last-ever performance the derri=E8re?
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--sgneBHv3152wZ8jf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWebLxAAoJEFheFHXiqx3kZ90P/RcDxilQRVtv2OHo/qDMhhGZ
vuz6l8dQ53JuU79d7pF0qn+81SlgXYsRu/lSt2I3vWU8ePaDGypPj4MzhSEqT0mI
EYnToy+9kswO1/ltQmo4+MJ8r8drfHPXVOmiJ11cTOAKcuzFii362Iq0ezMTS+vi
fUmSZk8/Y3RZKi6ifZiaByuFvZ1gPZ3AjF0XFvHlP7MqJPKSrVNlXV8+yE2T2hSI
PN4rZeJxYr6L/oO87rf3x6/HDQq0uPdyZHjWqbULKWrQtNBXhLdf+rF8J7PTDQ4Z
ku5kYCmumo/JW8RUq6bhz5eiw6X4pqKjnF5kZP/ApZ3ddomRZPeZepLi1yxZZMdh
dV/Lryi0ILrwwA/VXxfNQRWhXTryTA3MaELBXhzmh0BeZF4sBzR/8x0yczR7eyAZ
+7d4IDiyhxMdSPPV5RW5SoQiRMCBfO8tq/yxjVzmpzlZhXFEYNSblc4x04XbIT9U
TfTxO4VHOhMRfc30cHZPY9r3wVzZ6drktSfs0D+2MdzyhB0v7qgtlvOaRLW8rMyK
De0Efo5BJpW7dv2K69yvky6ByYaBeZ7+lrI1+O3z2yCzzWzCnuZNEfLTrcEz0vTK
Gh6QSy12kTJFNzVpq2sIsTZVWoYwccxRXa2iEO6TKT0rGkFc1bSSp6/MaLDfMmQD
IKnXwrWeLvfayx1Je9o+
=IG4R
-----END PGP SIGNATURE-----

--sgneBHv3152wZ8jf--
