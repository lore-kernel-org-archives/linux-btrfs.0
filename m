From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs and 1 billion small files
Date: Mon, 7 May 2012 12:39:28 +0100
Message-ID: <20120507113928.GE8938@carfax.org.uk>
References: <20120507105552.GC8938@carfax.org.uk>
 <1429905255.3406.1336389326378.JavaMail.root@zimbra.interconnessioni.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VdOwlNaOFKGAtAAV"
Cc: linux-btrfs@vger.kernel.org
To: Alessio Focardi <alessiof@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1429905255.3406.1336389326378.JavaMail.root@zimbra.interconnessioni.it>
List-ID: <linux-btrfs.vger.kernel.org>


--VdOwlNaOFKGAtAAV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2012 at 01:15:26PM +0200, Alessio Focardi wrote:
> > This is a lot more compact (as you can have several files' data in a
> > single block), but by default will write two copies of each file,
> > even
> > on a single disk.
> 
> Great, no (or less) space wasted, then!

   Less space wasted -- you will still have empty bytes left at the
end(*) of most metadata blocks, but you will definitely be packing in
storage far more densely than otherwise.

(*) Actually, the middle, but let's ignore that here.

> I will have a filesystem that's composed mostly of metadata blocks,
> if I understand correctly. Will this create any problem?

   Not that I'm aware of -- but you probably need to run proper tests
of your likely behaviour just to see what it'll be like.

> >    So, if you want to use some form of redundancy (e.g. RAID-1), then
> > that's great, and you need to do nothing unusual. However, if you
> > want
> > to maximise space usage at the expense of robustness in a device
> > failure, then you need to ensure that you only keep one copy of your
> > data. This will mean that you should format the filesystem with the
> > -m
> > single option.
> 
> 
> That's a very clever suggestion, I'm preparing a test server right now: going to use the -m single option. Any other suggestion regarding format options?
> 
> pagesize? leafsize?

   I'm not sure about these -- some values of them definitely break
things. I think they are required to be the same, and that you could
take them up to 64k with no major problems, but do check that first
with someone who actually knows.

   Having a larger pagesize/leafsize will reduce the depth of the
trees, and will allow you to store more items in each tree block,
which gives you less wastage again. I don't know what the drawbacks
are, though.

> > > XFS has a minimum block size of 512, but BTRFS is more modern and,
> > > given the fact that is able to handle indexes on his own, it could
> > > help us speed up file operations (could it?)
> > 
> >    Not sure what you mean by "handle indexes on its own". XFS will
> > have its own set of indexes and file metadata -- it wouldn't be much
> > of a filesystem if it didn't.

> Yes, you are perfectly right; I tough that recreating a tree like
> /d/u/m/m/y/ to store "dummy" would have been redundant since the
> whole filesystem is based on trees - I don't have to "ls"
> directories, we are using php to write and read files, I will have
> to find a "compromise" between levels of directories and number of
> files in each one of them.

   The FS tree (which is the bit that stores the directory hierarchy
and file metadata) is (broadly) a tree-structured index of inodes,
ordered by inode number. Don't confuse the inode index structure with
the directory structure -- they're totally different arrangements of
the data. You may want to try looking at [1], which attempts to
describe how the FS tree holds file data.

> May I ask you about compression? Would you use it in the scenario I
> described?

   I'm not sure if compression will apply to inline file data. Again,
someone else may be able to answer; and you should probably test it
with your own use-cases anyway.

   Hugo.

[1] http://btrfs.ipv5.de/index.php?title=Trees

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Welcome to Rivendell,  Mr Anderson... ---              

--VdOwlNaOFKGAtAAV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPp7RvIKyzvlFcI40RAjlNAKCPaV6iZKeiBTOH92f0d6abaR0GMACeJAnf
roVDRjxUenBwZeN+YEvbxK4=
=lNaz
-----END PGP SIGNATURE-----

--VdOwlNaOFKGAtAAV--
