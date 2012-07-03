Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:51140 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303Ab2GCNOl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jul 2012 09:14:41 -0400
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-2.hut.fi (8.13.6/8.12.10) with ESMTP id q63DEdlJ004123
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2012 16:14:39 +0300
Received: from smtp-2.hut.fi ([130.233.228.92])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 01739-1218 for <linux-btrfs@vger.kernel.org>;
 Tue,  3 Jul 2012 16:14:39 +0300 (EEST)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-2.hut.fi (8.13.6/8.12.10) with ESMTP id q63DEVQb004116
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2012 16:14:31 +0300
Date: Tue, 3 Jul 2012 16:14:30 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120703131430.GA8825@sli.dy.fi>
References: <20120702230121.GD12755@sli.dy.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
In-Reply-To: <20120702230121.GD12755@sli.dy.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 03, 2012 at 02:01:21AM +0300, Sami Liedes wrote:
> I just got this oops on a computer running 3.4.2.

I now repeated this on 3.4.4. Merely running a "btrfs scrub start /"
causes this after a couple of minutes of running. This time I didn't
run "btrfs scrub status /" in a loop, so that's not the cause. And
judging from the two tries and two crashes, this seems very
repeatable.

The backtrace is basically exactly the same as with 3.4.4.

	Sami

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJP8vA1AAoJEKLT589SE0a0VD0QANY6zmplnAPVFgyTxoIfYLPW
cfgsldXzEpeTOCixvI0B9skuGPpmeUfYObYMz0heTTeYWtJDsCzWjQTF2PyMxdy7
pnLpbCQ/cZWS5b//v8J8MYqqn5L01I7Iwr+vFdjiesLSgpM39ogvPozs+q4upXCA
tBNFty8edoblVVD8nWt1s+RmCnJysnlhVn+4hx3/jbEcqaP/1XlOdE/8fBc3zmUk
CcN/pNM9dFav9VOyCCJ2EEzSzHuj/b6W51GLUOKKk9KCyB9RflqjzbHhrMK4cxcg
yhRTXlc5rhbzDC1odBpOxB40NVNSCSwjUCp/yp6wvRx3vqvrl4ztlJ+GpLgdgSJJ
xFvXa9N1afwXGgZND7Gv3rNv75P2BkA1/QfgFi5rOTNbSr7Y4HI1iZCNv0FWeaWt
aoc9xHTByb3rIE4FYBQjfqqNDtjEj8uvzCgKJKZqeGPrptl86b/6fjYBYIqfHhAQ
S64EwaNfMD12WfaBqPZ/+S9PXPcU6DGgS1VL5kWj/Q9pNK8l9qXdUMJtVFDZfrjo
xToXYe3GmLUZxnLGXB51YtgdHxyIBwrT2Z80drQRp8lbZVn4b1sP+9NnXg2GzFDs
1AvhpOx0uCRuFLbIQx1pHwdp+BTegi2BC427YMptpp0ILuE1H4ljFC8Bfudt6qFo
dXEqeER09aEfzJcVJ36u
=f0b+
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
