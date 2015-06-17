Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60261 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbbFQN1i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 09:27:38 -0400
Date: Wed, 17 Jun 2015 13:27:36 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Vincent Olivier <vincent@up4.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID10 Balancing Request for Comments and Advices
Message-ID: <20150617132736.GT9850@carfax.org.uk>
References: <1434456557.89597618@apps.rackspace.com>
 <20150616122545.GI9850@carfax.org.uk>
 <61CBE6C4-0D06-4F16-B522-4DBB756FBC31@up4.com>
 <pan$966fb$92ec2f1c$291706f7$cf1b6c68@cox.net>
 <CAJCQCtRGxCr4GaVwkA0QpK8dYjhaBS0-rmi=ymPxycQiGUa_fg@mail.gmail.com>
 <80BA2964-3B67-430B-99BE-62A348C5DBED@up4.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/asd063ZXkk5ILJU"
In-Reply-To: <80BA2964-3B67-430B-99BE-62A348C5DBED@up4.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/asd063ZXkk5ILJU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2015 at 09:13:08AM -0400, Vincent Olivier wrote:
>=20
> > On Jun 16, 2015, at 8:14 PM, Chris Murphy <lists@colorremedies.com> wro=
te:
> >=20
> > On Tue, Jun 16, 2015 at 5:58 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> >=20
> >> On a current kernel unlike older ones, btrfs actually automates entire=
ly
> >> empty chunk reclaim, so this problem doesn't occur anything close to n=
ear
> >> as often as it used to.  However, it's still possible to have mostly b=
ut
> >> not entirely empty chunks that btrfs won't automatically reclaim.  A
> >> balance can be used to rewrite and combine these mostly empty chunks,
> >> reclaiming the space saved.  This is what Hugo was recommending.
> >=20
> > Yes, as little as a -dusage=3D5 (data chunks that are 5% or less full)
> > can clear the problem and is very fast, seconds. Possibly a bit
> > longer, many seconds o single digit minutes is -dusage=3D15. I haven't
> > done a full balance in forever.
>=20
>=20
> Yes, on this 80% full 6x4TB RAID10 -dusage=3D15 took 2 seconds and reloca=
ted "0 out of 3026 chunks=E2=80=9D.
>=20
> Out of curiosity, I had to use -dusage=3D90 to have it relocate only 1 ch=
unk and it took les than 30 seconds.
>=20
> So I put a -dusage=3D25 in the weekly cron just before the scrub.

   In most cases, all you need to do is clean up one data chunk to
give the metadata enough space to work in. Instead of manually
iterating through several values of usage=3D until you get a useful
response, you can use limit=3D<n> to stop after <n> successful block
group relocations.

   Hugo.

--=20
Hugo Mills             | Alert status mauve ocelot: Slight chance of
hugo@... carfax.org.uk | brimstone. Be prepared to make a nice cup of tea.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--/asd063ZXkk5ILJU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVgXXIAAoJEFheFHXiqx3kraYP/3H1YbPvrv4eRFa+YEmh/cau
iDxit4mrCfFDHGFMYDhBi9pLi581ngyLS438Rft/+DOYZ0DX+eMNN7I1Wnu5aQji
JhsWoLSIkA0PDsXcDKZ64L3gTiyUcFB3wcUoGK/zjjBxfk7mrglmHeLjwOFWTSu3
IIAHm8VSVQNLye2qO7xINEv0BnFjiDd0lIxA7Xj8BgtqmOAVOmLj1djWVH+ed2Nh
SnK3A/RXQVPhJezpqOAE9dhvTQdhhDdF+2HWKruCZ94G7B4BRoWHAkEchrjkiylc
gq6+7VxLq2O+N6OBKds7p4NfNO9EAx84KwXJfTWzj1hxThKBiK30RuD1X9bms7Gv
eOzSKr6LxfjStfWsGAHo2PNelRnWA6Y7gxx2RlYVwEEdrqm1Ch9285qCvO7BqhH9
9wNkxSR35l/PLUxkwrsCGl3eIQdmU66DAT0x7vygD3b7U5XyOj/L58b6vIuKUPpa
ryxIPdi9umDgX9YCgKDK8QQWIaqIqK68CPjnSFLC6f01TT+W2cpRMasHLX+GvyNZ
5sNZdh1u5p1OMqv1d/owG95/S6Ot4gWlWn16D7TdtUcZR/uc+xzzH1L9v8x5OzFx
+0CEeq91zPe7jSsM8EXVVRaXxNh+a3XhkRsd12i6i0jDjfay7AbASRsgrQ8If9qX
s5o0uLQCtbzvcxYaMYr6
=QJRr
-----END PGP SIGNATURE-----

--/asd063ZXkk5ILJU--
