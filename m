From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sun, 26 Feb 2012 11:00:44 +0000
Message-ID: <20120226110044.GA18898@carfax.org.uk>
References: <jic3e1$gpe$1@dough.gmane.org>
 <4F499498.1040006@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Cc: "Brian J. Murrell" <brian@interlinx.bc.ca>,
	linux-btrfs@vger.kernel.org
To: Fahrzin Hemmati <fahhem2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F499498.1040006@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 25, 2012 at 06:10:32PM -0800, Fahrzin Hemmati wrote:
> btrfs is horrible for small filesystems (like a 5GB drive). df -h
> says you have 967MB available, but btrfs (at least by default)
> allocates 1GB at a time to data/metadata. This means that your 10MB
> file is too big for the current allocation and requires a new data
> chunk, or another 1GB, which you don't have.
> 
> Others might know of a way of changing the allocation size to less
> than 1GB, but otherwise I recommend switching to something more
> stable like ext4/reiserfs/etc.

   The option that nobody's mentioned yet is to use mixed mode. This
is the -M or --mixed option when you create the filesystem. It's
designed specifically for small filesystems, and removes the
data/metadata split for more efficient packing.

> On 2/25/2012 5:55 PM, Brian J. Murrell wrote:
> >I have a 5G /usr btrfs filesystem on a 3.0.0-12-generic kernel that is
> >returning ENOSPC when it's only 75% full:

   As mentioned before, you probably need to upgrade to 3.2 or 3.3-rc5
anyway. There were quite a few fixes in the ENOSPC/allocation area
since then.

> >Filesystem            Size  Used Avail Use% Mounted on
> >/dev/mapper/rootvol-mint_usr
> >                       5.0G  2.8G  967M  75% /usr
> >
> >And yet I can't even unpack a linux-headers package on to it, which
> >should be nowhere near 967MB.  dpkg says it will need 10MB:
> >
> >So this starts to feel like some kind of inode count limitation.  But I
> >didn't think btrfs had inode count limitations.  Here's the df stats on
> >the filesystem:

   It doesn't have inode limitations. It does, however, have some
peculiar limitations on the use of space. Specifically, the
copy-on-write nature has some implications.

   When you write *anything* to the FS, it does a CoW copy of
everything involved in the write. This includes all of the related
metadata, including the path from the B-tree leaves being touched up
to the root of the tree [in each B-tree being touched]. So, if you're
near the bounds of space in metadata, you can end up in a situation
where you modify a lot of metadata, and need a lot of space to do the
CoW in, so you try to allocate more metadata block groups -- which
requires metadata to be modified -- and run out of metadata space in
the allocation operation, which is treated as ENOSPC.

   That's not necessarily what's happened here, but it's highly
plausible. The FS does actually keep a small set of metadata reserved
to deal with this situation, but sometimes it's not very good at
planning how much metadata it needs before an operation is started.
It's that code that's had a lot of work since 3.0.

> >$ btrfs filesystem df /usr
> >Data: total=3.22GB, used=3.22GB
> >System, DUP: total=8.00MB, used=4.00KB
> >System: total=4.00MB, used=0.00
> >Metadata, DUP: total=896.00MB, used=251.62MB
> >Metadata: total=8.00MB, used=0.00
> >
> >I don't know if that's useful or not.

   Not to me directly -- there appears to be enough metadata to do
pretty much anything, so the above scenario _probably_ isn't the
problem, but it's clearly trying to allocate a new data block group
(which it should be able to do -- it should just take all the
remaining space, unlike Fahrzin's hypothesis).

   There have been some issues over having very large metadata
allocations that can't apparently be reused, though. It's possible
you've hit this one -- particularly if you're trying to untar
something, which performs lots and lots of writes all in one
transaction. Again, there's been some work on this since 3.0.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- What part of "gestalt" don't you understand? ---           

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPShDcIKyzvlFcI40RAhAPAKCZQ462o42+zqoLkiU1zuwfW3LrWACgt+FE
0PxyTaRk7GysIcHaSARAtQU=
=87gH
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
