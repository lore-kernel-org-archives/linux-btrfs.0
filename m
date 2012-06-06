Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40203 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab2FFQE5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2012 12:04:57 -0400
Date: Wed, 6 Jun 2012 17:04:54 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: helmut@hullen.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: New btrfs-progs integration branch
Message-ID: <20120606160454.GP15986@carfax.org.uk>
References: <20120606154032.GO15986@carfax.org.uk>
 <CAMmdFRuCXB@helmut.hullen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0UhZIN3Sa23/ILEd"
In-Reply-To: <CAMmdFRuCXB@helmut.hullen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0UhZIN3Sa23/ILEd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 06, 2012 at 05:52:00PM +0200, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 06.06.12:
> 
> >>> However, the third line with the problem looks like something out
> >>> of date. Possibly a mis-merge?
> >>
> >> Where should I search?
> 
> >    Well, the first thing would be to try a completely new clone of
> > the repo, then git co integration-20120605, and run make again.
> 
> I had a brand new git clone.
> 
> Produced with
> 
> [...]
> git clone http://git.darksatanic.net/repo/btrfs-progs-unstable.git
> cd btrfs-progs-unstable
> git checkout integration-20120605
> 
> (and "btrfs-progs-unstable" had been empty before "checkout")
> 
> > If
> > that's OK, then take a look with gitk in the broken repo and see what
> > kind of history you've got in there -- it should be a single unbroken
> > sequence from "master" (1957076ab4fefa47b6efed3da541bc974c83eed7) to
> > "integration-20120605" (d4c539067d1cb2476c7fb6003625de26e84059af).
> 
> I don't know much about working with git ... but I suppose I'm not  
> working with such things as a (broken) repo.
> 
> It's the same way I had successfully compiled your version from 20111012  
> and from 20111030.
> 
> Is there any change compiling the new version?

   No, just type make from the directory.

   Can you compare your Makefile with the one at [1] -- in particular
the progs variable at line 21-23, the "all" target on line 37, and the
"btrfs-convert" target on line 97. There definitely should not be a
plain "convert" target in there, but that seems to be what your system
was failing on.

   Hugo.

[1] http://git.darksatanic.net/cgi/gitweb.cgi?p=btrfs-progs-unstable.git;a=blob;f=Makefile;h=96944449366d506918db711245aa771d103698a7;hb=integration-20120605

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- We are all lying in the gutter,  but some of us are looking ---   
                              at the stars.                              

--0UhZIN3Sa23/ILEd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFPz3+mIKyzvlFcI40RAgodAJ4l0ZSvJ1uH2qnfbm2oWzUqlfO0tQCgtcmV
Fg1rZ9lLDQ42hceaycC++Gs=
=HFEd
-----END PGP SIGNATURE-----

--0UhZIN3Sa23/ILEd--
