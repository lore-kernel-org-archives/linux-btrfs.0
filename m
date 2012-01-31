From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Packed small files
Date: Tue, 31 Jan 2012 16:46:10 +0000
Message-ID: <20120131164610.GE5531@carfax.org.uk>
References: <CAJJ3ruHxPqL6YRktpK+5V7Hgn2aAe=BCJLyicoLmYkxO4sVh1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3O1VwFp74L81IIeR"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Hans Stimer <hans.stimer@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJJ3ruHxPqL6YRktpK+5V7Hgn2aAe=BCJLyicoLmYkxO4sVh1g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--3O1VwFp74L81IIeR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 31, 2012 at 08:21:30AM -0800, Hans Stimer wrote:
> How space efficient are packed small files? For instance, if I have a
> 10,000 16 byte files with 16 byte file names, how much disk space will
> they use? Are there any caveats or gotchas around using btrfs to store
> millions of small (size<64bytes) files?

   For small files, the file content may be kept inline in the btree
blocks of the extent tree. The data is packed in alongside the
associated keys and inline extent metadata, and the Btree
implementation can be somewhat variable in its usage as well, so it's
hard to put fixed values on these things.

   There's metadata overhead on storing files as well -- each file
will be represented by a number of keys (17 bytes each) and metadata
structures to go with them. In the FS tree:

   DIR_ITEM      13
   DIR_INDEX     13
   INODE_ITEM   162
   INODE_REF     10 + size(name)
   EXTENT_DATA   52
   Keys          85
                ---
                335 + size(name)

   And in the extent tree:

   EXTENT_ITEM        24 + 17 for key
   extent_inline_ref   9
   extent_data_ref    28
                     ---
                      78

   So you're looking at a minimum of 413 bytes of metadata overhead
for an inline file, plus the length of the filename.

   Also note that the file is stored in the metadata, so by default
it's stored with DUP or RAID-1 replication (even if data is set to be
"single"). This means that you'll actually use up twice this amount of
space on the disks, unless you create the FS with metadata set to
"single".

   I don't know how these figures compare with other filesystems. My
entirely uneducated guess is that they're probably comparable, with
the exception of the DUP effect.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                   --- I know of three kinds: hot, ---                   
                cool,  and what-time-does-the-tune-start?                

--3O1VwFp74L81IIeR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPKBrSIKyzvlFcI40RAhg3AKCjwM9WRv5aWy5/dLYRa/bXurwP4gCfSUgP
ZBO1fZkR/MDkKnYN8Q+6FDg=
=IHmP
-----END PGP SIGNATURE-----

--3O1VwFp74L81IIeR--
