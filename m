Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.229.20.24]:53704 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab3KVWAb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 17:00:31 -0500
Date: Sat, 23 Nov 2013 04:00:28 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [virt-devel] btrfs NOCOW for VM disk images
Message-ID: <20131123040028.71a8ba4e@natsu>
In-Reply-To: <pan$25aa5$1906a260$3a199c05$d941ebdc@cox.net>
References: <20131122142051.GA32192@stefanha-thinkpad.redhat.com>
	<1616992290.20969836.1385137054390.JavaMail.root@redhat.com>
	<pan$25aa5$1906a260$3a199c05$d941ebdc@cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EXaK0KAeXFWj3W/aksdaW1_"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/EXaK0KAeXFWj3W/aksdaW1_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Nov 2013 21:26:16 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> > During testing I found that the NOCOW flag prevents file cloning from
> > working.  cp --reflink fails with EINVAL when the source file has the
> > NOCOW flag set.
>=20
> That would be expected, since disabling COW means the file will be=20
> updated in-place, and if reflink-copying was allowed, changing the one=20
> view in-place would by definition change the other view of the same file,=
=20
> since it /is/ the same file data.

However snapshotting a subvolume which has NOCOW files *is* allowed.
I'm told data is then COW'ed only once, and only the areas that are changed
after the snapshot has been made (or something along those lines). So since
snapshotting+NOCOW can be combined and everything works automagically as
expected, maybe reflink could be made to work as well?

--=20
With respect,
Roman

--Sig_/EXaK0KAeXFWj3W/aksdaW1_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlKP0/wACgkQTLKSvz+PZwi4+gCfVRfarkkHNz1F3yY17tsiG4ny
b6EAnA/5ehqBtk1j6J5yH8notTJLjvPP
=0UVb
-----END PGP SIGNATURE-----

--Sig_/EXaK0KAeXFWj3W/aksdaW1_--
