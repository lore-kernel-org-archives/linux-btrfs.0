From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: bug#8001: cp (8.10) sparse handling fails on compressed btrfs
 (cp/fiemap-2)
Date: Wed, 09 Feb 2011 10:57:14 +0000
Message-ID: <4D52730A.2080008@draigBrady.com>
References: <201102072253.34476.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: 8001@debbugs.gnu.org,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201102072253.34476.vapier@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/02/11 03:53, Mike Frysinger wrote:
> after upgrading from coreutils 8.9 to 8.10, the sparse handling in cp=
 is=20
> silently breaking on btrfs filesystems with the compressed option ena=
bled. =20
> using --sparse=3Dnever works fine, but "auto" or "always" tend to fai=
l.  the=20
> cp/fiemap-2 test catches the issue nicely.
>=20
> to reproduce (i'm using linux-2.6.37):
> file=3Dbtrfs.img
> mntp=3D/mnt/tmp/
> dd if=3D/dev/zero of=3D$file bs=3D1M count=3D0 seek=3D1024
> mkfs.btrfs $file=20
> mount -t btrfs -o compress $file $mntp
> cd $mntp
> tar xf ~/coreutils-8.10.tar.xz
> cd coreutils-8.10/tests
> ./cp/fiemap-2
>=20
> and this last test shows:
> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> /dev/loop0   btrfs     1048576     20420    377028   6% /mnt/tmp
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 2.7598e-05 s, 0.0 kB/s
> k k2 differ: byte 1, line 1

Eek.

That doesn't trigger here (2.6.35.10-72.fc14.i686)
because I guess this kernel doesn't honor the compress attribute:

dd if=3D/dev/zero of=3Dtest.size count=3D1000
# du -B512 test.size
1000    test.size

But on a general note, we may read more (or possibly less)
than is stored in the extent. So how to detect that?
I suppose one could use lseek() to get the current position
and see if it's ext_start + ext_length, otherwise adjust accordingly.
That would add a little overhead though.
I also notice the FIEMAP_EXTENT_DATA_ENCRYPTED and FIEMAP_EXTENT_ENCODE=
D
flags, which could mean we only need to handle these extents specially.
Does `filefrag -v` show those for you? I see nothing here.

I don't suppose there is any facility to read the raw data
to also avoid decompressing and compressing again (sendfile, mmap?).

cheers,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
