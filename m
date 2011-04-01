From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: btrfs balancing start - and stop?
Date: Fri, 1 Apr 2011 14:52:48 +0100
Message-ID: <20110401135248.GC2984@carfax.org.uk>
References: <4D95D19F.7060101@gmail.com>
 <Bj0iubBi1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qtZFehHsKgwS5rPz"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bj0iubBi1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--qtZFehHsKgwS5rPz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 01, 2011 at 03:36:00PM +0200, Helmut Hullen wrote:
> Hallo, Konstantinos,
> 
> Du meintest am 01.04.11:
> 
> >> "dmesg" counts down the number of remaining "jobs".
> 
> > are you sure? here is a snippet of dmesg from a balance i did
> > yesterday (2.6.38.1)
> 
> > btrfs: relocating block group 15338569728 flags 9
> > btrfs: found 17296 extents
> > btrfs: found 17296 extents
> > btrfs: relocating block group 13191086080 flags 9
> > btrfs: found 21029 extents
> > btrfs: found 21029 extents
> > btrfs: relocating block group 11043602432 flags 9
> > btrfs: found 4728 extents
> > btrfs: found 4728 extents
> 
> Yes - there I look how long the balancing job may still work. You see  
> that the "relocating" line counts down: 15 13 11 ...

   It's not a good measure of time remaining, as the numbers there are
pretty arbitrary: they're the start of the block group in btrfs's own
internal address space. The balance algorithm will indeed go through
the block groups in reverse order, but they're not guaranteed to
terminate at zero. In fact, if you've balanced before, they're pretty
much guaranteed to terminate a long way before zero.

   New block groups (for example, ones created during a balance) are
always created with virtual addresses larger than any previous block
group. So, if you started with block groups at addresses 1G, 2G, 3G,
4G and balanced, you'd end up with ones at 5G, 6G, 7G, 8G. The next
time you balanced, you'd see the numbers count down: 8G, 7G, 6G, 5G,
complete.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- Happiness is mandatory.  Are you happy? ---             

--qtZFehHsKgwS5rPz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNldiwIKyzvlFcI40RAgv5AJ9uwEm0SvhXAwc550pg6q1PKblpSACeODXX
lKzyLK19H/OzVeANd66Ka9E=
=QshE
-----END PGP SIGNATURE-----

--qtZFehHsKgwS5rPz--
