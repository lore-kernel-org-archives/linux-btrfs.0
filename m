From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Yet Another Newb Question...
Date: Wed, 7 Dec 2011 21:29:00 +0000
Message-ID: <20111207212900.GA4614@carfax.org.uk>
References: <bf38f96107f723d7471ad1d46a0403d7@www.jots.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Cc: linux-btrfs@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <bf38f96107f723d7471ad1d46a0403d7@www.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 07, 2011 at 04:14:46PM -0500, Ken D'Ambrosio wrote:
> (Asking this question on this list kinda makes me wonder if there shouldn't be
> a btrfs-users list where folks could ask questions just like this without
> pestering developers...)
> 
> Anyway -- I had a root partition with a /snapshots directory, in which I placed
> a bunch of snapshots.  At one point, I goofed stuff up, and decided to revert
> my root (using "btrfs sub set-default") to one of the snapshots.  Rebooted, and
> it worked great -- just like I'd hoped.
> 
> But where'd the snapshots in /snapshots go?

   Where they always were -- it's just that you've mounted a different
bit of the filesystem, so you can't see them. :)

> I mean, I still see them if I do a "btrfs sub list", but how do I *get* to them
> for, say, deleting?  (I can still mount them via "-o subvolid", but that's not
> quite the same thing.)

   If you've got subvolumes outside your mounted filesystem, then you
can either reach them by mounting via subvolid, or by mounting the
top-level subvolume with subvolid=0 (on, say, /media/btrfs-top) and
then navigating through that to the subvolume you want.

   See (my) recommended filesystem structure on the wiki[1].

   Hugo.

http://btrfs.ipv5.de/index.php?title=SysadminGuide#Managing_snapshots

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- There are three things you should never see being made: laws, ---  
                        standards,  and sausages.                        

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFO39qcIKyzvlFcI40RApCxAJ9agDk7JkqUI2pMd5Sc0oXRHGrqggCeNlYc
38nAbw7RIpHFyzFHOwvhtYk=
=ixvd
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
