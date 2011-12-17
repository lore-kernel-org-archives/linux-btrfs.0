From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 17:27:42 +0000
Message-ID: <20111217172742.GF17573@carfax.org.uk>
References: <201112161851.52011.Martin@lichtvoll.de>
 <201112171238.07681.Martin@lichtvoll.de>
 <20111217114508.GE17573@carfax.org.uk>
 <201112171735.15402.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vKFfOv5t3oGVpiF+"
Cc: Sergei Trofimovich <slyich@gmail.com>, linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112171735.15402.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>


--vKFfOv5t3oGVpiF+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 17, 2011 at 05:35:15PM +0100, Martin Steigerwald wrote:
> Am Samstag, 17. Dezember 2011 schrieb Hugo Mills:
> > > I might still be doing the balance for that optical viewing pleasure
> > > ;).
> > 
> >    :)
> > 
> >    It can't hurt, and with such a small FS it probably won't take
> > long.
> 
> Now I first did a defrag and then a balance. The balance was heavier I had 
> music stalls of about 5 to 10 seconds at time.
> 
> The defrag aborted  quickly with a non-zero return code on second run:
> 
> deepdance:~> btrfs filesystem defragment /
> ^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C
> 
> I wanted to start it via time.
> 
> deepdance:~> /usr/bin/time btrfs filesystem defragment /
> Command exited with non-zero status 20
> 0.00user 1.26system 0:03.86elapsed 32%CPU (0avgtext+0avgdata 
> 2160maxresident)k
> 2656inputs+70712outputs (2major+184minor)pagefaults 0swaps
> 
> Nothing in dmesg. Does 20 as return code mean "already defragmented"? ;)

   I'd have to check what return code 20 means, but... btrfs fi defrag
is *not* recursive, so what you did is effectively a no-op anyway.

> I am looking forward to the new asynchronous defrag interface I read about 
> somewhere.
> 
> Current state now is:
> 
> deepdance:~> btrfs filesystem df /                   
> Data: total=7.75GB, used=6.91GB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=896.00MB, used=506.47MB
> 
> Lets see how that fares.
> 
> Balance did log something:
> 
> [24065.740937] btrfs: found 4207 extents
> [24075.581494] btrfs: found 4207 extents
> [24077.982099] btrfs: relocating block group 24465375232 flags 1
[snip]
> [24730.473343] btrfs: found 19754 extents
> [24735.912210] btrfs: relocating block group 20707278848 flags 36
> [24852.827906] btrfs: found 26482 extents
> [24853.838002] btrfs: relocating block group 20698890240 flags 34
[snip]

> Appears quite fragmented to me, but as I do not understand whats exactly 
> behind this numbers I leave it as it.

   The long numbers are block group IDs. These correspond to a
position in the FS's internal address space (which doesn't, in the
general case, map directly to anything -- there's an internal tree
that holds the map). The flags indicate what type of block group is
being moved. These correspond to the line headings in "btrfs fi df",
and are a bitmap. "flags 1" is a non-RAIDed data block group. "flags
34" is a DUP system block group, and "flags 36" is a DUP metadata
block group. You'll probably find a single reference to a block group
with flags 2, which is the vestigial non-RAID System group you can see
in your "btrfs fi df" output above.

   Extents are simply contiguous regions of storage, corresponding to
parts (or all) of a file, or to individual tree blocks (which are 4k
in size). The "found <N> extents" messages just indicate how many
extents there are to move in the block group it's currently looking
at.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- "I lost my leg in 1942.  Some bastard stole it in a ---       
                            pub in Pimlico."                             

--vKFfOv5t3oGVpiF+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFO7NEOIKyzvlFcI40RAj8tAKDMxyZTKGiES8jw828RZyl4GMmMDwCgo8SM
wZAQ1BZzZRq4YfhCXLWEMdo=
=yKEE
-----END PGP SIGNATURE-----

--vKFfOv5t3oGVpiF+--
