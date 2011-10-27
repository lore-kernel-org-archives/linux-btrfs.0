From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Btrfs progs git repo on kernel.org
Date: Thu, 27 Oct 2011 22:48:11 +0100
Message-ID: <20111027214811.GL29548@carfax.org.uk>
References: <20111027152707.GA11028@shiny.Mikenopa.local>
 <20111027155854.GK29548@carfax.org.uk>
 <20111027213258.GA25582@shiny.Mikenopa.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xsn3knLL3qrmRbVI"
To: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111027213258.GA25582@shiny.Mikenopa.local>
List-ID: <linux-btrfs.vger.kernel.org>


--Xsn3knLL3qrmRbVI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 27, 2011 at 05:32:58PM -0400, Chris Mason wrote:
> On Thu, Oct 27, 2011 at 04:58:54PM +0100, Hugo Mills wrote:
> > On Thu, Oct 27, 2011 at 11:27:07AM -0400, Chris Mason wrote:
> > > I've pulled in Hugo's integration tree, minus the features that were not
> > > yet in the kernel.  This also has a few small commits that I had queued
> > > up outside of the fsck work.
> > > 
> > > Hugo, many thanks for keeping up the integration tree!  Taking out the
> > > features not in the kernel meant I had to rebase it the commits, I'm
> > > sorry about that.
> > 
> >    OK, I'm sure I can cope with that. I'll just drop the patches from
> > my stack that you've already brought in, and generate a new
> > integration branch based on your master. I've got 4-5 other patches to
> > add in as well, gleaned from the mailing list and, via David Sterba,
> > from SuSE's local patches.
> > 
> >    I've also got the basis of a set of regression tests for -progs,
> > which I'll send out patches for in the next couple of days. At the
> > moment, it only tests building and snapshots, but should be relatively
> > easily extensible to the other bits of ./btrfs (although I'm not sure
> > how we can easily and repeatably test the recovery tools).
> 
> Please talk with Anand Jain on the test programs, he has been making
> scripts for xfs-tests.

   Will do, although I think we're aiming at different things. I'm
very definitely *not* attempting to test the filesystem itself with my
test harness. I just want to exercise all the bits of the userspace
tools that I can. (This was primarily triggered by the mess
surrounding the parsing of "btrfs sub snap" parameters).

> >    One other thing that's *really* needed is a new version tag, which
> > I was going to do this weekend, but it looks like you're back at the
> > helm of -progs, so I'll just whine in your general direction instead.
> 
> Definitely, fsck deserves a new version tag.

   You mean we've got to wait *that* long? ;)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "I don't like the look of it,  I tell you." "Well, stop ---     
                          looking at it, then."                          

--Xsn3knLL3qrmRbVI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOqdGbIKyzvlFcI40RAhEcAKDHniRUaGc8csuolbXbk2AHB31DPACdGkMj
kGaOCwTRAq/3alOJ8o1Sut0=
=iKRq
-----END PGP SIGNATURE-----

--Xsn3knLL3qrmRbVI--
