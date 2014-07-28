Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:39425 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaG1RYt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 13:24:49 -0400
Received: by mail-la0-f45.google.com with SMTP id ty20so5707795lab.32
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jul 2014 10:24:47 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1403955302-22396-3-git-send-email-miaox@cn.fujitsu.com>
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
	<1403955302-22396-3-git-send-email-miaox@cn.fujitsu.com>
Date: Mon, 28 Jul 2014 18:24:47 +0100
Message-ID: <CAL3q7H5ihcw404e4dYpoJU-hcSZJaKe=mBi38srFqdSLv8DoRg@mail.gmail.com>
Subject: Re: [PATCH 02/12] Btrfs: load checksum data once when submitting a
 direct read io
From: Filipe David Manana <fdmanana@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 28, 2014 at 12:34 PM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> The current code would load checksum data for several times when we split
> a whole direct read io because of the limit of the raid stripe, it would
> make us search the csum tree for several times. In fact, it just wasted time,
> and made the contention of the csum tree root be more serious. This patch
> improves this problem by loading the data at once.
>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/btrfs_inode.h |  1 -
>  fs/btrfs/ctree.h       |  3 +--
>  fs/btrfs/file-item.c   | 14 ++------------
>  fs/btrfs/inode.c       | 40 ++++++++++++++++++++++------------------
>  4 files changed, 25 insertions(+), 33 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 4794923..7e9f53b 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -263,7 +263,6 @@ struct btrfs_dio_private {
>
>         /* dio_bio came from fs/direct-io.c */
>         struct bio *dio_bio;
> -       u8 csum[0];
>  };
>
>  /*
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index be91397..40e9938 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3739,8 +3739,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
>  int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
>                           struct bio *bio, u32 *dst);
>  int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
> -                             struct btrfs_dio_private *dip, struct bio *bio,
> -                             u64 logical_offset);
> +                             struct bio *bio, u64 logical_offset);
>  int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
>                              struct btrfs_root *root,
>                              u64 objectid, u64 pos,
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index f46cfe4..cf1b94f 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -299,19 +299,9 @@ int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
>  }
>
>  int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
> -                             struct btrfs_dio_private *dip, struct bio *bio,
> -                             u64 offset)
> +                             struct bio *bio, u64 offset)
>  {
> -       int len = (bio->bi_iter.bi_sector << 9) - dip->disk_bytenr;
> -       u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
> -       int ret;
> -
> -       len >>= inode->i_sb->s_blocksize_bits;
> -       len *= csum_size;
> -
> -       ret = __btrfs_lookup_bio_sums(root, inode, bio, offset,
> -                                     (u32 *)(dip->csum + len), 1);
> -       return ret;
> +       return __btrfs_lookup_bio_sums(root, inode, bio, offset, NULL, 1);
>  }
>
>  int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a3f102f..969fb22 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7081,7 +7081,8 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
>         struct inode *inode = dip->inode;
>         struct btrfs_root *root = BTRFS_I(inode)->root;
>         struct bio *dio_bio;
> -       u32 *csums = (u32 *)dip->csum;
> +       struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
> +       u32 *csums = (u32 *)io_bio->csum;
>         u64 start;
>         int i;
>
> @@ -7123,6 +7124,9 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
>         if (err)
>                 clear_bit(BIO_UPTODATE, &dio_bio->bi_flags);
>         dio_end_io(dio_bio, err);
> +
> +       if (io_bio->end_io)
> +               io_bio->end_io(io_bio, err);
>         bio_put(bio);
>  }
>
> @@ -7261,13 +7265,20 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
>                 ret = btrfs_csum_one_bio(root, inode, bio, file_offset, 1);
>                 if (ret)
>                         goto err;
> -       } else if (!skip_sum) {
> -               ret = btrfs_lookup_bio_sums_dio(root, inode, dip, bio,
> +       } else {
> +               /*
> +                * We have loaded all the csum data we need when we submit
> +                * the first bio, so skip it.
> +                */
> +               if (dip->logical_offset != file_offset)
> +                       goto map;
> +
> +               /* Load all csum data at once. */
> +               ret = btrfs_lookup_bio_sums_dio(root, inode, dip->orig_bio,
>                                                 file_offset);
>                 if (ret)
>                         goto err;
>         }
> -
>  map:
>         ret = btrfs_map_bio(root, rw, bio, 0, async_submit);
>  err:
> @@ -7288,7 +7299,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
>         u64 submit_len = 0;
>         u64 map_length;
>         int nr_pages = 0;
> -       int ret = 0;
> +       int ret;
>         int async_submit = 0;
>
>         map_length = orig_bio->bi_iter.bi_size;
> @@ -7392,30 +7403,20 @@ static void btrfs_submit_direct(int rw, struct bio *dio_bio,
>         struct btrfs_root *root = BTRFS_I(inode)->root;
>         struct btrfs_dio_private *dip;
>         struct bio *io_bio;
> +       struct btrfs_io_bio *btrfs_bio;
>         int skip_sum;
> -       int sum_len;
>         int write = rw & REQ_WRITE;
>         int ret = 0;
> -       u16 csum_size;
>
>         skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
>
> -       io_bio = btrfs_bio_clone(dio_bio, GFP_NOFS);
> +       io_bio = btrfs_bio_clone(dio_bio, GFP_NOFS | __GFP_ZERO);

Hi Miao,

With this change (adding the __GFP_ZERO flag), I ran once into the
following warning while running xfstests (dunno exactly which test
case triggered it, likely one of those that run fsstress):

[ 3941.856860] ------------[ cut here ]------------
[ 3941.856871] WARNING: CPU: 0 PID: 4154 at mm/mempool.c:205
mempool_alloc+0xc8/0x1c0()
[ 3941.856873] Modules linked in: btrfs xor raid6_pq binfmt_misc nfsd
auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc i2c_piix4
i2c_core pcspkr evbug psmouse serio_raw e1000 [
last unloaded: btrfs]
[ 3941.856886] CPU: 0 PID: 4154 Comm: xfs_io Tainted: G        W
3.16.0-rc6-fdm-btrfs-next-37+ #1
[ 3941.856887] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 3941.856889]  0000000000000009 ffff8800d569f778 ffffffff8169a687
00000000000077b0
[ 3941.856892]  0000000000000000 ffff8800d569f7b8 ffffffff8104fb4c
00000000ffffffff
[ 3941.856894]  0000000000008050 0000000000000001 0000000000008050
ffff88004f921918
[ 3941.856896] Call Trace:
[ 3941.856901]  [<ffffffff8169a687>] dump_stack+0x4e/0x68
[ 3941.856904]  [<ffffffff8104fb4c>] warn_slowpath_common+0x8c/0xc0
[ 3941.856905]  [<ffffffff8104fb9a>] warn_slowpath_null+0x1a/0x20
[ 3941.856907]  [<ffffffff81151fc8>] mempool_alloc+0xc8/0x1c0
[ 3941.856911]  [<ffffffff810129cf>] ? save_stack_trace+0x2f/0x50
[ 3941.856918]  [<ffffffff8131331a>] bio_alloc_bioset+0x10a/0x1c0
[ 3941.856921]  [<ffffffff81314c68>] bio_clone_bioset+0x88/0x310
[ 3941.856923]  [<ffffffff81151a65>] ? mempool_alloc_slab+0x15/0x20
[ 3941.856936]  [<ffffffffa0209385>] btrfs_bio_clone+0x15/0x20 [btrfs]
[ 3941.856944]  [<ffffffffa01ed47f>] btrfs_submit_direct+0x4f/0x7b0 [btrfs]
[ 3941.856948]  [<ffffffff811fc10a>] ? do_blockdev_direct_IO+0x17ea/0x1f60
[ 3941.856952]  [<ffffffff810afb35>] ? mark_held_locks+0x75/0xa0
[ 3941.856955]  [<ffffffff816a383f>] ? _raw_spin_unlock_irqrestore+0x3f/0x70
[ 3941.856956]  [<ffffffff811fc13e>] do_blockdev_direct_IO+0x181e/0x1f60
[ 3941.856965]  [<ffffffffa01f86d0>] ?
btrfs_page_exists_in_range+0x2a0/0x2a0 [btrfs]
[ 3941.856972]  [<ffffffffa01ed430>] ?
btrfs_writepage_start_hook+0xf0/0xf0 [btrfs]
[ 3941.856974]  [<ffffffff811fc8cc>] __blockdev_direct_IO+0x4c/0x50
[ 3941.856981]  [<ffffffffa01f86d0>] ?
btrfs_page_exists_in_range+0x2a0/0x2a0 [btrfs]
[ 3941.856987]  [<ffffffffa01ed430>] ?
btrfs_writepage_start_hook+0xf0/0xf0 [btrfs]
[ 3941.856993]  [<ffffffffa01eb591>] btrfs_direct_IO+0x1a1/0x340 [btrfs]
[ 3941.856999]  [<ffffffffa01f86d0>] ?
btrfs_page_exists_in_range+0x2a0/0x2a0 [btrfs]
[ 3941.857005]  [<ffffffffa01ed430>] ?
btrfs_writepage_start_hook+0xf0/0xf0 [btrfs]
[ 3941.857007]  [<ffffffff81150210>] generic_file_direct_write+0xb0/0x180
[ 3941.857014]  [<ffffffffa01fc4a1>] btrfs_file_write_iter+0x411/0x560 [btrfs]
[ 3941.857017]  [<ffffffff811ba541>] new_sync_write+0x81/0xb0
[ 3941.857019]  [<ffffffff811bb342>] vfs_write+0xc2/0x1f0
[ 3941.857020]  [<ffffffff811bba2a>] SyS_pwrite64+0x9a/0xb0
[ 3941.857022]  [<ffffffff816a3d92>] system_call_fastpath+0x16/0x1b
[ 3941.857024] ---[ end trace c1dfd29523250709 ]---

Thanks.


>         if (!io_bio) {
>                 ret = -ENOMEM;
>                 goto free_ordered;
>         }
>
> -       if (!skip_sum && !write) {
> -               csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
> -               sum_len = dio_bio->bi_iter.bi_size >>
> -                       inode->i_sb->s_blocksize_bits;
> -               sum_len *= csum_size;
> -       } else {
> -               sum_len = 0;
> -       }
> -
> -       dip = kmalloc(sizeof(*dip) + sum_len, GFP_NOFS);
> +       dip = kmalloc(sizeof(*dip), GFP_NOFS);
>         if (!dip) {
>                 ret = -ENOMEM;
>                 goto free_io_bio;
> @@ -7441,6 +7442,9 @@ static void btrfs_submit_direct(int rw, struct bio *dio_bio,
>         if (!ret)
>                 return;
>
> +       btrfs_bio = btrfs_io_bio(io_bio);
> +       if (btrfs_bio->end_io)
> +               btrfs_bio->end_io(btrfs_bio, ret);
>  free_io_bio:
>         bio_put(io_bio);
>
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
