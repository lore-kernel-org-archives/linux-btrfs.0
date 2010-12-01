From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 16:38:00 +0000
Message-ID: <20101201163800.GA4087@carfax.org.uk>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 01, 2010 at 09:21:36AM -0500, Josef Bacik wrote:
> === Quotas ===
> 
> This is a huge topic in and of itself, but Christoph mentioned wanting to have
> an idea of what we wanted to do with it, so I'm putting it here.  There are
> really 2 things here
> 
> 1) Limiting the size of subvolumes.  This is really easy for us, just create a
> subvolume and at creation time set a maximum size it can grow to and not let it
> go farther than that.  Nice, simple and straightforward.
> 
> 2) Normal quotas, via the quota tools.  This just comes down to how do we want
> to charge users, do we want to do it per subvolume, or per filesystem.  My vote
> is per filesystem.  Obviously this will make it tricky with snapshots, but I
> think if we're just charging the diff's between the original volume and the
> snapshot to the user then that will be the easiest for people to understand,
> rather than making a snapshot all of a sudden count the users currently used
> quota * 2.

   This is going to be tricky to get the semantics right, I suspect.

   Say you've created a subvolume, A, containing 10G of Useful Stuff
(say, a base image for VMs). This counts 10G against your quota. Now,
I come along and snapshot that subvolume (as a writable subvolume) --
call it B. This is essentially free for me, because I've got a COW
copy of your subvolume (and the original counts against your quota).

   If I now modify a file in subvolume B, the full modified section
goes onto my quota. This is all well and good. But what happens if you
delete your subvolume, A? Suddenly, I get lumbered with 10G of extra
files.  Worse, what happens if someone else had made a snapshot of A,
too? Who gets the 10G added to their quota, me or them? What if I'd
filled up my quota? Would that stop you from deleting your copy,
because my copy can't be charged against my quota? Would I just end up
unexpectedly 10G over quota?

   This is a whole gigantic can of worms, as far as I can see, and I
don't think it's going to be possible to implement quotas, even on a
filesystem level, until there's some good and functional model for
dealing with all the implications of COW copies. :(

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- I believe that it's closely correlated with ---           
                       the aeroswine coefficient.                        

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM9nnoIKyzvlFcI40RAhjXAKCMdWRxp4WJc6h7EzTJvgfEjB4YNgCghdAB
Qvu/g4IVV41BX4rkQ+bjSUA=
=4dwu
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
