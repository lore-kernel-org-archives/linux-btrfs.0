Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f182.google.com ([209.85.222.182]:42145 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbeIOBkt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 21:40:49 -0400
Received: by mail-qk1-f182.google.com with SMTP id g13-v6so5870599qki.9
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 13:24:46 -0700 (PDT)
Date: Fri, 14 Sep 2018 16:24:44 -0400
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Rafael =?iso-8859-1?Q?Jes=FAs_Alc=E1ntara_P=E9rez?=
        <ralcantara@idedalo.com>
Cc: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Subject: Re: Problem with BTRFS
Message-ID: <20180914202443.b5jnos64d2gymrqz@DigitalMercury.dynalias.net>
References: <c7040285-599d-4f6c-cf16-50dc77c9b5f1@idedalo.com>
 <20180914224612.07a5db1b@natsu>
 <20180914181818.rnef5ml3wgelwjm5@DigitalMercury.dynalias.net>
 <3dcb98e2-a3e5-4166-a4e0-42dddf6b7080@idedalo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wkmglbonfj3qzayj"
In-Reply-To: <3dcb98e2-a3e5-4166-a4e0-42dddf6b7080@idedalo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wkmglbonfj3qzayj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 14, 2018 at 10:13:06PM +0200, Rafael Jes=FAs Alc=E1ntara P=E9re=
z wrote:
> Hi,
>=20
> It seems that btrfs-progs_4.17-1 from Sid, includes that feature (at
> least, it says so in the manual page). I don't know if I can install it
> on Stretch but I'll try.
>=20
> Greets and thank you very much to both of you ;)
> Rafael J. Alc=E1ntara P=E9rez.

Please do not install btrfs-progs from sid on stretch, it's likely to
break your system.  If you can't wait, here is a link to what I
uploaded.  It includes both the source and the binary packages (see
gpg signed changes file, and please take care to verify the binaries
weren't tampered with):

https://drive.google.com/file/d/1WflwBEn-QN_btrKPiefz7Kxz58VT8kIQ/view?usp=
=3Dsharing

Of course, this package is unofficial.  The official one will soon
become available through the regular channels.

For best results, set up a local file:// apt repository so that apt
update && apt upgrade will work properly.  Official bpo will
automatically overwrite these, in any case.

Cheers,
Nicholas

--wkmglbonfj3qzayj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE4qYmHjkArtfNxmcIWogwR199EGEFAlucGQsACgkQWogwR199
EGFb+BAAqOC7ZceoBvvok/XYsCPizVwDaPE7ctGP9dbF+uIx1G8xW+U6A0x+sp0O
WY80n63HguzTUo+xDqoffHYWuPJqUQQBwEeCUTWQI7iGiIPbrmW0UmlioVEYZ6Zd
uo7sAzgKM8uBu5LKlXhSIUcbNcRDaV2kGHUTBAdK+ZX7zSMUBeO3Uc0z1MxSvxPP
pX1yqJLCZ0zvdSurGsblJDjbHF6NwJ/VLRpyRQ//Uz0R+dKNX5rY9Qdu6mfI7Z0M
3VA0lLb1/PiDk2ksnebiKdQ01wTszRNIy98ge6guPzy9I4rJG36QELLBdfaA1aAG
PPlysuHNHx4eUJAtQfulSHABe0rq3KziU3ErPqSgQ5pOQocu7xr9aXIHRJw+kJW1
qamhiDBwXvEKR3j+LXN+oTU1Fk5Kk8Sy6Hj0rJXiQbYuBlvbiOaGaz2luFuXTNqt
361ZGcVKpPZ93Z+FgjFGGF608m5jxIoEynNl0VBPvJ4WaUhyNTRJ/YT5DbbspwyX
6GeUirnLAMy5i9rzEj/OTXOuUKh1Dz5rFtuaurQ4RPdnl7maltvpLmIIYa6ykAk9
ZLkA9JRK+cE8JGZYGuj05Sf9J6xpYcycOyhCZqeDg3IbzWEkS+RE66rcOS1Pqdai
agJuLDr4JpHK7qYWZpiowNqY1dhtzle73ubEWeY9bn3+aETF8jU=
=GqM6
-----END PGP SIGNATURE-----

--wkmglbonfj3qzayj--
