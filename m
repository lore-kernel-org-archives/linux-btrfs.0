Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:33727 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752733AbcIZXNb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 19:13:31 -0400
Received: by mail-pf0-f170.google.com with SMTP id 21so70407358pfy.0
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Sep 2016 16:13:31 -0700 (PDT)
Date: Mon, 26 Sep 2016 16:13:29 -0700
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [PATCH v2 3/6] Btrfs: catch invalid free space trees
Message-ID: <20160926231329.GA23991@vader.DHCP.thefacebook.com>
References: <cover.1474580472.git.osandov@fb.com>
 <1381db7b5de30b8ea0d2e87aff26bfdb83b030e7.1474580472.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381db7b5de30b8ea0d2e87aff26bfdb83b030e7.1474580472.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 05:24:22PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> There are two separate issues that can lead to corrupted free space
> trees.
> 
> 1. The free space tree bitmaps had an endianness issue on big-endian
>    systems which is fixed by an earlier patch in this series.
> 2. btrfs-progs before v4.7.3 modified filesystems without updating the
>    free space tree.
> 
> To catch both of these issues at once, we need to force the free space
> tree to be rebuilt. To do so, add a FREE_SPACE_TREE_VALID compat_ro bit.
> If the bit isn't set, we know that it was either produced by a broken
> big-endian kernel or may have been corrupted by btrfs-progs.
> 
> This also provides us with a way to add rudimentary read-write support
> for the free space tree to btrfs-progs: it can just clear this bit and
> have the kernel rebuild the free space tree.
> 
> Cc: stable@vger.kernel.org # 4.5+
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/ctree.h           |  3 ++-
>  fs/btrfs/disk-io.c         |  9 +++++++++
>  fs/btrfs/free-space-tree.c |  2 ++
>  include/uapi/linux/btrfs.h | 10 +++++++++-
>  4 files changed, 22 insertions(+), 2 deletions(-)
> 

[snip]

> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index ac5eacd..549ecf4 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -239,7 +239,15 @@ struct btrfs_ioctl_fs_info_args {
>   * Used by:
>   * struct btrfs_ioctl_feature_flags
>   */
> -#define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
> +#define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE		(1ULL << 0)
> +/*
> + * Older kernels on big-endian systems produced broken free space tree bitmaps,
> + * and btrfs-progs also used to corrupt the free space tree. If this bit is
> + * clear, then the free space tree cannot be trusted. btrfs-progs can also
> + * intentionally clear this bit to ask the kernel to rebuild the free space
> + * tree.
> + */

Hm, I think I changed my mind about allowing btrfs-progs to clear the
bit intentionally. This creates a problem where we have a valid free
space tree, modify it with btrfs-progs and clear the bit, and then mount
it on an older kernel that doesn't check for the valid bit. If we really
wanted to, we could add yet another bit, say, FREE_SPACE_TREE_INVALID,
which prevents old kernels from mounting it, but I don't want to add
more hacks just because write support hasn't been implemented in progs
yet. That doesn't change this patch at all except for the comment here.
Should I resend it or can this be fixed on applying?

> +#define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID	(1ULL << 1)
>  
>  #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
>  #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
> -- 
> 2.10.0
> 

-- 
Omar
