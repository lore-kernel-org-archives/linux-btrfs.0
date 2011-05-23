From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Backref walking utilities
Date: Mon, 23 May 2011 11:15:33 +0100
Message-ID: <20110523101533.GA3346@carfax.org.uk>
References: <4DDA2EA7.9080305@cn.fujitsu.com>
 <4DDA30AD.2020409@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Cc: liubo <liubo2009@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDA30AD.2020409@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 23, 2011 at 12:02:21PM +0200, Arne Jansen wrote:
> Hi liubo,
> 
> On 23.05.2011 11:53, liubo wrote:
> > As one of my plans, I'm going to take this project over unless someone has been working on it.
> 
> Jan Schmidt has a patch for scrub nearly ready, that does some
> ref-walking to report affected files to the user. While this is
> kernel code and you're planning to add user-space code, it might
> still be possible to share some of it. Maybe the efforts can be
> coordinated.

   Another use for walking backrefs for a block (or an extent) is to
work out the differential size of a snapshot -- i.e. how much space
will be freed up if the snapshot is deleted. (You need to look at
every extent of every file in the snapshot, and work out whether those
extents are used anywhere outside the subvolume).

   Hugo.

> Thanks
> Arne
> 
> > 
> >>From wiki, quote:
> >     Backref walking utilities
> > 
> >     Given a block number on a disk, the Btrfs metadata can find all the files and directories
> >     that use or care about that block.  Some utilities to walk these back refs and print the
> >     results would help debug corruptions.
> > 
> >     Given an inode, the Btrfs metadata can find all the directories that point to the inode.
> >     We should have utils to walk these back refs as well. 
> > end quote.
> > 
> > And I have some thoughts to share with you:
> > 
> >     - Clearly, this is going to be another command.  Just like the command "btrfs-debug-tree",
> >       btrfs-walk-backref also needs to be able to track btrfs's metadata in
> >           a) the offline situation (at a umount state), or
> >           b) the corrupted situation.
> > 
> >     - For block number, the main goal is to find relative extent backrefs.  When it comes to
> >       those shared blocks, maybe things will be more complex.
> > 
> >     - For inode, the main goal is to find relative inode refs.  And we should be cautious about
> >       a) an inode with hard links, b) snapshot.
> > 
> > Did I miss or misunderstand something?  Any comments are welcomed. :)
> > 
> > thanks,
> > liubo

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- We are all lying in the gutter,  but some of us are looking ---   
                              at the stars.                              

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN2jPFIKyzvlFcI40RAgtIAKCjoMz5AfZDX4M4IzyjLyVJuDZGmQCeMJoF
2G9+8eCLHMVa6PLoRwyKNlA=
=vGz/
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
