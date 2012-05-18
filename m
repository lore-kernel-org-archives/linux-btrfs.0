Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45718 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2ERLup (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 07:50:45 -0400
Date: Fri, 18 May 2012 12:50:41 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Newbie questions on some of btrfs code...
Message-ID: <20120518115041.GZ8938@carfax.org.uk>
References: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V/5pStbHlGfNIMG1"
In-Reply-To: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--V/5pStbHlGfNIMG1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 18, 2012 at 02:21:59PM +0300, Alex Lyakas wrote:
> Greetings everybody,
> I have been studying some of the btrfs code and the developer
> documentation on the wiki. My primary interest at this point, is to be
> able to search within fs tree of a btrfs subvolume, which was created
> as a snapshot of another subvolume. For that I have been using the
> debug-tree tool plus the References.png diagram on the wiki. I realize
> that my knowledge of btrfs is very rudimentary at this point, so
> please bear with me.
> 
> # How can I navigate from EXTENT_DATA within the fs tree to
> appropriate CHUNK_ITEM in the chunk tree? I am basically trying to
> find where the file data resides on disk. For example, I have an
> EXTENT_DATA like this:
>         item 30 key (265 EXTENT_DATA 0) itemoff 888 itemsize 53
>                 extent data disk byte 12648448 nr 8192
>                 extent data offset 0 nr 8192 ram 8192
>                 extent compression 0
> I can navigate from here to EXTENT_ITEM within the extent tree, using
> btrfs_file_extent_item::disk_bytenr/disk_num_bytes as key for search:
>         item 3 key (12648448 EXTENT_ITEM 8192) itemoff 3870 itemsize 53
>                 extent refs 1 gen 8 flags 1
>                 extent data backref root 5 objectid 265 offset 0 count 1
> But from there how can I reach the relevant CHUNK_ITEM?

   CHUNK_ITEMs are indexed by the start address of the chunk, so for
the extent at $e, you need to search for the chunk item immediately
before the key (FIRST_CHUNK_TREE, CHUNK_ITEM, $e).

> # Once I have reached the CHUNK_ITEM, I assume that
> btrfs_file_extent_item::offset/num_bytes fields will provide the exact
> location of the data on disk. Is that correct? For now I assume that
> btrfs was created on a single device and raid0 is used for data, so I
> totally ignore mirroring/striping at this point.

   If you want to find the physical position of a given byte in a file
on disk (and repeating some of what you already know):

 - The FS tree holds the directory structure, so you use that to find
   the inode number of the file by name.

 - With the inode number, you can look in the FS tree again to get the
   set of extents which make up the file. These extents are a mapping
   from [byte offset within the file] to [byte offset in virtual
   address space].

 - The extent tree then holds extent info, indexed by virtual address.
   There are two main types of extent: the extents holding file data
   (EXTENT_ITEM), and, overlapping with them, extents representing the
   block groups (BLOCK_GROUP_ITEM), which are the high-level
   allocation units of the FS.

 - For any given file extent (EXTENT_ITEM), you can use the tree
   search API to look in the chunk tree for the chunks holding this
   virtual data extent. (For any non-single RAID level, there will be
   multiple chunks involved). You do this by simply finding CHUNK_ITEM
   items in the tree with a "start" value immediately less than or
   equal to the virtual-address offset of your file extent.

 - With any replicating RAID (-1 or -10) there will be multiple
   entries in the chunk tree for any given virtual address offset,
   representing the multiple mirrors. For any striped RAID level (-0,
   -10), each chunk record in the tree will have several btrfs_stripe
   records in its array.
   Each btrfs_stripe record that you end up with (duplicate copies
   from the RAID-1/-10, and stripes from the RAID-0/-10) will then
   reference the device tree, which gives you the physical location of
   that btrfs_stripe on a specific disk.

   Note that in the btrfs internal terminology, a "stripe" is a
contiguous (256MiB or 1GiB) sequence of bytes on a single disk. RAID
stripes (e.g. RAID-0, -10) are actually called "sub-stripes" in the
btrfs code. There's also no clearly-defined use of the terms "chunk"
and "block group".

   HTH,
   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- How do you become King?  You stand in the marketplace and ---    
          announce you're going to tax everyone. If you get out          
                           alive, you're King.                           

--V/5pStbHlGfNIMG1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPtjeRIKyzvlFcI40RAlCRAKCFxBnB1DAGgiAENLdsXQMymLvT3wCgod3+
nXQtrnE+prvgym2k7+Cg/No=
=bNOG
-----END PGP SIGNATURE-----

--V/5pStbHlGfNIMG1--
