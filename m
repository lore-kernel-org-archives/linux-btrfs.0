Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60794 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaETOdJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 10:33:09 -0400
Date: Tue, 20 May 2014 15:33:05 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Astro Xe <astroxeu@yahoo.it>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs fi df output is not updated in a timely manner after
 subvolumes have been deleted
Message-ID: <20140520143305.GA1756@carfax.org.uk>
References: <1400593810.31610.YahooMailNeo@web172206.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
In-Reply-To: <1400593810.31610.YahooMailNeo@web172206.mail.ir2.yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2014 at 02:50:10PM +0100, Astro Xe wrote:
> 
> On my box, the "used" value in the output of "btrfs filesystem df" is not updated in a timely manner, after that one or more subvolumes have been deleted. I need to execute "btrfs filesystem sync", in order to update the value.
> 
> How do I fix this? Or, could someone fix this in btrfs-progs, please?

   I've not tested this, but I think you need one of the two -c/-C
options to btrfs sub del, which perform a synchronous delete. Once the
command returns, you can be assured that the subvolume has actually
been deleted and any extents freed up.

> I suspect the cause is that subvolumes are marked immediately as deleted, but cleaned up at a later time, is this right?

   Correct.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Great oxymorons of the world, no. 10: Business Ethics ---      

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU3tnoFheFHXiqx3kAQKFdw/8Dm8wVQApUL+NfUtQ+47Ywzqbl9+T/+Oe
eLmXeGIPPTexgsbb6B/rbVYl9In0Fe/793Ezi97JYJVSu6XBtHs5vq9I0Qnp1Bj+
CqSmguMfUk/c0+/XCXjXxWcUhG3a8XZvxaV5JaUQy1ktQLRHUwN+H0RokDLe/Ol9
JC8ri9TIZw1tCMrihFLvA/BOACrhM0HvREGRDKKpcGP1U1FAK5AwfCBJp1MWGJmx
9tG8GVp7sG2kRrpvbxnZMc/0rblAtKCvO74elw0vkb1b9Bhy5CkUF3FLxfrwTAU7
ncKpDBo80M6l0+xQdgRDyY6ejKCUZBj+LyaJax8UCMG3seiPk7YT6zrrrW1dZ7zH
Lj14V/qufkvBmC5/Vzi7GnEnRTZIl2pdaZ+tsGMBQf0XrzE5nigG4BCwHhYzZ+QE
h0The1oxc7FrZGpYz10VfFQAso/v83YXFLa97UZk6CRhxqhkcpN4E/qXG0wsfvaX
zrmI9s4gunQu/WT/twB8yeybYyA9gUTHpJ9syr1YVa1ppfs8Sb5dvtVrsVyYBYFE
GKtHoGIDklvMoG183nbBFbSdGKiDrsZr//vCdT0Y7IoByB09fgRjBbEZ5U4HAGSZ
Ut61HrEOBrJhI2AUXrzMVCvEsvAU9W2T4LW/mBTkLoJ0NChb1ZaQvhBQ1zQNpHn6
r26YXfkM/C8=
=Skik
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
