Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43570 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3I0OZj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 10:25:39 -0400
Date: Fri, 27 Sep 2013 15:25:35 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Tom Gundersen <teg@jklm.no>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: csum questions
Message-ID: <20130927142535.GB28147@carfax.org.uk>
References: <CAG-2HqV3MoRQ9E9VqjJ7NFKia7=b30_LKKL82FmV6s4u6vOrTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
In-Reply-To: <CAG-2HqV3MoRQ9E9VqjJ7NFKia7=b30_LKKL82FmV6s4u6vOrTA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 27, 2013 at 04:22:16PM +0200, Tom Gundersen wrote:
> Hi guys,
> 
> I have some questions about btrfs' handling of invalid csums.
> 
> For the sake of argument I'm assuming no raid or anything like that
> (so only one copy exists of every file).
> 
> When I try to access a file whose csum does not match, btrfs logs an
> error and refuses access to the file. I have two questions about this:
> 
> 1) What happens to the file. Will btrfs just leave it alone, or will
> it be deleted from disk (I seem to remember reading this somewhere,
> just want to confirm)?

   It's left there.

> 2) How may I tell btrfs to ignore all csums and just assume they are
> all correct? The reason for wanting this is in case the csum is
> garbled and the file is intact, or the csum is correct and the file is
> only partially garbled, but may still contain useful data.

   You can't, right now. There's discussion on IRC about this very
point right now. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- A clear conscience.  Where did you get this taste ---        
                         for luxuries,  Bernard?                         

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUkWVX1heFHXiqx3kAQLz0g/9FVv/kWiA475oa8Dxq2G3czSi/hXkYB9b
K4Cd0fj3f3DMoydExQPiZc3PIh5GwKZtNoRH2cGU7NCI1KI27+tAzKcVUpzzGvWU
2CREHquZOXsCAnozRU6IGWaJWbNGvvDHoBagj+tlYcCLEBJtBEJPrYuHRjQhJPsm
23Jt+8sZZ9Wff+2/3Ze8zcgnMkRb2lhWdILQa+9vOa/pAzdX8+eOWGbWhDV/VygB
/55O4KNRlKsNtV9Mk3a8cHaHnplumECFAM8/YNIqfd8gEIaMsxKH3MFkOjwgl2DN
WNDcgB8vA2/Bh7x9O2xoGdhRvUiC9RlGD8olHAnLSInWe72l5iGzIPhHH7S+EJ5X
jqNEa7fE4HXL47LcTqxMIYcMTfGLsvzA+6NM9QAmn/2/nLj4ojH0P+akoYBTygoV
K1E9yNwPDS5hEh1dqw7iK3zglhJOOzUyYCHhgxboOw2kE1+8FfbzeehzhBSp0Ps7
8D0P2bhKr6btis7T/lL6iDhjOFkPkkgyE9g6NQguFVo2njN5RR5QMOruOusjThIQ
WIivKCJJP7ZMeDVjNr7GwWqj56QQRRU4nAsoXHqjS/p+Gb/+oviYhWSolsLabV2N
EEzqMWmcPxNzJb8R7UUzQawh1w3guTfTlLglpTItUJrKY7ptHy+Td9mySmDuM/2o
adNrQThonvg=
=Re8C
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
