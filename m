From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: kernel BUG at fs/btrfs/tree-log.c:1657!
Date: Sun, 31 Jul 2011 11:54:59 +0100
Message-ID: <20110731105459.GA28326@carfax.org.uk>
References: <CAHzCyiQs27_fX1ifnMEO=8asYZbYot794m5cFBByOnpADFAVyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Cc: linux-btrfs@vger.kernel.org
To: "Providence M. SALUMU" <providence.salumu@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAHzCyiQs27_fX1ifnMEO=8asYZbYot794m5cFBByOnpADFAVyg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 31, 2011 at 10:01:50AM +0200, Providence M. SALUMU wrote:
> A few days back, I had a hard reset of my computer while syncing my
> data with rsync -avz. I am using btrfs as the rootfs, and since then I
> can't mount my filesystem anymore. mount -t btrfs segfaults!
> Btrfs version in use and dmesg traces follow...
> 
> Can someone help figure out what is wrong?
[snip]
> Call Trace:
> [<ffffffffa0536f70>] ? walk_down_log_tree+0x204/0x3eb [btrfs]
> [<ffffffffa053721f>] ? walk_log_tree+0xc8/0x213 [btrfs]
> [<ffffffffa05382b4>] ? btrfs_recover_log_trees+0x1d3/0x2e0 [btrfs]

   This looks like a corrupt log tree. Fortunately, we have a tool
that will deal with this: grab a copy of the btrfs-progs sources,
build btrfs-zero-log, and run that on your filesystem. That _should_
get you to the point of being able to mount it.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- He's playing Schubert.  I think Schubert is losing. ---       

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFONTSCIKyzvlFcI40RAkXqAJ9OoO5P3PgMRK/uZcCDJdXwPXJfpACeNe9T
U6iFEa2JiAYoroJ7nOYTPCY=
=RVpO
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
