Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59767 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab3L1Rhd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Dec 2013 12:37:33 -0500
Date: Sat, 28 Dec 2013 17:37:30 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
Message-ID: <20131228173730.GA7234@carfax.org.uk>
References: <20131228171943.GE19863@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
In-Reply-To: <20131228171943.GE19863@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Yes, I am.

On Sat, Dec 28, 2013 at 09:19:43AM -0800, Marc MERLIN wrote:
> Currently, I have a nightly cronjob that rsyncs my SSD to my HD on my
> laptop.
> 
> Of course, running rsync on an entire FS every night is slow, especially
> if I happen to try to use the laptop at the same time.
> 
> Obviously, that's what btrfs send/receive is supposed to fix:
> https://btrfs.wiki.kernel.org/index.php/Design_notes_on_Send/Receive
> http://lwn.net/Articles/506244/
> 
> It's been around for about 1.5 years now, so I was curious if others had
> converted to it for backups when indeed the wiki has the CYA 'if you use
> for backups, you get what you deserve' :)
> 
> Is it still being worked on, or kind of frozen/good as is?

   It's almost feature-complete: there's one version bump expected in
the stream format, to handle files with holes in. There are probably
still awkward bugs in there (awkward in the sense that your backups
will fail noisily if you hit one), but for my current usage -- disk to
disk on the same system -- it seems to work OK.

   I'm trying at the moment to hack together a working send/receive
backup between two systems. As far as I know, the send/receive will
work OK, but I'm having problems with firewalls and ssh tunnels right
now. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- A cross? Oy vey, have you picked the wrong vampire! ---       

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUr8MWlheFHXiqx3kAQJWZA//dEt+pKBeTP68CQht5pCoxtWApoHnp/00
NrWpgnTMGc2G9veefGXjDigsKn/uKTcI2wLaX50aVtabxoYCcMxA2hxLnMA6Lnr2
/SZJ+cek0R7htW65nFNAPWL/UFiIhZC1PtWgbRyQabhZY0rK0thUsSkQC/aLfdyT
x/YyAEgTjRW7Z6/pzaT6dhSnHrrP/KjLeDRxCZIpDSLfNGUejTI7qHd8/T44hR6z
JRui1ekp+LRYrlBjjAly4Yu9zPEHhYIYqlNCUNh3TjRF8+5SRqz3Qqi73Ikf0L11
HBQKTrhF02X1t5wuMSEUlvVP+w9gxZKVoQu/xiBHRN8QVCZLns290SB+DjQjujbZ
+TFH35Iq9P2+CHAlvYCR4TOhO7a2Bik5a06al/vMG+ZSvgEoY9um/IsoWNyfI9PI
v3LjhFvAeoFk0oL4IiOQLTExO9K8pSicSnTnFkESn6J8zAEbKISfF0bOaMfE1DRu
M8v87Cd2cLOLvz9TzNX1IUTD2JKYiWfdIVrzeWQIWYf5XofDQnbktT5zXEZ2dLGV
Imw6Jr8I2wiwbl4jbmlWJJAFAQE9tpJ4HVqgP4qDvC49jQBo+OnAEdLLL1yhhEZg
TrbJp04XYkV/JqcER/YZx7h51kkr8WiUCOIjzGB56to1uOO/iCxZBxUdxN3NQLGh
gmnki3101pU=
=PZE/
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
