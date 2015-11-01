Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:50284 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbbKAORd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Nov 2015 09:17:33 -0500
Date: Sun, 1 Nov 2015 19:17:30 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Ken Long <kelargo1000@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: trying to balance, filesystem keeps going read-only.
Message-ID: <20151101191730.298dcff4@natsu>
In-Reply-To: <CAAvdE8T8AzeENxgYDvTTCN7H2RsBZg07mv+KsuPDG7AdLixCxA@mail.gmail.com>
References: <CAAvdE8So0SeT5q1bH5v2Awzm458Gi3CiSWqhVudg=vC-=Bqqtg@mail.gmail.com>
	<20151101184844.0d67e5e2@natsu>
	<CAAvdE8T8AzeENxgYDvTTCN7H2RsBZg07mv+KsuPDG7AdLixCxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OtkNPk_gcYSF8fVitsxllOP"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/OtkNPk_gcYSF8fVitsxllOP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Nov 2015 09:07:08 -0500
Ken Long <kelargo1000@gmail.com> wrote:

> Yes, the one drive is that Seagate 8TB drive..
>=20
> Smart tools doesn't show anything outrageous or obvious in hardware.
>=20
> Is there any other info I can provide to isolate, troubleshoot further?
>=20
> I'm not sure how to correlate the dmesg message to a specific drive,
> SATA cable etc..

See this discussion: http://www.spinics.net/lists/linux-btrfs/msg48054.html

My guess is these drives need to do a lot of housekeeping internally,
especially during heavy write load or random writes, and do not reply to the
host machine in time, which translates into those "frozen [...] failed
command: WRITE FPDMA QUEUED" failures.

I did not follow the issue closely enough to know if there's a solution yet=
, or
even if this is specific to Btrfs or to GNU/Linux in general. Maybe your be=
st
bet would be to avoid using that drive in your Btrfs array altogether for t=
he
time being.

--=20
With respect,
Roman

--Sig_/OtkNPk_gcYSF8fVitsxllOP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlY2HvoACgkQTLKSvz+PZwhTzwCdGTBoRvyonrzPVSsbsZLU2hrd
u+kAmwXkeQrg5PuQmL+qCSKUkS0KekJf
=HT/i
-----END PGP SIGNATURE-----

--Sig_/OtkNPk_gcYSF8fVitsxllOP--
