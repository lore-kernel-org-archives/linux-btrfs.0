From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: subvolumes missing from "btrfs subvolume list" output
Date: Thu, 30 Jun 2011 11:58:13 +0100
Message-ID: <20110630105813.GD11170@carfax.org.uk>
References: <chaz20110629143747.GA28702@seebyte.com>
 <chaz20110629150041.GB28702@seebyte.com>
 <4E0BC7AA.7000709@cn.fujitsu.com>
 <chaz20110630084046.GC28702@seebyte.com>
 <4E0C3F72.5040508@gmail.com>
 <chaz20110630104340.GD28702@seebyte.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1sNVjLsmu1MXqwQ/"
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
	Li Zefan <lizf@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110630104340.GD28702@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>


--1sNVjLsmu1MXqwQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 30, 2011 at 11:43:40AM +0100, Stephane Chazelas wrote:
> 2011-06-30 11:18:42 +0200, Andreas Philipp:
> [...]
> > >> After that, I posted a patch to fix btrfs-progs, which Chris
> > >> aggreed on:
> > >>
> > >> http://marc.info/?l=linux-btrfs&m=129238454714319&w=2
> > > [...]
> > >
> > > Great. Thanks a lot
> > >
> > > It fixes my problem indeed.
> > >
> > > Which brings me to my next question: where to find the latest
> > > btrfs-progs if not at
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> [...]
> > Hugo Mills keeps an integration branch with nearly all patches to
> > btrfs-progs applied.
> > See
> > 
> > http://www.spinics.net/lists/linux-btrfs/msg10594.html
> > 
> > and for the last update
> > 
> > http://www.spinics.net/lists/linux-btrfs/msg10890.html
> [...]
> 
> Thanks.
> 
> It might be worth adding a link to that to
> https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories
> 
> Note that it (integration-20110626) doesn't seem to include the fix in
> http://marc.info/?l=linux-btrfs&m=129238454714319&w=2 though.

   No, I didn't see it when I did my trawl through the mailing list
archives, because it wasn't marked as [PATCH]. I'll pull it in for the
next round of the integration tree, though.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Someone's been throwing dead sheep down my Fun Well ---       

--1sNVjLsmu1MXqwQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFODFbFIKyzvlFcI40RApHxAJ9JjYlZSa8/jXqsdZW851oapc8pTQCgviSd
OFBmNCRWTw3uwAM9my4GgRg=
=QhxW
-----END PGP SIGNATURE-----

--1sNVjLsmu1MXqwQ/--
