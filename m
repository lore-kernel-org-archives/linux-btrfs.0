Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:55580 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751890AbaG1WgG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 18:36:06 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.posteo.de (Postfix) with ESMTP id 398CB25AF530
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 00:36:04 +0200 (CEST)
Received: from posteo.de ([10.125.125.178]) (using TLS)
	by localhost (amavis1.posteo.de [10.125.125.165]) (amavisd-new, port 10026)
	with ESMTPS id MeG8pqV8qcjJ for <linux-btrfs@vger.kernel.org>;
	Tue, 29 Jul 2014 00:36:02 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by mail.posteo.de (Postfix) with ESMTPSA id CE8802C1491
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 00:36:01 +0200 (CEST)
Message-ID: <53D6D04F.7050904@posteo.de>
Date: Tue, 29 Jul 2014 00:35:59 +0200
From: Karl-Philipp Richter <krichter@posteo.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: How to skip "looping a lot" question of btrfs restore 3.15?
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="dxaJcLxekAAHaCtOpUsbgeUWdhP9fn9UM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dxaJcLxekAAHaCtOpUsbgeUWdhP9fn9UM
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi together,
In the current HEAD (3f11e516db629f7a662bfd6376231817b4e34cc9) of
https://github.com/kdave/btrfs-progs.git (I assume this list is the
right address because I got some hints to the project from here) the
btrfs restore subcommand asks often (up to 100 time during restauration
of 400 GB)

    We seem to be looping a lot on /a/path/to/our/precious, do you want
to keep going on ? (y/N):

which can't be suppressed with the `-i` option (which might be right
because it's technically not an error), but I can't see how to get
around this. Am I missing something? Otherwise it would be nice to have
an extra option maybe with an argument how often "we" are looping on a
file before the command asks for interaction.

Best regards,
Karl-P. Richter


--dxaJcLxekAAHaCtOpUsbgeUWdhP9fn9UM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT1tBPAAoJEGadKJ8eJ7ZG+hgH/3eQpQEuClXPa6pc1YOVDZvM
pnLqKCq6xGI1Qg5oRQwKcm+8N+Hlxxpe1xxi1gG1+kpz0tckwohRgY1SsNYmI6fQ
NG3odVF2zkLbMKq4Smd58uE0PWn8Rv2l7zN43s2MXb6CLogPusR0k6qiWl3Vhx15
1eiqsf/qt5rQnUAWx84QYwQfneBkvAZxkXNGssJGRGIwNmhlRJtdevAvlrtE5mvk
s4f+anIRpJkS/UksWZ0RJY353AjARVmU5Gor8aOzVRYKtLGEQ2ywA6HIahKAKG7S
B+34s17M23Dp3xxZmITYwSvT/iRa82iM0HIXPObhmUftdSoitplMTcJYEFl+Awg=
=nabY
-----END PGP SIGNATURE-----

--dxaJcLxekAAHaCtOpUsbgeUWdhP9fn9UM--
