From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Question on subvolumes and mount options
Date: Sun, 13 Feb 2011 19:18:20 +0000
Message-ID: <20110213191820.GA6321@carfax.org.uk>
References: <87oc6fj30p.fsf@savara.sat.thregr.org>
 <20110213173059.GB5484@carfax.org.uk>
 <87ei7bj03d.fsf@savara.sat.thregr.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Cc: linux-btrfs@vger.kernel.org
To: Yuri D'Elia <wavexx@users.sf.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87ei7bj03d.fsf@savara.sat.thregr.org>
List-ID: <linux-btrfs.vger.kernel.org>


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 13, 2011 at 06:49:58PM +0100, Yuri D'Elia wrote:
> On Sun, 13 Feb 2011 17:30:59 +0000, Hugo Mills wrote:
> >> First: In the / filesystem I create a subvolume named /home. As soon as
> >> the subvolume is created, I can already see the entry point in /home
> >> without having to mount it separately. Is that expected?
> >
> >    Yes.
> 
> What happens if I mount the home subvolume into a different point, like:
> 
> mount -o subvol=home /home2
> 
> and then change a file in /home (which is accessible through the default
> subvolume)?
> 
> Will the change be reflected on both mount points? Or the inverse
> (change /home2)?

   Yes, it's the same piece of storage, just appearing at more than
one point in your overall filesystem. Similar to the way that bind
mounts work.

> >> So, which is best? Looks like mounting subvolumes is not necessary.
> >
> >    I would recommend putting nothing in the root of the filesystem
> > *except* subvolumes. i.e. create a "root" subvolume in / that contains
> > your root filesystem, and make that the default. Then you can mount
> > your btrfs root subvolume (i.e. the thing that contains all the other
> > subvolumes) somewhere like /media/btrfs-root, for purposes of managing
> > subvolumes.
> 
> So you would recommend creating both /root and /home subvolumes, to be
> mounted separately, or create /root and /root/home subvolumes?

   The former.

> >> like to use nodatasum except for /home, will the following work?
> >> 
> >> mount -o nodatasum /dev/x /
> >> btrfs subvolume create /home
> >> mount -o datasum,subvol=home /dev/x
> >
> >    I'd expect that to work, although I haven't tried it myself.
> 
> What if I remount the /home subvol into /home2. What happens when I
> touch a file through /home (nodatasum) and what happens when I use
> /home2 - since both are available at the same time?

   They'll stay in sync with respect to the files written to either
one. I'm not sure what the behaviour of nodatasum is with different
mounts of the same subvolume.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Try everything once,  except incest and folk-dancing. ---      

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNWC58IKyzvlFcI40RAp9xAJ9XfEgPXbjgvUzaS083iR5zG6DBJACeOmTM
dlLo6cV7gThLLJgoBBdLkGo=
=whZZ
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
