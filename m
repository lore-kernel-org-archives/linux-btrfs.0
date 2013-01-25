Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40924 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3AYQsj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 11:48:39 -0500
Date: Fri, 25 Jan 2013 16:48:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Eric Sandeen <sandeen@redhat.com>
Cc: kreijack@inwind.it, Goffredo Baroncelli <kreijack@tiscalinet.it>,
        Goffredo Baroncelli <kreijack@gmail.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, gene@czarc.net
Subject: Re: [PATCH 01/10] Btrfs-progs: move open_file_or_dir() to utils.c
Message-ID: <20130125164829.GC1371@carfax.org.uk>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1358928771-31960-2-git-send-email-anand.jain@oracle.com>
 <5100BB01.3030408@redhat.com>
 <5100FDA3.3040907@giantdisaster.de>
 <510175F7.5080806@gmail.com>
 <51018EBA.60201@redhat.com>
 <5101B131.6010804@tiscalinet.it>
 <5102AF4E.2000300@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
In-Reply-To: <5102AF4E.2000300@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 25, 2013 at 10:14:06AM -0600, Eric Sandeen wrote:
> On 1/24/13 4:09 PM, Goffredo Baroncelli wrote:
> > On 01/24/2013 08:42 PM, Eric Sandeen wrote:
> >> On 1/24/13 11:57 AM, Goffredo Baroncelli wrote:
> >>> On 01/24/2013 10:23 AM, Stefan Behrens wrote:
> >>>> On Wed, 23 Jan 2013 22:39:29 -0600, Eric Sandeen wrote:
> >>>>> instead of renaming&   keeping the btrfsctl.c copy
> >>>>
> >>>> There is a new momentum to improve the Btrfs-progs quality :)
> >>>>
> >>>> IMO, one step is to get rid of the legacy tools and sources. It
> >>>> wastes time to maintain them and these old tools cause confusion.
> >>>> btrfsctl.c, btrfs-vol.c and btrfs-show.c are not needed anymore.
> >>>> Please correct me if there are plans to use these old tools in
> >>>> future Linux distributions. The "btrfs" tool replaces the legacy
> >>>> "btrfsctl", "btrfs-vol" and "btrfs-show" tools. Below, the usage
> >>>> text of the old tools is quoted. All these tasks are also offered
> >>>> in the "btrfs" tool, and this tool is the newer one.
> >>>
> >>> I fully agree: btrfsctl, btrfs-vol, btrfs-show are perfectly
> >>> replaced by by btrfs. Moreover time to time the patches are more
> >>> complex than the needing because exists these "legacy" programs.
> >>>
> >>> I checked the debian package, and to me seems that there is no need
> >>> of {btrfsctl,btrfs-vol,btrfs-show}
> >>
> >> Hm, they are shipped in the Fedora package.
> > 
> > The same is true for the debian package, but are these used in Fedora ?
> > 
> >>
> >> For backwards compat, could those be turned into shell scripts which
> >> invoke the btrfs tool?
> > 
> > I don't see any gain to maintains a script bash (which has to be
> > written from scratch) instead of maintains the current C code.
> 
> It should be a trivial bash script to convert the calls, and it should
> require very little maintenance.  Much less than the hundreds of lines
> of duplicated C code, I think.
> 
> If nobody needs them, though, no reason for even a bash script.
> 
> David, Suse may be using them now, but probably can adapt?
> Anaconda said it could drop the use of btrfsctl.  :)

   I've just asked someone I know at Canonical, and he says there's no
use of these tools in the Ubuntu installer. (Disclaimer: it's not
entirely his area, and there's probably other places to look, like
udev rules, but on a cursory glance, it should be OK).

   I've also checked with the Debian installer people, and they're not
using the deprecated tools either. Further, these searches:

http://codesearch.debian.net/search?q=btrfs-show
http://codesearch.debian.net/search?q=btrfs-vol
http://codesearch.debian.net/search?q=btrfsctl

suggest that there's very little impact over the rest of the system as
well.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                --- If it ain't broke,  hit it again. ---                

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUQK3XL9z9OVl50rAAQJOphAAj/sSXa//ccs3zDRy2amGEPrZPqpmaPdL
X034luNCpl0pWXLu8Ry/FQN23oIF9AanO1lk3JN7xAmwEVX3dGGJyfcH5leGaXho
/dSQbkmNjCxQ5QwBX2wvVKxYGy0w8aQwtFz7ju6fGXRo0XzJ5wdziWv1ZwaCqMSf
Dp2P6U3tCQJq9OZOnoh5rajpP3MUuKfC1SRRolwNKQbCYBBR0Q9ieOC+paBxHaZM
J5Cf/qwHU0GAVcbjyA7iYCR5FyoW9SrlYUuE1OLDhbNx2IYkeQqFfBzcsmmI2MJz
9csZ9RS+0YAvxDpRfocnI0r6R8/VEUYHnO8c029D+ma6tZBLXsHVzHFqV2lM6K0c
Bx8sCHwc6RqPp4LMIxCYc98GPeWtANJhjrKU9aHXQsdqvNfuuhlMP88OkoLuwNq9
ZaRKbUZkMMQi38UmloAGJ4iNpNIFDywooBG/aUAC3031QCKZ52WJn7bWcGb+GsgZ
WM6rG8jSo1Jnn4EHvFawi0XZgZ3CTkhCfARZ3AioQVBm71JZlKDPehiy0Pf6kynV
L3w1u1tHy1K7UE/WAR/tjZFbIl6p1N+gsviJaH/d0R5VEpu6Otu20EW8zrlFBVGy
s2KICTRq9oICSDWKG55VrGr1wQBJBV2m9hPlzGcOhebuZciEkEUB9FbYpZH5I/Hy
MXBHzl/G8lw=
=e9Uc
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
