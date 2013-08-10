Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:38302 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab3HJE6Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Aug 2013 00:58:16 -0400
From: Chris Samuel <chris@csamuel.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: russell@coker.com.au
Subject: Re: error count
Date: Sat, 10 Aug 2013 14:58:06 +1000
Message-ID: <10123682.SXiMQfqCrF@quad>
In-Reply-To: <CAGy7UtjvPHbC0zSvXNAV+LYAr=QX-ePXKCXCx-VKTDD2O9fLMw@mail.gmail.com>
References: <201308042142.12310.russell@coker.com.au> <CAGy7UtjvPHbC0zSvXNAV+LYAr=QX-ePXKCXCx-VKTDD2O9fLMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1504253.gQio7aJA34"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1504253.gQio7aJA34
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sun, 4 Aug 2013 03:37:22 PM Bart Noordervliet wrote:

> a sufficiently up-to-date kernel and btrfs tool will provide the
> 'btrfs device stats' command, which should give you the info you want.

This is what it looks like:

chris@quad:~/Downloads/Linux/FileSystems/BtrFS/btrfs-progs$ sudo ./btrfs 
device stats /srv/DR
[/dev/sdb3].write_io_errs   0
[/dev/sdb3].read_io_errs    0
[/dev/sdb3].flush_io_errs   0
[/dev/sdb3].corruption_errs 0
[/dev/sdb3].generation_errs 0

All the best,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1504253.gQio7aJA34
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEVAwUAUgXIXo1yjaOTJg85AQIH4Af/SDWqR7d+sFD39jx5SKhTiXxfBzywtC9j
eRc7/pkIzvC7jbh2zGENqDRF9Mm7VBT1XsP274a164b+2I37shTIT9HFNMyv7uHe
JqoK8xPQfpNnCxvYh4rFz8Puq7ChN1H7Wk9KGdHr/VFvu8DS6j4WCcs5RP0W3hut
N1Yrj6vnC8Rg690gIzxmyf0fhLcg2ircnVncXM4S1HN2zXtaizvZjkuhvCH3W00c
pI6ixEAUdjblbiwlnbCRRW6U/TxGdLuVPBnL+t2iuahKuO+qFV1CNdu1DadMCXDm
aE0lFi+aFujBSvV6Uu+BluQ9lACNkl5OdbuMiD4SWGEZwsC4FLnKHg==
=Yc/3
-----END PGP SIGNATURE-----

--nextPart1504253.gQio7aJA34--

