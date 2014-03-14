Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:54160 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbaCNH1e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 03:27:34 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id A5CE141774
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 18:27:33 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 15134-01 for <linux-btrfs@vger.kernel.org>;
 Fri, 14 Mar 2014 18:27:33 +1100 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id 4615141772
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 18:27:33 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: discard synchronous on most SSDs?
Date: Fri, 14 Mar 2014 18:27:26 +1100
Message-ID: <1523699.N4qpGEZQ9Y@quad>
In-Reply-To: <C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com>
References: <531C1CC4.701@gmail.com> <20140314021159.GQ18959@merlins.org> <C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2386156.aHj2Ovt5sT"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2386156.aHj2Ovt5sT
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Thu, 13 Mar 2014 09:39:02 PM Chris Murphy wrote:

> smartctl -a or -x will tell you what SATA revision is in place. The q=
ueued
> trim support is in SATA Rev 3.1. I'm not certain if this requires onl=
y the
> drive to support that revision level, or both controller and drive.

Both I'd say as I believe it's the controller that has to issue it to t=
he=20
drive, and the drive needs to understand it.

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


--nextPart2386156.aHj2Ovt5sT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUyKvXo1yjaOTJg85AQIYRgf9GuIYv9T6Pg+TwvKf8TH9HZNZTvX+K+v+
rDm6zlZHkYTw6tR/pHCkB4RLBCzcoBpESQYbozXz3P5jCbzfd+He9KoTZuUTAf73
IMXweY8jxZXU+Q1fO2EoDdtaey8yCzCS7mHe/UL9xzhIY/ct5YAbnTYgrIY0xw01
2m5IKGZJEK/M3XydU5zmKQK2szfTbEDf4vj4H4BWSdq3pA/Eqib6eaB4JDRgxySb
7YfugC0H3lAabi8oLaHngIk/Ne3HxiK7IJnUSb6knzVqKJ0nSJMo6v/0Pa5RM7wQ
ZWpFaC1APpmzoAS9ZBZTOc1SX2FXyw17stucTTsQYjRk9AdLVzmPRQ==
=5EEH
-----END PGP SIGNATURE-----

--nextPart2386156.aHj2Ovt5sT--

