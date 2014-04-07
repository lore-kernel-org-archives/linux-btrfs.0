Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36910 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbaDGJNZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 05:13:25 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Scrub bug on kernel 3.13
Date: Mon, 07 Apr 2014 11:12:52 +0200
Message-ID: <2486343.V0VCIWFSzf@zafu>
In-Reply-To: <20140407090236.GW7442@carfax.org.uk>
References: <17911062.Cl4v2ZqDNL@zafu> <20140407090236.GW7442@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3287558.jyJTDD2GY3"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart3287558.jyJTDD2GY3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Le lundi 7 avril 2014 10:02:36 Hugo Mills a =E9crit :
>    There's a status file in /var/lib/btrfs (at least, it's somewhere
> near there -- I think that's it, though). Delete that

# rm /var/lib/btrfs/scrub.status.13c87f57-3a85-4daf-a4bf-ba777407c169

> and you should be OK.

I'm OK, thanks ! :-)

> What version of the tools are you using?

Latest Arch available version:

# pacman -Qi btrfs-progs
Name           : btrfs-progs
Version        : 3.12-1
Description    : btrfs filesystem utilities
Architecture   : x86_64
URL            : http://btrfs.wiki.kernel.org/
[...]
Provides       : btrfs-progs-unstable
[...]
Conflicts With : btrfs-progs-unstable
Replaces       : btrfs-progs-unstable
Installed Size : 2480,00 KiB
Packager       : Tom Gundersen <teg@jklm.no>
Build Date     : mer. 27 nov. 2013 12:24:33 CET
Install Date   : dim. 22 d=E9c. 2013 09:48:58 CET
Install Reason : Explicitly installed
Install Script : Yes
Validated By   : Signature

Thanks again :-)

=2D-=20
Sw=E2mi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 907=
6E32E

--nextPart3287558.jyJTDD2GY3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iD8DBQBTQmwvL8JcHZB24y4RAu54AJ9aEBnevTT6NIjnTovVo+uenHpl1QCgoIIg
PN+hUDPjL8BzPt7K3Tl/57Y=
=ZtF5
-----END PGP SIGNATURE-----

--nextPart3287558.jyJTDD2GY3--

