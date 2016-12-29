Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34.italiaonline.it ([212.48.25.162]:40014 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752888AbcL2SPh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 13:15:37 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH v2 00/19]
References: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <018da5f8-a4e7-f35e-6eac-e01f6936a3e1@inwind.it>
Date: Thu, 29 Dec 2016 19:15:32 +0100
MIME-Version: 1.0
In-Reply-To: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

I tried your patch, because I had an hardware failure and I needed to check the data integrity. I didn't find any problem however I was not able to understand what "btrfs check --scrub" was doing because the program didn't give any output (there is no progress bar). So I tried to strace it to check if the program was working properly. The strace output showed me that the program ran correctly.
However form the strace I noticed that the program read several time the same page (size 16k). I think that this is due to the  walking of the btree. However this could be a possible optimization: cache the last read(s).

Only my 2¢

BR
G.Baroncelli



On 2016-12-26 07:29, Qu Wenruo wrote:
> For any one who wants to try it, it can be get from my repo:
> https://github.com/adam900710/btrfs-progs/tree/offline_scrub
> 
> Currently, I only tested it on SINGLE/DUP/RAID1/RAID5 filesystems, with
> mirror or parity or data corrupted.
> The tool are all able to detect them and give recoverbility report.
> 
> Several reports on kernel scrub screwing up good data stripes are in ML
> for sometime.
> 
> And since kernel scrub won't account P/Q corruption, it makes us quite
> to detect error like kernel screwing up P/Q when scrubbing.
> 
> To get a comparable tool for kernel scrub, we need a user-space tool to
> act as benchmark to compare their different behaviors.
> 
> So here is the patchset for user-space scrub.
> 
> Which can do:
> 
> 1) All mirror/backup check for non-parity based stripe
>    Which means for RAID1/DUP/RAID10, we can really check all mirrors
>    other than the 1st good mirror.
> 
>    Current "--check-data-csum" option will be finally replace by scrub.
>    As it doesn't really check all mirrors, if it hits a good copy, then
>    resting copies will just be ignored.
> 
> 2) Comprehensive RAID5/6 full stripe check
>    It will take full use of btrfs csum(both tree and data).
>    It will only recover the full stripe if all recovered data matches
>    with its csum.
> 
> In fact, it can already expose several new btrfs kernel bug.
> As it's the main tool I'm using when developing the kernel fixes.
> 
> For example, after screwing up a data stripe, kernel did repairs using
> parity, but recovered full stripe has wrong parity.
> Need to scrub again to fix it.
> 
> And this patchset also introduced new map_block() function, which is
> more flex than current btrfs_map_block(), and has a unified interface
> for all profiles, not just an array of physical addresses.
> 
> Check the 6th and 7th patch for details.
> 
> They are already used in RAID5/6 scrub, but can also be used for other
> profiles too.
> 
> The to-do list has been shortened, since RAID6 and new check logical is
> introduced.
> 1) Repair support
>    In fact, current tool can already report recoverability, repair is
>    not hard to implement.
> 
> 2) Test cases
>    Need to make the infrastructure able to handle multi-device first.
> 
> 3) Make btrfsck able to handle RAID5 with missing device
>    Now it doesn't even open RAID5 btrfs with missing device, even though
>    scrub should be able to handle it.
> 
> Changelog:
> V0.8 RFC:
>    Initial RFC patchset
> 
> v1:
>    First formal patchset.
>    RAID6 recovery support added, mainly copied from kernel radi6 lib.
>    Cleaner recovery logical.
> 
> v2:
>    More comments in both code and commit message, suggested by David.
>    File re-arrangement, no check/ dir, raid56.ch moved to kernel-lib,
>    Suggested by David
> 
> Qu Wenruo (19):
>   btrfs-progs: raid56: Introduce raid56 header for later recovery usage
>   btrfs-progs: raid56: Introduce tables for RAID6 recovery
>   btrfs-progs: raid56: Allow raid6 to recover 2 data stripes
>   btrfs-progs: raid56: Allow raid6 to recover data and p
>   btrfs-progs: Introduce wrapper to recover raid56 data
>   btrfs-progs: Introduce new btrfs_map_block function which returns more
>     unified result.
>   btrfs-progs: Allow __btrfs_map_block_v2 to remove unrelated stripes
>   btrfs-progs: csum: Introduce function to read out one data csum
>   btrfs-progs: scrub: Introduce structures to support fsck scrub for
>     RAID56
>   btrfs-progs: scrub: Introduce function to scrub mirror based tree
>     block
>   btrfs-progs: scrub: Introduce function to scrub mirror based data
>     blocks
>   btrfs-progs: scrub: Introduce function to scrub one extent
>   btrfs-progs: scrub: Introduce function to scrub one data stripe
>   btrfs-progs: scrub: Introduce function to verify parities
>   btrfs-progs: extent-tree: Introduce function to check if there is any
>     extent in given range.
>   btrfs-progs: scrub: Introduce function to recover data parity
>   btrfs-progs: scrub: Introduce a function to scrub one full stripe
>   btrfs-progs: scrub: Introduce function to check a whole block group
>   btrfs-progs: fsck: Introduce offline scrub function
> 
>  .gitignore                         |    2 +
>  Documentation/btrfs-check.asciidoc |    7 +
>  Makefile.in                        |   19 +-
>  cmds-check.c                       |   12 +-
>  csum.c                             |   96 ++++
>  ctree.h                            |    8 +
>  disk-io.c                          |    4 +-
>  disk-io.h                          |    7 +-
>  extent-tree.c                      |   60 +++
>  kernel-lib/mktables.c              |  148 ++++++
>  kernel-lib/raid56.c                |  359 +++++++++++++
>  kernel-lib/raid56.h                |   58 +++
>  raid56.c                           |  172 ------
>  scrub.c                            | 1004 ++++++++++++++++++++++++++++++++++++
>  volumes.c                          |  283 ++++++++++
>  volumes.h                          |   49 ++
>  16 files changed, 2103 insertions(+), 185 deletions(-)
>  create mode 100644 csum.c
>  create mode 100644 kernel-lib/mktables.c
>  create mode 100644 kernel-lib/raid56.c
>  create mode 100644 kernel-lib/raid56.h
>  delete mode 100644 raid56.c
>  create mode 100644 scrub.c
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
