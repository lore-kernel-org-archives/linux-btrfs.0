From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Errors during defragmentation
Date: Mon, 29 Nov 2010 21:25:46 +0000
Message-ID: <20101129212546.GA3733@carfax.org.uk>
References: <4CF41500.8000804@podzimek.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Cc: linux-btrfs@vger.kernel.org
To: Andrej Podzimek <andrej@podzimek.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF41500.8000804@podzimek.org>
List-ID: <linux-btrfs.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Mon, Nov 29, 2010 at 10:02:56PM +0100, Andrej Podzimek wrote:
> Hello,
> 
> I decided to test the 'defragment' feature on my system (after a huge number of system updates and prelinking):
> 
> 	find /bin /sbin /lib /usr/lib /usr/bin /usr/sbin -type d -exec btrfs filesystem defragment '{}' '+'
> 
> I have already defragmented a couple of (very large) directories with no errors at all, so this was expected to work somehow. Surprisingly, this time there were thousands of messages like this:
> 
> 	ioctl failed on <directory name> ret -1 errno 28

   errno 28 is ENOSPC

   You've run out of disk space. (Or at least, btrfs thinks so).

> Most of the reported directories had zero files/subdirectories. However, *most* of them were *not* empty...

> What does this error message mean? Could someone shed more light on
> this, please? Should I get ready for a bad crash? ;-) (There seems
> to be no data loss so far. No new messages in dmesg, no unexpected
> system behavior.)

   Hugo.

- -- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- I believe that it's closely correlated with ---           
                       the aeroswine coefficient.                        
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM9BoxIKyzvlFcI40RAv5SAJkB13ClPuTeRElrN1ARFhvDJ2C76gCghC/d
zFczJesxQGbd2jC2ildNNI0=
=i+tI
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD4DBQFM9BpaIKyzvlFcI40RArcoAJdvvhAAyAmGSbUjSUU7YnhNzft4AKDKkjyE
XnwYNEMl6LoCjcON72mjFA==
=qk1T
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
