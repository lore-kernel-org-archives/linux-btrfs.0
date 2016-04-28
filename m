Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:47092 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbcD1Odt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 10:33:49 -0400
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
	by meiko.romanrm.net (Postfix) with SMTP id 61DEC13F9E0
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 14:33:46 +0000 (UTC)
Date: Thu, 28 Apr 2016 19:33:39 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: Checking if two files share extents
Message-ID: <20160428193339.6eb251cd@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/E_gPacQ1wUYwDenBKkCb.XV"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/E_gPacQ1wUYwDenBKkCb.XV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I'm writing a simple custom deduplication script, and faced a problem with =
how
to make it skip already deduped files. E.g., if I do

  cp -a --reflink fileA fileB

...after this, how to check if fileA and fileB refer to the same extents on
disk? I tried comparing the outputs of "filefrag -e", but this doesn't seem=
 to
be very reliable (and e.g. instantly after such copying and until some time
later, the extent maps WILL differ).

The script I'm writing is in a scripting language, so ideally this should be
obtainable via some command-line text based tool, without kernel API calls =
or
the like.

Perhaps ideally something that would print a list of a given file's extents
with their absolute block numbers. Looked at what's available in "btrfs
inspect", but there doesn't seem to be any command of that sort.

--=20
With respect,
Roman

--Sig_/E_gPacQ1wUYwDenBKkCb.XV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlciH0kACgkQTLKSvz+PZwinhACgkf7yPFPzEeOu9uxH9jrm3g6G
/e4AnRHdslWT60bNUyDvEA9rSUQNA20A
=/dHj
-----END PGP SIGNATURE-----

--Sig_/E_gPacQ1wUYwDenBKkCb.XV--
