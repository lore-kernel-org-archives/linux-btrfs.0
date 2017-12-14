Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36792 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752228AbdLNNfz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 08:35:55 -0500
Received: by mail-it0-f65.google.com with SMTP id d16so11162618itj.1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 05:35:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171213232524.3709-1-nefelim4ag@gmail.com>
References: <20171213232524.3709-1-nefelim4ag@gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 14 Dec 2017 16:35:13 +0300
Message-ID: <CAGqmi75AvLW7-sGcfi7gLOpONo3aCS=U2+BLyPmCrH5p4pORGw@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: btrfs_defrag_file() force use target extent
 size SZ_128KiB for compressed data
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ignore that patch please, i will send another

2017-12-14 2:25 GMT+03:00 Timofey Titovets <nefelim4ag@gmail.com>:
> Defrag heuristic use extent lengh as threshold,
> kernel autodefrag use SZ_256KiB and btrfs-progs use SZ_32MiB as
> target extent lengh.
>
> Problem:
> Compressed extents always have lengh at < 128KiB (BTRFS_MAX_COMPRESSED)
> So btrfs_defrag_file() always rewrite all extents in defrag range.
>
> Hot fix that by force set target extent size to BTRFS_MAX_COMPRESSED,
> if file allowed to be compressed.
>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/ioctl.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index be5bd81b3669..952364ff4108 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1232,6 +1232,26 @@ static int cluster_pages_for_defrag(struct inode *inode,
>
>  }
>
> +static inline int inode_use_compression(struct inode *inode)
> +{
> +       struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> +
> +       /* force compress */
> +       if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
> +               return 1;
> +       /* defrag ioctl */
> +       if (BTRFS_I(inode)->defrag_compress)
> +               return 1;
> +       /* bad compression ratios */
> +       if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
> +               return 0;
> +       if (btrfs_test_opt(fs_info, COMPRESS) ||
> +           BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||
> +           BTRFS_I(inode)->prop_compress)
> +               return 1;
> +       return 0;
> +}
> +
>  int btrfs_defrag_file(struct inode *inode, struct file *file,
>                       struct btrfs_ioctl_defrag_range_args *range,
>                       u64 newer_than, unsigned long max_to_defrag)
> @@ -1270,6 +1290,9 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>                         compress_type = range->compress_type;
>         }
>
> +       if (inode_use_compression(inode))
> +               extent_thresh = BTRFS_MAX_COMPRESSED;
> +
>         if (extent_thresh == 0)
>                 extent_thresh = SZ_256K;
>
> --
> 2.15.1



-- 
Have a nice day,
Timofey.
