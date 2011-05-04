From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Wed, 04 May 2011 15:20:51 -0400
Message-ID: <16280.1304536851@localhost>
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <15392.1304535887@localhost>
            <4DC1A49C.4010101@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304536851_7352P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: Your message of "Wed, 04 May 2011 15:10:20 EDT."
             <4DC1A49C.4010101@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

--==_Exmh_1304536851_7352P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 May 2011 15:10:20 EDT, Josef Bacik said:

> Yeah sorry the log says "nearest" but the code says "next", if you look 
> at it thats how it works.  Thanks,

Oh good - the changelog is usually easier to fix than the code is. :)

Probably want to fix the changelog before it gets committed, as there's a fair
chance that text will end up being used as the basis for a manpage or other
documentation.


--==_Exmh_1304536851_7352P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwacTcC3lWbTT17ARAjJiAJ9l9/l5RNEafTbHd/DT2CFfC5216ACgnFEV
uq/MaPi1c5I/dGQBzOcmpXo=
=FwjA
-----END PGP SIGNATURE-----

--==_Exmh_1304536851_7352P--
