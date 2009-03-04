From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Entirely unexpected ENOSPC?
Date: Wed, 4 Mar 2009 20:48:43 +0000
Message-ID: <20090304204843.GB9407@vlad.carfax.org.uk>
References: <20090304180619.GA3282@selene> <20090304185053.GI5446@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090304185053.GI5446@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 04, 2009 at 01:50:53PM -0500, Josef Bacik wrote:
> On Wed, Mar 04, 2009 at 06:06:19PM +0000, Hugo Mills wrote:
> >    Last night, this event jammed up a good chunk of my server:
> > 
> > Mar  4 01:51:36 vlad kernel: btrfs searching for 1716224 bytes, num_bytes 1716224, loop 2, allowed_alloc 1
> > Mar  4 01:51:36 vlad kernel: btrfs searching for 860160 bytes, num_bytes 860160, loop 2, allowed_alloc 1
> > [lots of this...]
> > Mar  4 01:55:52 vlad kernel: btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 1
> > Mar  4 01:55:52 vlad kernel: btrfs allocation failed flags 1, wanted 4096
> > Mar  4 01:55:52 vlad kernel: space_info has 0 free, is full
> > Mar  4 01:55:52 vlad kernel: block group 12582912 has 8388608 bytes, 8388608 used 0 pinned 0 reserved
> > Mar  4 01:55:52 vlad kernel: 0 blocks of free space at or bigger than bytes is
> > Mar  4 01:55:52 vlad kernel: block group 1103101952 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
> > Mar  4 01:55:52 vlad kernel: 0 blocks of free space at or bigger than bytes is
> > [30 more lines of this]
> 
> So yeah thats expected, you ran out of space.  The key thing is this
> 
> Mar  4 01:55:52 vlad kernel: space_info has 0 free, is full
> 
> If space_info has 0 free and is full, then there is no space to allocate for it
> and its completely used.  I'd recommend switching to the -rc7 kernel since that
> has things in place to keep this from happening as often.  Thanks,

   I'll do that.

   However, what's confusing me is that the filesystem was reported as
less than half full (17/41GiB used) at the time that it decided it had
no space. Is there any likely explanation for that behaviour?

   I've used btrfsctl to resize it online several times: shrink by
1GiB, then enlarge by 12, 10, 10GiB. Might that have been a factor?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- How do you become King?  You stand in the marketplace and ---    
          announce you're going to tax everyone. If you get out          
                           alive, you're King.                           

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJrukrIKyzvlFcI40RAqY2AJ9Rq9fBonfB31tpdZC6aFVqvBhWAwCgr3Rw
LwE6PvevGdXJXoZZnj/F0F4=
=QRzT
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
