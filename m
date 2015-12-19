Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:42119 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbbLSVuR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Dec 2015 16:50:17 -0500
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
	by meiko.romanrm.net (Postfix) with SMTP id 8B766ECEB2
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Dec 2015 21:50:11 +0000 (UTC)
Date: Sun, 20 Dec 2015 02:50:10 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: Timeouts copying large files to a Samba server with Btrfs
Message-ID: <20151220025010.7d353d35@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HwOJ96KdkqXWhsJz/8Bj6+h"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/HwOJ96KdkqXWhsJz/8Bj6+h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Sometimes when I copy large files (the latest case was with a 13 GB file) t=
o a
Btrfs-residing share on a Samba file server (using Thunar file manager), the
copy process fails around the end with following messages in dmesg on the
client:

[7699154.504380] CIFS VFS: sends on sock ffff88010d41e800 stuck for 15 seco=
nds
[7699154.504440] CIFS VFS: Error -11 sending data on socket to server
[7699215.173469] CIFS VFS: sends on sock ffff88010d41e800 stuck for 15 seco=
nds
[7699215.173533] CIFS VFS: Error -11 sending data on socket to server
[7699317.982262] CIFS VFS: sends on sock ffff88010d41e800 stuck for 15 seco=
nds
[7699317.982319] CIFS VFS: Error -11 sending data on socket to server

Nothing in dmesg on the server.

My guess is that the Samba server process submits too much queued buffers at
once to be written to disk, then blocks on waiting for this, and the whole
operation ends up taking so long, that it doesn't get back to the client in
time.

This also happens much more often is compress-force is enabled on the serve=
r.

The server specs are AMD E-350 1.6GHz, 16GB of RAM, client/server network
connection is 1 Gbit. Kernel 4.1.15 on the server, 3.18.21 on the client.

Any idea what to tune so that this doesn't happen? (server/client/Samba/Btr=
fs?)

--=20
With respect,
Roman

--Sig_/HwOJ96KdkqXWhsJz/8Bj6+h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlZ10RIACgkQTLKSvz+PZwjTzgCfavN/BYZQqurGk/I9DXzJzBvV
gEwAnjkHzW8/2bWmKf44Wcv1Eo6J3STo
=edxD
-----END PGP SIGNATURE-----

--Sig_/HwOJ96KdkqXWhsJz/8Bj6+h--
