From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: A little confused about what remains to make a stable release
Date: Wed, 17 Nov 2010 22:59:01 +0000
Message-ID: <20101117225901.GA5367@vlad.carfax.org.uk>
References: <AANLkTi=q4bKVGfD-QoF68NecL4e4d5dfcvMrgv5NHtb3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Cc: linux-btrfs@vger.kernel.org
To: Daniel Farina <drfarina@acm.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=q4bKVGfD-QoF68NecL4e4d5dfcvMrgv5NHtb3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 17, 2010 at 02:27:39PM -0800, Daniel Farina wrote:
> I have been tracking the development of btrfs for some time, as the
> built-in support for snapshotting would be of great convenience for
> relational database use cases. I have been crawling the wiki
> (especially the FAQ), but I still don't have a clear sense of "what's
> left" *besides* the need for a 'fsck' utility that can be called
> absolutely vital.
> 
> That, and testing and bug reports.

   This question (and answer) should probably go in the FAQ...

   Nobody is going to magically stick a label on btrfs and say "it's
stable now!" Software -- particularly something as complex as this --
just doesn't work that way.

   It's stable *for you* when it functions with the workloads *you*
expect of it, with a failure rate that is acceptable *to you*.

   For what I'm using it for right now, it's already stable by that
definition, *for me*.

> From the materials I've been able to find, it's hard for me to get a
> sense of how one could assist the project towards being recommended
> for general use; do the denizens of this list has a sense of what
> those things might be? (Or a link?)

   The primary things you can do: Use it, test it, file bug reports.
Do this with, as close as you can, the use-cases (IOPs/s, feature
uses, data sizes) that you want to use it for.

   Beyond that: Fix bugs. Add the features that you think are
important. Add features that other people think are important (see the
"Project Ideas" page on the wiki for the latter).

   Hugo.

</2-penn'orth>

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- The trouble with you, Ibid, is you think you know everything. ---  
                                                                         

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM5F41IKyzvlFcI40RAnbWAKCouJAYObMH5eIl0Vu9DPNcf0wY6gCggZ91
tHI2S0NRSAL76BduLLoMPRM=
=7dZv
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
