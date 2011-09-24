From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: RAID not RAIDing? Or at least not showing correct usage?
Date: Sat, 24 Sep 2011 20:52:09 +0100
Message-ID: <20110924195209.GC2459@carfax.org.uk>
References: <96eceb54b5f19f36507deb29d049fbaf@www.jots.org>
 <20110924193547.GB2459@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
To: Ken D'Ambrosio <ken@jots.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110924193547.GB2459@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 24, 2011 at 08:35:47PM +0100, Hugo Mills wrote:
> On Sat, Sep 24, 2011 at 02:51:12PM -0400, Ken D'Ambrosio wrote:
> > df and btrfs don't always see eye-to-eye, I copied over a 350 MB .avi, and
> > fired up btrfs-show, which came back with:
> > 
> > Label: bigguy  uuid: 5e062e02-f55e-4d7f-866c-3b851b3c6e02
> > 	Total devices 2 FS bytes used 350.57MB
> > 	devid    1 size 2.73TB used 1.27GB path /dev/sdb
> > 	devid    2 size 2.73TB used 0.00 path /dev/sdc
> > 
> > That don't look very mirrored to me.  All the instructions I found said I
> > should just mount /dev/sd(b|c) singly; is there, instead, a logical RAID
> > partition I should be mounting?  Or... is there something else I'm just
> > missing?
> 
>    I would expect it to look like this if you did mkfs with raid10,
> but not raid1.

   I've just realised what might be causing the discrepancy with
RAID-1: btrfs fi show accesses the block devices directly, and so
might show incorrect details if you run it immediately after the copy
has completed. Try running sync first, and then the fi show.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "Your problem is that you have a negative personality." ---     
                             "No,  I don't!"                             

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOfjTpIKyzvlFcI40RAmAjAJ41Yla5TQ815XNsdgV494VRkuUnQwCghztI
ghf/z1AVYKdVf0FYeH43nbs=
=gtpr
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
