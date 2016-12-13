Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39042 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752553AbcLMGmI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2016 01:42:08 -0500
Date: Tue, 13 Dec 2016 01:40:13 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Xin Zhou <xin.zhou@gmx.com>
Cc: Roman Mamedov <rm@romanrm.net>, Filipe Manana <fdmanana@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix hole read corruption for compressed inline
 extents
Message-ID: <20161213064012.GX8685@hungrycats.org>
References: <1480309392-4786-1-git-send-email-ce3g8jdj@umail.furryterror.org>
 <20161128172710.202587ce@natsu>
 <20161211051641.GA21290@hungrycats.org>
 <trinity-05c92524-3d70-42a6-b8cd-f9bf40f58f9a-1481493419884@3capp-mailcom-bs05>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fCmRXBY78W5odcVA"
In-Reply-To: <trinity-05c92524-3d70-42a6-b8cd-f9bf40f58f9a-1481493419884@3capp-mailcom-bs05>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fCmRXBY78W5odcVA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 11, 2016 at 10:56:59PM +0100, Xin Zhou wrote:
>    Hi Zygo,
>    =A0
>    Since the corruption happens after I/O and checksum,
>    could it be possible to add some bug catcher code in debug build, to h=
elp
>    narrowing down the issue?

The corruption happens only during reads, after IO and checksum.
It happens at the point that I have patched, after decompression when
the decompressed data doesn't fill the extent and there is a hole after
the extent.  No other code exists in btrfs to fill the hole that forms
in such cases.  There is nothing left to narrow down.

Chris Mason discovered the same bug in 2009 and fixed half of it in commit
93c82d5750.  His fix only fixed one of two cases where corruption occurs
(i.e. after uncompressed extents).  The compressed extent case remained
unfixed until the present.

To be fair to everyone who missed this bug for seven years:  it was
quite a hard bug to spot.  Over a period of 28 months I observed backup
verification failures and eliminated competing theories until only this
bug remained.

There were at least two other bugs fixed between 2009 and 2014 which
would have also produced corrupted data in compressed files under
slightly different circumstances, so anyone looking for data corruption
in compressed extents would have thought they'd solved the problem at
least twice before now.

There was a memset in *almost* the right spot in the code to fix the
corruption bug until early 2014.  Ironically, that memset (which was
introduced in 2009) was itself the cause of another corruption bug.
The memset was removed in 166ae5a418 ("btrfs: fix inline compressed read
err corruption") but that commit removed the memset entirely instead of
fixing it.

It's hard to detect this bug in the wild because the uninitialized
kernel data is often zero by accident (zero is typically the most common
byte value in kernel memory) and the corrupted data is always holes.
The programs that create files with the specific extent structure that
triggers the corruption don't write any data to the corrupted regions
of the files (e.g. the corrupted bytes are unused bytes in ELF headers,
or EXIF thumbnail data in JPEG files).  Such programs typically won't
read the corrupted data bytes, so the corruption often has no visible
impact on users even when it occurs.

The file on disk is not corrupted--the kernel corrupts the file while
reading it--so repeatedly copying and verifying the same files over
and over (e.g. daily backups of the same origin data) will *eventually*
succeed.  That makes the problem look like a hardware issue.  For several
months I thought it *was* a hardware issue, but I kept finding similar
corruption on too many dissimilar machines that were showing no other
evidence of hardware problems.

All that seems to be needed to produce corruption is a filesystem mounted
with the compress option and max_inline >=3D 2048.  Any version of btrfs
=66rom 2012 to the present behaves the same way (older kernels probably also
behave the same way, but they crash too early to finish running my tests).

So far I've discovered corrupted files in these places in the wild:

	- in build directories (e.g. Linux kernel or anything using GCC)

	- in /etc/lvm/{archive,backup}/*

	- in /var/log/ntpstats

	- in backups made with rsync -avxzHSP (but not with rsync -avxzHP)

Here is a one-line script that will find potentially corrupted files on an
existing filesystem.  There is no special setup or repro script required,
other than to set 'compress' in the mount options.  This is just a
developer's work box chosen at random:

	# cd /usr/src/linux
	# find -type f -size +4097c -exec sh -c 'for x; do if filefrag -v "$x" | s=
ed -n "4p" | grep -q inline; then echo "$x"; fi; done' -- {} +
	./arch/x86/kernel/.module.o.cmd
	./block/.scsi_ioctl.o.cmd
	./drivers/ata/.pata_sis.o.cmd

	# filefrag -v ./drivers/ata/.pata_sis.o.cmd
	Filesystem type is: 9123683e
	File size of ./drivers/ata/.pata_sis.o.cmd is 45677 (12 blocks of 4096 byt=
es)
	 ext:     logical_offset:        physical_offset: length:   expected: flag=
s:
	   0:        0..    4095:          0..      4095:   4096:             not_=
aligned,inline
	   1:        1..       1:   35322749..  35322749:      1:          1: shar=
ed
	   2:        2..       2:   35371776..  35371776:      1:   35322750: shar=
ed
	   3:        3..       3:   35532566..  35532566:      1:   35371777: shar=
ed
	   4:        4..       4:   35315682..  35315682:      1:   35532567: shar=
ed
	   5:        5..       5:   36010227..  36010227:      1:   35315683: shar=
ed
	   6:        6..       9:   35396173..  35396176:      4:   36010228: enco=
ded,shared
	   7:       10..      10:   35913574..  35913574:      1:   35396177: shar=
ed
	   8:       11..      11:   35305969..  35305969:      1:   35913575: last=
,eof
	./drivers/ata/.pata_sis.o.cmd: 9 extents found

Note that corruption can only occur if the first extent (the inline extent
at offset 0) is compressed (encoded).  Uncompressed inline extents (like
the one above) will not be corrupted due to the fix in commit 93c82d5750.

If commit 93c82d5750 is reverted, you can get corruption on uncompressed
files too.







>    Thanks,
>    Xin
>    =A0
>    Sent:=A0Saturday, December 10, 2016 at 9:16 PM
>    From:=A0"Zygo Blaxell" <ce3g8jdj@umail.furryterror.org>
>    To:=A0"Roman Mamedov" <rm@romanrm.net>, "Filipe Manana" <fdmanana@gmai=
l.com>
>    Cc:=A0linux-btrfs@vger.kernel.org
>    Subject:=A0Re: [PATCH] btrfs: fix hole read corruption for compressed =
inline
>    extents
>    Ping?
>=20
>    I know at least two people have read this patch, but it hasn't appeare=
d in
>    the usual integration branches yet, and I've seen no actionable sugges=
tion
>    to improve it. I've provided two non-overlapping rationales for it.
>    Is there something else you are looking for?
>=20
>    This patch is a fix for a simple data corruption bug. It (or some
>    equivalent fix for the same bug) should be on its way to all stable
>    kernels starting from 2.6.32.
>=20
>    Thanks
>=20
>    On Mon, Nov 28, 2016 at 05:27:10PM +0500, Roman Mamedov wrote:
>    > On Mon, 28 Nov 2016 00:03:12 -0500
>    > Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:
>    >
>    > > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>    > > index 8e3a5a2..b1314d6 100644
>    > > --- a/fs/btrfs/inode.c
>    > > +++ b/fs/btrfs/inode.c
>    > > @@ -6803,6 +6803,12 @@ static noinline int uncompress_inline(struct
>    btrfs_path *path,
>    > > max_size =3D min_t(unsigned long, PAGE_SIZE, max_size);
>    > > ret =3D btrfs_decompress(compress_type, tmp, page,
>    > > extent_offset, inline_size, max_size);
>    > > + WARN_ON(max_size > PAGE_SIZE);
>    > > + if (max_size < PAGE_SIZE) {
>    > > + char *map =3D kmap(page);
>    > > + memset(map + max_size, 0, PAGE_SIZE - max_size);
>    > > + kunmap(page);
>    > > + }
>    > > kfree(tmp);
>    > > return ret;
>    > > }
>    >
>    > Wasn't this already posted as:
>    >
>    > btrfs: fix silent data corruption while reading compressed inline
>    extents
>    > [1]https://patchwork.kernel.org/patch/9371971/
>    >
>    > but you don't indicate that's a V2 or something, and in fact the pat=
ch
>    seems
>    > exactly the same, just the subject and commit message are entirely
>    different.
>    > Quite confusing.
>    >
>    > --
>    > With respect,
>    > Roman
>    > --
>    > To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s"
>    in
>    > the body of a message to majordomo@vger.kernel.org
>    > More majordomo info at [2]http://vger.kernel.org/majordomo-info.html
>=20
> References
>=20
>    Visible links
>    1. https://patchwork.kernel.org/patch/9371971/
>    2. http://vger.kernel.org/majordomo-info.html

--fCmRXBY78W5odcVA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhPl8wACgkQgfmLGlazG5xbywCgwZvTw+AegGUcMT1wTFJjhEju
6FwAoLfwAualp3dfEeyQh9IvW9JXCnYi
=kVcK
-----END PGP SIGNATURE-----

--fCmRXBY78W5odcVA--
