From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Wed, 04 May 2011 15:31:38 -0400
Message-ID: <16735.1304537498@localhost>
References: <1304531920-2890-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304537498_7352P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: Your message of "Wed, 04 May 2011 13:58:39 EDT."
             <1304531920-2890-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

--==_Exmh_1304537498_7352P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 May 2011 13:58:39 EDT, Josef Bacik said:

> +#define SEEK_HOLE	3	/* seek to the closest hole */
> +#define SEEK_DATA	4	/* seek to the closest data */

Comments here need nearest/next fixing as well - otherwise the ext[34] crew may
actually implement the commented semantics. ;)

Other than that, patch 1/2 looks OK to me (not that there's much code to
review), and 2/2 *seems* sane and implement the "next" semantics, though I only
examined the while/if structure and am assuming the btrfs innards are done
correctly.  In particular, that 'while (1)' looks like it can be painful for a
sufficiently large and fragmented file (think a gigabyte file in 4K chunks,
producing a million extents), but I'll let a btrfs expert analyse that
performance issue ;)


--==_Exmh_1304537498_7352P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwamacC3lWbTT17ARAid6AKDHWhefzq1tM6rxD2vx5Dm39yNX0wCg1P9Y
3Q26CBfOfmUDFFhPmjgw/uY=
=qOad
-----END PGP SIGNATURE-----

--==_Exmh_1304537498_7352P--
