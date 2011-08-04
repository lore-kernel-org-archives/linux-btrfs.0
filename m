From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs-progs repository
Date: Thu, 4 Aug 2011 11:01:42 +0100
Message-ID: <20110804100142.GB28326@carfax.org.uk>
References: <CAAeznTpDgdQ3T8MGrNXAE2H6K4fO27sDNQADaXkx7J=_Epzf6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Cc: linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAeznTpDgdQ3T8MGrNXAE2H6K4fO27sDNQADaXkx7J=_Epzf6A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 04, 2011 at 10:45:30AM +0100, Leonidas Spyropoulos wrote:
> Why the official repository is not updated with the latest patched for gcc 4.6?
> I noticed that http://git.darksatanic.net/repo/btrfs-progs-unstable.git/
> includes more patches than the
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> 
> So I was wondering is it some kind of testing to be done on patches to
> be included into the official repo?

   There have been a lot of patches published in the 9 months or so
since the upstream repo was last updated -- Chris has been
concentrating on other things (like kernel-side stability and the new
fsck). I pulled them all into one place and started to try to make
sense of them all, which is the ongoing work that is the darksatanic
repo.

   There's a for-chris branch (which is actually the same as my master
branch now), which is the "stable" patches that have (mostly) been
reviewed. Then there's the integration-* branches, which are general
dumps of things that aren't ready to go upstream yet, but which I'm
publishing simply to get patches available for testing (particularly
new features like scrub).

   I should probably send Chris another pull request. :)

> Another thing is that there are commands for creating the build
> enviroment for fedora and debian but I found nowhere in the wiki the
> dependencies of the btrfs-progs to compile them.
> Shouldn't be a list of packages or dependencies for it?

   The website is a wiki, so feel free to update the instructions with
anything you've found to be missing. And I'll happily accept patches
to any instructions that are shipped with the userspace tools. :)

   (I believe the only dependencies are libuuid and libxattr --
whatever they're called on $distribution).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- emacs:  Eighty Megabytes And Constantly Swapping. ---        

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOOm4GIKyzvlFcI40RAhsRAJ9G+zIkvJcOAxJp/bACRlLFYqbwIwCggMaU
mMaunZQG3NDI4yazFuC517Y=
=GQRp
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
