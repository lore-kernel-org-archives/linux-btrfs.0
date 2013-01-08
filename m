Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36379 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765Ab3AHSJi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 13:09:38 -0500
Date: Tue, 8 Jan 2013 10:09:37 -0800
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3707 still not fixed in 3.7.1 (btrfs-zero-log required) but shown as "RIP btrfs_num_copies"
Message-ID: <20130108180937.GE2044@merlins.org>
References: <20130108164958.GA2044@merlins.org> <20130108171012.GP19051@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
In-Reply-To: <20130108171012.GP19051@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

See bottom, my filesystem mounts, but apparently it's still corrupted as per
btrfs-image output

On Tue, Jan 08, 2013 at 05:10:12PM +0000, Hugo Mills wrote:
> > Question #1:
> > I have hourly snapshots of my root filesystem, and I wasn't able to mou=
nt
> > any of them. I got the BUG at fs/btrfs/volumes.c:3707 each time.
> > gandalfthegreat:~# mount -o ro,recovery /dev/mapper/root -o 'subvol=3Dr=
oot_daily_20130108_00:01:02,defaults,compress=3Dlzo,discard,nossd,space_cac=
he,noatime'
> >=20
> > If my log is damaged, why are all other snapshots also broken?
>=20
>    Snapshots are not independent of each other. The filesystem as a
> whole is damaged -- if you can't mount it, it won't make a difference
> which subvolume you try to mount. A snapshot is not a backup; it won't
> save you from a broken filesystem or dead hardware. At best, it'll
> save you from accidental deletion of files.
=20
Thanks for explaining. I guess it makes sense that the log is not a per
subvolume thing, but a filesystem-wide thing.
Last time I posted this problem, someone replied and suggested that I tried
mounting an older snapshot, but now I understand that it won't help.

>    Oopses in log playback are a bug. The last time we had such a bug
> which was identifiable and traceable (back in the 3.1-3.2 era, IIRC),
> it got fixed, eventually. So yes, this is a bug, it should be fixed,
> and you're not the only person to have seen log tree replys fail in
> 3.6 and 3.7 kernels.
>    Since you seem to be hitting the problem frequently and repeatably,
> could you help? Josef has said he'd like a copy of the filesystem
> image that btrfs-image produces when run against the broken FS (i.e.
> while the FS can't mount) -- that would help track down the corruption
> problem, and make the kernel more robust in this area. Just as a
> warning, the output may be quite large: it contains all of your FS's
> metadata.
=20
Argh, I reported this here with 3.6.3 3 months ago and waited an entire week
for someone to tell me what they wanted off my FS before I removed all
evidence of the bug, but never got a reply asking for anything.

Since I didn't read any updates since then or found anything new on=20
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_can.27t_mount_my_file=
system.2C_and_I_get_a_kernel_oops.21
I just went ahead and fixed my laptop right away this morning, sorry about
that.

Because it's my main work laptop, I don't want to break it on purpose, or
risk corruption that I may not notice and would creep in my incremental
backups, so I'd rather not try and reproduce this on purpose, but if you
want a way to reproduce this, I think pulling the sata cable off a drive=20
while writing a few times should reproduce this pretty easily
(or maybe even just pulling power although I know pulling power still lets
some drives write some things before they shut down)

I'm however likely to hit the problem again sooner or later, whether I want
it or not. I'll make sure to run btrfs-image next time.

Ok, how about this.=20
1) I updated https://btrfs.wiki.kernel.org/index.php/Problem_FAQ to tell
people to run btrfs-image. It'll be easier for you to get what you need if
it's documented somewhere :)
Please update it further to say what people should do since posting on the
list does not always yield timely replies for people who need to recover
soon-ish from backup if necessary.

2) You may still be in luck, maybe? and me not so much. I thought my
filesystem was recovered, I'm running it right now, but:

gandalfthegreat:~# btrfs-image -c 9 -t 8 /dev/mapper/cryptroot /var/tmp/fs_=
image
Check tree block failed, want=3D5212229632, have=3D12481778023482407252
Check tree block failed, want=3D5212229632, have=3D12481778023482407252
Check tree block failed, want=3D5212229632, have=3D14440972074482314957
Check tree block failed, want=3D5212229632, have=3D12481778023482407252
Check tree block failed, want=3D5212229632, have=3D12481778023482407252
read block failed check_tree_block
btrfs-image: btrfs-image.c:518: create_metadump: Assertion `!(ret < 0)' fai=
led.
Aborted
gandalfthegreat:~# l /var/tmp/fs_image=20
-rw-r--r-- 1 root root 234413056 Jan  8 09:58 /var/tmp/fs_image

No idea what version I have because it won't say:
gandalfthegreat:~# btrfs-image --version
btrfs-image: invalid option -- '-'
usage: btrfs-image [options] source target
	-r      	restore metadump image
	-c value	compression level (0 ~ 9)
	-t value	number of threads (1 ~ 32)
gandalfthegreat:~# btrfs-image -v
btrfs-image: invalid option -- 'v'
(...)

Is my incomplete /var/tmp/fs_image useful, or anything else you want out of
my maybe still corrupted filesystem?

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQCVAwUBUOxg4X4xUKZ2O+kBAQKNdgQAmrNJFS1vdKthWYD/ehCF916Hry1jV/gh
2vcPQbS/HnPIv44IRXs8mTvo7nF/iQiErd1uEyVSbQZnVTmsq3OzMO+R3GG7kOxR
CnHCY6O6VzXZ3rZ73GkIKTkCMUbVCT0ssw89eHvv4/lGfaEIG5/Uwz1klyQkAT7D
RzgyI7mdYfQ=
=qsas
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
