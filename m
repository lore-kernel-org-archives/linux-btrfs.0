Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49159 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755724AbcIKNC3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 09:02:29 -0400
Date: Sun, 11 Sep 2016 13:02:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Waxhead <waxhead@online.no>
Cc: Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke?
Message-ID: <20160911130221.GE7138@carfax.org.uk>
References: <57D51BF9.2010907@online.no>
 <57D53E3A.1030106@online.no>
 <15194548.valIGHoaRh@merkaba>
 <2682119.DRdtbgPpNZ@merkaba>
 <57D55072.2010701@online.no>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
In-Reply-To: <57D55072.2010701@online.no>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 11, 2016 at 02:39:14PM +0200, Waxhead wrote:
> Martin Steigerwald wrote:
> >Am Sonntag, 11. September 2016, 13:43:59 CEST schrieb Martin Steigerwald:
> >>>>Thing is: This just seems to be when has a feature been implemented
> >>>>matrix.
> >>>>Not when it is considered to be stable. I think this could be done wi=
th
> >>>>colors or so. Like red for not supported, yellow for implemented and
> >>>>green for production ready.
> >>>Exactly, just like the Nouveau matrix. It clearly shows what you can
> >>>expect from it.
> >I mentioned this matrix as a good *starting* point. And I think it would=
 be
> >easy to extent it:
> >
> >Just add another column called "Production ready". Then research / ask a=
bout
> >production stability of each feature. The only challenge is: Who is
> >authoritative on that? I=C2=B4d certainly ask the developer of a feature=
, but I=C2=B4d
> >also consider user reports to some extent.
> >
> >Maybe thats the real challenge.
> >
> >If you wish, I=C2=B4d go through each feature there and give my own esti=
mation. But
> >I think there are others who are deeper into this.
> That is exactly the same reason I don't edit the wiki myself. I
> could of course get it started and hopefully someone will correct
> what I write, but I feel that if I start this off I don't have deep
> enough knowledge to do a proper start. Perhaps I will change my mind
> about this.

   Given that nobody else has done it yet, what are the odds that
someone else will step up to do it now? I would say that you should at
least try. Yes, you don't have as much knowledge as some others, but
if you keep working at it, you'll gain that knowledge. Yes, you'll
probably get it wrong to start with, but you probably won't get it
*very* wrong. You'll probably get it horribly wrong at some point, but
even the more knowledgable people you're deferring to didn't identify
the problems with parity RAID until Zygo and Austin and Chris (and
others) put in the work to pin down the exact issues.

   So I'd strongly encourage you to set up and maintain the stability
matrix yourself -- you have the motivation at least, and the knowledge
will come with time and effort. Just keep reading the mailing list and
IRC and bugzilla, and try to identify where you see lots of repeated
problems, and where bugfixes in those areas happen.

   So, go for it. You have a lot to offer the community.

   Hugo.

> >I do think for example that scrubbing and auto raid repair are stable, e=
xcept
> >for RAID 5/6. Also device statistics and RAID 0 and 1 I consider to be s=
table.
> >I think RAID 10 is also stable, but as I do not run it, I don=C2=B4t kno=
w. For me
> >also skinny-metadata is stable. For me so far even compress=3Dlzo seems =
to be
> >stable, but well for others it may not.
> >
> >Since what kernel version? Now, there you go. I have no idea. All I know=
 I
> >started BTRFS with Kernel 2.6.38 or 2.6.39 on my laptop, but not as RAID=
 1 at
> >that time.
> >
> >See, the implementation time of a feature is much easier to assess. Maybe
> >thats part of the reason why there is not stability matrix: Maybe no one
> >*exactly* knows *for sure*. How could you? So I would even put a footnot=
e on
> >that "production ready" row explaining "Considered to be stable by devel=
oper
> >and user oppinions".
> >
> >Of course additionally it would be good to read about experiences of cor=
porate
> >usage of BTRFS. I know at least Fujitsu, SUSE, Facebook, Oracle are usin=
g it.
> >But I don=C2=B4t know in what configurations and with what experiences. =
One Oracle
> >developer invests a lot of time to bring BTRFS like features to XFS and =
RedHat
> >still favors XFS over BTRFS, even SLES defaults to XFS for /home and oth=
er non
> >/-filesystems. That also tells a story.
> >
> >Some ideas you can get from SUSE releasenotes. Even if you do not want t=
o use
> >it, it tells something and I bet is one of the better sources of informa=
tion
> >regarding your question you can get at this time. Cause I believe SUSE
> >developers invested some time to assess the stability of features. Cause=
 they
> >would carefully assess what they can support in enterprise environments.=
 There
> >is also someone from Fujitsu who shared experiences in a talk, I can sea=
rch
> >the URL to the slides again.
> By all means, SUSE's wiki is very valuable. I just said that I
> *prefer* to have that stuff on the BTRFS wiki and feel that is the
> right place for it.
> >
> >I bet Chris Mason and other BTRFS developers at Facebook have some idea =
on
> >what they use within Facebook as well. To what extent they are allowed t=
o talk
> >about it=E2=80=A6 I don=C2=B4t know. My personal impression is that as s=
oon as Chris went
> >to Facebook he became quite quiet. Maybe just due to being busy. Maybe d=
ue to
> >Facebook being concerned much more about the privacy of itself than of i=
ts
> >users.
> >
> >Thanks,
>=20

--=20
Hugo Mills             | How do you become King? You stand in the marketpla=
ce
hugo@... carfax.org.uk | and announce you're going to tax everyone. If you
http://carfax.org.uk/  | get out alive, you're King.
PGP: E2AB1DE4          |                                        Harry Harri=
son

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJX1VXcAAoJEFheFHXiqx3kQDkQAJTHnfOfWP4CzZey9glG0TZw
qEYJso3DwCxoUGzoU0GXz3v7+xu4zz+H01T8FmJgulAjCdf7plQzMGCXThDkzP0D
fHtS4ETX20OH6ZtPEHk+lpZt/CVtcZXTjH0u9ON9XKEX0xFj40BDCxPQbInxFeyv
YTZ+a1LaLl2xd0i+fEqK4xWHf2do+olxLfeizeokf2/QOX/VO9UE7T5z0T3oRjkb
wTKjotyhII2w6pyKCy8ZaQ6VmNa9PYTMyrupPaQjbL8SC4zKgR6y1A20Pp7ydjGG
/ynQHyhgyGvUDE61xQ1w3OHWA9dKqshLjqURk1Oz+zxn3xjUsY1OQkVMMQ9D13It
fiWM1QCvhMwnvkY4jcp8k7FW5fDzKz9EuPmBsXej9GniNg3DogYRt1pL7EWLXqYC
65N2EK0Ko89qZ92zdtZ0IIBCYST8BlpqAnaezR1UqDhmICFIzLLPSTVi31+ap1JN
E8TNfBdBI4C+1C7KBJK4aqlGM8vTxajupN68DrbwgF2YuYoi0DshpjnWr3U60+8C
x0mc4sEBR4kAIVHqitPf/1b4GyXmg3T0enmX894DtZTl6bfzxg7FrpJ51txPvYJ2
91skj7CRo/6ll2dWTu65b9gZdFJ/6a/TymrCkSQoTlLUp/2JVBIcyiJpAXgYEyk4
hHJqm2wX0EQ+tWOEySu0
=h8mm
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--
