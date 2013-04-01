Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:43719 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757762Ab3DAIML (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Apr 2013 04:12:11 -0400
Received: from natsu (unknown [IPv6:fd39::1e6f:65ff:fea1:3ea6])
	by len.romanrm.net (Postfix) with ESMTPS id 38AD32046C
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2013 08:12:09 +0000 (UTC)
Date: Mon, 1 Apr 2013 14:12:07 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS error in __btrfs_inc_extent_ref:1935: Object already
 exists
Message-ID: <20130401141207.533886a2@natsu>
In-Reply-To: <20130401043605.2eb250a7@natsu>
References: <20130401041540.4b8a4ab3@natsu>
	<20130401043605.2eb250a7@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7dBjxAW1veMdY7fPs8KNqBU"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/7dBjxAW1veMdY7fPs8KNqBU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Apr 2013 04:36:05 +0600
Roman Mamedov <rm@romanrm.ru> wrote:

> Hello,
>=20
> After a reboot the filesystem now does not mount at all, with similar mes=
sages.

So thinking this was an isolated incident, I foolishly continued setting up
scheduled balance on other systems with btrfs that I have.

And got into exactly the same situation on another machine!!

Trying to balance this with -dusage=3D5, on kernel 3.8.5:

Data: total=3D215.01GB, used=3D141.76GB
System, DUP: total=3D32.00MB, used=3D32.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D9.38GB, used=3D1.09GB

Same messages, "Object already exists".

While I currently left the previously mentioned 2TB FS in an unmounted brok=
en
state, still waiting for any response from you on how to properly recover f=
rom
this problem, in this new case I needed to restore the machine as soon as
possible.

I tried btrfsck --repair, it corrected a lot of errors, but in the end gave=
 up
with a message saying that it can't repair the filesystem; then I did
btrfs-zero-log. After this the FS started mounting successfully again.

Not sure if I got any data corruption as a result, but this is the root FS
and /home, and the machine successfully booted up with no data lost in any =
of
the apps that were active just before the crash (e.g browser, IM and IRC
clients), so probably not.

--=20
With respect,
Roman

--Sig_/7dBjxAW1veMdY7fPs8KNqBU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFZQVcACgkQTLKSvz+PZwgM+wCfUDOuHFFTUnzyWI/HVQwuWesT
BXoAnjaCFcyRHtqEdoJY99UmvaVrsPFd
=Gu4J
-----END PGP SIGNATURE-----

--Sig_/7dBjxAW1veMdY7fPs8KNqBU--
