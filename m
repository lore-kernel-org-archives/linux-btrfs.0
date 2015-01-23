Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from netz.smurf.noris.de ([213.95.21.43]:37719 "EHLO
	netz.extern.smurf.noris.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754407AbbAWKPR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 05:15:17 -0500
Received: from [2001:780:107:0:1278:d2ff:fea3:d4a6] (helo=smurf.noris.de)
	by netz.extern.smurf.noris.de with smtp (Exim 4.84)
	(envelope-from <matthias@urlichs.de>)
	id 1YEb0o-0004cN-UG
	for linux-btrfs@vger.kernel.org; Fri, 23 Jan 2015 09:58:49 +0000
Date: Fri, 23 Jan 2015 10:58:46 +0100
From: Matthias Urlichs <matthias@urlichs.de>
To: linux-btrfs@vger.kernel.org
Subject: "btrfs send" and interrupts
Message-ID: <20150123095846.GC26830@smurf.noris.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

root@data:/daten/backup/email/xmit# btrfs send foo | ssh wherever btrfs rec=
eive /mnt/mail/xmit/
At subvol foo
At subvol foo
[ some time passes and I need to do something else on that volume ]

^Z
[1]+  Stopped                 btrfs send foo | ssh -p50022 surf btrfs recei=
ve /mnt/mail/xmit/
root@data:/daten/backup/email/xmit# bg
[1]+ btrfs send foo | ssh -p50022 surf btrfs receive /mnt/mail/xmit/ &
root@data:/daten/backup/email/xmit#=20
[ Immediately afterwards, this happens: ]

ERROR: crc32 mismatch in command.

At subvol foo

At subvol foo
ERROR: creating subvolume foo failed. File exists
[1]+  Exit 1                  btrfs send foo | ssh -p50022 surf btrfs recei=
ve /mnt/mail/xmit/
root@data:/daten/backup/email/xmit#=20

Yowch. Please make sure that the simple act of backgrounding a data
transfer doesn't abort it. That was ten hours in, now I have to repeat
the whole thing. :-/

Thank you.
--=20
-- Matthias Urlichs

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwhtWAAoJEHLPjl4ltMKTFMwP/3n+uGcgQb51zyg1FY1Pqq1d
k2GkHyqh9wDfMCtnINzu5+Iq8nNVOhlbKT44TGtthJUru/SEg4c22nADVWAetlfB
2RLNd6GaMvj82amx/Lrh2fk/ubhw9T/7bEuSElnJrax1E6vs6QFETeXVSJ9h9dOz
rxCXZNef9xKgIHeiB/jLYEAWz7QrKcdmo+EptMR5GjhlXLf8UiQIzmsvzp89qx/M
JGz5udxo0Np43NnpcNZYrb+1eDxhB3rLezJZntK8WR0Us69kOo+baLiSdreqb+wY
XiR8OU5u6QWHQnL9nSIDho2+A4DKQZKtCv9icb5Mkgn/sMsOt5Q3NWj4nqZTLgCs
cLP8ezdqSxZs8zq587/rqWAcI+Lzf8zTdDak8FumdMl8woXkO8ZAmIAiTXvDNRs2
hQQmLk+TzDYx47Khhalo7nHbwDTrwdwmg6japhBSjjbicxHv7MG/kG9MBr7G14F8
tc+iOSDvsZZrMQDzzc21uEwpVXbouSzL8kVx1Tu46kkKwLhThcW0IrNSnfBwNJjJ
yGHcHAkApdCbdzZ7kLDZ6iVtuub6w/iUJpj7Dwf/JiDCnbxGkQDGSnD2V06dudWF
L40v+QtC5pZNtaoK62mItFRuaIYZLqW2wb7+xj426+bGw6ds72Wt5kz5r0epVd7u
n24UhWXtG2oTgDS5YVDQ
=kqEg
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
