Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59496 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab3AMOjL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jan 2013 09:39:11 -0500
Date: Sun, 13 Jan 2013 14:39:08 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Holger Hoffstaette <holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Changing metadata block size after the fact
Message-ID: <20130113143908.GY19051@carfax.org.uk>
References: <pan.2013.01.13.14.07.00.577910@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OsjXUGRLsfCucSoX"
In-Reply-To: <pan.2013.01.13.14.07.00.577910@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OsjXUGRLsfCucSoX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 13, 2013 at 03:07:00PM +0100, Holger Hoffstaette wrote:
> 
> Hi,
> 
> I have an existing btrfs filesystem which was initialized with defaults. I
> want to increase the metadata block size, but after reading wiki/man pages
> etc. have come to the conclusion that this does not seem to be possible.
> Is this correct, and the only way would be backup/mkfs with -l/restore?

   Correct, you can't change the metadata block size once the FS has
been created.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- In my day, we didn't have fancy high numbers.  We had ---      
               "nothing", "one", "twain" and "multitudes".               

--OsjXUGRLsfCucSoX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUPLHDL9z9OVl50rAAQL/+A//e7fGV11auIC3b9zde7nkLp3WpPOeU/He
NaX97HeSoT3+MQhFNyW/Jc5/CucgVQsYmca4YPzV/uMPHOnHi/UFGRM6qQmvsKe7
KJOTPsj/miFVkA3VZxYAfYHdOQISVhr5cMkcNvtuVd2QOhct0/Lk+HJlxrHHq2Gv
Cq20BUOtXFmQVJBGUCythWudWtbUf3TMwTG20skBZrhgxYzWu+lte7Whl072GRD6
+Z8DPN/0RCJEdnA/dMmSgBS7v8BztelspM3o9UNQUXFl+cgGbPSE7m7+gTSSY0Eq
dx9gKBic6gDrHCQBWCwmjDr8bGiJq1FWNZv5NlAz0NqzEMk0sdplvJo1TQjMMsZW
DuK8Q1CrHGum4V1YJ0x+gQ7R+GIynUHgCEAJHC38bh30NHwKMmNquwEdSLPjes0s
hXou9z+IjzcwfKOSIcOz9QcM69rSWbmY7OjHWhr2bwYomiJxNdpTkEuNT1NBZpwW
c9CjQjMWRVPOPEsOETF3A15NEi08kC996XHpx/4U7gfcrXxgzB8hBY5fDaCuEwnt
kY1AgyQT60JQLGWZ5qoEyPtbXYZrtNCk37h6gQ0QvsuCl2RKCeVuTBawzgLC/DJs
Fb/8HcQZUyb53yxZcbhxkhD6o1/6T2syFS65YSMKnc6XpZWMzPJSH1zxcs4ZmpXZ
WKJPWtahaHc=
=xYDp
-----END PGP SIGNATURE-----

--OsjXUGRLsfCucSoX--
