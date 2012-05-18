Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47704 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab2ERN7o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 09:59:44 -0400
Date: Fri, 18 May 2012 14:59:38 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Newbie questions on some of btrfs code...
Message-ID: <20120518135938.GC8938@carfax.org.uk>
References: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>
 <20120518115041.GZ8938@carfax.org.uk>
 <CAHf9xva5ux5VXbww2YMjORSSdhSKH7L6W5vbP-ZnxijiGK4fUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ds9maZbwT7uk2FVi"
In-Reply-To: <CAHf9xva5ux5VXbww2YMjORSSdhSKH7L6W5vbP-ZnxijiGK4fUw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ds9maZbwT7uk2FVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 18, 2012 at 04:32:09PM +0300, Alex Lyakas wrote:
> Thank you, Hugo, for the detailed explanation. I am now able to find
> the CHUNK_ITEMs and to successfully locate the file data on disk.
> Can you maybe address several follow-up questions I have?
> 
> # When looking for CHUNK_ITEMs, should I check that their
> btrfs_chunk::type==BTRFS_BLOCK_GROUP_DATA (and not SYSTEM/METADATA
> etc)? Or file extent should always be mapped to BTRFS_BLOCK_GROUP_DATA
> chunk?

   File extents will either be mapped to a data chunk, _or_ the file
data will live inline in the metadata area, following the
btrfs_extent_item. This is probably the trickiest piece of the on-disk
data format to figure out, and I fear that I didn't document it well
enough. Basically, it's non-obvious where inline extents are
calculated, because there's all sorts of awkward-looking type casting
to get to the data.

> # It looks like I don't even need to bother with the extent tree at
> this point, because from EXTENT_DATA in fs tree I can navigate
> directly to CHUNK_ITEM in chunk tree, correct?

   Mmm... possibly. Again, I'm not sure how this interacts with inline
extents.

> # For replicating RAID levels, you said there will be multiple
> CHUNK_ITEMs. How do I find them then? Should I know in advance how
> much there should be, and look for them, considering only
> btrfs_chunk::type==BTRFS_BLOCK_GROUP_DATA? (I don't bother for
> replication at this point, though).

   Actually, thinking about it, there's a single CHUNK_ITEM, and the
stripe[] array holds all of the per-disk allocations that correspond
to that block group. So, for RAID-1, you'll have precisely two
elements in the stripe[] array. Sorry for getting it wrong earlier.

> # If I find in the fs tree an EXTENT_DATA of type
> BTRFS_FILE_EXTENT_PREALLOC, how should I treat it? What does it mean?
> (BTRFS_FILE_EXTENT_INLINE are easy to treat).

   I don't know, sorry.

> # One of my files has two EXTENT_DATAs, like this:
> 	item 14 key (270 EXTENT_DATA 0) itemoff 1812 itemsize 53
> 		extent data disk byte 432508928 nr 1474560
> 		extent data offset 0 nr 1470464 ram 1474560
> 		extent compression 0
> 	item 15 key (270 EXTENT_DATA 1470464) itemoff 1759 itemsize 53
> 		extent data disk byte 432082944 nr 126976
> 		extent data offset 0 nr 126976 ram 126976
> 		extent compression 0
> Summing btrfs_file_extent_item::num_bytes gives
> 1470464+126976=1597440. (I know that I should not be summing
> btrfs_file_extent_item::disk_num_bytes, but num_bytes).
> However, it's INODE_ITEM gives size of 1593360, which is less:
> 	item 11 key (270 INODE_ITEM 0) itemoff 1970 itemsize 160
> 		inode generation 26 size 1593360 block group 0 mode 100700 links 1
> 
> Is this a valid situation, or I should always consider size in
> INODE_ITEM as the correct one?

   Again, I don't know off the top of my head. It's been some time
since I dug into these kinds of details, sorry.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- In my day, we didn't have fancy high numbers.  We had ---      
               "nothing", "one", "twain" and "multitudes".               

--ds9maZbwT7uk2FVi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPtlXKIKyzvlFcI40RAjT9AKC18yxEu4U8UrPULpOw8s1otlxcLwCgp+w6
cckAa+kvOzDIoZdPYYiFYs8=
=+zPp
-----END PGP SIGNATURE-----

--ds9maZbwT7uk2FVi--
