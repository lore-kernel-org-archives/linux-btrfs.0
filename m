Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:39796 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbaCOGtE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 02:49:04 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id E456ED47F1
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Mar 2014 17:49:02 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 23847-03 for <linux-btrfs@vger.kernel.org>;
 Sat, 15 Mar 2014 17:49:02 +1100 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id 7CD80D47F0
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Mar 2014 17:49:02 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: discard synchronous on most SSDs?
Date: Sat, 15 Mar 2014 17:48:56 +1100
Message-ID: <1566234.HjNzCBAKa5@quad>
In-Reply-To: <4448214.x9oPWjPhdL@quad>
References: <1756989.4ep0Vdupld@tethys> <yq1bnx8y2mi.fsf@sermon.lab.mkp.net> <4448214.x9oPWjPhdL@quad>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart30329158.UQJpz1ujyR"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart30329158.UQJpz1ujyR
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Sat, 15 Mar 2014 04:25:05 PM Chris Samuel wrote:

> I wonder if it would be possible to use that knowledge to extend the=20=

> smartctl's --identify functionality to report this?

After reading the SATA 3.1 spec I believe that smartctl *can* indicate =
if a=20
drive claims to support SATA 3.1 NCQ TRIM, thus:

$ sudo smartctl --identify /dev/sdb | fgrep 'Trim bit in DATA SET MANAG=
EMENT'
 169      0          1   Trim bit in DATA SET MANAGEMENT command suppor=
ted=20
$

If that command returns nothing then it's not reported as supported (an=
d I've=20
tested that).  You can get the same info with hdparm -I.

Of course, as Martin said, that doesn't necessarily mean the kernel is =
using=20
that reported ability.

My puzzle now is that I have two SSD drives that report supporting NCQ =
TRIM=20
(one confirmed via product info) but report only supporting SATA 3.0 no=
t 3.1.

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


--nextPart30329158.UQJpz1ujyR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUyP32I1yjaOTJg85AQLWkAf/ZRinrYwI20UYClAyBskLLHDxZpibXwL8
BQuo1CHL9MUfHtrR0zUbQVm9UxKIgr3eEFuG6etixXsaIysiqdJgznyPipmiG/q1
gojoGQxr/FdPPYFWYpLmxbsQW9HTGbfFmwMuujTy87guuaANDVylDdoONDk8x9kd
k99RJdqy+Hs0ob/Vqdcp8Lwln77ghBU1nvhFm9ow6YTb94FCkiZypMO3LaO7+DLO
DPXej7wudN75j5ndT+mQglwi2BzG8x8lVBSgrvGVvDpV2jZXMEZXDJayzbrYb3bZ
kx1AruMN9Cc25Bd735LtQNa3hFRBVH1ddoq/jHLLQpL9N8HjaHU8Eg==
=Bg8Z
-----END PGP SIGNATURE-----

--nextPart30329158.UQJpz1ujyR--

