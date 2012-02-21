From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Balance RAID10 with odd device count
Date: Tue, 21 Feb 2012 01:07:25 +0000
Message-ID: <20120221010724.GB5350@carfax.org.uk>
References: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com>
 <CAHH42iun+Qby5evPhwv0T6LH7BaOk=pcPrPbrKXe2BUEnNX5sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Cc: tom@drdabbles.us, linux-btrfs@vger.kernel.org
To: Wes <anomaly256@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAHH42iun+Qby5evPhwv0T6LH7BaOk=pcPrPbrKXe2BUEnNX5sA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 21, 2012 at 11:45:51AM +1100, Wes wrote:
> I've noticed similar behavior when even RAID0'ing an odd number of
> devices which should be even more trivial in practice.
> You would expect something like:
> sda A1 B1
> sdb A2 B2
> sdc A3 B3

   This is what it should do -- it'll use as many disks as it can find
to put stripes across at the time the allocator is asked to make
another block group.

> or at least, if BTRFS can only handle block pairs,
> 
> sda  A1 B2
> sdb  A2 C1
> sdc  B1 C2
> 
> But the end result was that disk usage and reporting went all out of
> whack, allocation reporting got confused and started returning
> impossible values, and very shortly after the entire FS was corrupted.
>  Rebalancing messed everything up royally and in the end I concluded
> to simply not use an odd number of drives with BTRFS.

   I can't see why that should have happened. What kernel were you
doing this with?

> I also tried RAID1 with an odd number of drives, expecting to have 2
> redundant mirrors.

   This isn't a valid expectation. Or rather, you can expect it, but
it's not what btrfs is designed to deliver. Btrfs's RAID-1
implementation is *precisely two* copies. Hence it isn't really much
like RAID-1, as you've found out.

>  Instead the end result was that the blocks were
> still only allocated in pairs, and since they were allocated
> round-robbin on the drives I completely lost the ability to remove any
> single drive from the array without data loss.
> 
> ie:
> Instead of:
> sda A1 B1
> sdb A1 B1
> sdc A1 B1
> 
> it ended up doing:
> 
> sda A1 B1
> sdb A1 C1
> sdc B1 C1
> 
> meaning removing any 1 drive would result in lost data.

   (Any 2 drives, as you corrected in your subsequent email)

   However, you can remove any one drive, and your data is fine, which
is what btrfs's RAID-1 guarantee is. I understand that there will be
additional features coming along Real Soon Now (possibly at the same
time that RAID-5 and -6 are integrated) which will allow the selection
of larger numbers of copies.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- People are too unreliable to be replaced by machines. ---      

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPQu5MIKyzvlFcI40RAur+AKC2RG3jFveWAzo90HRBkKGNw7DMrACgjTFW
fbDrs4OYsdlvDSUqfzebCCg=
=kBh9
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
