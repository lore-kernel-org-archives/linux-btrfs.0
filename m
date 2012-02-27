From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: LABEL only 1 device
Date: Mon, 27 Feb 2012 21:23:10 +0000
Message-ID: <20120227212310.GA4481@carfax.org.uk>
References: <pan.2012.02.27.16.48.34@cox.net>
 <C3f4teQD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C3f4teQD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 27, 2012 at 10:15:00PM +0100, Helmut Hullen wrote:
> Du meintest am 27.02.12:
> 
> >>>    I've said this several times: Your expectations are wrong. You
> >>> don't label partitions.
> 
> >> Yes - now I know.
> >> But I'm afraid other people also expect wrong - when I use
> >> mkfs.ext[234] then this option works (in another way than with
> >> "mkfs.btrfs").
> 
> > AFAIK, it works in the same way... that is, it labels the, in that
> > case, ext2/3/4 filesystem, in this case (mkfs.btrfs), btrfs
> > filesystem.
> 
> > From the manpages:
> 
> > mkfs.btrfs (aka mkbtrfs):
> 
> >        -L, --label name
> >               Specify a label for the filesystem.
> 
> > mkfs.ext2/3/4 (aka mke2fs):
> 
> >        -L new-volume-label
> >               Set  the  volume  label  for the filesystem to
> > 	      new-volume-label.  The maximum length of the
> >               volume label is 16 bytes.
> 
> But there's a small difference:
> 
>         mke2fs -L MyLabel /dev/sdn4
> 
> only sets/changes the label (ok - it tests the type of the partition and  
> refuses labeling if the type doesn't fit).

   That feels really weird. It wouldn't ever occur to me to look at a
mkfs tool to relabel a filesystem without destroying the data on it. I
view this behaviour as a bug.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 6: Mature Student ---       

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPS/Q+IKyzvlFcI40RApwVAKDHfW0m+nYBSYEQDc6yUUlYQyWXhQCfby/k
XydbUBhqKdgXAMAGaBEmCSg=
=l5Uo
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
