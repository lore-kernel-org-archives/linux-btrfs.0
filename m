Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16316 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752925AbbBZBkd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 20:40:33 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'David Sterba'" <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
CC: <clm@fb.com>
References: <cover.1424880058.git.dsterba@suse.cz>
In-Reply-To: <cover.1424880058.git.dsterba@suse.cz>
Subject: RE: [PULL] [PATCH 00/11] Cleanups for 4.1
Date: Thu, 26 Feb 2015 09:39:57 +0800
Message-ID: <009a01d05165$2112c790$633856b0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David

* From: linux-btrfs-owner@vger.kernel.org
> Subject: [PULL] [PATCH 00/11] Cleanups for 4.1
> 
> Hi,
> 
> a few cleanups that accumulated over time. No real fixes but there are changes
> that may touch functionality (no fstests complaints though).
> 
I like these cleanups.

But it cause following build warnings:
  fs/btrfs/volumes.c: In function ‘__btrfs_map_block’:
  fs/btrfs/volumes.c:5206: warning: unused variable ‘tmp’

  fs/btrfs/free-space-cache.c: In function ‘recalculate_thresholds’:
  fs/btrfs/free-space-cache.c:1527: warning: comparison of distinct pointer types lacks a cast

And little checkpatch notice:
  ERROR: "foo* bar" should be "foo *bar"
  #41: FILE: fs/btrfs/sysfs.h:70:
  +static inline struct kobj_attribute* attr_to_btrfs_attr(struct attribute *attr)
In [PATCH 09/11].

Could you fix it?

Thanks
Zhaolei

>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git cleanups-for-4.1
> 
> all merged together, but are also available in the following topic branches
> based on current for-linus branch.
> 
> cleanup/sched
> cleanup/divs
> cleanup/kmalloc-array
> cleanup/shadow-vars
> cleanup/initializers
> 
> David Sterba (11):
>   btrfs: need_resched not needed with cond_resched
>   btrfs: use cond_resched_lock where possible
>   btrfs: cleanup 64bit/32bit divs, compile time constants
>   btrfs: cleanup 64bit/32bit divs, provably bounded values
>   btrfs: replace remaining do_div calls with div_u64 variants
>   btrfs: cleanup, use correct type in div_u64_rem
>   btrfs: cleanup, use kmalloc_array/kcalloc array helpers
>   btrfs: remove shadowing variables in __btrfs_buffered_write
>   btrfs: switch helper macros to static inlines in sysfs.h
>   btrfs: remove shadowing variables in __btrfs_map_block
>   btrfs: use explicit initializer for seq_elem
> 
>  fs/btrfs/backref.c          |  4 +--
>  fs/btrfs/check-integrity.c  |  4 +--
>  fs/btrfs/compression.c      |  2 +-
>  fs/btrfs/ctree.c            |  9 +++--
>  fs/btrfs/ctree.h            |  2 ++
>  fs/btrfs/dev-replace.c      |  6 ++--
>  fs/btrfs/disk-io.c          |  4 +--
>  fs/btrfs/extent-tree.c      | 21 ++++++------
>  fs/btrfs/file-item.c        |  4 +--
>  fs/btrfs/file.c             | 12 +++----
>  fs/btrfs/free-space-cache.c | 34 ++++++++-----------
>  fs/btrfs/inode.c            |  2 +-
>  fs/btrfs/ioctl.c            |  4 +--
>  fs/btrfs/math.h             |  6 ++--
>  fs/btrfs/qgroup.c           |  6 ++--
>  fs/btrfs/raid56.c           |  3 +-
>  fs/btrfs/scrub.c            | 23 ++++++-------
>  fs/btrfs/super.c            |  2 +-
>  fs/btrfs/sysfs.h            | 22 ++++++++++---
>  fs/btrfs/transaction.c      |  7 ++--
>  fs/btrfs/volumes.c          | 80
> ++++++++++++++++++++++-----------------------
>  21 files changed, 125 insertions(+), 132 deletions(-)
> 
> --
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


