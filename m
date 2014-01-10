Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:38871 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaAJKjI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jan 2014 05:39:08 -0500
From: Andrea Mazzoleni <amadvance@gmail.com>
To: neilb@suse.de
Cc: clm@fb.com, jbacik@fb.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        amadvance@gmail.com
Subject: [RFC v3 0/3] New RAID library supporting up to six parities
Date: Fri, 10 Jan 2014 11:38:40 +0100
Message-Id: <1389350323-19021-1-git-send-email-amadvance@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Here another version of the new RAID library that addresses the Neil's comments.
The new thing is an example patch to async_tx to support more parities and to
use the new lib.

The RAID library itself is mostly unchanged besides some renaming, removing
the controversial raid_sort() function, and more documentation.
I don't have plan for further changes, and I think that it's now a good
candidate for review and possible inclusion.

If some patch is missing due mailinglist size limit, you can download them at:

http://snapraid.sourceforge.net/linux/v3/

Changes from v2 to v3:
 - Adds a new patch to change async_tx to use the new raid library
   for syncronous cases and to export a similar interface.
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

---

This is a port to the Linux kernel of a RAID engine that I'm currently using
in a hobby project called SnapRAID. This engine supports up to six parities
levels and at the same time maintains compatibility with the existing Linux
RAID6 one.

The mathematical method used was already discussed in the linux-raid/linux-btrfs
mailing list in November in the thread "Triple parity and beyond":

http://thread.gmane.org/gmane.comp.file-systems.btrfs/30159

The first patch of the serie is the implementation of such discussion, done
porting my existing code to the kernel environment.

The code compiles without warnings with gcc -Wall -Wextra, with the clang
analyzer, and test programs run cleany with valgrind.
I verified that the module builds, loads and passes the self test in the x86,
and x64 architectures. I expect no problems in other platforms, but they are
not really tested.

The other two patches are a preliminary change in btrfs and async_tx to use
the new interface and to extend the internal support to up to six parities.
These are mainly provided to show how to use the new raid interface, and are
not meant for inclusion at this stage as they are not tested at all.

A good entry point to understand the code is to start from the
include/linux/raid/raid.h file. It contains the functions that external
modules should call with a complete description of them.
Then follow with lib/raid/raid.c that contains an introductory description
of the mathematical method used, and more details of the implementation
of the new RAID interface.

Something that you can try is to build the new RAID Cauchy library as a module
(it's in the configuration Library section), and load it with "speedtest=1"
argument and see if it pass the selftest and the reported speed measurements.

WARNING! The btrfs/async_tx/md patches are not SAFE to try as they are not
tested. They are only example code to show how the new raid library could
be integrated in existing code.

Please let me know what do you think. Any kind of feedback is welcome.

Thanks,
Andrea

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
 lib/raid/module.c                   |  454 ++++++++++
 lib/raid/raid.c                     |  492 +++++++++++
 lib/raid/test/Makefile              |   33 +
 lib/raid/test/combo.h               |  155 ++++
 lib/raid/test/fulltest.c            |   74 ++
 lib/raid/test/memory.c              |   79 ++
 lib/raid/test/memory.h              |   78 ++
 lib/raid/test/selftest.c            |   42 +
 lib/raid/test/speedtest.c           |  565 +++++++++++++
 lib/raid/test/test.c                |  314 +++++++
 lib/raid/test/test.h                |   59 ++
 lib/raid/test/usermode.h            |   91 ++
 lib/raid/test/xor.c                 |   41 +
 lib/raid/x86.c                      | 1565 +++++++++++++++++++++++++++++++++++
 36 files changed, 5985 insertions(+), 512 deletions(-)
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

