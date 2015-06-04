Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35502 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbbFDQbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 12:31:06 -0400
Received: by obbgp2 with SMTP id gp2so14153740obb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 09:31:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150604153345.GD3626@kajt.de>
References: <20150604125448.GB3626@kajt.de>
	<15093386.MD5Tv7KU3x@merkaba>
	<20150604153345.GD3626@kajt.de>
Date: Thu, 4 Jun 2015 09:31:05 -0700
Message-ID: <CAKgsxVSxePXpFCG6m6VZNz7aof2LoON6Zio75OYGCoq1dX8zJA@mail.gmail.com>
Subject: Re: Stability of Btrfs in Kernel 3.0
From: Justin Maggard <jmaggard10@gmail.com>
To: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
        BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes, ReadyNAS btrfs is a long way away from 3.0 btrfs.  And RN202/204
currently ship with a 3.12 kernel, and will be updated further soon.
There are also firmware versions currently available in beta for all
other hardware platforms using a much newer kernel, if you'd rather.
But anyway, here's a diffstat of the fs/btrfs directory:

 linux-3.0.101-netgear/fs/btrfs/Kconfig            |   40
 linux-3.0.101-netgear/fs/btrfs/Makefile           |   10
 linux-3.0.101-netgear/fs/btrfs/acl.c              |   36
 linux-3.0.101-netgear/fs/btrfs/async-thread.c     |  181
 linux-3.0.101-netgear/fs/btrfs/async-thread.h     |    8
 linux-3.0.101-netgear/fs/btrfs/backref.c          |only
 linux-3.0.101-netgear/fs/btrfs/backref.h          |only
 linux-3.0.101-netgear/fs/btrfs/btrfs_inode.h      |  126
 linux-3.0.101-netgear/fs/btrfs/check-integrity.c  |only
 linux-3.0.101-netgear/fs/btrfs/check-integrity.h  |only
 linux-3.0.101-netgear/fs/btrfs/compat.h           |   28
 linux-3.0.101-netgear/fs/btrfs/compression.c      |  108
 linux-3.0.101-netgear/fs/btrfs/compression.h      |    4
 linux-3.0.101-netgear/fs/btrfs/cslink.c           |only
 linux-3.0.101-netgear/fs/btrfs/cslink.h           |only
 linux-3.0.101-netgear/fs/btrfs/ctree.c            | 2943 ++++++++++---
 linux-3.0.101-netgear/fs/btrfs/ctree.h            | 1623 ++++++-
 linux-3.0.101-netgear/fs/btrfs/delayed-inode.c    |  596 +-
 linux-3.0.101-netgear/fs/btrfs/delayed-inode.h    |    8
 linux-3.0.101-netgear/fs/btrfs/delayed-ref.c      |  391 +
 linux-3.0.101-netgear/fs/btrfs/delayed-ref.h      |  113
 linux-3.0.101-netgear/fs/btrfs/dev-replace.c      |only
 linux-3.0.101-netgear/fs/btrfs/dev-replace.h      |only
 linux-3.0.101-netgear/fs/btrfs/dir-item.c         |  270 +
 linux-3.0.101-netgear/fs/btrfs/disk-io.c          | 2565 ++++++++----
 linux-3.0.101-netgear/fs/btrfs/disk-io.h          |   46
 linux-3.0.101-netgear/fs/btrfs/export.c           |    4
 linux-3.0.101-netgear/fs/btrfs/extent-tree.c      | 4106 +++++++++++++------
 linux-3.0.101-netgear/fs/btrfs/extent_io.c        | 2663 +++++++++---
 linux-3.0.101-netgear/fs/btrfs/extent_io.h        |  205
 linux-3.0.101-netgear/fs/btrfs/extent_map.c       |  231 -
 linux-3.0.101-netgear/fs/btrfs/extent_map.h       |   18
 linux-3.0.101-netgear/fs/btrfs/fiemap_physical.c  |only
 linux-3.0.101-netgear/fs/btrfs/file-item.c        |  227 -
 linux-3.0.101-netgear/fs/btrfs/file.c             | 1693 ++++++--
 linux-3.0.101-netgear/fs/btrfs/free-space-cache.c | 1756 ++++----
 linux-3.0.101-netgear/fs/btrfs/free-space-cache.h |    5
 linux-3.0.101-netgear/fs/btrfs/hash.h             |   10
 linux-3.0.101-netgear/fs/btrfs/inode-item.c       |  294 +
 linux-3.0.101-netgear/fs/btrfs/inode-map.c        |   60
 linux-3.0.101-netgear/fs/btrfs/inode.c            | 4642 ++++++++++++++--------
 linux-3.0.101-netgear/fs/btrfs/ioctl.c            | 2608 +++++++++---
 linux-3.0.101-netgear/fs/btrfs/ioctl.h            |  302 +
 linux-3.0.101-netgear/fs/btrfs/locking.c          |  350 -
 linux-3.0.101-netgear/fs/btrfs/locking.h          |   40
 linux-3.0.101-netgear/fs/btrfs/math.h             |only
 linux-3.0.101-netgear/fs/btrfs/ordered-data.c     |  441 +-
 linux-3.0.101-netgear/fs/btrfs/ordered-data.h     |   62
 linux-3.0.101-netgear/fs/btrfs/orphan.c           |    2
 linux-3.0.101-netgear/fs/btrfs/print-tree.c       |   26
 linux-3.0.101-netgear/fs/btrfs/print-tree.h       |    2
 linux-3.0.101-netgear/fs/btrfs/qgroup.c           |only
 linux-3.0.101-netgear/fs/btrfs/rcu-string.h       |only
 linux-3.0.101-netgear/fs/btrfs/reada.c            |only
 linux-3.0.101-netgear/fs/btrfs/relocation.c       |  405 +
 linux-3.0.101-netgear/fs/btrfs/root-tree.c        |  136
 linux-3.0.101-netgear/fs/btrfs/scrub.c            | 3188 ++++++++++++---
 linux-3.0.101-netgear/fs/btrfs/send.c             |only
 linux-3.0.101-netgear/fs/btrfs/send.h             |only
 linux-3.0.101-netgear/fs/btrfs/struct-funcs.c     |  183
 linux-3.0.101-netgear/fs/btrfs/super.c            | 1228 ++++-
 linux-3.0.101-netgear/fs/btrfs/transaction.c      | 1167 +++--
 linux-3.0.101-netgear/fs/btrfs/transaction.h      |   41
 linux-3.0.101-netgear/fs/btrfs/tree-defrag.c      |   19
 linux-3.0.101-netgear/fs/btrfs/tree-log.c         | 1500 +++++--
 linux-3.0.101-netgear/fs/btrfs/tree-log.h         |    5
 linux-3.0.101-netgear/fs/btrfs/ulist.c            |only
 linux-3.0.101-netgear/fs/btrfs/ulist.h            |only
 linux-3.0.101-netgear/fs/btrfs/volumes.c          | 3157 ++++++++++++--
 linux-3.0.101-netgear/fs/btrfs/volumes.h          |  172
 linux-3.0.101-netgear/fs/btrfs/xattr.c            |   94
 linux-3.0.101-netgear/fs/btrfs/zlib.c             |    8
 linux-3.0.101-orig/fs/btrfs/ref-cache.c           |only
 linux-3.0.101-orig/fs/btrfs/ref-cache.h           |only
 74 files changed, 29498 insertions(+), 10648 deletions(-)

-Justin

On Thu, Jun 4, 2015 at 8:33 AM, Maximilian Eschenbacher
<maximilian@eschenbacher.email> wrote:
> Hey Martin,
>
> On 04/06/2015 15:55:49, Martin Steigerwald wrote:
>>
>> BTRFS and Kernel 3.0?
>>
>> Unless its has a newer BTRFS version or at least critical fixed
>> backported, I would run away from it.
>>
>> Free space management in Kernel 3.0 still had issues that even with 2
>> GiB free the filesystem could report its full, while also denying to rm
>> a file, delete a subvolume or do anything else to mitigate the
>> situation. I have seen this on SLES 11 SP 3.
>>
>> I suggest something newer. Really.
>>
>> Or, if you still want to use it:
>>
>> If you want to store 50 GiB, keep 50 GiB of space free, or at least
>> 20-30 GiB. I.e. have plenty of free space on the device. Do not fill up
>> the filesystem.
>>
>> Or well… use another filesystem on that device.
>>
>> In addition meanwhile there will be a ton of other issues with such an
>> old BTRFS fixed.
>>
>> So until you can´t get a newer kernel for that device, I would not use
>> it with BRFS.
>
>
> thanks for the quick and precise answer. I will find out whether Netgear
> did some backporting for btrfs in their kernel and report back.
>
> Unfortunately Netgear uses only btrfs (or zfs on some systems) and one
> cannot select another fs like ext4 (which they supported on previous
> systems).
>
> Regards,
>
> Max
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
