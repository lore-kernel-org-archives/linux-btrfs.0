Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:33480 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934762AbaDJJIY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 05:08:24 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so2758337eek.38
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 02:08:22 -0700 (PDT)
Message-ID: <53465F81.7000803@gmail.com>
Date: Thu, 10 Apr 2014 12:08:17 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
CC: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, alanqk@gmail.com,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: Re: [RFC PATCH v10 00/16] Online(inband) data deduplication
References: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/4/2014 6:48 πμ, Liu Bo wrote:
> Hello,
>
> This the 10th attempt for in-band data dedupe, based on Linux _3.14_ kernel.
>
> Data deduplication is a specialized data compression technique for eliminating
> duplicate copies of repeating data.[1]
>
> This patch set is also related to "Content based storage" in project ideas[2],
> it introduces inband data deduplication for btrfs and dedup/dedupe is for short.
>
> * PATCH 1 is a speed-up improvement, which is about dedup and quota.
>
> * PATCH 2-5 is the preparation work for dedup implementation.
>
> * PATCH 6 shows how we implement dedup feature.
>
> * PATCH 7 fixes a backref walking bug with dedup.
>
> * PATCH 8 fixes a free space bug of dedup extents on error handling.
>
> * PATCH 9 adds the ioctl to control dedup feature.
>
> * PATCH 10 targets delayed refs' scalability problem of deleting refs, which is
>    uncovered by the dedup feature.
>
> * PATCH 11-16 fixes bugs of dedupe including race bug, deadlock, abnormal
>    transaction abortion and crash.
>
> * btrfs-progs patch(PATCH 17) offers all details about how to control the
>    dedup feature on progs side.
>
> I've tested this with xfstests by adding a inline dedup 'enable & on' in xfstests'
> mount and scratch_mount.
>
>
> ***NOTE***
> Known bugs:
> * Mounting with options "flushoncommit" and enabling dedupe feature will end up
>    with _deadlock_.
>
>
> TODO:
> * a bit-to-bit comparison callback.
>
> All comments are welcome!
Hi Liu,
Thanks for doing this work.
I tested your previous patches a few months ago, and will now test the 
new ones. One question about memory requirements, are they in the same 
league as ZFS dedup (ie needing 10's of gb of RAM for multi TB 
filesystems) or are they more reasonable?
Thanks
>
>
> [1]: http://en.wikipedia.org/wiki/Data_deduplication
> [2]: https://btrfs.wiki.kernel.org/index.php/Project_ideas#Content_based_storage
>
> v10:
> - fix a typo in the subject line.
> - update struct 'btrfs_ioctl_dedup_args' in the kernel side to fix
>    'Inappropriate ioctl for device'.
>
> v9:
> - fix a deadlock and a crash reported by users.
> - fix the metadata ENOSPC problem with dedup again.
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
> Liu Bo (16):
>    Btrfs: disable qgroups accounting when quota_enable is 0
>    Btrfs: introduce dedup tree and relatives
>    Btrfs: introduce dedup tree operations
>    Btrfs: introduce dedup state
>    Btrfs: make ordered extent aware of dedup
>    Btrfs: online(inband) data dedup
>    Btrfs: skip dedup reference during backref walking
>    Btrfs: don't return space for dedup extent
>    Btrfs: add ioctl of dedup control
>    Btrfs: improve the delayed refs process in rm case
>    Btrfs: fix a crash of dedup ref
>    Btrfs: fix deadlock of dedup work
>    Btrfs: fix transactin abortion in __btrfs_free_extent
>    Btrfs: fix wrong pinned bytes in __btrfs_free_extent
>    Btrfs: use total_bytes instead of bytes_used for global_rsv
>    Btrfs: fix dedup enospc problem
>
>   fs/btrfs/backref.c           |   9 +
>   fs/btrfs/ctree.c             |   2 +-
>   fs/btrfs/ctree.h             |  86 ++++++
>   fs/btrfs/delayed-ref.c       |  26 +-
>   fs/btrfs/delayed-ref.h       |   3 +
>   fs/btrfs/disk-io.c           |  37 +++
>   fs/btrfs/extent-tree.c       | 235 +++++++++++++---
>   fs/btrfs/extent_io.c         |  22 +-
>   fs/btrfs/extent_io.h         |  16 ++
>   fs/btrfs/file-item.c         | 244 +++++++++++++++++
>   fs/btrfs/inode.c             | 635 ++++++++++++++++++++++++++++++++++++++-----
>   fs/btrfs/ioctl.c             | 167 ++++++++++++
>   fs/btrfs/ordered-data.c      |  44 ++-
>   fs/btrfs/ordered-data.h      |  13 +-
>   fs/btrfs/qgroup.c            |   3 +
>   fs/btrfs/relocation.c        |   3 +
>   fs/btrfs/transaction.c       |  41 +++
>   fs/btrfs/transaction.h       |   1 +
>   include/trace/events/btrfs.h |   3 +-
>   include/uapi/linux/btrfs.h   |  12 +
>   20 files changed, 1471 insertions(+), 131 deletions(-)
>

