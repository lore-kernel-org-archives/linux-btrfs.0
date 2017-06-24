Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35105 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbdFXKFE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Jun 2017 06:05:04 -0400
Received: by mail-yw0-f196.google.com with SMTP id e142so3964733ywa.2
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Jun 2017 03:05:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cover.1498229425.git.dsterba@suse.com>
References: <cover.1498229425.git.dsterba@suse.com>
From: Wang Shilong <wangshilong1991@gmail.com>
Date: Sat, 24 Jun 2017 18:05:03 +0800
Message-ID: <CAP9B-Qmv9QMahi_Ook4FOL8c7hojgKgzcOA4mMeiY2H012ByxQ@mail.gmail.com>
Subject: Re: [PULL] Btrfs for 4.13, part 1
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for bikeshedding.

On Fri, Jun 23, 2017 at 11:16 PM, David Sterba <dsterba@suse.com> wrote:
> Hi,
>
> this is the main batch for 4.13. There are some user visible changes, see
> below. The core updates improve error handling (mostly related to bios), with
> the usual incremental work on the GFP_NOFS (mis)use removal. All patches have
>
> Fabian Frederick (1):
>       btrfs: kmap() can't fail
>
<..SNIP..>
>
> Sargun Dhillon (2):
>       btrfs: add quota override flag to enable quota override for CAP_SYS_RESOURCE
>       btrfs: Add quota_override knob into sysfs
>
> Su Yue (9):
>       btrfs: Introduce btrfs_is_name_len_valid to avoid reading beyond boundary
>       btrfs: Check name_len with boundary in verify dir_item
>       btrfs: Check name_len on add_inode_ref call path
>       btrfs: Verify dir_item in replay_xattr_deletes
>       btrfs: Check name_len in btrfs_check_ref_name_override
>       btrfs: Check name_len before read in iterate_dir_item
>       btrfs: Check name_len before reading btrfs_get_name
>       btrfs: Check name_len before in btrfs_del_root_ref
>       btrfs: Verify dir_item in iterate_object_props

Hmm..add those check might be expensive for metadata operations,
especially in hot path, i could see similar behavior in Ext4 for ext4
dentry check.

Could we run some metadata tests to confirm？it makes sense to
add check but with min affects to performace.


Thanks,
Shilong

> Timofey Titovets (3):
>       Btrfs: lzo: fix typo in error message after failed deflate
>       Btrfs: lzo: compressed data size must be less then input size
>       Btrfs: compression must free at least one sector size
>
> Yonghong Song (1):
>       Btrfs: add statx support
>
>  fs/btrfs/backref.c               |  10 +-
>  fs/btrfs/check-integrity.c       |  53 ++---
>  fs/btrfs/compression.c           |  94 ++------
>  fs/btrfs/compression.h           |  44 +++-
>  fs/btrfs/ctree.c                 |  42 ++--
>  fs/btrfs/ctree.h                 |  84 ++++---
>  fs/btrfs/delayed-ref.c           |  29 ++-
>  fs/btrfs/delayed-ref.h           |   6 +-
>  fs/btrfs/dir-item.c              |  94 +++++++-
>  fs/btrfs/disk-io.c               | 179 +++++++--------
>  fs/btrfs/disk-io.h               |   8 +-
>  fs/btrfs/export.c                |   5 +
>  fs/btrfs/extent-tree.c           | 481 +++++++++++++++++++++------------------
>  fs/btrfs/extent_io.c             | 217 ++++++++----------
>  fs/btrfs/extent_io.h             |  82 +++++--
>  fs/btrfs/file-item.c             |  31 ++-
>  fs/btrfs/file.c                  |  46 ++--
>  fs/btrfs/free-space-tree.c       |  38 ++--
>  fs/btrfs/inode-map.c             |   4 +-
>  fs/btrfs/inode.c                 | 449 ++++++++++++++++++++----------------
>  fs/btrfs/ioctl.c                 |  16 +-
>  fs/btrfs/lzo.c                   |  33 +--
>  fs/btrfs/print-tree.c            |   7 +-
>  fs/btrfs/props.c                 |   7 +
>  fs/btrfs/qgroup.c                | 223 +++++++++++++-----
>  fs/btrfs/qgroup.h                |   9 +-
>  fs/btrfs/raid56.c                |  16 +-
>  fs/btrfs/reada.c                 |   1 -
>  fs/btrfs/relocation.c            |  15 +-
>  fs/btrfs/root-tree.c             |   7 +
>  fs/btrfs/scrub.c                 | 209 +++++++----------
>  fs/btrfs/send.c                  | 112 ++++++---
>  fs/btrfs/super.c                 |  72 +-----
>  fs/btrfs/sysfs.c                 |  41 ++++
>  fs/btrfs/tests/extent-io-tests.c |   2 +-
>  fs/btrfs/transaction.c           |  23 +-
>  fs/btrfs/tree-log.c              |  44 +++-
>  fs/btrfs/volumes.c               |  74 +++---
>  fs/btrfs/volumes.h               |   7 +
>  fs/btrfs/xattr.c                 |   2 +-
>  fs/btrfs/zlib.c                  |  20 +-
>  include/trace/events/btrfs.h     |  36 ---
>  include/uapi/linux/btrfs.h       |  63 +++--
>  43 files changed, 1682 insertions(+), 1353 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
