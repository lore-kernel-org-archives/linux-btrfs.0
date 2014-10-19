Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41136 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751582AbaJSTcy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Oct 2014 15:32:54 -0400
Date: Sun, 19 Oct 2014 15:25:26 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: 3.16.3..3.17.1 hang in renameat2()
Message-ID: <20141019192525.GA29401@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I've seen a hang in renameat2() from time to time on the last few
stable kernels.  I can reproduce it easily but only on one specific
multi-terabyte filesystem with millions of files.  I've tried to make
a simpler repro setup but so far without success.

Here is what I know so far.  First, the stack trace:

Oct 19 13:59:44 tester7 kernel: [ 4411.832218] INFO: task faster-dupemerg:22368 blocked for more than 240 seconds.
Oct 19 13:59:44 tester7 kernel: [ 4411.832227]       Not tainted 3.17.1-zb64+ #1
Oct 19 13:59:44 tester7 kernel: [ 4411.832229] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 19 13:59:44 tester7 kernel: [ 4411.832231] faster-dupemerg D ffff8803fcc5db20     0 22368  22367 0x00000000
Oct 19 13:59:44 tester7 kernel: [ 4411.832235]  ffff8802570cbb68 0000000000000086 ffff8802fb08e000 0000000000020cc0
Oct 19 13:59:44 tester7 kernel: [ 4411.832238]  ffff8802570cbfd8 0000000000020cc0 ffff8802ff328000 ffff8802fb08e000
Oct 19 13:59:44 tester7 kernel: [ 4411.832242]  ffff8802570cbab8 ffffffffc0343844 ffff8802570cbab8 00000000ffffffef
Oct 19 13:59:44 tester7 kernel: [ 4411.832245] Call Trace:
Oct 19 13:59:44 tester7 kernel: [ 4411.832283]  [<ffffffffc0343844>] ? free_extent_state.part.29+0x34/0xb0 [btrfs]
Oct 19 13:59:44 tester7 kernel: [ 4411.832299]  [<ffffffffc0343d45>] ? free_extent_state+0x25/0x30 [btrfs]
Oct 19 13:59:44 tester7 kernel: [ 4411.832314]  [<ffffffffc034449a>] ? __set_extent_bit+0x3aa/0x4f0 [btrfs]
Oct 19 13:59:44 tester7 kernel: [ 4411.832319]  [<ffffffff817a78d2>] ? _raw_spin_unlock_irqrestore+0x32/0x70
Oct 19 13:59:44 tester7 kernel: [ 4411.832323]  [<ffffffff8109ead1>] ? get_parent_ip+0x11/0x50
Oct 19 13:59:44 tester7 kernel: [ 4411.832326]  [<ffffffff817a3da9>] schedule+0x29/0x70
Oct 19 13:59:44 tester7 kernel: [ 4411.832343]  [<ffffffffc03453f0>] lock_extent_bits+0x1b0/0x200 [btrfs]
Oct 19 13:59:44 tester7 kernel: [ 4411.832346]  [<ffffffff810b4c50>] ? add_wait_queue+0x60/0x60
Oct 19 13:59:44 tester7 kernel: [ 4411.832361]  [<ffffffffc03334b9>] btrfs_evict_inode+0x139/0x550 [btrfs]
Oct 19 13:59:44 tester7 kernel: [ 4411.832368]  [<ffffffff8120d9a8>] evict+0xb8/0x190
Oct 19 13:59:44 tester7 kernel: [ 4411.832370]  [<ffffffff8120e165>] iput+0x105/0x1a0
Oct 19 13:59:44 tester7 kernel: [ 4411.832373]  [<ffffffff81209d48>] __dentry_kill+0x1b8/0x210
Oct 19 13:59:44 tester7 kernel: [ 4411.832375]  [<ffffffff8120a48a>] dput+0xba/0x190
Oct 19 13:59:44 tester7 kernel: [ 4411.832378]  [<ffffffff81203940>] SyS_renameat2+0x440/0x530
Oct 19 13:59:44 tester7 kernel: [ 4411.832384]  [<ffffffff811f2b2c>] ? vfs_write+0x19c/0x1f0
Oct 19 13:59:44 tester7 kernel: [ 4411.832387]  [<ffffffff813f29ce>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Oct 19 13:59:44 tester7 kernel: [ 4411.832390]  [<ffffffff81203a6e>] SyS_rename+0x1e/0x20
Oct 19 13:59:44 tester7 kernel: [ 4411.832393]  [<ffffffff817a842d>] system_call_fastpath+0x1a/0x1f

This rename system call doesn't return (I've let it try for almost
a week with 3.16.x kernels, and 2+ days on 3.17.1).  When I watch
/proc/22368/stack there doesn't seem to be any change in state which
would indicate forward progress.  iotop reports no apparent I/O in
progress in btrfs kernel threads or the kworkers.

faster-dupemerge is a simple hard-linking deduplicator.  It finds
identical files and replaces them with hardlinks to a common file.
It sorts files by size, compares them, then does a link and rename
equivalent to:

	# (a/b/c is identical to d/e/f but a different inode)
	ln -f a/b/c d/e/.f.XXXXXX
	mv -f d/e/.f.XXXXXX d/e/f
	# (now a/b/c and d/e/f should be the same inode)

It is the rename (mv) that is getting stuck.  It seems to hold a lock that
prevents any process from later traversing d/e with find or ls, but does
not prevent a stat on the path 'd/e/f' (which reports that d/e/f is now
a hard link to a/b/c).

btrfs check and scrub find no errors before or after the problem occurs.
After a reboot the filesystem seems to be fine.  No files are missing,
all the data seems to be there, still no btrfs scrub or check errors,
and the temporary file d/e/.f.XXXXXX has gone away.  d/e/f is still a
hardlink to a/b/c.

Although the filesystem is large, only a few thousand files are
involved in faster-dupemerge.  I've tried to reproduce this in a smaller
filesystem but so far without success.  The file it gets stuck on is
different on each run, and it doesn't stop on the first rename either.
It will usually get through a few dozen renames before getting stuck.

I have not been able to construct a simpler repro case so far
(e.g. by making thousands of clones and hardlinking them without using
faster-dupemerge).  Along the way I have found some other variables that
may be significant:

- this filesystem has skinny_metadata and no_holes flags (in addition
to mkfs defaults like big_metadata).  I have no other filesystems with
these options, and I also have not observed this problem on any of the
other filesystems.

- I am using zlib compression on all btrfs filesystems, with or without
this issue.  The files involved in the rename hangs have included both
compressed and uncompressed files (e.g. vmlinuz and C source files).

- the specific files that are involved in this issue were btrfs clones
(made by cp --reflink=always) to start with, so the rename is replacing
one inode's shared file extents with another inode's references to the
same extents.  I have not been able to reproduce this particular bug
with ordinary copies of files.

- the NFS server may be involved somehow?  I attempted to reproduce
this on the same filesystem but in a directory that was not exported
via NFS, and could not after several dozen attempts.  When I moved
the test file tree under a directory that is NFS exported, the problem
occurs so often that I can't finish processing the tree a single time
with faster-dupemerge.  On the other hand, if I stop the NFS server the
problem does not seem to go away, so the problem may be related to some
feature hiding in the directory metadata on my filesystem and not to
the NFS server at all.

That's all I've got so far.  Any ideas?

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlREECAACgkQgfmLGlazG5ynJwCfbv/VQrErZu4TQjhF9GoW7TCz
RwgAoM8qP+GENbKmUN8XrU0TRiGtcYfq
=ZT44
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
