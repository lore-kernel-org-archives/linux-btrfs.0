From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: is space really freed after deleting large subvolume?
Date: Fri, 14 Oct 2011 09:45:05 +0100
Message-ID: <20111014084504.GI21931@carfax.org.uk>
References: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com>
 <CAJ1PRSk0BVoYw89C0RYejbRF-4QdrKkA_J94Kf+Y7r-u=w+aHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mXDO3udm/xYWQeMQ"
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com " <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSk0BVoYw89C0RYejbRF-4QdrKkA_J94Kf+Y7r-u=w+aHA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--mXDO3udm/xYWQeMQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 14, 2011 at 07:17:44AM +0200, krzf83@gmail.com  wrote:
> Just a idea: I don't know if btrfs works like that or not but idea
> would be that b-tree filesystem should be able to "loose" or "discard"
> branches be removing a node. Cut a tree node and branches will fall
> off - and get overwrited as empty space sometime in future (just like
> during data deletion).
> 
> If subvolume is filesystem in filesystem (don't know to what extend
> this is true in btrfs) then sub-filesystem could be re-formated but
> severing it links to its branches.

   Subvolumes each have their own FS-tree, so if it were just a matter
of the FS tree, then yes, you'd be right. Sadly, it isn't. Even on
other filesystems, you still have to perform at least one operation
per extent to mark that extent as unused, so that it can be reclaimed.

    On btrfs, there's a little more work than that involved (but not
much more). Since btrfs can make CoW copies of files, you can end up
with the same blocks on disk being used by several different parts of
the filesystem. This applies both to data extents and to metadata
blocks. In order to make it possible to know when a block (or set of
blocks) can be reclaimed to be overwritten at some later date, the
blocks are all reference-counted, so each block knows how many things
point to it. Updating and checking the reference count is the thing
that takes time, and can't really be short-circuited.

   What btrfs can do is, as you suggest, unlink the FS-tree for the
subvolume immediately so that it's no longer visible. It can then
clean up all the references from that tree in the background -- which
is exactly what it does do.

> Reason for this if of course fast and not io costly deletion of large
> number of files.

   It just ain't that simple, I'm afraid. Getting rid of files is a
complicated business.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Nothing right in my left brain. Nothing left in ---         
                             my right brain.                             

--mXDO3udm/xYWQeMQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOl/aQIKyzvlFcI40RAvOcAJ0Yeih1RIMjoD0VFqyR0Bns02s/CwCfVu2b
+L8cwB0siQ0QZIjlKhQ3yl8=
=ifFO
-----END PGP SIGNATURE-----

--mXDO3udm/xYWQeMQ--
