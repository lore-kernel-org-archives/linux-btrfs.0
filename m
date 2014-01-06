Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:41038 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaAFJcL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jan 2014 04:32:11 -0500
From: Andrea Mazzoleni <amadvance@gmail.com>
To: neilb@suse.de
Cc: clm@fb.com, jbacik@fb.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        amadvance@gmail.com
Subject: [RFC v2 0/2] New RAID library supporting up to six parities
Date: Mon,  6 Jan 2014 10:31:54 +0100
Message-Id: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

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

The second patch is a preliminary change in btrfs to use the new interface
and to extend its internal support to up to six parities.
This patch is mainly provided to show how to use the new interface, and not
meant for inclusion at this stage.

A good entry point to understand the code is to start from the
include/linux/raid/raid.h file. It contains the functions that external
modules should call with a complete description of them.

Please let me know what do you think. Any kind of feedback is welcome.

Thanks,
Andrea

Changes from v1 to v2:
 - Adds a patch to btrfs to extend its support to more than double parity.
 - Changes the main raid_rec() interface to merge the failed data
   and parity index vectors. This matches better the kernel usage.
 - Uses alloc_pages_exact() instead of __get_free_pages().
 - Removes unnecessary register loads from par1_sse().
 - Converts the asm_begin/end() macros to inlined functions.
 - Fixes some more checkpatch.pl warnings.
 - Other minor style/comment changes.

Andrea Mazzoleni (2):
  lib: raid: New RAID library supporting up to six parities
  fs: btrfs: Extends btrfs/raid56 to support up to six parities

 fs/btrfs/Kconfig          |    1 +
 fs/btrfs/raid56.c         |  278 +++-----
 fs/btrfs/raid56.h         |   12 +-
 fs/btrfs/volumes.c        |    4 +-
 include/linux/raid/raid.h |   81 +++
 lib/Kconfig               |   12 +
 lib/Makefile              |    1 +
 lib/raid/Makefile         |   14 +
 lib/raid/cpu.h            |   44 ++
 lib/raid/gf.h             |  109 ++++
 lib/raid/int.c            |  567 ++++++++++++++++
 lib/raid/internal.h       |  147 +++++
 lib/raid/mktables.c       |  338 ++++++++++
 lib/raid/module.c         |  460 +++++++++++++
 lib/raid/raid.c           |  435 +++++++++++++
 lib/raid/sort.c           |   72 +++
 lib/raid/test/Makefile    |   33 +
 lib/raid/test/combo.h     |  155 +++++
 lib/raid/test/fulltest.c  |   74 +++
 lib/raid/test/memory.c    |   79 +++
 lib/raid/test/memory.h    |   78 +++
 lib/raid/test/selftest.c  |   39 ++
 lib/raid/test/speedtest.c |  565 ++++++++++++++++
 lib/raid/test/test.c      |  316 +++++++++
 lib/raid/test/test.h      |   59 ++
 lib/raid/test/usermode.h  |   91 +++
 lib/raid/test/xor.c       |   41 ++
 lib/raid/x86.c            | 1565 +++++++++++++++++++++++++++++++++++++++++++++
 28 files changed, 5477 insertions(+), 193 deletions(-)
 create mode 100644 include/linux/raid/raid.h
 create mode 100644 lib/raid/Makefile
 create mode 100644 lib/raid/cpu.h
 create mode 100644 lib/raid/gf.h
 create mode 100644 lib/raid/int.c
 create mode 100644 lib/raid/internal.h
 create mode 100644 lib/raid/mktables.c
 create mode 100644 lib/raid/module.c
 create mode 100644 lib/raid/raid.c
 create mode 100644 lib/raid/sort.c
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

