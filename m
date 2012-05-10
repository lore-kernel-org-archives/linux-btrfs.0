From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Thu, 10 May 2012 21:15:30 +0100
Message-ID: <20120510201530.GS8938@carfax.org.uk>
References: <20120508200228.GM8938@carfax.org.uk>
 <4FAA8352.4020304@schleiser.de>
 <201205101240.49200.Martin@lichtvoll.de>
 <3868267.PxBJ7yCiiK@bursa22>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="im83/wVv0jiGQj4J"
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
	linux-btrfs@vger.kernel.org, Kaspar Schleiser <kaspar@schleiser.de>
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3868267.PxBJ7yCiiK@bursa22>
List-ID: <linux-btrfs.vger.kernel.org>


--im83/wVv0jiGQj4J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 10, 2012 at 09:43:58PM +0200, Hubert Kario wrote:
> On Thursday 10 of May 2012 12:40:49 Martin Steigerwald wrote:
> > Am Mittwoch, 9. Mai 2012 schrieb Kaspar Schleiser:
> > > Hi,
> > > 
> > > On 05/08/2012 10:56 PM, Roman Mamedov wrote:
> > > > Regarding btrfs, AFAIK even "btrfs -d single" suggested above works
> > > > not "per file", but per allocation extent, so in case of one disk
> > > > failure you will lose random *parts* (extents) of random files,
> > > > which in effect could mean no file in your whole file system will
> > > > remain undamaged.
> > > 
> > > Maybe we should evaluate the possiblility of such a "one file gets on
> > > one disk" feature.
> > > 
> > > Helmut Hullen has the use case: Many disks, totally non-critical but
> > > nice-to-have data. If one disk dies, some *files* should lost, not some
> > > *random parts of all files*.
> > > 
> > > This could be accomplished by some userspace-tool that moves stuff
> > > around, combined with "file pinning"-support, that lets the user make
> > > sure a specific file is on a specific disk.
> > 
> > Yeah, basically I think thats the whole point Helmut is trying to make.
> > 
> > I am not sure whether that should be in userspace. It could be just an
> > allocation mode like "raid0" or "single". Such as "single" as in one file
> > is really on one disk and thats it.
> 
> I was thinking that "linear" would be good name for old style allocator.

   Please do distinguish between the replication level (e.g. "single",
"RAID-1") and the allocator algorithm. These are distinct. Also, note
that both of those work on the scale of chunks/block groups. There is
a further consideration, which is the allocation of file data to block
groups, which is a whole different thing again (and not something I
know a great deal about), but which will also affect the desired
outcome quite a lot.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Anyone who claims their cryptographic protocol is secure is ---   
         either a genius or a fool.  Given the genius/fool ratio         
                 for our species,  the odds aren't good.                 

--im83/wVv0jiGQj4J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPrCHiIKyzvlFcI40RAnBTAJsFxiSUMtsXkR83ShjJNk9WJIUTDwCgjjjR
U35NNmiK56IUlRYJZUN8oZc=
=rOfs
-----END PGP SIGNATURE-----

--im83/wVv0jiGQj4J--
