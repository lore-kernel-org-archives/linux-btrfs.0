Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:58003 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbaCNHd1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 03:33:27 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 3990F41774
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 18:33:27 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 15134-02 for <linux-btrfs@vger.kernel.org>;
 Fri, 14 Mar 2014 18:33:27 +1100 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id C73D441772
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 18:33:26 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: discard synchronous on most SSDs?
Date: Fri, 14 Mar 2014 18:33:24 +1100
Message-ID: <5289248.oqpgSKG6td@quad>
In-Reply-To: <20140314051750.GY6143@merlins.org>
References: <531C1CC4.701@gmail.com> <C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com> <20140314051750.GY6143@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6776770.CkBIl5dEYt"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart6776770.CkBIl5dEYt
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Marc,

On Thu, 13 Mar 2014 10:17:50 PM Marc MERLIN wrote:

> I'm not sure I'm seeing this, which field is that?

I *think* you want smartctl -i instead, and look for the field that say=
s=20
something like:

ATA Version is:   ATA8-ACS, ACS-2 T13/2015-D revision 3

So if my understanding is correct that says it's just rev. 3.0 so TRIM =
for=20
this is synchronous.

Good luck!
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


--nextPart6776770.CkBIl5dEYt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUyKwxI1yjaOTJg85AQKYKAf/eLtJ/sL/ngqRMPYhMmcEYnsMw134t9A7
xc/cE19BRgwGOplkluiYoL7Is+3JUyqUMjZDopxC+90S4MNjv09GQx4yAE7XWHn9
/nlfZPYfckYnOuu85xqhjhhIu7XB67xR/D+E4hGyQbQs7Q8qp1+XqRwd1Nj8pVa8
7TavBjszNompl5g71mkTNHZGNcHex0a1JG8eHUeuTBG6Y7klmb5SQg6Bwch0o5sF
pupeuBhkEcU7L5JvaYX0miUVOWPLAO8sxt7xbVqz5X8Zw/vk6jC8lPAq6+P+UwOt
yu7tfmKDhsPXkPx3kHxwrQZFVdNjNGsr/pVn0f/AAXjViJtbHqgfWA==
=ohnV
-----END PGP SIGNATURE-----

--nextPart6776770.CkBIl5dEYt--

