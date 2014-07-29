Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:34056 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752552AbaG2BD5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 21:03:57 -0400
Message-ID: <53D6F2F5.9080107@posteo.de>
Date: Tue, 29 Jul 2014 03:03:49 +0200
From: Karl-Philipp Richter <krichter@posteo.de>
MIME-Version: 1.0
To: Justin Maggard <jmaggard10@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: How to skip "looping a lot" question of btrfs restore 3.15?
References: <53D6D04F.7050904@posteo.de> <CAKgsxVQbP-3huz92Y4Z3d6zVq6dnKekgs0mQzBfbLnhvD-VMjQ@mail.gmail.com>
In-Reply-To: <CAKgsxVQbP-3huz92Y4Z3d6zVq6dnKekgs0mQzBfbLnhvD-VMjQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="TFE7ILpsCSocuksUGFTts822lbXxv1P9S"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TFE7ILpsCSocuksUGFTts822lbXxv1P9S
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Justin,
thanks for your help. I guess the patch will be available in the repos,
soon, so I'll work with `yes` in the meantime because I'm not too
familiar with patching in this form.

Best regards,
Karl-P. Richter

Am 29.07.2014 um 02:09 schrieb Justin Maggard:
> On Mon, Jul 28, 2014 at 3:35 PM, Karl-Philipp Richter
> <krichter@posteo.de> wrote:
>> Hi together,
>> In the current HEAD (3f11e516db629f7a662bfd6376231817b4e34cc9) of
>> https://github.com/kdave/btrfs-progs.git (I assume this list is the
>> right address because I got some hints to the project from here) the
>> btrfs restore subcommand asks often (up to 100 time during restauratio=
n
>> of 400 GB)
>>
>>     We seem to be looping a lot on /a/path/to/our/precious, do you wan=
t
>> to keep going on ? (y/N):
>>
>> which can't be suppressed with the `-i` option (which might be right
>> because it's technically not an error), but I can't see how to get
>> around this. Am I missing something? Otherwise it would be nice to hav=
e
>> an extra option maybe with an argument how often "we" are looping on a=

>> file before the command asks for interaction.
>>
>> Best regards,
>> Karl-P. Richter
>>
>=20
> I just posted the patch we use to get around that.  Or, if you don't
> want to build a modified btrfs-progs, you could always use the `yes`
> command to press y for you.
>=20
> -Justin
>=20


--TFE7ILpsCSocuksUGFTts822lbXxv1P9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT1vL2AAoJEGadKJ8eJ7ZG5M8H+wfiOQfY6kt7ULQVqcZ/nvhL
tmVOoHh1rV55mpL8fOvvD5KT4KyD63T/9mX62g/5LyAkOYwWA8coAtLyhAIKY222
bJgjpcs27FEtJ0Ld7c0BRDuChLs4udZNWf2XN3BXDTthv91ZcS4huYC09Gp97iNC
X79ClIw/5p8dD1Tods7IiY5yf/CIG4C4KXWQf89bYT0e5bmVkx55nVf+9nCWGbGH
0vpWwpSvx4Zz5Oy4EKyQtuL7ejNFajjzxJJvsfCRRtmYFscRv2VDWGZA5LqQ+h8d
ghj6MyX+500+JcY9y5ClqvsYuMnozWmh4ggMy4uc4ysu6J5SFnTK7eMIMHc0ZVs=
=zsBN
-----END PGP SIGNATURE-----

--TFE7ILpsCSocuksUGFTts822lbXxv1P9S--
