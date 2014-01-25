Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:56147 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaAYINB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 03:13:01 -0500
From: Andrea Mazzoleni <amadvance@gmail.com>
To: neilb@suse.de
Cc: clm@fb.com, jbacik@fb.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        amadvance@gmail.com
Subject: [RFC v4 0/3] lib: raid: New RAID library supporting up to six parities
Date: Sat, 25 Jan 2014 09:12:46 +0100
Message-Id: <1390637569-22551-1-git-send-email-amadvance@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Again another version of the new RAID library. This time to add new tests.

There is now a matrix inversion test that inverts all the possible
377.342.351.231 square submatrices of the Cauchy matrix used to compute
the parity. This ensures that recovering is always possible.

There is also a new code coverage test. It shows that the raid library has
a 99.2% line coverage. You can see the lcov report online at:

  http://snapraid.sourceforge.net/linux/v4/coverage/

I now rate the first patch ready for inclusion. Please anyone review it
if possible.

I recommend to start from the include/raid/raid.h that describes the new
generic raid interface. Then move to lib/raid/raid.c where the interface
is implement. You can start reading the documentation about the RAID
mathematics used, taking care that its correctness is proven both
mathematically and by brute-force by the test programs.
You can then review raid_gen() and raid_rec(), that are essentially high
level forwarders to generic and optimized asm functions that generate parity
and recover data. Their internal structure is very similar at the functions
in RAID6. The main difference is to have a generic matrix of parity coefficients.
All the these functions are verified by the test program, with full lines and
branches coverage, meaning that you can concentrate the review on their
structure, than in the computation and asm details.
Finally, you can review the test programs in lib/raid/test, to ensure that
everything is really tested, and the coverage test will help you on that.

In the mean time I'll continue developing the other btrfs and async_tx/md patches,
but my time is now limited, it's a hobby :), and progress will happen a slower rate.
I'm going to start from the btrfs side, because it's the one I'm more
interested on.

But if the first patch get included, I suppose it will raise enough attention
to have also others working on that.

If some patch is missing due mailinglist size limit, you can download them at:

  http://snapraid.sourceforge.net/linux/v4/

Changes from v3 to v4:
 - Adds a code coverage test using lcov.
 - Adds a matrix inversion test.
 - Updated for kernel 3.13.

Changes from v2 to v3:
 - Adds a new patch to change async_tx to use the new raid library
   for synchronous cases and to export a similar interface.
   Also modified md/raid5.c to use the new interface of async_tx.
   This is just example code not meant for inclusion!
 - Renamed raid_par() to raid_gen() to match existing naming.
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

Andrea Mazzoleni (3):
  lib: raid: New RAID library supporting up to six parities
  fs: btrfs: Extends btrfs/raid56 to support up to six parities
  crypto: async_tx: Extends crypto/async_tx to support up to six
    parities

 crypto/async_tx/async_pq.c          |  257 +++---
 crypto/async_tx/async_raid6_recov.c |  286 +++++--
 drivers/md/Kconfig                  |    1 +
 drivers/md/raid5.c                  |  206 ++---
 drivers/md/raid5.h                  |    2 +-
 fs/btrfs/Kconfig                    |    1 +
 fs/btrfs/raid56.c                   |  273 ++----
 fs/btrfs/raid56.h                   |   12 +-
 fs/btrfs/volumes.c                  |    4 +-
 include/linux/async_tx.h            |   15 +-
 include/linux/raid/helper.h         |   32 +
 include/linux/raid/raid.h           |   87 ++
 lib/Kconfig                         |   17 +
 lib/Makefile                        |    1 +
 lib/raid/.gitignore                 |    3 +
 lib/raid/Makefile                   |   14 +
 lib/raid/cpu.h                      |   44 +
 lib/raid/gf.h                       |  109 +++
 lib/raid/helper.c                   |   38 +
 lib/raid/int.c                      |  567 +++++++++++++
 lib/raid/internal.h                 |  148 ++++
 lib/raid/mktables.c                 |  338 ++++++++
 lib/raid/module.c                   |  458 ++++++++++
 lib/raid/raid.c                     |  492 +++++++++++
 lib/raid/test/Makefile              |   72 ++
 lib/raid/test/combo.h               |  155 ++++
 lib/raid/test/fulltest.c            |   79 ++
 lib/raid/test/invtest.c             |  172 ++++
 lib/raid/test/memory.c              |   79 ++
 lib/raid/test/memory.h              |   78 ++
 lib/raid/test/selftest.c            |   44 +
 lib/raid/test/speedtest.c           |  578 +++++++++++++
 lib/raid/test/test.c                |  314 +++++++
 lib/raid/test/test.h                |   59 ++
 lib/raid/test/usermode.h            |   95 +++
 lib/raid/test/xor.c                 |   41 +
 lib/raid/x86.c                      | 1565 +++++++++++++++++++++++++++++++++++
 37 files changed, 6224 insertions(+), 512 deletions(-)
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

