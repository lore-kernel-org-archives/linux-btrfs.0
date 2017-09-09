Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36256 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756862AbdIILGf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 07:06:35 -0400
Date: Sat, 9 Sep 2017 11:06:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, framstag@rus.uni-stuttgart.de
Subject: Re: generic name for volume and subvolume root?
Message-ID: <20170909110632.GG23980@carfax.org.uk>
References: <20170909083551.GC22060@rus.uni-stuttgart.de>
 <48008a58-a82e-d9f7-327e-eeb905e18aa1@gmx.com>
 <20170909104845.GW12642@rus.uni-stuttgart.de>
 <9911ae20-6181-5ce2-0374-e601a1034c4a@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XaUbO9McV5wPQijU"
In-Reply-To: <9911ae20-6181-5ce2-0374-e601a1034c4a@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XaUbO9McV5wPQijU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 09, 2017 at 06:58:38PM +0800, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B409=E6=9C=8809=E6=97=A5 18:48, Ulli Horlacher wrote:
> >On Sat 2017-09-09 (18:40), Qu Wenruo wrote:
> >
> >>>Is there a generic name for both volume and subvolume root?
> >>
> >>Nope, subvolume (including snapshot) is not distinguished by its
> >>filename/path/directory name.
> >>
> >>And you can only do snapshot on subvolume (snapshot is one kind of
> >>subvolume) boundary.
> >
> >So, I can name a btrfs root volume also btrfs subvolume?
>=20
> Yes, root volume is also a subvolume, so just call "btrfs root volume"
> a "subvolume".

   I find it's best to avoid the word "root" entirely, as it's got
several meanings, and it tends to get confusing in conversation.
Instead, we have:

 - "the top level" (subvolid=3D5)
 - "/"             (what you see at / in your running system)
 - "<top-level>/@" or similar names
                   (the subvolume that's mounted at /)

> >I am talking about documentation, not coding!
> >
> >I just want yo use the correct terms.
>=20
> If you're referring to the term, I think subvolume is good enough.
> Which represents your original term, "directories one can snapshot".
>=20
>=20
> For the whole btrfs "volume", I would just call it "filesystem" to
> avoid the name "volume" or "subvolume" at all.

   Yes, it's a filesystem. (Although that does occasionally cause
confusion between "the conceptual filesystem implemented by btrfs.ko"
and "the concrete filesystem stored on /dev/sda1", but it's generally
far less confusing than the overloading of "root").

   Hugo.

--=20
Hugo Mills             | Well, you don't get to be a kernel hacker simply by
hugo@... carfax.org.uk | looking good in Speedos.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                         Rusty Russ=
ell

--XaUbO9McV5wPQijU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZs8s4AAoJEFheFHXiqx3kUn8P/RPkfl+P5/SxX9zLtZ1Corjj
ZEV1zKmVbY8qdniQrYtoXXieUIr/NnZFfBr+DyVQSllR6FKzxWkeycQ8b9198hDM
d0brQRn3Y3XCUUfP6BkNnR8+5rm8DrrEccCT6a4r/GRBNkoWmpF3QzXO3pLZfmkH
qMUrvthBR4FPT3ROuhnDRkPJpvuPGFPFvxbGRbyWW/6g/HVPlQ4lIGKtdgQiGWhU
UgpTADg/j6vP9Wc3AnNARLPN2J2B0o6IIYMRuRx3sjkCeXaJX4zXYkvzYORdF3Gn
P199v0/KsAZs1wXpCTt2Gq58KezZa5CYb0R5Cr7OgMhI2XF1yvujzkT8rUDYQgAQ
s0F4dbf6ej6gKD4unGNJQXwjkB0ioSxqOPZ+f9KCaSsd9KMCBc2Aq15aYwrCmNhC
q5KVs8IZACFBYJkdvaCkc2iSBJADN820SD+yB6p+hql6PuX15ZnafNdrm+W7n8EV
BTJyO/YPMylBUVezoeXwjbwlAOXjQdUC5MEt8clqMMAMe9ruB0d5oBshH0+fxNXt
q+2gMne1tSXf2nCd7TwJkZwioFILS/x5h6m5q4g0u5lPsUOO6Sc46W70242TQQr5
MYPVkqr3q+xspFcYoibudlKWYrDDKKa0+vLnlVzYgD8CqZDWaLLM0TD73Ih3QRtD
VnH9hOCfmlFwWXWgthp2
=Tr/v
-----END PGP SIGNATURE-----

--XaUbO9McV5wPQijU--
