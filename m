From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: btrfs: 21 minutes to read 1.2M file directory
Date: Wed, 22 Dec 2010 23:01:00 +0000
Message-ID: <20101222230100.GB7736@carfax.org.uk>
References: <20101220222446.GA8629@hexapodia.org>
 <AANLkTikjuoiCJvbBTLuyh3-d=QRyVVdatc4Ybcx5UOdf@mail.gmail.com>
 <20101222203915.GA9918@hexapodia.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Andy Isaacson <adi@hexapodia.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101222203915.GA9918@hexapodia.org>
List-ID: <linux-btrfs.vger.kernel.org>


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 22, 2010 at 12:39:15PM -0800, Andy Isaacson wrote:
> On Tue, Dec 21, 2010 at 03:07:33AM +0200, Felipe Contreras wrote:
> > On Tue, Dec 21, 2010 at 12:24 AM, Andy Isaacson <adi@hexapodia.org> wrote:
> > > I have a directory with 1.2M files in it, which makes readdir very slow
> > > on btrfs with cold caches (although it's reasonably fast with hot caches
> > > as in the first example below):
> > 
> > Sounds like:
> > 
> > Bug 21562 - btrfs is dead slow due to fragmentation
> > https://bugzilla.kernel.org/show_bug.cgi?id=21562
> 
> Hmmm, how do I look at the btree layout for a given inode?

   There's documentation on the tree structures at [1] and [2]. If you
know the inode number of the object you're interested in, you need to
look in the FS tree for the subvolume it's in and find the
(inode_number, EXTENT_DATA, ...) keys for the file. Each of those
records will reference an individual disk extent -- and you can get
the disk start position and length of the extent from the data stored
under the key.

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/Btree_Items
[2] https://btrfs.wiki.kernel.org/index.php/Data_Structures

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Hail and greetings.  We are a flat-pack invasion force from ---   
                     Planet Ikea. We come in pieces.                     

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNEoMsIKyzvlFcI40RAiPkAKDKw9Me4aEuC4JiIcBDzz7+z6jIpgCg0b+g
tCoSbY5Yz1aLYSY5QXEAt0Q=
=vT2Y
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
