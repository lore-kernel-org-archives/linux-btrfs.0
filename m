From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: LABEL only 1 device
Date: Mon, 27 Feb 2012 21:45:36 +0000
Message-ID: <20120227214536.GB4481@carfax.org.uk>
References: <pan.2012.02.27.16.48.34@cox.net>
 <C3f4teQD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C3f4teQD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 27, 2012 at 10:15:00PM +0100, Helmut Hullen wrote:
> Du meintest am 27.02.12:
> 
> >>>    I've said this several times: Your expectations are wrong. You
> >>> don't label partitions.
> 
> >> Yes - now I know.
> >> But I'm afraid other people also expect wrong - when I use
> >> mkfs.ext[234] then this option works (in another way than with
> >> "mkfs.btrfs").
> 
> > AFAIK, it works in the same way... that is, it labels the, in that
> > case, ext2/3/4 filesystem, in this case (mkfs.btrfs), btrfs
> > filesystem.
> 
> > From the manpages:
> 
> > mkfs.btrfs (aka mkbtrfs):
> 
> >        -L, --label name
> >               Specify a label for the filesystem.
> 
> > mkfs.ext2/3/4 (aka mke2fs):
> 
> >        -L new-volume-label
> >               Set  the  volume  label  for the filesystem to
> > 	      new-volume-label.  The maximum length of the
> >               volume label is 16 bytes.
> 
> But there's a small difference:
> 
>         mke2fs -L MyLabel /dev/sdn4
> 
> only sets/changes the label (ok - it tests the type of the partition and  
> refuses labeling if the type doesn't fit).

   OK, I have just tried this out. It does set the filesystem label.
It also wipes the filesystem, as I expected it to. You clearly aren't
doing this on existing filesystems with data in them.

hrm@ruth:~ $ sudo mke2fs /dev/loop0 
mke2fs 1.42 (29-Nov-2011)
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=0 blocks, Stripe width=0 blocks
25688 inodes, 102400 blocks
5120 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=67371008
13 block groups
8192 blocks per group, 8192 fragments per group
1976 inodes per group
Superblock backups stored on blocks: 
		   8193, 24577, 40961, 57345, 73729

Allocating group tables: done                            
Writing inode tables: done                            
Writing superblocks and filesystem accounting information: done 

hrm@ruth:~ $ sudo mount /dev/loop0 /mnt
hrm@ruth:~ $ sudo dd if=/dev/urandom of=/mnt/foo bs=1M count=5
5+0 records in
5+0 records out
5242880 bytes (5.2 MB) copied, 1.74158 s, 3.0 MB/s
hrm@ruth:~ $ ls /mnt
foo  lost+found
hrm@ruth:~ $ sudo umount /mnt
hrm@ruth:~ $ sudo mke2fs -L newlabel /dev/loop0 
mke2fs 1.42 (29-Nov-2011)
Filesystem label=newlabel
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=0 blocks, Stripe width=0 blocks
25688 inodes, 102400 blocks
5120 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=67371008
13 block groups
8192 blocks per group, 8192 fragments per group
1976 inodes per group
Superblock backups stored on blocks: 
		   8193, 24577, 40961, 57345, 73729

Allocating group tables: done                            
Writing inode tables: done                            
Writing superblocks and filesystem accounting information: done 

hrm@ruth:~ $ sudo mount /dev/loop0 /mnt
hrm@ruth:~ $ ls /mnt
lost+found
hrm@ruth:~ $ 


   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 6: Mature Student ---       

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPS/l/IKyzvlFcI40RAlaIAJ4wxLJHrMn67JjbvUHKHIxZOA05ugCfeEIb
wxSHrNHaCVOUtx5U8Jc48+A=
=WR5k
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
