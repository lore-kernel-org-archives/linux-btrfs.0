Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kria.lutoma.org ([176.9.249.87]:52173 "EHLO kria.lutoma.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab3GTWVw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Jul 2013 18:21:52 -0400
Message-ID: <51EB0BD2.1050700@lutoma.org>
Date: Sun, 21 Jul 2013 00:14:42 +0200
From: Lukas Martini <hello@lutoma.org>
MIME-Version: 1.0
To: Jason Russell <jasrusable@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Lots of harddrive chatter on after booting with btrfs on root
 (slow boot)
References: <CA+MxQPHSHVQQko8koeK=WCjS4wq+dss++PWUB6wq7TPOTsY3Yw@mail.gmail.com>
In-Reply-To: <CA+MxQPHSHVQQko8koeK=WCjS4wq+dss++PWUB6wq7TPOTsY3Yw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2BTEAUSAIIQDHITRCFRTR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2BTEAUSAIIQDHITRCFRTR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hey,

I wouldn't neccessarily say this is a btrfs specific problem. I'm
experiencing the same issues in a very similar setup (Also using Arch
Linux, booting to multi-user.target with systemd and starting X
manually, also using the i3 window manager) and I'm using ext4 for the
root partition.

Best,
Lukas

On 07/20/2013 05:15 PM, Jason Russell wrote:
> Hi,
>=20
> I've been using btrfs for my root partition for about a month on
> archlinux and recently Ive started using the i3 window manager and
> starting X manually and I now boot to run level 3 (multi-user.target
> for systemd) and Ive noticed that booting archlinux on a btrfs root,
> there is a lot off hdd chatter after the login prompts are displayed,
> which doesnt happen with ext4 on root, so I have done some testing and
> comparisons.
>=20
> I have stripped down two arch installs, one with btrfs root and one
> with ext4, (same laptop, same hdd) I removed all packages except for
> the base group. On the btrfs root, there is about +- 15 seconds of hdd
> chatter and it takes a long time to log in from the prompts, with the
> ext4 root, the computer is silent after the prompts pop up and login
> is almost instant. The prompts of the two installs pop up at more or
> less the same time (+- 3 seconds) but the login on the btrfs root
> takes muuch longer than the ext4.
>=20
> Ive also noted that this excessive hdd chatter does not occur
> immediately after a fresh format with arch on btrfs root.
>=20
> Ive made some deductions/assumptions:
> This only seems to occur with btrfs roots.
> This only happens after some number of reboots OR after the partition
> fills up a little bit.
> Im pretty sure of ruled out everything except for the filesystem.
>=20
>=20
> I have just done two clean installs to more thoroughly compare ext4
> and btrfs roots. So far no excessive hdd chatter from btrfs.
>=20
> I have also seen what I have described on two other computers
> (different hardware entirely) where there is lots of hdd chatter from
> btrfs root, and nothing from ext4.
>=20
> Here are two threads:
> https://bbs.archlinux.org/viewtopic.php?pid=3D1117932
> https://bbs.archlinux.org/viewtopic.php?pid=3D1301684
>=20
> Any ideas?
>=20
> Thanks,
>=20
> --
> Jason Russell
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


------enig2BTEAUSAIIQDHITRCFRTR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJR6wvXAAoJEPgooMjJ4b0sEbwIAIlxOnnxTmDG0brhTosLmFwT
OUenv5loyaLLlvIfo9+OmU1BlsRCYWZkNbLawgEqH9iHOdwOtIF69EW7d1nx8MbN
OZEhDjFQo0ke8bzYQMZkkmDRQmsxxMrsXdozhToJci3wXLw2CbhVle4xvFHPFcqR
tGsPeW9AVoxzXVMcmN0rIJNlyaAPxpSd9ubcgP8eRGqgLFb2zoJh08uoDuD6smOU
OVG2xaUvEZNV2+HjnrdUze4xc1ncwfjYON2gSaHTeRn8urfFQQQLvisCIWc3cJGl
rxLX/fIqpQLZMHwe4D57XJ/RG7mti45fdIHdqwFrOWrTWBgSy7Q69+rv6tA3OWE=
=UKd1
-----END PGP SIGNATURE-----

------enig2BTEAUSAIIQDHITRCFRTR--
