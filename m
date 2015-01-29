Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13251 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754256AbbA2CUg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 21:20:36 -0500
Message-ID: <54C99921.4040808@cn.fujitsu.com>
Date: Thu, 29 Jan 2015 10:21:21 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: Re: [PATCH v4 0/8] Fix freeze/sysfs deadlock in better method.
References: <1422494863-15077-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422494863-15077-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh, I'm very sorry for the patchset which includes other 
unrelated/out-of-date patches.

I'll resend them with correct patchese.

Thanks,
Qu
-------- Original Message --------
Subject: [PATCH v4 0/8] Fix freeze/sysfs deadlock in better method.
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年01月29日 09:27
> Patchset to solve the previous found freeze/sysfs deadlock.
>
> Unlike previous pending_changes, which uses transaction commits to
> ensure mount option doesn't change during transaction.
> This idea is great in concept, but will introduce extra and somewhat
> duplicated ro/freeze check, and the original synchronized behavior is
> also changed.
>
> [Per-transaction mount option]
> This patch use the RCU-like concept, which will copy the mount_opt from
> fs_info into btrfs_transaction, and each btrfs_test_opt() for specific
> mount option bit(SPACE_CACHE/INODE_MAP_CACHE) should be changed to
> btrfs_test_trans_opt().
> So mount option during transaction won't be changed, and also, no extra
> read_only or freeze check is needed, the commit routine is also
> untouched.
>
> [Use VFS protect for sysfs change]
> The 6th patch will introduce a new help function get_vfsmount_sb() to
> get a vfsmount from a sb, with this vfsmount, we can use vfs level
> mnt_want_write() to do a comprehensive protection other than the cheap
> ro/freeze check.
>
> Qu Wenruo (8):
>    Revert "btrfs: add support for processing pending changes" related
>      commits
>    btrfs: Make btrfs_parse_options() parse mount option in a atomic way
>    btrfs: Introduce per-transaction mount_opt to keep mount option
>      consistent during transaction.
>    btrfs: Use btrfs_test_trans_opt() to handle SPACE_CACHE if it's under
>         transaction protect.
>    btrfs: Use btrfs_test_trans_opt() to handle INODE_CACHE if it's under
>         transaction protect.
>    vfs: Add get_vfsmount_sb() function to get vfsmount from a given sb.
>    btrfs: Use mnt_want_write() to protect label change.
>    btrfs: Use mnt_want_write() to protect sysfs feature change.
>
>   fs/btrfs/ctree.h            |  64 +++-------------------
>   fs/btrfs/disk-io.c          |   6 ---
>   fs/btrfs/extent-tree.c      |   2 +-
>   fs/btrfs/free-space-cache.c |   2 +-
>   fs/btrfs/inode-map.c        |   5 +-
>   fs/btrfs/super.c            | 129 ++++++++++++++++++++++----------------------
>   fs/btrfs/sysfs.c            |  73 ++++++++++++++++++-------
>   fs/btrfs/transaction.c      |  43 ++-------------
>   fs/btrfs/transaction.h      |   6 ++-
>   fs/namespace.c              |  25 +++++++++
>   include/linux/mount.h       |   1 +
>   11 files changed, 167 insertions(+), 189 deletions(-)
>

