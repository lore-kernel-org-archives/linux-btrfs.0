Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:50789 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850Ab3KIBWZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 20:22:25 -0500
From: Chris Samuel <chris@csamuel.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.11.5 kernel infinite loop
Date: Sat, 09 Nov 2013 12:22:19 +1100
Message-ID: <5116277.EeSxDVfOuC@quad>
In-Reply-To: <pan$70f09$474e61ed$c27deec7$82b1529a@cox.net>
References: <201311061252.39398.russell@coker.com.au> <pan$70f09$474e61ed$c27deec7$82b1529a@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2032747.TcNZBengxf"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2032747.TcNZBengxf
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wed, 6 Nov 2013 12:37:32 PM Duncan wrote:

> Note that there's another critical patch in-flight, patching a bug 
> triggered by btrfs balance on filesystems with pre-allocated files (like 
> systemd does with its journal and various torrent clients do with their 
> downloads).  But this one is currently being held up because stable rules 
> require it to be in current mainline first, and 3.12 is out, but the two-
> week 3.13 commit window that would normally be open now is suspended for 
> a week, as Linux is traveling without a reliable net connection.  So the 
> patch can't hit mainline, and thus won't hit stable unless an exception 
> is made, until after Linus' vacation, when the commit window opens and 
> the patch is accepted.

Greg K-H has said he'll accept stable patches that haven't hit the mainline 
during this period.

cheers!
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart2032747.TcNZBengxf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUn2OS41yjaOTJg85AQLhLAf/dLXBRB3+YR+wqlYQqeQGNH3XyKF8NDKB
ujfhUUUYeJUnWPXTrqO9/KC7zZ6ep3EbMGVyFKW4n1nWJC7ePK55Z9Kb6sSuCmaG
47tspgoT1jqnsqOhwLwGoEy7J8U2yw+YNYHlmNz/TpRZG6JiDPvgMWM3Vujq6Xxb
VhMGZXfFszHvRiF6ZNZbjVYT+OMQHy70XZa1uYKg6Su9aY5qzOt0+kUTC+jYoywM
6pgh/ungEGC8BzKUv2s4ZCJqOUcWvfnK1ldChEw28fFjrYO0EO1KdlkgFaMVGK9n
z7VovB7V2JOYLPrbdMGZ48tnXVO25K5VTb2xQziWU4OItneqjvgWjQ==
=Hk3o
-----END PGP SIGNATURE-----

--nextPart2032747.TcNZBengxf--

