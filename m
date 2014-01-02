Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:55762 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbaABOb7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jan 2014 09:31:59 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so6351799eaj.1
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jan 2014 06:31:57 -0800 (PST)
Message-ID: <52C5788F.70600@gmail.com>
Date: Thu, 02 Jan 2014 16:32:47 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
CC: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>,
        "alanqk@gmail.com" <alanqk@gmail.com>
Subject: Re: [RFC PATCH v8 00/14] Online(inband) data deduplication
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, I am trying to test your patches and they do not apply to latest 
3.12 source or 3.13 git. Am I doing something wrong?

---logs for 3.12---

Hunk #1 succeeded at 59 with fuzz 2 (offset 1 line).
patching file init/Kconfig
Hunk #1 succeeded at 1085 (offset 96 lines).
Hunk #2 succeeded at 1096 (offset 96 lines).
patching file fs/btrfs/ctree.h
Hunk #1 FAILED at 3692.
1 out of 1 hunk FAILED -- saving rejects to file fs/btrfs/ctree.h.rej
patching file fs/btrfs/extent-tree.c
Hunk #1 FAILED at 5996.
Hunk #2 FAILED at 6023.
2 out of 2 hunks FAILED -- saving rejects to file fs/btrfs/extent-tree.c.rej
patching file fs/btrfs/file-item.c
Hunk #1 FAILED at 887.
Hunk #2 succeeded at 765 with fuzz 2 (offset -151 lines).
Hunk #3 FAILED at 978.
Hunk #4 FAILED at 1061.
Hunk #5 FAILED at 1094.
4 out of 5 hunks FAILED -- saving rejects to file fs/btrfs/file-item.c.rej
patching file fs/btrfs/inode.c
Hunk #1 FAILED at 969.
Hunk #2 FAILED at 2364.
2 out of 2 hunks FAILED -- saving rejects to file fs/btrfs/inode.c.rej

---logs for 3.13---
Hunk #1 succeeded at 59 with fuzz 2 (offset 1 line).
patching file init/Kconfig
Hunk #1 succeeded at 1078 (offset 89 lines).
Hunk #2 succeeded at 1089 (offset 89 lines).
patching file fs/btrfs/ctree.h
Hunk #1 FAILED at 3692.
1 out of 1 hunk FAILED -- saving rejects to file fs/btrfs/ctree.h.rej
patching file fs/btrfs/extent-tree.c
Hunk #1 FAILED at 5996.
Hunk #2 FAILED at 6023.
2 out of 2 hunks FAILED -- saving rejects to file fs/btrfs/extent-tree.c.rej
patching file fs/btrfs/file-item.c
Hunk #1 FAILED at 887.
Hunk #2 succeeded at 768 with fuzz 2 (offset -148 lines).
Hunk #3 FAILED at 978.
Hunk #4 FAILED at 1061.
Hunk #5 FAILED at 1094.
4 out of 5 hunks FAILED -- saving rejects to file fs/btrfs/file-item.c.rej
patching file fs/btrfs/inode.c
Hunk #1 FAILED at 969.
Hunk #2 FAILED at 2364.
2 out of 2 hunks FAILED -- saving rejects to file fs/btrfs/inode.c.rej


On 30/12/2013 10:12 πμ, Liu Bo wrote:
> Hello,
>
> Here is the New Year patch bomb :-)
>
> Data deduplication is a specialized data compression technique for eliminating
> duplicate copies of repeating data.[1]
>
> This patch set is also related to "Content based storage" in project ideas[2],
> it introduces inband data deduplication for btrfs and dedup/dedupe is for short.
>
> PATCH 1 is a hang fix with deduplication on, but it's also useful without
> dedup in practice use.
>
> PATCH 2 and 3 are targetting delayed refs' scalability problems, which are
> uncovered by the dedup feature.
>
> PATCH 4 is a speed-up improvement, which is about dedup and quota.
>
> PATCH 5-8 is the preparation work for dedup implementation.
>
> PATCH 9 shows how we implement dedup feature.
>
> PATCH 10 fixes a backref walking bug with dedup.
>
> PATCH 11 fixes a free space bug of dedup extents on error handling.
>
> PATCH 12 adds the ioctl to control dedup feature.
>
> PATCH 13 fixes the metadata ENOSPC problem with dedup which has been there
> WAY TOO LONG.
>
> PATCH 14 fixes a race bug on dedup writes.
>
> And there is also a btrfs-progs patch(PATCH 15) which offers all details about
> how to control the dedup feature.
>
> I've tested this with xfstests by adding a inline dedup 'enable & on' in xfstests'
> mount and scratch_mount.
>
> TODO:
> * a bit-to-bit comparison callback.
>
> All comments are welcome!
>
>
> [1]: http://en.wikipedia.org/wiki/Data_deduplication
> [2]: https://btrfs.wiki.kernel.org/index.php/Project_ideas#Content_based_storage
>
> v8:
> - fix the race crash of dedup ref again.
> - fix the metadata ENOSPC problem with dedup.
>
> v7:
> - rebase onto the lastest btrfs
> - break a big patch into smaller ones to make reviewers happy.
> - kill mount options of dedup and use ioctl method instead.
> - fix two crash due to the special dedup ref
>
> For former patch sets:
> v6: http://thread.gmane.org/gmane.comp.file-systems.btrfs/27512
> v5: http://thread.gmane.org/gmane.comp.file-systems.btrfs/27257
> v4: http://thread.gmane.org/gmane.comp.file-systems.btrfs/25751
> v3: http://comments.gmane.org/gmane.comp.file-systems.btrfs/25433
> v2: http://comments.gmane.org/gmane.comp.file-systems.btrfs/24959
>
> Liu Bo (14):
>    Btrfs: skip merge part for delayed data refs
>    Btrfs: improve the delayed refs process in rm case
>    Btrfs: introduce a head ref rbtree
>    Btrfs: disable qgroups accounting when quata_enable is 0
>    Btrfs: introduce dedup tree and relatives
>    Btrfs: introduce dedup tree operations
>    Btrfs: introduce dedup state
>    Btrfs: make ordered extent aware of dedup
>    Btrfs: online(inband) data dedup
>    Btrfs: skip dedup reference during backref walking
>    Btrfs: don't return space for dedup extent
>    Btrfs: add ioctl of dedup control
>    Btrfs: fix dedupe 'ENOSPC' problem
>    Btrfs: fix a crash of dedup ref
>
>   fs/btrfs/backref.c           |   9 +
>   fs/btrfs/ctree.c             |   2 +-
>   fs/btrfs/ctree.h             |  86 ++++++
>   fs/btrfs/delayed-ref.c       | 161 +++++++----
>   fs/btrfs/delayed-ref.h       |   8 +
>   fs/btrfs/disk-io.c           |  40 +++
>   fs/btrfs/extent-tree.c       | 208 ++++++++++++--
>   fs/btrfs/extent_io.c         |  22 +-
>   fs/btrfs/extent_io.h         |  16 ++
>   fs/btrfs/file-item.c         | 244 +++++++++++++++++
>   fs/btrfs/inode.c             | 635 ++++++++++++++++++++++++++++++++++++++-----
>   fs/btrfs/ioctl.c             | 167 ++++++++++++
>   fs/btrfs/ordered-data.c      |  38 ++-
>   fs/btrfs/ordered-data.h      |  13 +-
>   fs/btrfs/qgroup.c            |   3 +
>   fs/btrfs/relocation.c        |   3 +
>   fs/btrfs/transaction.c       |   4 +-
>   include/trace/events/btrfs.h |   3 +-
>   include/uapi/linux/btrfs.h   |  11 +
>   19 files changed, 1501 insertions(+), 172 deletions(-)
>

