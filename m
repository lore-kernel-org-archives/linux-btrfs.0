From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Question on subvolumes and mount options
Date: Sun, 13 Feb 2011 17:30:59 +0000
Message-ID: <20110213173059.GB5484@carfax.org.uk>
References: <87oc6fj30p.fsf@savara.sat.thregr.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Cc: linux-btrfs@vger.kernel.org
To: Yuri D'Elia <wavexx@users.sf.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87oc6fj30p.fsf@savara.sat.thregr.org>
List-ID: <linux-btrfs.vger.kernel.org>


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 13, 2011 at 05:46:46PM +0100, Yuri D'Elia wrote:
> Hi everyone, I'm experimenting with btrfs but I have some question
> regarding subvolumes.
> 
> First: In the / filesystem I create a subvolume named /home. As soon as
> the subvolume is created, I can already see the entry point in /home
> without having to mount it separately. Is that expected?

   Yes.

> Mounting the subvolume with mount -o subvol=home /dev/x /home also works
> as expected.
> 
> So, which is best? Looks like mounting subvolumes is not necessary.

   I would recommend putting nothing in the root of the filesystem
*except* subvolumes. i.e. create a "root" subvolume in / that contains
your root filesystem, and make that the default. Then you can mount
your btrfs root subvolume (i.e. the thing that contains all the other
subvolumes) somewhere like /media/btrfs-root, for purposes of managing
subvolumes.

> Is it possible to change mount options in a subvolume? Suppose I would
> like to use nodatasum except for /home, will the following work?
> 
> mount -o nodatasum /dev/x /
> btrfs subvolume create /home
> mount -o datasum,subvol=home /dev/x

   I'd expect that to work, although I haven't tried it myself.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- I always felt that as a C programmer, I ---             
                         was becoming typecast.                          

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNWBVTIKyzvlFcI40RAsFdAKC4NEkNEspTtVO7l8gdeGRDPGiAfQCgwJRz
zxteLQ3BvI2si/Px5QNSpek=
=dH1Q
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
