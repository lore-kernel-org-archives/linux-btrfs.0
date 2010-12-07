From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: 800 GByte free, but "no space left"
Date: Tue, 7 Dec 2010 17:25:12 +0000
Message-ID: <20101207172512.GH4273@carfax.org.uk>
References: <20101206182917.GF4273@carfax.org.uk>
 <BbRUmsly1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jaoouwwPWoQSJZYp"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BbRUmsly1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--jaoouwwPWoQSJZYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Helmut -

On Tue, Dec 07, 2010 at 06:05:00PM +0100, Helmut Hullen wrote:
> Du meintest am 06.12.10:
> 
> >> Kernel 2.6.37-rc4:
> >>
> >> # btrfs filesystem df /srv/MM
> >> Data, RAID0: total=2.39TB, used=2.37TB
> >> System, RAID1: total=8.00MB, used=188.00KB
> >> System: total=4.00MB, used=0.00
> >> Metadata, RAID1: total=4.25GB, used=3.51GB
> >> Metadata, DUP: total=1.00GB, used=2.33MB
> >>
> >> Hope it helps!
> 
> >    Yup. You've got what I've got(*). You have two different RAID
> > types for metadata, which shouldn't happen (but does, due to a bug).
> 
> Fear I right that "balancing" tries to reduce the system to something  
> like RAID1?

   It _should_ move all the data on the disk to somewhere else on the
disk, whilst honouring the RAID settings for the filesystem. However,
since it's got buggered up RAID settings now and has been using some
of the space for the wrong RAID type, the balance can't find space
with the right RAID parameters to write to, so it "runs out of space".

   (I think I got that right, anyway. I'm working off a conversation
with Chris on IRC some weeks ago, about what happened to my
filesystem).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Always be sincere,  whether you mean it or not. ---         

--jaoouwwPWoQSJZYp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM/m34IKyzvlFcI40RArNSAJwInAKpbqNY+r3w+wQJ65StCPt2kgCghXgu
Gu1TkWihVJkIbrjvxAtcLmg=
=FOPO
-----END PGP SIGNATURE-----

--jaoouwwPWoQSJZYp--
