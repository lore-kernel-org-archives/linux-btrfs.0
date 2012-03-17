From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Can't mount, power failure - recoverable?
Date: Sat, 17 Mar 2012 10:31:40 +0000
Message-ID: <20120317103140.GA3172@carfax.org.uk>
References: <loom.20120317T051243-551@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Cc: linux-btrfs@vger.kernel.org
To: Skylar Burtenshaw <daninfuchs@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120317T051243-551@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 17, 2012 at 04:24:02AM +0000, Skylar Burtenshaw wrote:
> Hey all. First and foremost, great work on the filesystem. Love it. That is,
> until this...
> 
> AGES ago, I had a power failure. I had 22 drives in one BTRFS filesystem. I
> know, dumb idea given that it's an experimental FS, but it's not important data,
> just.....LOTS of it. A dozen terabytes or so.

> Now when I try to mount it with all present kernels (up to 3.2.0) I
> get several minutes of disk churning, and a kernel stack trace.
> Every tool I throw at it fails. find-root only shows one tree (at
> the very end) after complaining about blocks seeming great, but
> generations don't match for ages.

   Can you give us the last, say, 200 lines of find-root's output?
Does it give you any listings for "root objectid"s? With find-root and
recover, it's not necessarily fatal that the transids/generations
don't match.

> The btrfsck from the stable tree lists twenty "item # key" messages,
> then stops with "failed to find block number 20975616" and aborts
> every time.

> I've been sitting on this filesystem for half a year now, using my
> backup array, but it's getting full. I realize I'm being very sparse
> on information, but I'm not sure what you need from me.

   Only half a year? :) I sat on my broken 6TB array for a year before
I gave up and recovered the data I didn't have in backups... (And for
the same reason you have -- I ran out of space on the secondary
storage)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- 2 + 2 = 5,  for sufficiently large values of 2. ---         

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPZGgLIKyzvlFcI40RAlgjAJ4xX5u16jBoYUyoVdCYNMuOI1LLzACguQLA
giDlgUBfxWTpEg004TVfX8A=
=FcQ+
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
