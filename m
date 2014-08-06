Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:48964 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbaHFS6s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Aug 2014 14:58:48 -0400
Received: by mail-la0-f54.google.com with SMTP id hz20so2591331lab.41
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Aug 2014 11:58:47 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1401434170-30695-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1401434170-30695-1-git-send-email-quwenruo@cn.fujitsu.com>
Date: Wed, 6 Aug 2014 19:58:46 +0100
Message-ID: <CAL3q7H7kuFoKBsfwEBzjQTxkNSDpPw5MKQCOu9a_BFZDde3iqQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Avoid trucating page or punching hole in a already
 existed hole.
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 30, 2014 at 8:16 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> btrfs_punch_hole() will truncate unaligned pages or punch hole on a
> already existed hole.
> This will cause unneeded zero page or holes splitting the original huge
> hole.
>
> This patch will skip already existed holes before any page truncating or
> hole punching.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Hi Qu,

FYI, this change seems to introduce some regressions when using the
NO_HOLES feature, and it's easy to reproduce with xfstests, where at
least 3 tests fail in a deterministic way:

$ cat /home/fdmanana/git/hub/xfstests/local.config
export TEST_DEV=/dev/sdb
export TEST_DIR=/home/fdmanana/btrfs-tests/dev
export SCRATCH_MNT="/home/fdmanana/btrfs-tests/scratch_1"
export FSTYP=btrfs

$ cd /home/fdmanana/git/hub/xfstests
$ mkfs.btrfs -f -O no-holes /dev/sdb
Performing full device TRIM (100.00GiB) ...
Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
fs created label (null) on /dev/sdb
nodesize 16384 leafsize 16384 sectorsize 4096 size 100.00GiB
Btrfs v3.14.1-96-gcc7fd5a-dirty

$ ./check generic/075  generic/091  generic/112
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 debian-vm3 3.16.0-rc6-fdm-btrfs-next-38+

generic/075 87s ... [failed, exit status 1] - output mismatch (see
/home/fdmanana/git/hub/xfstests/results//generic/075.out.bad)
    --- tests/generic/075.out 2014-08-06 20:30:02.986012249 +0100
    +++ /home/fdmanana/git/hub/xfstests/results//generic/075.out.bad
2014-08-06 20:42:23.386012249 +0100
    @@ -4,15 +4,5 @@
     -----------------------------------------------
     fsx.0 : -d -N numops -S 0
     -----------------------------------------------
    -
    ------------------------------------------------
    -fsx.1 : -d -N numops -S 0 -x
    ------------------------------------------------
    ...
    (Run 'diff -u tests/generic/075.out
/home/fdmanana/git/hub/xfstests/results//generic/075.out.bad'  to see
the entire diff)
generic/091 56s ... [failed, exit status 1] - output mismatch (see
/home/fdmanana/git/hub/xfstests/results//generic/091.out.bad)
    --- tests/generic/091.out 2014-02-21 19:11:09.460443001 +0000
    +++ /home/fdmanana/git/hub/xfstests/results//generic/091.out.bad
2014-08-06 20:42:25.262012249 +0100
    @@ -1,7 +1,601 @@
     QA output created by 091
     fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
    ...
    (Run 'diff -u tests/generic/091.out
/home/fdmanana/git/hub/xfstests/results//generic/091.out.bad'  to see
the entire diff)
generic/112 93s ... [failed, exit status 1] - output mismatch (see
/home/fdmanana/git/hub/xfstests/results//generic/112.out.bad)
    --- tests/generic/112.out 2014-02-21 19:11:09.460443001 +0000
    +++ /home/fdmanana/git/hub/xfstests/results//generic/112.out.bad
2014-08-06 20:42:28.930012249 +0100
    @@ -4,15 +4,5 @@
     -----------------------------------------------
     fsx.0 : -A -d -N numops -S 0
     -----------------------------------------------
    -
    ------------------------------------------------
    -fsx.1 : -A -d -N numops -S 0 -x
    ------------------------------------------------
    ...
    (Run 'diff -u tests/generic/112.out
/home/fdmanana/git/hub/xfstests/results//generic/112.out.bad'  to see
the entire diff)
Ran: generic/075 generic/091 generic/112
Failures: generic/075 generic/091 generic/112
Failed 3 of 3 tests


Without NO_HOLES, those tests pass. With NO_HOLES and without this
patch, the tests pass too.
Do you think you can take a look at this?

(A couple nitpick comments below too)

Thanks Qu


> ---
>  fs/btrfs/file.c | 112 +++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 98 insertions(+), 14 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index ae6af07..93915d1 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2168,6 +2168,37 @@ out:
>         return 0;
>  }
>
> +/*
> + * Find a hole extent on given inode and change start/len to the end of hole
> + * extent.(hole/vacuum extent whose em->start <= start &&
> + *        em->start + em->len > start)
> + * When a hole extent is found, return 1 and modify start/len.
> + */
> +static int find_first_non_hole(struct inode *inode, u64 *start, u64 *len)
> +{
> +       struct extent_map *em;
> +       int ret = 0;
> +
> +       em = btrfs_get_extent(inode, NULL, 0, *start, *len, 0);
> +       if (IS_ERR_OR_NULL(em)) {
> +               if (!em)
> +                       ret = -ENOMEM;
> +               else
> +                       ret = PTR_ERR(em);
> +               return ret;
> +       }
> +
> +       /* Hole or vacuum extent(only exists in no-hole mode) */
> +       if (em->block_start == EXTENT_MAP_HOLE) {
> +               ret = 1;
> +               *len = em->start + em->len > *start + *len ?
> +                      0 : *start + *len - em->start - em->len;
> +               *start = em->start + em->len;
> +       }
> +       free_extent_map(em);
> +       return ret;
> +}
> +
>  static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>  {
>         struct btrfs_root *root = BTRFS_I(inode)->root;
> @@ -2175,17 +2206,18 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>         struct btrfs_path *path;
>         struct btrfs_block_rsv *rsv;
>         struct btrfs_trans_handle *trans;
> -       u64 lockstart = round_up(offset, BTRFS_I(inode)->root->sectorsize);
> -       u64 lockend = round_down(offset + len,
> -                                BTRFS_I(inode)->root->sectorsize) - 1;
> -       u64 cur_offset = lockstart;
> +       u64 lockstart;
> +       u64 lockend;
> +       u64 tail_start;
> +       u64 tail_len;
> +       u64 orig_start = offset;
> +       u64 cur_offset;
>         u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
>         u64 drop_end;
>         int ret = 0;
>         int err = 0;
>         int rsv_count;
> -       bool same_page = ((offset >> PAGE_CACHE_SHIFT) ==
> -                         ((offset + len - 1) >> PAGE_CACHE_SHIFT));
> +       bool same_page;
>         bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
>         u64 ino_size = round_up(inode->i_size, PAGE_CACHE_SIZE);
>
> @@ -2194,6 +2226,21 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>                 return ret;
>
>         mutex_lock(&inode->i_mutex);
> +       ret = find_first_non_hole(inode, &offset, &len);
> +       if (ret < 0)
> +               goto out_only_mutex;
> +       if (ret && !len) {
> +               /* Already in a large hole */
> +               ret = 0;
> +               goto out_only_mutex;
> +       }
> +
> +       lockstart = round_up(offset , BTRFS_I(inode)->root->sectorsize);

Nitpick, this should have caused checkpatch.pl to emit a warning
(space after the comma).

> +       lockend = round_down(offset + len,
> +                            BTRFS_I(inode)->root->sectorsize) - 1;
> +       same_page = ((offset >> PAGE_CACHE_SHIFT) ==
> +                   ((offset + len - 1) >> PAGE_CACHE_SHIFT));
> +
>         /*
>          * We needn't truncate any page which is beyond the end of the file
>          * because we are sure there is no data there.
> @@ -2205,8 +2252,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>         if (same_page && len < PAGE_CACHE_SIZE) {
>                 if (offset < ino_size)
>                         ret = btrfs_truncate_page(inode, offset, len, 0);
> -               mutex_unlock(&inode->i_mutex);
> -               return ret;
> +               goto out_only_mutex;
>         }
>
>         /* zero back part of the first page */
> @@ -2218,12 +2264,39 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>                 }
>         }
>
> -       /* zero the front end of the last page */
> -       if (offset + len < ino_size) {
> -               ret = btrfs_truncate_page(inode, offset + len, 0, 1);
> -               if (ret) {
> -                       mutex_unlock(&inode->i_mutex);
> -                       return ret;
> +       /* Check the aligned pages after the first unaligned page,
> +        * if offset != orig_start, which means the first unaligned page
> +        * including serveral following pages are already in holes,
> +        * the extra check can be skipped */
> +       if (offset == orig_start) {
> +               /* after truncate page, check hole again */
> +               len = offset + len - lockstart;
> +               offset = lockstart;
> +               ret = find_first_non_hole(inode, &offset, &len);
> +               if (ret < 0)
> +                       goto out_only_mutex;
> +               if (ret && !len) {
> +                       ret = 0;
> +                       goto out_only_mutex;
> +               }
> +               lockstart = offset;
> +       }
> +
> +       /* Check the tail unaligned part is in a hole */
> +       tail_start = lockend + 1;
> +       tail_len = offset + len - tail_start;
> +       if (tail_len) {
> +               ret = find_first_non_hole(inode, &tail_start, &tail_len);
> +               if (unlikely(ret < 0))
> +                       goto out_only_mutex;
> +               if (!ret) {
> +                       /* zero the front end of the last page */
> +                       if (tail_start + tail_len < ino_size) {
> +                               ret = btrfs_truncate_page(inode,
> +                                               tail_start + tail_len, 0, 1);
> +                               if (ret)
> +                                       goto out_only_mutex;
> +                               }

Nitpick, this last } is not aligned (same indentation level) with its
matching {.

>                 }
>         }
>
> @@ -2299,6 +2372,8 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>         BUG_ON(ret);
>         trans->block_rsv = rsv;
>
> +       cur_offset = lockstart;
> +       len = lockend - cur_offset;
>         while (cur_offset < lockend) {
>                 ret = __btrfs_drop_extents(trans, root, inode, path,
>                                            cur_offset, lockend + 1,
> @@ -2339,6 +2414,14 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>                                               rsv, min_size);
>                 BUG_ON(ret);    /* shouldn't happen */
>                 trans->block_rsv = rsv;
> +
> +               ret = find_first_non_hole(inode, &cur_offset, &len);
> +               if (unlikely(ret < 0))
> +                       break;
> +               if (ret && !len) {
> +                       ret = 0;
> +                       break;
> +               }
>         }
>
>         if (ret) {
> @@ -2372,6 +2455,7 @@ out_free:
>  out:
>         unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
>                              &cached_state, GFP_NOFS);
> +out_only_mutex:
>         mutex_unlock(&inode->i_mutex);
>         if (ret && !err)
>                 err = ret;
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
