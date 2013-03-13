Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50285 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab3CMIxR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 04:53:17 -0400
Date: Wed, 13 Mar 2013 08:53:09 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: dima <dolenin@parallels.com>
Cc: Alex <alex@bpmit.com>, linux-btrfs@vger.kernel.org
Subject: Re: File space cache
Message-ID: <20130313085309.GB2327@carfax.org.uk>
References: <loom.20130312T171252-0@post.gmane.org>
 <51400F2F.5060109@parallels.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
In-Reply-To: <51400F2F.5060109@parallels.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 13, 2013 at 02:31:27PM +0900, dima wrote:
> Hello Alex,
> 
> On 03/13/2013 01:17 AM, Alex wrote:
> >Hi All,
> >
> >It seems my btrfs file space cache is corrupt; I had to run clear the log
> >through a kernel problem.
> >
> >I've seen messages that the cache is rebuilt automatically, but this doesn't
> >seem to be true as the messages that the free space is what is expected keep
> >coming.
> >
> >I'm running kernel 3.8.2 (Siduction) on Debian testing.
> 
> 
> I believe you may try clear_cache mount option
> https://btrfs.wiki.kernel.org/index.php/Mount_options
> 
> 
> >
> >As a subsidiary question, please, should the <pass> value in fstab be zero or
> >non-zero?
> 
> 
> It should be zero. But since fsck.btrfs is non-existent, it does not
> really matter I guess.

   Eh? We've had a functional btrfsck for nearly a year.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- But somewhere along the line, it seems / That pimp became ---    
                       cool,  and punk mainstream.                       

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUUA+db9z9OVl50rAAQKB/BAAmsQ6tvl9auJoa5N+kdQSR1txa9doJCVZ
gFzlwWG8+MY7uUJPUgPsSlFW3K9IXfRIOXaq7oMxQgS9TdY0tR6Y3eDa2QC79ZPI
SGUW8/BL2WBBSCXiiQrM5J1ezGKBJafDeM8H2LT4PvKncIa/TCCrQCbhGHKKhw7n
DMaGIqPFS1xdaH4qrBs7G7aCtSoyorlIbHA3o+ro+jXksxHoxPr/V57UHFPXIRaB
sLGW6jAZ+wAcXtwA/jqlv5/qBMF6PQaiheuybwUfxxY/VcHJ0lBsZaHByjYS8fOl
zFIWB2MCZLKtZ6u65/Nj1r7V9KuLC3KUnNPjdJq296PTQ70/a+U5+KsUjtySHOdR
rA7WPMJEm/n4FCnJFgrIlYX1MHugtgbDwivM9rcT0SjeZjvsAVRXyeJXwoKmYECA
TAPfH9tIPtg3zYTPSo6gFe2QeM0aggF/bG25YVRyVMLfSRB/Ix7FL0xs9tqf3F0z
tdMwEI3PR+vOZFFRHcdke/OEaz3O4W76l8TEfbrbuakKmevvE5yfa9NyYo6VlcBB
ZzQPVors9GZri8w23nmGyTbo2UyeT7yXoWnU+TLvh0zK2kt7S1DttaoVWsCR/V1Y
Ff27Am5oUPnaSm/8GCyNGbmEZRhEz4/OAjJ5f+DhR7zS4eosTI9h2JuLU7Yf+vNx
p4Yht3c+uRw=
=+tyj
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
