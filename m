Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from netz.smurf.noris.de ([213.95.21.43]:37894 "EHLO
	netz.extern.smurf.noris.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754193AbbAWKP6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 05:15:58 -0500
Received: from [2001:780:107:0:1278:d2ff:fea3:d4a6] (helo=smurf.noris.de)
	by netz.extern.smurf.noris.de with smtp (Exim 4.84)
	(envelope-from <matthias@urlichs.de>)
	id 1YEb76-0006RQ-45
	for linux-btrfs@vger.kernel.org; Fri, 23 Jan 2015 10:05:17 +0000
Date: Fri, 23 Jan 2015 11:05:15 +0100
From: Matthias Urlichs <matthias@urlichs.de>
To: linux-btrfs@vger.kernel.org
Subject: Moving snapshots
Message-ID: <20150123100515.GD26830@smurf.noris.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

how do I move a (read-only) snapshot?

Simply creating another read-only snap from the first one and then deleting
the source works, except that it destroy's the snapshot's identity -- which
means that it can't be used as a parent for "btrfs receive" any more.  :-(

--=20
-- Matthias Urlichs

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwhzbAAoJEHLPjl4ltMKTIaEQAM8sYdNbYjU6yDTHiVfb2UFS
fIB2qDVNo6ogWbKheWqE2KopSHQgKSvQSO8Dn1Nx2OT5NUqK7SLbX8IJORUS86qI
xUDrmlmKdxz8b5CZlukwuRDECTw3iNx1Tt9roAaeOYxcx7pyW8LYQ2JFWyi2gzh/
yH6Doimd3hEra+F9FmcOayUBGCjtbrKj4Ei3zi6FkNFsiBBFBE3SWZ//1qWKIdvM
H0xut37wfAXMycsBHzvUJv44FOlXRySPRMd3kNYarOoTcqOw/vv12cN5v7QrRwOe
n02dBUyljR4bLgO/9hIctF2RVYa5q4WvaUqXOmU26mmhTYIpPzjUrwL1ElxVOjKW
o4QemgTGvo/7JcJSgopftxxrsnKWdFoO2CtzxbtGuNKm8pdUWTnXBrGqAVB73K+9
13/53e5aW8WJY489zeIfdhi+WqO9cZCiIyTjS9v+3A+Tr8f2yMFi3Wpc2GiPru6d
3aREgGHpVepvp4XncMiGp1J/QLZYwic23IY8Ud2zhSpBWB5KwHddgFeYqiqFw8/C
rNHMWEMPnI6IO40LQAweY++6xINQ6OoKjh3WsfWKVDjk8tKcl1pkFL1uprr++cN3
4KSXrbK5eCgLX7eAtfm1UMfgeI8M4i9FaWedkwNyIA3wK0EtcAyvaO4bRXaxHO6b
v7YRiHDUm3ZeEM7ogAX3
=/tmg
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
