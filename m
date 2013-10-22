Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47209 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3JVN2g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 09:28:36 -0400
Date: Tue, 22 Oct 2013 14:28:31 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Anand Jain <Anand.Jain@oracle.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH 1/3 v4] btrfs-progs: use kernel for mounted disk for show
Message-ID: <20131022132831.GH6598@carfax.org.uk>
References: <1381203700-17558-1-git-send-email-anand.jain@oracle.com>
 <20131015171333.GM5787@twin.jikos.cz>
 <20131021144428.GG6924@localhost.localdomain>
 <526612EB.1050802@oracle.com>
 <20131022132147.GA27304@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IbVRjBtIbJdbeK1C"
In-Reply-To: <20131022132147.GA27304@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--IbVRjBtIbJdbeK1C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 22, 2013 at 09:21:47AM -0400, Josef Bacik wrote:
> On Tue, Oct 22, 2013 at 01:53:47PM +0800, Anand Jain wrote:
> >  That would be less productive approach as a whole.
> >  I have sent out the fix for this. Kindly find it.
> > 
> > ---
> > [PATCH 1/2] btrfs-progs: make get_btrfs_mount callable
> > [PATCH 2/2] btrfs-progs: filesystem show of specified mounted disk should
> > work
> > ---
> > 
> 
> Did you test these?  Because they aren't working for me, so I think a revert is
> the only solution.  Thanks,

   Just for the avoidance of doubt -- Josef means a full xfstests run
on the patches. It may take a long time, but it does mean that
everything(*) gets tested for regressions and helps prevent this
to-and-fro of patches trying to fix up earlier bugs.

   Hugo.

(*) OK, not quite everything, but Eric's and Josef's recent work is
taking us closer to that goal.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "What's so bad about being drunk?" "You ask a glass of water" ---  
                                                                         

--IbVRjBtIbJdbeK1C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUmZ9f1heFHXiqx3kAQJNhw//X/lUkmAcd3/BwXFfwoyPMj0cLBLBBfw2
W9TwGDMsjQhZJ1qpR3Iqc4Cttxequ5MK9EfCmU3TjeUbnMeCjPtSFwuoRCPCf3ek
phtVBUljNuqlvHcJx9XiYbO8uZLNO2mPt9mpO2Va9BtUqcVQACEKNUlwQrpf5nyc
xx+PcQuHNKj/0m7zAOSAgIVlJULAUIASikluuIAuMvVfq/QoMRXSL0ezlFo+sz6o
14veODtSb6/PylgGlNw3XnvKXQEWt1lQjGQBiz8RpTaHgUNC7GYMZ/oDK4aGIPFK
Pvj25fA8B6efMG7Re9UTZaKGTPDk1D+fD7NM6pysw2p7DHH7VcBj/liqIrVqAS+T
ap9y8K1SXVq0xbHjD48OFCDOhWV8e2V6ApJMKRRuaYU3ZQ/5TgP/b3WIwOuJMid2
IgTKtAhL0OsFFqAXmvDHy2SHsm7fQP6cBbDQMQ+Fx7oMTsuSPy/Haa/A3dzp5PRa
SDydjpvfQV9UQvuUq0suTZi5jBJfv6aiuFYhHJhB6KtAUiQPLyj7IXu/XgUeyQb6
lcETS+NIVXAzHP9B26Ag+rgIFEQcww7f8r5MN5tVHJ4y0sHt4crmh6oNrmHIMwQx
y3tH3/i6xsUNOQHC/MN+8MezoBqxpS/PwYITdazEKC4gUIvGVSBuv4CsfeeJv3ls
IQULWR/pcqQ=
=jZth
-----END PGP SIGNATURE-----

--IbVRjBtIbJdbeK1C--
