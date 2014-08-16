Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:38329 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751644AbaHPWfj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Aug 2014 18:35:39 -0400
Message-ID: <53EFDCB2.5030701@posteo.de>
Date: Sun, 17 Aug 2014 00:35:30 +0200
From: Karl-Philipp Richter <krichter@posteo.de>
MIME-Version: 1.0
To: Justin Maggard <jmaggard10@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: How to skip "looping a lot" question of btrfs restore 3.15?
References: <53D6D04F.7050904@posteo.de> <CAKgsxVQbP-3huz92Y4Z3d6zVq6dnKekgs0mQzBfbLnhvD-VMjQ@mail.gmail.com> <53D6F2F5.9080107@posteo.de>
In-Reply-To: <53D6F2F5.9080107@posteo.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="osFTt998jQVu1gG94acFHU9V3RapNnFOk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--osFTt998jQVu1gG94acFHU9V3RapNnFOk
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,
I saw that the `a` answer in the `remotes/origin/integration-20140729`
branch only allows to skip the following question/interaction, for the
next after the next, the question is asked again.

-Kalle

Am 29.07.2014 um 03:03 schrieb Karl-Philipp Richter:
> Hi Justin,
> thanks for your help. I guess the patch will be available in the repos,=

> soon, so I'll work with `yes` in the meantime because I'm not too
> familiar with patching in this form.
>=20
> Best regards,
> Karl-P. Richter
>=20
> Am 29.07.2014 um 02:09 schrieb Justin Maggard:
>> On Mon, Jul 28, 2014 at 3:35 PM, Karl-Philipp Richter
>> <krichter@posteo.de> wrote:
>>> Hi together,
>>> In the current HEAD (3f11e516db629f7a662bfd6376231817b4e34cc9) of
>>> https://github.com/kdave/btrfs-progs.git (I assume this list is the
>>> right address because I got some hints to the project from here) the
>>> btrfs restore subcommand asks often (up to 100 time during restaurati=
on
>>> of 400 GB)
>>>
>>>     We seem to be looping a lot on /a/path/to/our/precious, do you wa=
nt
>>> to keep going on ? (y/N):
>>>
>>> which can't be suppressed with the `-i` option (which might be right
>>> because it's technically not an error), but I can't see how to get
>>> around this. Am I missing something? Otherwise it would be nice to ha=
ve
>>> an extra option maybe with an argument how often "we" are looping on =
a
>>> file before the command asks for interaction.
>>>
>>> Best regards,
>>> Karl-P. Richter
>>>
>>
>> I just posted the patch we use to get around that.  Or, if you don't
>> want to build a modified btrfs-progs, you could always use the `yes`
>> command to press y for you.
>>
>> -Justin
>>
>=20


--osFTt998jQVu1gG94acFHU9V3RapNnFOk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT79yyAAoJEGadKJ8eJ7ZGhyQH/RdUIU6U5a95TWKA8Kzl51st
fAv+xUUCALTNUgBKqvCHXgc7K3pqFNEgc74RncMIAW5ebzZNW8ZjKRzwDkkPyyIg
VkYnIPY1G25GIPH/mxPTJ8E74L1GxcwK0edtxoF+8v4zCPtCHSPk7+x/2h9z1/m7
7gCPgQsTKXY+odaI2XE6RAGejhZ6dwPPmfx/RxWBCdc51uZeFm6Jg7zjiVuNjtNo
l3f0BPUuebOqkKy3AdB3QrQml+/9/xn7OvyyUYePFaAsnMZ20atSwN7/5mB6r1ff
9pyWJVlSFt28QWy0K/3wMxRBom1GGx0s5T/H04gwIttHGezm62XR9xSdzCGNTfo=
=ZxAz
-----END PGP SIGNATURE-----

--osFTt998jQVu1gG94acFHU9V3RapNnFOk--
