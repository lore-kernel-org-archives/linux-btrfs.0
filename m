From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Honest timeline for btrfsck
Date: Thu, 18 Aug 2011 22:22:12 +0100
Message-ID: <20110818212212.GA14473@carfax.org.uk>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
 <1312404713-sup-6548@shiny>
 <loom.20110818T030824-742@post.gmane.org>
 <1313700115-sup-2457@shiny>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Cc: Yalonda Gishtaka <yalonda.gishtaka@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313700115-sup-2457@shiny>
List-ID: <linux-btrfs.vger.kernel.org>


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 18, 2011 at 04:50:08PM -0400, Chris Mason wrote:
> I've been working non-stop on this.  Currently fsck has four parts:

   This all looks like great stuff. Can't wait to try it out...

   One thing strikes me for purposes of automated testing and
regression testing: Do you have tools or techniques for breaking a
filesystem in specific ways?

> 1) mount -o recovery mode.  I've posted smaller forms of these patches
> in the past that bypass log tree replay.  The new versions have code to
> create stub roots for trees that can't be read (like the extent
> allocation tree) and will allow the mount to proceed.

   I can see that this will deal with some kinds of breakage, like the
log tree being missing, but most of the other trees are kind of
important for minor things like finding your data. :)

   How useful or reliable is it to ignore missing trees that aren't
the log tree? I'd have thought that if you were missing one of the 6
main trees, you'd have a pretty much unreadable FS.

> 2) fsck that scans for older roots.  This takes advantage of older
> copies of metadata to look for consistent tree roots on disk.  The
> downside is that it is currently very slow.  I'm trying to speed it up
> by limiting the search to only the metadata block groups and a few other
> tricks.

   If this is in decent shape, it's probably worth it to release it in
its current form anyway (and possibly request a moratorium on extra
patches until you've finished the optimisation). I suspect that
there's a number of people out there who wouldn't mind the speed
issues just to get a filesystem back.

> 3) fsck that fixes the extent allocation tree and the chunk tree.  This
> is where I've been spending most of my time.  The problem is that it
> tends to recover some filesystems and badly break others.  While I'm
> fixing up the corner cases that work poorly, I'm adding an undo log to
> the fsck code so that you can get the FS back into its original state if
> you don't like the result of the fsck.

> 4) The rest of the corruptions can be dealt with fairly well from the
> kernel.  I have a series of patches to make the extent allocation tree
> less strict about reference counts and other rules, basically allowing
> the FS to limp along instead of crash.

   Is that going to be always-on, with stubs to highlight where
subsequent patches can add the requisite healing code in later
revisions, or as a mount flag like -o recovery?

> These four things together are basically my minimal set of features
> required for fedora and our own internal projects at Oracle to start
> treating us as production filesystem.
> 
> There are always bugs to fix, and I have #1 and #2 mostly ready.  I had
> hoped to get #1 out the door before I left on vacation and I still might
> post it tonight.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "You know,  the British have always been nice to mad people." ---  

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOTYKEIKyzvlFcI40RAkJ8AJ9CFOwUdpGzS8w9423zhLGnqnXKiACgv27D
3fLS6lu4EABmmVM9Rc7tA74=
=Qh9O
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
