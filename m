Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:38305 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757825Ab3KIBNv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 20:13:51 -0500
From: Chris Samuel <chris@csamuel.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Pedro Fonseca <pfonseca@mpi-sws.org>
Subject: Re: [PATCH] Btrfs: fix a crash when running balance and defrag concurrently
Date: Sat, 09 Nov 2013 12:05:42 +1100
Message-ID: <16485118.7Xh0Mq2NkE@quad>
In-Reply-To: <1383110724-13122-1-git-send-email-bo.li.liu@oracle.com>
References: <1383110724-13122-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1699229.M0anrmjDn7"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1699229.M0anrmjDn7
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wed, 30 Oct 2013 01:25:24 PM Liu Bo wrote:

> Running balance and defrag concurrently can end up with a crash:

It's worth noting that Greg K-H has said he'll take stable patches before they 
hit mainline whilst Linus is off-net, as reported here at the kernel summit:

https://lwn.net/Articles/571997/

# Greg added that, during this time, urgent stable fixes could,
# contrary to normal policy, get into the stable tree prior to
# being merged into the mainline; he won't hold them while
# Linus is off the net.

This patch seems like a very good candidate for that.

cheers!
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1699229.M0anrmjDn7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUn2KZo1yjaOTJg85AQLfVQf/ZyLwMTQozkTTU91QRcIncIQZ1ZTuRiUu
vXtbJ/n1yn5w19K/ZJURqWoqTvru6IU2eZ4L+edPRxxJ0IOXkC9cmzdj+djIrj/k
4HEgFjs71ltX0Cco7UQyOGSe6YjBF5+DBp6PsCYSTAheH9S0doLy81Aly4F4M2Nb
w/HpqG6p9wcpQrYIXHZjTk7SgFhOValbgTqwyowTymte7hSzVgP9LcETiqYkADFA
3pDkpzFJ00uTkOJNL91AMNn/yOjFO5W+LPjOooTGSDCHpaQtL47QFbj+ORVr63Dw
hzhqifLsYTpoLb0Hqo28MK+eWQQZGKX5QY+CTVgt5s78l0iAa+IIVg==
=qPkt
-----END PGP SIGNATURE-----

--nextPart1699229.M0anrmjDn7--

