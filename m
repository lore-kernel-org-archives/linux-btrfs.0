From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: Integration branch pushed out to btrfs-unstable
Date: Wed, 25 May 2011 23:41:10 +0300
Message-ID: <20110525234110.669f4d71@sf>
References: <1306179381-sup-443@shiny>
	<4DDCF79F.80405@gmx.net>
	<20110525214418.225ec273@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0Oes6zkpH02673Kk=cTU1U="; protocol="application/pgp-signature"
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110525214418.225ec273@sf>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/0Oes6zkpH02673Kk=cTU1U=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> > The commit
> >=20
> > commit c4f675cd40d955d539180506c09515c90169b15b
> > Author: Sergei Trofimovich <slyfox@gentoo.org>
> > Date:   Fri May 20 20:20:30 2011 +0000
> >=20
> >     btrfs: don't spin in shrink_delalloc if there is nothing to free
> >=20
> > gives me very early ENOSPC in my tests on a small volume (7GB).
>=20
> What king of test is that? I'd like to reproduce it.
> Does it do a lot of parallel I/O?
>=20
> May I ask you to try to reproduce the problem with this sole patch
> on top of linus master?

With Arne's params to fs_mark it triggers for 2.6.39+this patch.
I took 2GB loop device and the script [1].

$ ./make_it.sh
...
#  /home/slyfox/dev/fs_mark/fs_mark  -D  512  -t  16  -n  4096  -s  51200  =
-L7  -S0  -d  /mnt/ut=20
#       Version 3.3, 16 thread(s) starting at Wed May 25 23:35:06 2011
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 512 subdir=
ectories with 180 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 =
random bytes at end of name)
#       Files info: size 51200 bytes, written with an IO size of 16384 byte=
s per write
#       App overhead is time in microseconds spent in the test not doing fi=
le writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
fs_mark: write_file write failed: -1 No space left on device
fs_mark: write_file write failed: -1 No space left on device
fs_mark: write_file write failed: -1 No space left on device
...^C

$ .../btrfs fi df /mnt/ut/
Data: total=3D622.25MB, used=3D434.61MB
System: total=3D4.00MB, used=3D4.00KB
Metadata: total=3D417.50MB, used=3D6.69MB

$ sudo .../btrfs fi show /dev/loop0
Label: none  uuid: ccb18c12-4cbe-458c-835a-30e767939121
        Total devices 1 FS bytes used 441.31MB
        devid    1 size 2.00GB used 1.02GB path /dev/loop0

[1] 'make_it.sh' script exposing bug:
    export LANG=3DC

    FS_MARK=3D$HOME/dev/fs_mark/fs_mark
    MKFS_BTRFS=3D$HOME/dev/git/btrfs-progs-unstable/mkfs.btrfs

    sz=3D2
    the_file=3D${sz}G.img
    mount_point=3D/mnt/ut

    dd if=3D/dev/zero of=3D"${the_file}" bs=3D1 count=3D1 seek=3D$((${sz}*1=
024*1024*1024-1))
    $MKFS_BTRFS -d raid0 -m raid0 "${the_file}"
    sudo mount -oloop "${the_file}" "${mount_point}"
    sudo chown slyfox:users "${mount_point}"
    chmod u+w "${mount_point}"
    cd /tmp
    $FS_MARK \
        -D  512  -t  16  -n  4096  -s  51200  -L7  -S0 \
        -d "${mount_point}"
    sudo umount "${mount_point}"

--=20

  Sergei

--Sig_/0Oes6zkpH02673Kk=cTU1U=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk3daXEACgkQcaHudmEf86rIngCdGCRDkZUtUYCTrs1MFmVSREwB
Tv8AoIbxhJzt2D/CDlqg+jc6yr9FkS4p
=DiuO
-----END PGP SIGNATURE-----

--Sig_/0Oes6zkpH02673Kk=cTU1U=--
