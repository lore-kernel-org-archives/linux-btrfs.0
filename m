Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43656 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbaLLW7V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 17:59:21 -0500
Date: Fri, 12 Dec 2014 22:59:18 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Robert White <rwhite@pobox.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RAID0 extent sizes?
Message-ID: <20141212225918.GG1442@carfax.org.uk>
References: <548B7220.1040403@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ahP6B03r4gLOj5uD"
In-Reply-To: <548B7220.1040403@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ahP6B03r4gLOj5uD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 12, 2014 at 02:54:24PM -0800, Robert White wrote:
> I've seen it mentioned here that generally data extents are 1G and
> metadata extents are 256M.
> 
> Is that per-drive or per-stripe in the case of RAID0?
> 
> That is, if I have data mode raid0 across N drives does the system
> allocate one 1G extent on each drive making the full stripe
> allocation N-gigs; or does it allocate 1/Nth(gig) on each drive
> making the total new allocation 1G?
> 
> Does the raid0 have any arity constraints (like how raid1 is always
> arity-2)?

   The 1 GiB (or 256 MiB for metadata) is the allocation unit. So for
striped RAID levels (like 0, 10, 5, 6), the FS will allocate as many
as it can across all the available devices, and stripe within those.

   Now on to your question -- the stripes within the allocation unit
are 64 KiB in size, so the first 64k goes on the first device, the
next 64k on the second device, and so on.

   The minimum stripe width (e.g. number of devices) is 2 for RAID-0,
4 for RAID-10, 2 for RAID-5 and 3 for RAID-6.

   Hugo.

-- 
Hugo Mills             | I get nervous when I see words like 'mayhaps' in a
hugo@... carfax.org.uk | novel, because I fear that just round the corner is
http://carfax.org.uk/  | lurking 'forsooth'
PGP: 65E74AC0          |                                      GRRM's UK editor

--ahP6B03r4gLOj5uD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUi3NGAAoJEFheFHXiqx3kJFkQAKVHEzJ7ukaEWkLjNK4W3HU8
2Adt46jBNu1pmJOo1+lxIAv54zf3FFzmHMk181BUGoCcnjBGuP6Mp4Tt6CWwah5v
avZM+1x69rMZ7KZ0uNsC3USmvMtCtoMnAnZKn0Az+b/e8+5zIHH4puGFLwQ9aTGJ
raPuoTUBA0hR9lc9v7Rjwfpw/uNY/VBcOFfaP2RshbvyIVI1sDwC1ke+vpmk8Up2
cSnWPkZY7OSBr9dTI4Nja0v39AMxrd5AMCF9zlXxLanjSwgtx/lgjTKInI3zIV1I
3XIXUIR3q5M1BsAGV5LG+CAmal2nzTQH5+rydnuZ5zTDpBDsUkG7J2FNFz6ZqUZ3
AS33ml8i8P+ae8q+Hk99ayI3eMWInZOQ07AY64sI8yHDGo3MtRX056UMUX3MncB6
o0I+ZZTA4utqvPnlhQhIVJKEhH4iobgg9QRCNbVLpKqH7IRzia5dCfmST+YhWwCc
Y4xijbaT45QpdfirWFs2wBigDcl/LfHHJgzgdG4FNR+Q3HcJW8mCrbCoTEsWJwBW
zdzFuGrPUhv/WY7vMrZ5qM0jePVjG0CZHtsfYXnuJUre++1Iv/95cQSC68J+fnyl
1V2ypTIBxVI/G25k9VLHTuKtQk5cnT3gAudv7wyljku7VnHoIh/l7Qplik9xUz0G
NRUKXsJr1KtJXp5oh+f3
=Fm8t
-----END PGP SIGNATURE-----

--ahP6B03r4gLOj5uD--
