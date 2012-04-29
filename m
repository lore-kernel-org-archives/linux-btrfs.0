From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Interpreting Output of "btrfs fi show"
Date: Sun, 29 Apr 2012 19:34:27 +0100
Message-ID: <20120429183427.GL6172@carfax.org.uk>
References: <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com>
 <C7$h9m5PCXB@helmut.hullen.de>
 <pan.2012.04.26.20.54.46@cox.net>
 <8118972.tgkAvno4mK@bursa22>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cy9Nn4fUvYST66Pl"
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, josef@redhat.com
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <8118972.tgkAvno4mK@bursa22>
List-ID: <linux-btrfs.vger.kernel.org>


--cy9Nn4fUvYST66Pl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 28, 2012 at 06:42:52PM +0200, Hubert Kario wrote:
> On Thursday 26 of April 2012 20:54:47 Duncan wrote:
> > Helmut Hullen posted on Thu, 26 Apr 2012 13:11:00 +0200 as excerpted:
> > > Hallo, Bart,
> > >> 
> > >> Well I think there is a btrfs superblock still present from the
> > >> full-disk filesystem. Due to the offset of the first partition from the
> > >> start of the disk, this superblock was not overwritten when you created
> > >> the filesystem inside the partition.
> > > 
> > > Sounds familiar ...
> > > 
> > > I now use to delete about the first 10 MByte of the target disk via "dd
> > > if=/dev/zero"
> > 
> > But /unlike/ reiserfs, which was only affected with the well warned as
> > don't-use-unless-you-have-to fsck --rebuild-tree option, it seems that
> > due to btrfs scan, etc, btrfs has its similar problem in more routine
> > operation.
> 
> I'd say that this kind of problem is basically impossible in btrfs because 
> of FS UUID written all over the tree.
> 
> What we see here, is a superblock that is written in *very* specific place 
> on the partition, that just is aligned in place that makes the whole disk 
> look like btrfs.
> 
> I don't think it's actually possible for btrfs to put a file with btrfs 
> filesystem image in place where it could seem like the basic block device 
> has btrfs /too/. It depends on whatever the metadata block is allocated 
> before data block on disk. It /may/ be possible in mixed data-metadata 
> allocation mode.
> Chris or Josef, can you confirm?

   It's actually even harder than that -- btrfs filesystems have the
FS UUID embedded in every single block of metadata, including the
superblock, so there's no way of mixing up two filesystems, even if
they actually occupy blocks on the same device (as in the scenario
above).

   However, this comes at a price, which is that a block-for-block
copy of a btrfs filesystem looks like it's a part of the original FS,
and you can't mount both the original and the copy on the same machine
at the same time.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "What's so bad about being drunk?" "You ask a glass of water" ---  
                                                                         

--cy9Nn4fUvYST66Pl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPnYmzIKyzvlFcI40RAlq2AKC9XIFzx+/DrE/jRh9QkagQiqD3rgCfQvmo
UiII/w0/DTTHwpLPnz8btwU=
=EocZ
-----END PGP SIGNATURE-----

--cy9Nn4fUvYST66Pl--
