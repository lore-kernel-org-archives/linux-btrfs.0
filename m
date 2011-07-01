From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs-progs: integration branch updated
Date: Fri, 1 Jul 2011 09:54:19 +0100
Message-ID: <20110701085419.GB4067@carfax.org.uk>
References: <20110630211902.GC4352@carfax.org.uk>
 <4E0CEEF8.7030901@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0CEEF8.7030901@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 30, 2011 at 11:47:36PM +0200, Andreas Philipp wrote:
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>  
> On 30.06.2011 23:19, Hugo Mills wrote:
> > After a reorganisation of patches, and sending a bunch of them to
> > Chris, I've also updated the integration branch to match that.
> > It's available from:
> >
> > http://git.darksatanic.net/repo/btrfs-progs-unstable.git/
> > integration-20110630
> >
> > The shortlog of 17 patches in this branch beyond the ones I've
> > sent to Chris is below.
> >
> > Hugo.
> >
> >
> > Andreas Philipp (1): print parent ID in btrfs subvolume list
> >
> > Goffredo Baroncelli (1): Scan the devices listed in
> > /proc/partitions
> >
> > Hugo Mills (8): Balance progress monitoring. Add --monitor option
> > to btrfs balance progress. User-space tool for cancelling balance
> > operations. Run userspace tool in background for balances. Initial
> > implementation of userspace interface for filtered balancing.
> > Balance filter by device ID Balance filter for virtual address
> > range Interface for device range balance filter
> >
> > Jan Schmidt (5): commands added scrub ioctls added
> > check_mounted_where scrub userland implementation scrub added to
> > manpage
> >
> > WuBo (1): Btrfs-progs: Add chunk tree recover tool
> >
> > Zhong, Xin (1): btrfs-progs: Improvement for making btrfs image
> > from source directory.
> 
> When issuing 'make all' in this branch I get the following error:
> make: *** No rule to make target `btrfs-recover-chunk.o', needed by
> `btrfs-recover-chunk'.  Stop.
> When trying to figure out what is going wrong I did not find a file
> called btrfs-recover-chunk.c. Might it be missing?

   It is. The file was still on my disk (which is why I didn't see
this when compile-testing), but it had dropped out of its patch when I
was re-working the stack. I've added it again and will be producing a
new integration branch later today.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Nothing wrong with being written in Perl... Some of my best ---   
                      friends are written in Perl.                       

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFODYs7IKyzvlFcI40RAk3SAJwN8cZASVGgm0kOxbFgUNDBp9P0ewCglfIA
aMEPe38TO3hc1yeKAOTfBSE=
=M1ZS
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
