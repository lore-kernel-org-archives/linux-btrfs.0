From: Phillip Susi <psusi@cfl.rr.com>
Subject: Chunk allocation size
Date: Mon, 12 Dec 2011 23:40:05 -0500
Message-ID: <4EE6D725.7090606@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

While poking around with btrfs-gui I noticed my fs had a fair number of quite small chunks ( especially metadata ), so I started looking into how they are allocated.  It appears that the current rule is to allocate:

1)  At most, 10% of the total fs capacity
2)  For metadata, at most 256 mb
3)  For data, at most 10gb, or 1gb per disk, whichever is lower

Why these values?  Why have hard coded sizes at all instead of just saying for instance, 4% of total capacity for metadata and 8% of total capacity for data chunks?  In my case, I had two 36 gb disks, so this led to data chunks maxing out at 2gb ( or ~2.8% ), and metadata chunks maxing out at 256mb ( or ~0.36% ).  It seems to me that ideal chunk sizes should be in the vicinity of 4%-10% of total capacity ( giving a total of 10-21 chunks ), never less than 1% ( giving more than 100 chunks ).
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7m1yUACgkQJ4UciIs+XuJ99wCfdhSvFB6S1uz+qTWBJotFoZ0d
6FwAoJuerIp9brqfv1E2PJfRsV7VDEbr
=FpRK
-----END PGP SIGNATURE-----
