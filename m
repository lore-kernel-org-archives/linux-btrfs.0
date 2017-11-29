Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47589 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933682AbdK2Q4L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 11:56:11 -0500
Date: Wed, 29 Nov 2017 17:56:08 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: jack@suse.cz, axboe@kernel.dk, clm@fb.com, jbacik@fb.com,
        kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCHSET v2] cgroup, writeback, btrfs: make sure btrfs issues
 metadata IOs from the root cgroup
Message-ID: <20171129165608.GA26740@quack2.suse.cz>
References: <20171010155441.753966-1-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171010155441.753966-1-tj@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Tejun,

What has happened with this patch set?

Honza

On Tue 10-10-17 08:54:36, Tejun Heo wrote:
> Changes from the last version are
> 
> * blkcg_root_css exported to fix build breakage on modular btrfs.
> 
> * Use ext4_should_journal_data() test instead of
>   EXT4_MOUNT_JOURNAL_DATA.
> 
> * Separated out create_bh_bio() and used it to implement
>   submit_bh_blkcg_css() as suggested by Jan.
> 
> btrfs has different ways to issue metadata IOs and may end up issuing
> metadata or otherwise shared IOs from a non-root cgroup, which can
> lead to priority inversion and ineffective IO isolation.
> 
> This patchset makes sure that btrfs issues all metadata and shared IOs
> from the root cgroup by exempting btree_inodes from cgroup writeback
> and explicitly associating shared IOs with the root cgroup.
> 
> This patchset containst he following three patches
> 
>  [PATCH 1/5] blkcg: export blkcg_root_css
>  [PATCH 2/5] cgroup, writeback: replace SB_I_CGROUPWB with per-inode
>  [PATCH 3/5] buffer_head: separate out create_bh_bio() from
>  [PATCH 4/5] cgroup, buffer_head: implement submit_bh_blkcg_css()
>  [PATCH 5/5] btrfs: ensure that metadata and flush are issued from the
> 
> and is also available in the following git branch
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-btrfs-metadata-v2
> 
> diffstat follows.  Thanks.
> 
>  block/blk-cgroup.c          |    1 +
>  fs/block_dev.c              |    3 +--
>  fs/btrfs/check-integrity.c  |    2 +-
>  fs/btrfs/disk-io.c          |    4 ++++
>  fs/btrfs/ioctl.c            |    6 +++++-
>  fs/btrfs/super.c            |    1 -
>  fs/buffer.c                 |   42 ++++++++++++++++++++++++++++++++++--------
>  fs/ext2/inode.c             |    3 ++-
>  fs/ext2/super.c             |    1 -
>  fs/ext4/inode.c             |    5 ++++-
>  fs/ext4/super.c             |    2 --
>  include/linux/backing-dev.h |    2 +-
>  include/linux/buffer_head.h |    3 +++
>  include/linux/fs.h          |    3 ++-
>  14 files changed, 58 insertions(+), 20 deletions(-)
> 
> --
> tejun
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
