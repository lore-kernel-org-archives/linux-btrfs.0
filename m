Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56408 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753995AbcKVBMf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Nov 2016 20:12:35 -0500
Subject: Re: [PATCH 00/19] Offline scrub support
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <b396cf56-bcaa-52f6-34a6-fd2e204b76c2@cn.fujitsu.com>
Date: Tue, 22 Nov 2016 09:09:18 +0800
MIME-Version: 1.0
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Any comment on this patchset?

This offline scrub is quite useful and will be core of the incoming 
xfstests test cases for RAID56 scrub.

Thanks,
Qu

At 10/28/2016 10:31 AM, Qu Wenruo wrote:
> For any one who wants to try it, it can be get from my repo:
> https://github.com/adam900710/btrfs-progs/tree/fsck_scrub
>
> Currently, I only tested it on SINGLE/DUP/RAID1/RAID5 filesystems, with
> mirror or parity or data corrupted.
> The tool are all able to detect them and give recoverbility report.
>
> Several reports on kernel scrub screwing up good data stripes are in ML
> for sometime.
>
> The reason seems to be lack of csum check before and after reconstruction, and
> unfinished parity write seems also involved.
>
> To get a comparable tool for kernel scrub, we need a user-space tool to
> act as benchmark to compare their different behaviors.
>
> So here is the RFC patch set for user-space scrub.
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
> In fact, it can already expose one new btrfs kernel bug.
> For example, after screwing up a data stripe, kernel did repairs using
> parity, but recovered full stripe has wrong parity.
> Need to scrub again to fix it.
>
> And this patchset also introduced new map_block() function, which is
> more flex than current btrfs_map_block(), and has a unified interface
> for all profiles.
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
> Qu Wenruo (19):
>   btrfs-progs: raid56: Introduce raid56 header for later recovery usage
>   btrfs-progs: raid56: Introduce tables for RAID6 recovery
>   btrfs-progs: raid56: Allow raid6 to recover 2 data stripes
>   btrfs-progs: raid56: Allow raid6 to recover data and p
>   btrfs-progs: Introduce wrapper to recover raid56 data
>   btrfs-progs: Introduce new btrfs_map_block function which returns more
>     unified result.
>   btrfs-progs: Allow __btrfs_map_block_v2 to remove unrelated stripes
>   btrfs-progs: check/csum: Introduce function to read out one data csum
>   btrfs-progs: check/scrub: Introduce structures to support fsck scrub
>   btrfs-progs: check/scrub: Introduce function to scrub mirror based
>     tree block
>   btrfs-progs: check/scrub: Introduce function to scrub mirror based
>     data blocks
>   btrfs-progs: check/scrub: Introduce function to scrub one extent
>   btrfs-progs: check/scrub: Introduce function to scrub one data stripe
>   btrfs-progs: check/scrub: Introduce function to verify parities
>   btrfs-progs: extent-tree: Introduce function to check if there is any
>     extent in given range.
>   btrfs-progs: check/scrub: Introduce function to recover data parity
>   btrfs-progs: check/scrub: Introduce a function to scrub one full
>     stripe
>   btrfs-progs: check/scrub: Introduce function to check a whole block
>     group
>   btrfs-progs: fsck: Introduce offline scrub function
>
>  .gitignore                         |   2 +
>  Documentation/btrfs-check.asciidoc |   8 +
>  Makefile.in                        |  18 +-
>  check/check.h                      |  23 +
>  check/csum.c                       |  96 ++++
>  check/scrub.c                      | 924 +++++++++++++++++++++++++++++++++++++
>  cmds-check.c                       |  12 +-
>  ctree.h                            |   2 +
>  disk-io.c                          |   4 +-
>  disk-io.h                          |   6 +-
>  extent-tree.c                      |  52 +++
>  mktables.c                         | 142 ++++++
>  raid56.c                           | 175 +++++++
>  raid56.h                           |  47 ++
>  volumes.c                          | 283 ++++++++++++
>  volumes.h                          |  49 ++
>  16 files changed, 1832 insertions(+), 11 deletions(-)
>  create mode 100644 check/check.h
>  create mode 100644 check/csum.c
>  create mode 100644 check/scrub.c
>  create mode 100644 mktables.c
>  create mode 100644 raid56.h
>


