From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: ?Understanding metadata efficiency of btrfs
Date: Tue, 6 Mar 2012 11:29:58 +0000
Message-ID: <20120306112957.GJ4481@carfax.org.uk>
References: <F728B049-9007-4FA6-B75B-0249A472E40C@gmail.com>
 <pan.2012.03.06.05.30.23@cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4vpci17Ql0Nrbul2"
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>, Kai Ren <gleemanrk@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.03.06.05.30.23@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>


--4vpci17Ql0Nrbul2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 06, 2012 at 05:30:23AM +0000, Duncan wrote:
> Kai Ren posted on Mon, 05 Mar 2012 21:16:34 -0500 as excerpted:
> 
> > I've run a little wired benchmark on comparing Btrfs v0.19 and XFS:
> 
> [snip description of test]
> > 
> > I monitor the number of disk read requests
> > 
> >        #WriteRq  #ReadRq  #WriteSect  #ReadSect
> > Btrfs   2403520  1571183    29249216   13512248 
> > XFS      625493   396080    10302718    4932800
> > 
> > I found the number of write quests of Btrfs is significant larger than
> > XFS.
> 
> > I am not quite familiar with how btrfs commits the metadata change into
> > the disks. From the website, it is said that btrfs uses COW B-tree
> > which never overwrite previous disk pages. I assume that Btrfs also
> > keep an in-memory buffer to keep the metadata changes.  But it is
> > unclear to me that how often Btrfs will commit these changes
> > and what is the behind mechanism.

   By default, btrfs will commit a transaction every 30 seconds.

   (Some of this is probably playing a bit fast and loose with
terminology such as "block cache". I'm sure if I've made any major
errors, I'll be corrected.)

   The "in-memory buffer" is simply the standard Linux block layer and
FS cache: When a piece of metadata is searched for, btrfs walks down
the relevant tree, loading each tree node (a 4k page) in turn, until
it finds the metadata. Unless there is a huge amount of memory
pressure, Linux's block cache will hang on those blocks in RAM.

   btrfs can then modify those blocks as much as it likes, in RAM, as
userspace tools request those changes to be made (e.g. writes,
deletes, etc). By the CoW nature of the FS, modifying a metadata block
will also require modification of the block above it in the tree, and
so on up to the top of the tree. If it's all kept in RAM, this is a
fast operation, since the trees aren't usually very deep(*).

   At regular intervals (30s), the btrfs code will ensure that it has
a consistent in-memory set of blocks, and flushes those dirty blocks
to disk, ensuring that they're moved from the original location. It
does so by first writing all of the tree data, sending down disk flush
commands to ensure that the data gets to disk reliably, and then
writing out new copies of the superblocks so that they point to the
new trees.

[snip]
> The #1 biggest difference between btrfs and most other filesystems is 
> that btrfs, by default, duplicates all metadata -- two copies of all 
> metadata, one copy of data, by default.
[snip]
> So that doubles the btrfs metadata writes, right there, since by default, 
> btrfs double-copies all metadata.
> 
> The #2 big factor is that btrfs (again, by default, but this is a major 
> feature of btrfs, otherwise, you might as well run something else) does 
> full checksumming for both data and metadata.  Unlike most filesystems, 
[snip] 
> And of course all these checksums must be written somewhere as well, so 
> that's another huge increase in written metadata, even for 0-length 
> files, since the metadata itself is checksummed!

   This isn't quite true. btrfs checksums everything at the rate of a
single (currently 4-byte) checksum per (4096-byte) page. In the case
of data blocks, those go in the checksum tree -- thus increasing the
size of the metadata, as you suggest. However, for metadata blocks,
the checksum is written into each metadata block itself. Thus the
checksum overhead of metadata is effectively zero.

   Further, if the files are all zero length, I'd expect the file
"data" to be held inline in the extent tree, which will increase the
per-file size of the metadata a little, but not much. As a result of
this, there won't be any checksums in the checksum tree, because all
of the extents are stored inline elsewhere, and checksummed by the
normal embedded metadata checksums.

   Hugo.

(*) An internal tree node holds up to 121 tree-node references, so the
depth of a tree with n items in it is approximately log(n)/log(121). A
tree with a billion items in it would have a maximum depth of 5.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- I believe that it's closely correlated with ---           
                       the aeroswine coefficient.                        

--4vpci17Ql0Nrbul2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPVfU1IKyzvlFcI40RAjB0AKDHNbL/LRSggaiEV4I7SFkeuoKQsgCgvtJc
47mG2YTvWn+8qzpfxCf27UI=
=uN3c
-----END PGP SIGNATURE-----

--4vpci17Ql0Nrbul2--
