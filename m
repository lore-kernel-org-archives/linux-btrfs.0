Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59416 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3CJXtz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 19:49:55 -0400
Date: Sun, 10 Mar 2013 23:49:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: sam tygier <samtygier@yahoo.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Message-ID: <20130310234953.GH30771@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <513CAA25.2010803@gmail.com>
 <khj5l7$ge9$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1EKig6ypoSyM7jaD"
In-Reply-To: <khj5l7$ge9$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1EKig6ypoSyM7jaD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 10, 2013 at 11:40:27PM +0000, sam tygier wrote:
> On 10/03/13 15:43, Goffredo Baroncelli wrote:
> > - DUP			-> dD		(to allow more that 2 copy per
> > 					 disk)
> > 
> > - RAID1			-> nC or *C	
> > 
> > - RAID0 		-> mS or *S
> > 
> > - RAID10		-> nCmS or *CmS or nC*s
> > 
> > - RAID with parity	-> mSpP or *SpP or mS*p (it is possible ?)
> > 
> > - single		-> 1C or 1D or 1S or "single"
> > 
> > 
> > where d,n,m,p are integers; '*' is the literal '*' and means "how many
> > possible".
> 
> Using an asterisk '*' in something will be used as a command line argument risks having the shell expand it. Sticking to pure alphanumeric names would be better.

   Yeah, David's just pointed this out on IRC. After a bit of fiddling
around with various options, I like using X.

   I'm also going to use lowercase c,s,p, because it seems to be
easier to read with the different-height characters. So we end up
with, e.g.

1c      (single)
2cXs    (RAID-10)
1cXs2p  (RAID-6)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- It's against my programming to impersonate a deity! ---       

--1EKig6ypoSyM7jaD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUT0cIL9z9OVl50rAAQL7fxAAnQD9oTGWWn+AcnppotHuSWJFjYpcgirt
ZKH+ZIhnz59LRrxNefbEsIYdwx76ehe/O2lxvdFyo89oV3F7xVrjfzTyQRjjTU3C
RYr7BjrIi6sBP3aL3j/E8+V2ZmEHsIROgM6WtbSO0Lq+s25fU80F3Gw/3Mk61lci
aMdYr2USX5QKTejngaQLE4hXnswdOTHtgi9/6zvJe7R9/OCVHdX1n1AE1ju2SpEj
o9S4uVqi8BKkoWZAvSmNEL1QMvMwskzmvHhlGjwZK9KqPps1CqqrazJmrSNSbiIC
J2iNaOBFqrOsSOXW11pQcRcYByQl4kDn81C9S9IlJpK1CF/6Kw053bfw+5x7DDmR
96EUq/YtLL0V6gns7JqFsQRyPXoJzzk5CPNCAwRbNcxZ25+c/YTPCuz3T4Y1U683
mdXVEjDQ1jMf4soE+tja1ab2tycW+jwnuCbbPVNvPo07ZjyoHKNtaCV3ggeLz7GJ
d+cM5ytUtR5QUKwG4RC+QsBQvRC4CpNBU5uyJ/gbO4S6wAzIaM6IWmGytgCYfUwM
OZq+n9T2Bb35FpBJ49CyU1yiwdSQd1IFMg/M9X0rzHcpeMk6SdBZpZjXHSuQz3RV
2jQ+CYQNSimlBsckokDFbEfZ7Wuu6J7DJ+FzSi4UAzv2puq2SrUO09ivqmhmWWx+
wxsnCd98QaQ=
=sRdn
-----END PGP SIGNATURE-----

--1EKig6ypoSyM7jaD--
