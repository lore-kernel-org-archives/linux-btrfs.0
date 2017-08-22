Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:31697 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932305AbdHVJpR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 05:45:17 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: "quwenruo.btrfs@gmx.com" <quwenruo.btrfs@gmx.com>
Subject: RE: [PATCH 00/15] Btrfs-progs offline scrub
Date: Tue, 22 Aug 2017 09:45:13 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D0141283AEA@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20170715091053.19725-1-gujx@cn.fujitsu.com>
 <20170718063357.12450-1-gujx@cn.fujitsu.com>
In-Reply-To: <20170718063357.12450-1-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ping

-----Original Message-----
From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Gu Jinxiang
Sent: Tuesday, July 18, 2017 2:34 PM
To: linux-btrfs@vger.kernel.org
Cc: quwenruo.btrfs@gmx.com
Subject: [PATCH 00/15] Btrfs-progs offline scrub

For any one who wants to try it, it can be get from my repo:
https://github.com/gujx2017/btrfs-progs/tree/offline_scrub

In this v5, just make some small fixups of comments on the left 15 patches, according to problems pointed out by David when mergering the first 5 patches of this patchset.
And rebase it to 93a9004dde410d920f08f85c6365e138713992d8.

Several reports on kernel scrub screwing up good data stripes are in ML for sometime.

And since kernel scrub won't account P/Q corruption, it makes us quite hard to detect error like kernel screwing up P/Q when scrubbing.

To get a comparable tool for kernel scrub, we need a user-space tool to act as benchmark to compare their different behaviors.

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
   In v4 update, repair is finally added.

And this patchset also introduces new btrfs_map_block() function, which is more flex than current btrfs_map_block(), and has a unified interface for all profiles, not just an extra array for RAID56.

Check the 6th and 7th patch for details.

They are already used in RAID5/6 scrub, but can also be used for other profiles too.

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

For guys who want to review the patchset, there is a basic function relationships slide.
I hope this will reduce the time needed to get what the patchset is doing.
https://docs.google.com/presentation/d/1tAU3lUVaRUXooSjhFaDUeyW3wauHDSg9H-AiLBOSuIM/edit?usp=sharing

Changelog:
V0.8 RFC:
   Initial RFC patchset

v1:
   First formal patchset.
   RAID6 recovery support added, mainly copied from kernel radi6 lib.
   Cleaner recovery logical.

v2:
   More comments in both code and commit message, suggested by David.
   File re-arrangement, no check/ dir, raid56.ch moved to kernel-lib,
   Suggested by David

v3:
  Put "--offline" option to scrub, other than put it in fsck.
  Use bitmap to read multiple csums in one run, to improve performance.
  Add --progress/--no-progress option, to tell user we're not just
  wasting CPU and IO.

v4:
  Improve data check. Make data extent to be checked sector by sector.
  And make repair to be supported.

Gu Jinxiang (1):
  btrfs-progs: Introduce new btrfs_map_block function which returns more
    unified result.

Qu Wenruo (14):
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

 Documentation/btrfs-scrub.asciidoc |    9 +
 Makefile                           |    2 +-
 cmds-scrub.c                       |  116 ++-
 csum.c                             |  134 ++++
 ctree.h                            |   12 +
 disk-io.c                          |    4 +-
 disk-io.h                          |    2 +
 extent-tree.c                      |   60 ++
 kerncompat.h                       |    3 +
 scrub.c                            | 1368 ++++++++++++++++++++++++++++++++++++
 utils.h                            |   12 +
 volumes.c                          |  282 ++++++++
 volumes.h                          |   78 ++
 13 files changed, 2075 insertions(+), 7 deletions(-)  create mode 100644 csum.c  create mode 100644 scrub.c

--
2.9.4



--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
