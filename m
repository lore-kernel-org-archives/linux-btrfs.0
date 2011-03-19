From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: btrfs fi df units
Date: Sat, 19 Mar 2011 17:41:05 +0000
Message-ID: <20110319174105.GE14946@carfax.org.uk>
References: <im2ofa$5fi$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fWddYNRDgTk9wQGZ"
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <im2ofa$5fi$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>


--fWddYNRDgTk9wQGZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 19, 2011 at 01:17:21PM -0400, Brian J. Murrell wrote:
> I notice when I issue a btrfs fi df the result is in units of GB (for a
> large filesystem -- maybe it's smaller for smaller filesystems).  Is
> there any way to force the units?  I'd like to see the granularity of
> KBs if possible.

   There's a patch set out there[1] that fixes the binary/decimal
units inconsistencies in the output of the btrfs tools. The patch also
allows you to display plain bytes.

   Hugo.

[1] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg06517.html

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Anyone who claims their cryptographic protocol is secure is ---   
         either a genius or a fool.  Given the genius/fool ratio         
                 for our species,  the odds aren't good.                 

--fWddYNRDgTk9wQGZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNhOqxIKyzvlFcI40RAsn3AKCzX5YUtqaWJtDcMP82NjvMt5fL0gCgjqPW
JdgmeCv47dOe4enhpY6shmo=
=nA9m
-----END PGP SIGNATURE-----

--fWddYNRDgTk9wQGZ--
