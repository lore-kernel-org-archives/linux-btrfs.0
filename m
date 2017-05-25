Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45979 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1034479AbdEYGWf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 02:22:35 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <lakshmipathi.g@gmail.com>
Subject: [PATCH v4 00/20] Btrfs-progs offline scrub
Date: Thu, 25 May 2017 14:21:45 +0800
Message-ID: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For any one who wants to try it, it can be get from my repo:
https://github.com/adam900710/btrfs-progs/tree/offline_scrub

Several reports on kernel scrub screwing up good data stripes are in ML
for sometime.

And since kernel scrub won't account P/Q corruption, it makes us quite
hard to detect error like kernel screwing up P/Q when scrubbing.

To get a comparable tool for kernel scrub, we need a user-space tool to
act as benchmark to compare their different behaviors.

So here is the patchset for user-space scrub.

Which can do:
1) All mirror/backup check for non-parity based stripe
   Which means for RAID1/DUP/RAID10, we can really check all mirrors
   other than the 1st good mirror.

   Current "--check-data-csum" option should be finally replaced by
   offline scrub.
   As "--check-data-csum" doesn't really check all mirrors, if it hits
   a good copy, then resting copies will just be ignored.

   In v4 update, data check is further improved, inspired by kernel
   behavior, now data extent is checked sector by sector, so it can
   handle the following corruption case:

   Data extent A contains data from 0~28K.
   And |///| = corrupted  |   | = good
             0   4k  8k  12k 16k 20k 24k 28k
   Mirror 0  |///|   |///|   |///|   |   |
   Mirror 1  |   |///|   |///|   |///|   |

   Extent A should be RECOVERABLE, while in v3 we treat data extent A as
   a whole unit, above case is reported as CORRUPTED.

2) RAID5/6 full stripe check
   It will take full use of btrfs csum(both tree and data).
   It will only recover the full stripe if all recovered data matches
   with its csum.

   NOTE: Due to the lack of good bitmap facilities, RAID56 sector by
   sector repair will be quite complex, especially when NODATASUM is
   involved.

   So current RAID56 doesn't support vertical sector recovery yet.

   Data extent A contains data from 0~64K
   And |///| = corrupted while |   | = good
                  0   8K  16K 24K 32K 40K 48K 56K 64K
   Data stripe 0  |///|   |///|   |///|   |///|   |
   Data stripe 1  |   |///|   |///|   |///|   |///|
   Parity         |   |   |   |   |   |   |   |   |

   Kernel will recover it, while current scrub will report it as
   CORRUPTED.

3) Repair
   In this v4 update, repair is finally added.

And this patchset also introduces new btrfs_map_block() function, which is
more flex than current btrfs_map_block(), and has a unified interface
for all profiles, not just an extra array for RAID56.

Check the 6th and 7th patch for details.

They are already used in RAID5/6 scrub, but can also be used for other
profiles too.

The to-do list has been shortened, since repair is added in v4 update.
1) Test cases
   Need to make the infrastructure able to handle multi-device first.

2) Make btrfsck able to handle RAID5 with missing device
   Now it doesn't even open RAID5 btrfs with missing device, even though
   scrub should be able to handle it.

3) RAID56 vertical sector repair
   Although I consider such case is minor compared to RAID1 vertical
   sector repair.
   As for RAID1, an extent can be as large as 128M, while for RAID56 one
   stripe will always be 64K, much smaller than RAID1 case, making the
   possibility lower.

   I prefer to add this function after the patchset get merged, as no
   one really likes get 20 mails every time I update the patchset.

For guys who want to review the patchset, there is a basic function
relationships slide.
I hope this will reduce the time needed to get what the patchset is
doing.
https://docs.google.com/presentation/d/1tAU3lUVaRUXooSjhFaDUeyW3wauHDSg9H-AiLBOSuIM/edit?usp=sharing


Qu Wenruo (20):
  btrfs-progs: raid56: Introduce raid56 header for later recovery usage
  btrfs-progs: raid56: Introduce tables for RAID6 recovery
  btrfs-progs: raid56: Allow raid6 to recover 2 data stripes
  btrfs-progs: raid56: Allow raid6 to recover data and p
  btrfs-progs: Introduce wrapper to recover raid56 data
  btrfs-progs: Introduce new btrfs_map_block function which returns more
    unified result.
  btrfs-progs: Allow __btrfs_map_block_v2 to remove unrelated stripes
  btrfs-progs: csum: Introduce function to read out data csums
  btrfs-progs: scrub: Introduce structures to support offline scrub for
    RAID56
  btrfs-progs: scrub: Introduce functions to scrub mirror based tree
    block
  btrfs-progs: scrub: Introduce functions to scrub mirror based data
    blocks
  btrfs-progs: scrub: Introduce function to scrub one mirror-based
    extent
  btrfs-progs: scrub: Introduce function to scrub one data stripe
  btrfs-progs: scrub: Introduce function to verify parities
  btrfs-progs: extent-tree: Introduce function to check if there is any
    extent in given range.
  btrfs-progs: scrub: Introduce function to recover data parity
  btrfs-progs: scrub: Introduce helper to write a full stripe
  btrfs-progs: scrub: Introduce a function to scrub one full stripe
  btrfs-progs: scrub: Introduce function to check a whole block group
  btrfs-progs: scrub: Introduce offline scrub function

 .gitignore                         |    2 +
 Documentation/btrfs-scrub.asciidoc |    9 +
 Makefile                           |   19 +-
 cmds-scrub.c                       |  116 ++-
 csum.c                             |  136 ++++
 ctree.h                            |   12 +
 disk-io.c                          |    4 +-
 disk-io.h                          |    6 +-
 extent-tree.c                      |   60 ++
 kerncompat.h                       |    3 +
 kernel-lib/mktables.c              |  148 ++++
 kernel-lib/raid56.c                |  359 ++++++++++
 kernel-lib/raid56.h                |   58 ++
 raid56.c                           |  172 -----
 scrub.c                            | 1370 ++++++++++++++++++++++++++++++++++++
 utils.h                            |   12 +
 volumes.c                          |  283 ++++++++
 volumes.h                          |   78 ++
 18 files changed, 2660 insertions(+), 187 deletions(-)
 create mode 100644 csum.c
 create mode 100644 kernel-lib/mktables.c
 create mode 100644 kernel-lib/raid56.c
 create mode 100644 kernel-lib/raid56.h
 delete mode 100644 raid56.c
 create mode 100644 scrub.c

-- 
2.13.0



