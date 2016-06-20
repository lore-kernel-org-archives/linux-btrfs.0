Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:37836 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751742AbcFTDo3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jun 2016 23:44:29 -0400
Date: Sun, 19 Jun 2016 23:44:27 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: Adventures in btrfs raid5 disk recovery
Message-ID: <20160620034427.GK15597@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RwxaKO075aXzzOz0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--RwxaKO075aXzzOz0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Not so long ago, I had a disk fail in a btrfs filesystem with raid1
metadata and raid5 data.  I mounted the filesystem readonly, replaced
the failing disk, and attempted to recover by adding the new disk and
deleting the missing disk.

It's not going well so far.  Pay attention, there are at least four
separate problems in here and we're not even half done yet.

I'm currently using kernel 4.6.2 with btrfs fixes forward-ported from
4.5.7, because 4.5.7 has a number of fixes that 4.6.2 doesn't.  I have
also pulled in some patches from the 4.7-rc series.

This fixed a few problems I encountered early on, and I'm still making
forward progress, but I've only replaced 50% of the failed disk so far,
and this is week four of this particular project.

What worked:

'mount -odegraded,...' successfully mounts the filesystem RW. =20
'btrfs device add' adds the new disk.  Success!

The first thing I did was balance the metadata onto non-missing disks.
That went well.  Now there are only data chunks to recover from the
missing disk.  Success!

The normal 'device delete' operation got about 25% of the way in,
then got stuck on some corrupted sectors and aborting with EIO. =20
That ends the success, but I've had similar problems with raid5 arrays
before and been able to solve them.

I've managed to remove about half of the data from the missing disk
so far.  'balance start -ddevid=3D<missing disk ID>,drange=3D0..10000000000=
0'
(with increasing values for drange) is able to move data off the failed
disk while avoiding the damaged regions.  It looks like this process could
reduce the amount of data on "missing" devices to a manageable number,
then I could identify the offending corrupted extents with 'btrfs scrub',
remove the files containing them, and finish the device delete operation.
Hope!

What doesn't work:

The first problem is that the kernel keeps crashing.  I put the filesystem
and all its disks in a KVM so the crashes are less disruptive, and I can
debug them (or at least collect panic logs).  OK now crashes are merely a
performance problem.

Why did I mention 'btrfs scrub' above?  Because 'btrfs scrub' tells me
where corrupted blocks are.  'device delete' fills my kernel logs with
lines like this:

	[26054.744158] BTRFS info (device vdc): relocating block group 27753592127=
488 flags 129
	[26809.746993] BTRFS warning (device vdc): csum failed ino 404 off 6021976=
064 csum 778377694 expected csum 2827380172
	[26809.747029] BTRFS warning (device vdc): csum failed ino 404 off 6021980=
160 csum 3776938678 expected csum 514150079
	[26809.747077] BTRFS warning (device vdc): csum failed ino 404 off 6021984=
256 csum 470593400 expected csum 642831408
	[26809.747093] BTRFS warning (device vdc): csum failed ino 404 off 6021988=
352 csum 796755777 expected csum 690854341
	[26809.747108] BTRFS warning (device vdc): csum failed ino 404 off 6021992=
448 csum 4115095129 expected csum 249712906
	[26809.747122] BTRFS warning (device vdc): csum failed ino 404 off 6021996=
544 csum 2337431338 expected csum 1869250975
	[26809.747138] BTRFS warning (device vdc): csum failed ino 404 off 6022000=
640 csum 3543852608 expected csum 1929026437
	[26809.747154] BTRFS warning (device vdc): csum failed ino 404 off 6022004=
736 csum 3417780495 expected csum 3698318115
	[26809.747169] BTRFS warning (device vdc): csum failed ino 404 off 6022008=
832 csum 3423877520 expected csum 2981727596
	[26809.747183] BTRFS warning (device vdc): csum failed ino 404 off 6022012=
928 csum 550838742 expected csum 1005563554
	[26896.379773] BTRFS info (device vdc): relocating block group 27753592127=
488 flags 129
	[27791.128098] __readpage_endio_check: 7 callbacks suppressed
	[27791.236794] BTRFS warning (device vdc): csum failed ino 405 off 6021980=
160 csum 3776938678 expected csum 514150079
	[27791.236799] BTRFS warning (device vdc): csum failed ino 405 off 6021971=
968 csum 3304844252 expected csum 4171523312
	[27791.236821] BTRFS warning (device vdc): csum failed ino 405 off 6021984=
256 csum 470593400 expected csum 642831408
	[27791.236825] BTRFS warning (device vdc): csum failed ino 405 off 6021988=
352 csum 796755777 expected csum 690854341
	[27791.236842] BTRFS warning (device vdc): csum failed ino 405 off 6021992=
448 csum 4115095129 expected csum 249712906
	[27791.236847] BTRFS warning (device vdc): csum failed ino 405 off 6021996=
544 csum 2337431338 expected csum 1869250975
	[27791.236857] BTRFS warning (device vdc): csum failed ino 405 off 6022004=
736 csum 3417780495 expected csum 3698318115
	[27791.236864] BTRFS warning (device vdc): csum failed ino 405 off 6022000=
640 csum 3543852608 expected csum 1929026437
	[27791.236874] BTRFS warning (device vdc): csum failed ino 405 off 6022008=
832 csum 3423877520 expected csum 2981727596
	[27791.236978] BTRFS warning (device vdc): csum failed ino 405 off 6021976=
064 csum 778377694 expected csum 2827380172
	[27927.222130] BTRFS info (device vdc): relocating block group 27753592127=
488 flags 129
	[28679.904235] __readpage_endio_check: 7 callbacks suppressed
	[28679.907160] BTRFS warning (device vdc): csum failed ino 406 off 6021984=
256 csum 470593400 expected csum 642831408
	[28679.914460] BTRFS warning (device vdc): csum failed ino 406 off 6021980=
160 csum 3776938678 expected csum 514150079
	[28679.914566] BTRFS warning (device vdc): csum failed ino 406 off 6021976=
064 csum 778377694 expected csum 2827380172
	[28679.914584] BTRFS warning (device vdc): csum failed ino 406 off 6021988=
352 csum 796755777 expected csum 690854341
	[28679.914596] BTRFS warning (device vdc): csum failed ino 406 off 6021992=
448 csum 4115095129 expected csum 249712906
	[28679.914616] BTRFS warning (device vdc): csum failed ino 406 off 6021996=
544 csum 2337431338 expected csum 1869250975
	[28679.914625] BTRFS warning (device vdc): csum failed ino 406 off 6022000=
640 csum 3543852608 expected csum 1929026437
	[28679.914641] BTRFS warning (device vdc): csum failed ino 406 off 6022004=
736 csum 3417780495 expected csum 3698318115
	[28679.914643] BTRFS warning (device vdc): csum failed ino 406 off 6022008=
832 csum 3423877520 expected csum 2981727596
	[28679.914661] BTRFS warning (device vdc): csum failed ino 406 off 6022012=
928 csum 550838742 expected csum 1005563554
	[28769.622165] BTRFS info (device vdc): relocating block group 27753592127=
488 flags 129
	[29409.886503] __readpage_endio_check: 7 callbacks suppressed
	[29409.889486] BTRFS warning (device vdc): csum failed ino 407 off 6021971=
968 csum 3304844252 expected csum 4171523312
	[29409.896090] BTRFS warning (device vdc): csum failed ino 407 off 6021976=
064 csum 778377694 expected csum 2827380172
	[29409.918458] BTRFS warning (device vdc): csum failed ino 407 off 6021984=
256 csum 470593400 expected csum 642831408
	[29409.918463] BTRFS warning (device vdc): csum failed ino 407 off 6021980=
160 csum 3776938678 expected csum 514150079
	[29409.918489] BTRFS warning (device vdc): csum failed ino 407 off 6021992=
448 csum 4115095129 expected csum 249712906
	[29409.918504] BTRFS warning (device vdc): csum failed ino 407 off 6021996=
544 csum 2337431338 expected csum 1869250975
	[29409.918517] BTRFS warning (device vdc): csum failed ino 407 off 6022000=
640 csum 3543852608 expected csum 1929026437
	[29409.918530] BTRFS warning (device vdc): csum failed ino 407 off 6022004=
736 csum 3417780495 expected csum 3698318115
	[29409.918543] BTRFS warning (device vdc): csum failed ino 407 off 6022008=
832 csum 3423877520 expected csum 2981727596
	[29409.918556] BTRFS warning (device vdc): csum failed ino 407 off 6022012=
928 csum 550838742 expected csum 1005563554

"ino 407" is a lie and I have not yet been able to identify what the
offsets mean (assuming they're not lies too).  What's really interesting
is that ino increases by one each time 'btrfs dev del' is run.
I guess it's just printing uninitialized memory here or something?
OK I'll avoid some of the more broken btrfs tools.

'btrfs scrub' tells me the precise ino, offset, and path names of
corrupted files, but it takes a week to run, so I'm moving as much data
as possible onto newer (and faster) disks to make the scrub run faster.
Sounds like a viable plan.

I kept getting crashes at two specific BUG_ONs, which I patched around
as follows:

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 57fccc4..1ed1e43 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2296,7 +2296,10 @@ int btrfs_check_repairable(struct inode *inode, stru=
ct bio *failed_bio,
 		 * if the following BUG_ON triggers, our validation request got
 		 * merged. we need separate requests for our algorithm to work.
 		 */
-		BUG_ON(failrec->in_validation);
+		if (failrec->in_validation) {
+			printk(KERN_ERR "failrec->in_validation at %s:%d\n", __FUNCTION__, __LI=
NE__);
+			return 0;
+		}
 		failrec->in_validation =3D 1;
 		failrec->this_mirror =3D failed_mirror;
 	} else {
@@ -2306,7 +2309,10 @@ int btrfs_check_repairable(struct inode *inode, stru=
ct bio *failed_bio,
 		 * everything for repair_io_failure to do the rest for us.
 		 */
 		if (failrec->in_validation) {
-			BUG_ON(failrec->this_mirror !=3D failed_mirror);
+			if (failrec->this_mirror !=3D failed_mirror) {
+				printk(KERN_ERR "failrec->this_mirror (%d) !=3D failed_mirror (%d) at =
%s:%d\n", failrec->this_mirror, failed_mirror, __FUNCTION__, __LINE__);
+				return 0;
+			}
 			failrec->in_validation =3D 0;
 			failrec->this_mirror =3D 0;
 		}

'failrec->this_mirror' often has values like 0, 1, or 2, but sometimes
has values like -445886021 or -823858068.  More uninitialized memory?
This worries me.

The other BUG_ON lands here:

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c1fe22c..71afeb3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2018,10 +2018,10 @@ int repair_io_failure(struct inode *inode, u64 star=
t, u64 length, u64 logical,
 	int ret;
=20
 	ASSERT(!(fs_info->sb->s_flags & MS_RDONLY));
-	BUG_ON(!mirror_num);
+	WARN_ON(!mirror_num);
=20
 	/* we can't repair anything in raid56 yet */
-	if (btrfs_is_parity_mirror(map_tree, logical, length, mirror_num))
+	if (!mirror_num || btrfs_is_parity_mirror(map_tree, logical, length, mirr=
or_num))
 		return 0;
=20
 	bio =3D btrfs_io_bio_alloc(GFP_NOFS, 1);

This code gives me more questions than answers:  Why is there a BUG_ON
located before the call to btrfs_is_parity_mirror?  Why is mirror_num
even passed to btrfs_is_parity_mirror?  btrfs_is_parity_mirror doesn't
use the mirror_num argument.  Never has since it was written in 2013.
More worrying.

Those two patches helped to the extent that my kernel stopped crashing
whenever it encountered a bad checksum on the filesystem; however, now I'm
getting EIO randomly all over the filesystem, including in files that were
written entirely _after_ the disk failure.  I had assumed there would be
no reason such files would not be written successfully, but it seems not.
Uh oh.  Better stop writing new data to the filesystem, then.

I added 'convert=3Draid1' to the 'btrfs balance' command to try to stem
the flow of corrupted data.  It seems to help, but hasn't completely
stopped new files from getting corrupted.  The new disks are large enough
to hold all the data in raid1, so maybe if I manage to delete the missing
disk I'll convert the whole filesystem to raid1 and pretend the raid5
feature doesn't exist any more.

I've already "voided the warranty" as it were, so I'm not surprised
about seeing a bunch of unexpected corruption.  The kernel already
tried twice to kill itself before it gets as far as I am now, so there
was probably a good reason for that.  At this point it's still less
disruptive to just fix the corruption one file at a time from backups,
and without the patches the only other option is to mkfs+restore the
filesystem, so I'm pressing on... :-/

The code I'm changing above hasn't changed since 2011, which is well
before there was raid5.  Clearly it's not handling the cases that raid5
brings up very well.  Is recovery a lost cause?  Do I just give up now
and mkfs+restore the filesystem?

Compounding the difficulty is the fact that the balance operation
keeps getting stuck every few hours with this backtrace:

[18365.506156] Call Trace:
[18365.506164]  [<ffffffff81b17b1f>] schedule+0x3f/0xa0
[18365.506167]  [<ffffffff81407ebd>] lock_extent_bits+0x18d/0x1e0
[18365.506171]  [<ffffffff810ddc30>] ? wait_woken+0xb0/0xb0
[18365.506174]  [<ffffffff8143ea70>] invalidate_extent_cache+0xe0/0x200
[18365.506177]  [<ffffffff814430ed>] merge_reloc_root+0x33d/0x570
[18365.506179]  [<ffffffff81443463>] merge_reloc_roots+0x143/0x250
[18365.506181]  [<ffffffff814439e1>] relocate_block_group+0x471/0x6b0
[18365.506183]  [<ffffffff81443dcd>] ? btrfs_relocate_block_group+0x1ad/0x2=
a0
[18365.506185]  [<ffffffff81443dd5>] btrfs_relocate_block_group+0x1b5/0x2a0
[18365.506188]  [<ffffffff81413877>] btrfs_relocate_chunk.isra.37+0x47/0xd0
[18365.506190]  [<ffffffff814150f1>] btrfs_balance+0xa71/0x1200
[18365.506192]  [<ffffffff81420072>] ? btrfs_ioctl_balance+0x182/0x3b0
[18365.506195]  [<ffffffff81420072>] btrfs_ioctl_balance+0x182/0x3b0
[18365.506197]  [<ffffffff8142680d>] btrfs_ioctl+0x139d/0x2550
[18365.506201]  [<ffffffff81071f4a>] ? __do_page_fault+0x1da/0x570
[18365.506203]  [<ffffffff812823af>] do_vfs_ioctl+0x8f/0x680
[18365.506205]  [<ffffffff81071f4a>] ? __do_page_fault+0x1da/0x570
[18365.506207]  [<ffffffff8128e9ef>] ? __fget_light+0x6f/0x90
[18365.506209]  [<ffffffff81282a19>] SyS_ioctl+0x79/0x90
[18365.506212]  [<ffffffff81b1ddc0>] entry_SYSCALL_64_fastpath+0x23/0xc1

That's probably another bug, but I don't know if it's because of something
I've done, something weird in my filesystem's metadata, or a previously
unreported regression since kernel 4.4.  For now I just detect when it
happens inside the KVM and reboot it from outside.

I only have a few months left before the next disk in this array fails,
and I'd like to be out of degraded mode by then.  ;)


--RwxaKO075aXzzOz0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldnZpsACgkQgfmLGlazG5xUJQCfU6c7LrXFJNk072db2qJjnYwK
yZ4AmQHyWjIcTjUohBu4CFdTvQTXXwI7
=TUuk
-----END PGP SIGNATURE-----

--RwxaKO075aXzzOz0--
