Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:60332 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbcG2KUz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 06:20:55 -0400
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
To: dsterba@suse.cz, Anatoly Pugachev <matorola@gmail.com>,
        debian-sparc <debian-sparc@lists.debian.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
 <20160727195609.GN30795@twin.jikos.cz> <20160728094441.GO30795@twin.jikos.cz>
 <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
 <5cef3bff-a0bf-e4f9-7906-1b784171e266@physik.fu-berlin.de>
 <20160728122439.GW30795@twin.jikos.cz>
 <CADxRZqyzOtHmpaO9FHhvi0DJjmabRYL0eGYBXBPXSaYa0WcWEw@mail.gmail.com>
 <f56a1b71-cd68-3d83-0650-a10df01f5d5c@physik.fu-berlin.de>
 <b2ac0d76-f2e3-81d7-0ab1-35960426d412@physik.fu-berlin.de>
 <20160728180413.GY30795@suse.cz>
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Message-ID: <35720fc9-5b85-27c7-3d48-bad3ab3c2200@physik.fu-berlin.de>
Date: Fri, 29 Jul 2016 12:20:47 +0200
MIME-Version: 1.0
In-Reply-To: <20160728180413.GY30795@suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="M7d5GDWdej7RKsWan4S4ONHGRdr2fd9Sh"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--M7d5GDWdej7RKsWan4S4ONHGRdr2fd9Sh
Content-Type: multipart/mixed; boundary="Ea5Vkfo4AMaG8qOqGcnggxGVP5gDSkqTr"
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: dsterba@suse.cz, Anatoly Pugachev <matorola@gmail.com>,
 debian-sparc <debian-sparc@lists.debian.org>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <35720fc9-5b85-27c7-3d48-bad3ab3c2200@physik.fu-berlin.de>
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
 <20160727195609.GN30795@twin.jikos.cz> <20160728094441.GO30795@twin.jikos.cz>
 <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
 <5cef3bff-a0bf-e4f9-7906-1b784171e266@physik.fu-berlin.de>
 <20160728122439.GW30795@twin.jikos.cz>
 <CADxRZqyzOtHmpaO9FHhvi0DJjmabRYL0eGYBXBPXSaYa0WcWEw@mail.gmail.com>
 <f56a1b71-cd68-3d83-0650-a10df01f5d5c@physik.fu-berlin.de>
 <b2ac0d76-f2e3-81d7-0ab1-35960426d412@physik.fu-berlin.de>
 <20160728180413.GY30795@suse.cz>
In-Reply-To: <20160728180413.GY30795@suse.cz>

--Ea5Vkfo4AMaG8qOqGcnggxGVP5gDSkqTr
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/28/2016 08:04 PM, David Sterba wrote:
> And I've fixed it that way, now pushed to devel ("btrfs-progs: fix
> unaligned access in raid6 calculations" [1]). Would be great if you or
> Anatoly can test it so I can add it to the 4.7 release (ETA tomorrow).

Awesome, thank you very much! Much appreciated!

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913


--Ea5Vkfo4AMaG8qOqGcnggxGVP5gDSkqTr--

--M7d5GDWdej7RKsWan4S4ONHGRdr2fd9Sh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXmy3/AAoJEHQmOzf1tfkTFNYQAMiejICezdM7omIMxonZ/5hw
Cgwwk4egigj2ulvCdKae/iD1vVKHqRoJMdXOyeb2fjy7lLlzYrQHK8eRw/E546nU
udfzV9KqVvcO0Tl+s4K8wvfvFHQZcJjUzvrh/OByRlRcd3Ia70RszUFtmCv0AIRY
OBJlcsKT/A0OLL6V5cH0l4BOe4BzZWC/3908ZV67sla/Rf56+zAXinqBXbleRLzV
5utfHO8GD+j4TEljPXjhJ36rDVYkbf+tQa4BnsoK7usen7AbRJzRtjaEkLTPbiqe
iKjMKcmXYkZXXu+dknK+AthWSDLe1E7SzPnO3CqVW06iZAEYZkW3kLrlbi7gxzuu
e+HVjgCpTBp24fke9i0Iqg7QxWU+NKHysz8uNk8TOtj2HbExzIQsrfBpfbaZYnOx
+KZoBUDbQFTQSsGmB5Tpq6SAw9IwvnF4ehCl09R59e56mZTD1nQWzpwobz7hn4Rq
fw65bIrX0/fsh3gcIPmabDvXekxHQHKz6JywzwFZSRC/5+GSkyUPI0gXvi0b11+n
M+PBiuTrbAcCMrZRZKQkx1xbMo4ZSyZVJliMgqQ5ovVJkx2BBoapHg54Ph81aLc2
vON6An4hAsaTIfVdAgOKYvobAift0iHD+OFqYJ4Pb3Ta1xS8MykgVeE3HKPefM8c
meqCbn75AxmrdZuU3Po+
=MTgj
-----END PGP SIGNATURE-----

--M7d5GDWdej7RKsWan4S4ONHGRdr2fd9Sh--
