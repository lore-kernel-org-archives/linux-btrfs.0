From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Update to Project_ideas wiki page
Date: Wed, 17 Nov 2010 14:31:03 +0000
Message-ID: <20101117143103.GA2401@selene>
References: <m3hbfg3acu.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Cc: linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3hbfg3acu.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 16, 2010 at 10:19:45PM -0500, Chris Ball wrote:
> Hi,
> 
> Chris Mason has posted a bunch of interesting updates to the
> Project_ideas wiki page.  If you're interested in working on any
> of these, feel free to speak up and ask for more information if
> you need it.  Here are the new sections, for the curious:
> 
> == Block group reclaim ==
> 
> The split between data and metadata block groups means that we
> sometimes have mostly empty block groups dedicated to only data or
> metadata.  As files are deleted, we should be able to reclaim these
> and put the space back into the free space pool.
> 
> We also need rebalancing ioctls that focus only on specific raid
> levels.

> == Changing RAID levels ==
> 
> We need ioctls to change between different raid levels.  Some of these
> are quite easy -- e.g. for RAID0 to RAID1, we just halve the available
> bytes on the fs, then queue a rebalance.

   I would be interested in the rebalancing ioctls, and in RAID level
management. I'm still very much trying to learn the basics, though, so
I may go very slowly at first...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- We demand rigidly defined areas of doubt and uncertainty! ---    

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM4+cnIKyzvlFcI40RAmwLAKChF2mJBXP8gkX0ZpVegMaJtQih6wCcCJxO
vs6pgONRDZ3NKxS1hT84UFc=
=AeBs
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
