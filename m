From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Sun, 24 Apr 2011 23:11:20 -0400
Message-ID: <125854.1303701080@localhost>
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1303701080_5888P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@infradead.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: Your message of "Thu, 21 Apr 2011 15:42:33 EDT."
             <1303414954-3315-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

--==_Exmh_1303701080_5888P
Content-Type: text/plain; charset=us-ascii

On Thu, 21 Apr 2011 15:42:33 EDT, Josef Bacik said:

> -SEEK_HOLE: this moves the file pos to the nearest hole in the file from the
> given position. 

Do we want the semantic to be "the nearest" hole?  Or did we really want "the
next" hole?  Loops like a bullet loaded in the chamber and pointed at the
programmer's foot if they aren't allowing for the fact that this can go
*backwards* in the file if the closest hole is towards the beginning.  Good way
to end up in an infinite loop or other messy...

Consider the obvious implementation of "skip over a hole" - lseek(SEEK_HOLE),
lseek(SEEK_DATA).  and start reading data because we've skipped over the hole.
Wrong - the second seek may have gone backwards if the data was only 4K away
but the hole was 64K in size...


--==_Exmh_1303701080_5888P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNtOZYcC3lWbTT17ARAkB2AKDk0fzyUs+QaUFRVh6wDYDvs5yiXgCg+9LO
gbr1xY/QAHlMo7lFrxDHxUw=
=/6Mr
-----END PGP SIGNATURE-----

--==_Exmh_1303701080_5888P--

