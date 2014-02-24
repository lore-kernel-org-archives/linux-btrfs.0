Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41930 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaBXVPt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 16:15:49 -0500
From: Andrea Mazzoleni <amadvance@gmail.com>
To: clm@fb.com, jbacik@fb.com, neilb@suse.de
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, amadvance@gmail.com
Subject: [PATCH v5 0/3] New RAID library supporting up to six parities
Date: Mon, 24 Feb 2014 22:15:27 +0100
Message-Id: <1393276530-26423-1-git-send-email-amadvance@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

A new version of the new RAID library. Finally with *working* btrfs support!

It includes patches for both the kernel and btrfs-progs to add new parity
modes "par3", "par4", "par5" and "par6" working similarly at the existing
"raid5" and "raid6" ones.

The patches apply cleanly to kernel v3.14-rc3 and btrfs-progs v3.12.

If you are willing to test it, you can do something like that:

mkfs.btrfs -d par3 -m par3 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
mount /dev/sdb1 /mnt/tmp
...copy something to /mnt/tmp...
md5deep -r /mnt/tmp > test_before.hash
umount /mnt/tmp
dd if=/dev/urandom of=/dev/sdc1 count=...
dd if=/dev/urandom of=/dev/sdd1 count=...
dd if=/dev/urandom of=/dev/sde1 count=...
mount -o degraded /dev/sdb1 /mnt/tmp
md5deep -r /mnt/tmp > test_after.hash
umount /mnt/tmp
diff -u test_before.hash test_after.hash && echo OK

I run various test like that, and everything seems to work.

The first patch is the new RAID library for the kernel, supporting up to six
parities. It's verified with automated test that reach 99.3% code coverage.
It also passes clang and valgrind tests with no error.

It applies cleanly to kernel v3.14-rc3, but it should work with any other
version because it's formed only of new files. The only kernel change
is the new CONFIG_RAID_CAUCHY option in the "lib" configuration section.

For reviewing I recommend to start from the include/raid/raid.h that describes
the new generic raid interface. Then continue in lib/raid/raid.c where the interface
is implement. You can start reading the documentation about the RAID
mathematics used, taking care that its correctness is proven both
mathematically and by brute-force by the test programs.
You can then review raid_gen() and raid_rec(), that are high level forwarders
to generic and optimized asm functions that generate parity
and recover data. Their internal structure is very similar at the functions
in RAID6. The main difference is to have a generic matrix of parity coefficients.
All these functions are verified by the test programs, with full lines and
branches coverage, meaning that you can concentrate the review on their
structure, than in the computation and asm details.
Finally, you can review the test programs in lib/raid/test, to ensure that
everything is really tested, and the coverage test can help you on that.

The second patch contains the kernel btrfs modifications. Besides adding the
new parity modes it also removes a lot of code about raid details that are
now handled by the new raid library.

It applies cleanly to kernel v3.14-rc3. You can use it also for previous kernels,
with an obvious adjustment in fs/btrfs/ctree.h.

For reviewing you can start from the diff, and check chunk after chunk.
Likely the two most complex changes are where the new raid_gen() and raid_rec()
are called replacing big chunks of code. But the rest is mostly straightforward
as I just extended all the checks about RAID5 and RAID6 to six parities.
But for sure it needs a more careful review as my knowledge of btrfs internals is
very limited.

The third patch contains the btrfs-progs modification. They are just matching
the kernel changes, and the same considerations apply.

It applies cleanly to btrfs-progs v3.12.

Please let me know what you think, and if it can be considered for inclusion or
something more is required.

If some patch is missing due mailinglist size limit, you can download them at:

  http://snapraid.sourceforge.net/linux/v5/

You can see the code coverage analysis made by lcov at:

  http://snapraid.sourceforge.net/linux/v5/coverage/

Changes from v4 to v5:
 - Adds more comments in the libraid patch.
 - Reviews and completes the btrfs patch. The previous patch was not
   really working due some missing pieces.
 - Adds a new patch for btrfs-progs to extend the mkfs.btrfs
   functionality to create filesystem with up to six parity levels.
 - Removes the async_tx patch as not yet ready for inclusion.

Changes from v3 to v4:
 - Adds a code coverage test
 - Adds a matrix inversion test.
 - Everything updated to kernel 3.13.

Changes from v2 to v3:
 - Adds a new patch to change async_tx to use the new raid library
   for synchronous cases and to export a similar interface.
   Also modified md/raid5.c to use the new interface of async_tx.
   This is just example code not meant for inclusion!
 - Renamed raid_par() to raid_gen() to match better existing naming.
 - Removed raid_sort() and replaced with raid_insert() that allows
   to build a vector already in order instead of sorting it later.
   This function is declared in the new raid/helper.h.
 - Better documentation in the raid.h/c files. Start from raid.h
   to see the documentation of the new interface.

Changes from v1 to v2:
 - Adds a patch to btrfs to extend its support to more than double parity.
   This is just example code not meant for inclusion!
 - Changes the main raid_rec() interface to merge the failed data
   and parity index vectors. This matches better the kernel usage.
 - Uses alloc_pages_exact() instead of __get_free_pages().
 - Removes unnecessary register loads from par1_sse().
 - Converts the asm_begin/end() macros to inlined functions.
 - Fixes some more checkpatch.pl warnings.
 - Other minor style/comment changes.

Andrea Mazzoleni (2):
  lib: raid: New RAID library supporting up to six parities
  fs: btrfs: Adds new par3456 modes to support up to six parities

 fs/btrfs/Kconfig             |    1 +
 fs/btrfs/ctree.h             |   50 +-
 fs/btrfs/disk-io.c           |    7 +-
 fs/btrfs/extent-tree.c       |   67 +-
 fs/btrfs/inode.c             |    3 +-
 fs/btrfs/raid56.c            |  273 +++-----
 fs/btrfs/raid56.h            |   19 +-
 fs/btrfs/scrub.c             |    3 +-
 fs/btrfs/volumes.c           |  144 ++--
 include/linux/raid/helper.h  |   32 +
 include/linux/raid/raid.h    |   87 +++
 include/trace/events/btrfs.h |   16 +-
 include/uapi/linux/btrfs.h   |   19 +-
 lib/Kconfig                  |   17 +
 lib/Makefile                 |    1 +
 lib/raid/.gitignore          |    3 +
 lib/raid/Makefile            |   14 +
 lib/raid/cpu.h               |   44 ++
 lib/raid/gf.h                |  109 +++
 lib/raid/helper.c            |   38 +
 lib/raid/int.c               |  567 +++++++++++++++
 lib/raid/internal.h          |  148 ++++
 lib/raid/mktables.c          |  383 +++++++++++
 lib/raid/module.c            |  458 ++++++++++++
 lib/raid/raid.c              |  492 +++++++++++++
 lib/raid/test/Makefile       |   72 ++
 lib/raid/test/combo.h        |  155 +++++
 lib/raid/test/fulltest.c     |   79 +++
 lib/raid/test/invtest.c      |  172 +++++
 lib/raid/test/memory.c       |   79 +++
 lib/raid/test/memory.h       |   78 +++
 lib/raid/test/selftest.c     |   44 ++
 lib/raid/test/speedtest.c    |  578 ++++++++++++++++
 lib/raid/test/test.c         |  314 +++++++++
 lib/raid/test/test.h         |   59 ++
 lib/raid/test/usermode.h     |   95 +++
 lib/raid/test/xor.c          |   41 ++
 lib/raid/x86.c               | 1565 ++++++++++++++++++++++++++++++++++++++++++
 38 files changed, 6037 insertions(+), 289 deletions(-)
 create mode 100644 include/linux/raid/helper.h
 create mode 100644 include/linux/raid/raid.h
 create mode 100644 lib/raid/.gitignore
 create mode 100644 lib/raid/Makefile
 create mode 100644 lib/raid/cpu.h
 create mode 100644 lib/raid/gf.h
 create mode 100644 lib/raid/helper.c
 create mode 100644 lib/raid/int.c
 create mode 100644 lib/raid/internal.h
 create mode 100644 lib/raid/mktables.c
 create mode 100644 lib/raid/module.c
 create mode 100644 lib/raid/raid.c
 create mode 100644 lib/raid/test/Makefile
 create mode 100644 lib/raid/test/combo.h
 create mode 100644 lib/raid/test/fulltest.c
 create mode 100644 lib/raid/test/invtest.c
 create mode 100644 lib/raid/test/memory.c
 create mode 100644 lib/raid/test/memory.h
 create mode 100644 lib/raid/test/selftest.c
 create mode 100644 lib/raid/test/speedtest.c
 create mode 100644 lib/raid/test/test.c
 create mode 100644 lib/raid/test/test.h
 create mode 100644 lib/raid/test/usermode.h
 create mode 100644 lib/raid/test/xor.c
 create mode 100644 lib/raid/x86.c

-- 
1.7.12.1

