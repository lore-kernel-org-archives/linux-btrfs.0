From: Christian Brunner <chb@muc.de>
Subject: Re: [PATCH] Btrfs: allow us to overcommit our enospc reservations
 TEST THIS PLEASE!!!
Date: Thu, 13 Oct 2011 17:03:07 +0200
Message-ID: <CAO47_-_Kf1kH7JYPb1cEAPtY1n1d0NDUC_jhduC4bh8UA6unaQ@mail.gmail.com>
References: <1317072155-26792-1-git-send-email-josef@redhat.com>
	<CAKcLGm_oFQOCCeFs69ohGfskkCj1FSbdxL18653ANoTX75n4SQ@mail.gmail.com>
	<20111011190049.GG2293@localhost.localdomain>
	<CAKcLGm-JU1e4ssv9FQTieX-OmHgbc6hef8Rnsy_R7Jy3RwsznA@mail.gmail.com>
	<20111011200131.GH2293@localhost.localdomain>
	<CAKcLGm-y5on_dWjaNdSARd5_K5nri0G9zuMZAsV19ecuYmXH9g@mail.gmail.com>
	<20111012175047.GA14280@localhost.localdomain>
	<CAKcLGm_MMzv0rK169pZJyHu4r2=6xXBE0OjxcoLZVzLMkf3evg@mail.gmail.com>
	<20111013125746.GA2310@localhost.localdomain>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111013125746.GA2310@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

2011/10/13 Josef Bacik <josef@redhat.com>:
[...]
>> >> [ =A0175.956273] kernel BUG at fs/btrfs/inode.c:2176!
>> >
>> > Ok I think I see what's happening, this patch replaces the previou=
s one, let me
>> > know how it goes. =A0Thanks,
>> >
>>
>> Getting a slightly different BUG this time:
>>
>
> Ok looks like I've fixed the original problem and now we're hitting a=
 problem
> with the free space cache. =A0This patch will replace the last one, i=
ts all the
> fixes up to now and a new set of BUG_ON()'s to figure out which free =
space cache
> inode is screwing us up. =A0Thanks,
>
> Josef
>
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index fc0de68..e595372 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3334,7 +3334,7 @@ out:
> =A0* shrink metadata reservation for delalloc
> =A0*/
> =A0static int shrink_delalloc(struct btrfs_trans_handle *trans,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_roo=
t *root, u64 to_reclaim, int sync)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_roo=
t *root, u64 to_reclaim, int retries)
> =A0{
> =A0 =A0 =A0 =A0struct btrfs_block_rsv *block_rsv;
> =A0 =A0 =A0 =A0struct btrfs_space_info *space_info;
> @@ -3365,12 +3365,10 @@ static int shrink_delalloc(struct btrfs_trans=
_handle *trans,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0max_reclaim =3D min(reserved, to_reclaim);
> + =A0 =A0 =A0 if (max_reclaim > (2 * 1024 * 1024))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_pages =3D max_reclaim >> PAGE_CACHE_=
SHIFT;
>
> =A0 =A0 =A0 =A0while (loops < 1024) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* have the flusher threads jump in and=
 do some IO */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 smp_mb();
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_pages =3D min_t(unsigned long, nr_pa=
ges,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0root->fs_info->delalloc_=
bytes >> PAGE_CACHE_SHIFT);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0writeback_inodes_sb_nr_if_idle(root->f=
s_info->sb, nr_pages);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&space_info->lock);
> @@ -3384,14 +3382,22 @@ static int shrink_delalloc(struct btrfs_trans=
_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (reserved =3D=3D 0 || reclaimed >=3D=
 max_reclaim)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (trans && trans->transaction->blocke=
d)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (trans)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EAGAIN;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 time_left =3D schedule_timeout_interrup=
tible(1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!retries) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 time_left =3D schedule_=
timeout_interruptible(1);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We were interrupted, exit */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (time_left)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We were interrupted,=
 exit */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (time_left)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We've already done=
 this song and dance once, let's
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* really wait for so=
me work to get done.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_wait_ordered_exte=
nts(root, 0, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* we've kicked the IO a few times, if=
 anything has been freed,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * exit. =A0There is no sense in loopi=
ng here for a long time
> @@ -3399,15 +3405,13 @@ static int shrink_delalloc(struct btrfs_trans=
_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * just too many writers without enoug=
h free space
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (loops > 3) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!retries && loops > 3) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smp_mb();
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (progress !=3D spac=
e_info->reservation_progress)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 if (reclaimed < to_reclaim && !trans)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_wait_ordered_extents(root, 0, 0);
> =A0 =A0 =A0 =A0return reclaimed >=3D to_reclaim;
> =A0}
>
> @@ -3552,7 +3556,7 @@ again:
> =A0 =A0 =A0 =A0 * We do synchronous shrinking since we don't actually=
 unreserve
> =A0 =A0 =A0 =A0 * metadata until after the IO is completed.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 ret =3D shrink_delalloc(trans, root, num_bytes, 1);
> + =A0 =A0 =A0 ret =3D shrink_delalloc(trans, root, num_bytes, retries=
);
> =A0 =A0 =A0 =A0if (ret < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> @@ -3568,17 +3572,6 @@ again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto again;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* Not enough space to be reclaimed, don't bother com=
mitting the
> - =A0 =A0 =A0 =A0* transaction.
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 spin_lock(&space_info->lock);
> - =A0 =A0 =A0 if (space_info->bytes_pinned < orig_bytes)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOSPC;
> - =A0 =A0 =A0 spin_unlock(&space_info->lock);
> - =A0 =A0 =A0 if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> -
> =A0 =A0 =A0 =A0ret =3D -EAGAIN;
> =A0 =A0 =A0 =A0if (trans)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d6ba353..cb63904 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -782,7 +782,8 @@ static noinline int cow_file_range(struct inode *=
inode,
> =A0 =A0 =A0 =A0struct extent_map_tree *em_tree =3D &BTRFS_I(inode)->e=
xtent_tree;
> =A0 =A0 =A0 =A0int ret =3D 0;
>
> - =A0 =A0 =A0 BUG_ON(btrfs_is_free_space_inode(root, inode));
> + =A0 =A0 =A0 BUG_ON(root =3D=3D root->fs_info->tree_root);
> + =A0 =A0 =A0 BUG_ON(BTRFS_I(inode)->location.objectid =3D=3D BTRFS_F=
REE_INO_OBJECTID);
> =A0 =A0 =A0 =A0trans =3D btrfs_join_transaction(root);
> =A0 =A0 =A0 =A0BUG_ON(IS_ERR(trans));
> =A0 =A0 =A0 =A0trans->block_rsv =3D &root->fs_info->delalloc_block_rs=
v;
> @@ -2790,7 +2791,8 @@ static struct btrfs_trans_handle *__unlink_star=
t_trans(struct inode *dir,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ERR_PTR(-ENOMEM);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 trans =3D btrfs_start_transaction(root, 0);
> + =A0 =A0 =A0 /* 1 for the orphan item */
> + =A0 =A0 =A0 trans =3D btrfs_start_transaction(root, 1);
> =A0 =A0 =A0 =A0if (IS_ERR(trans)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_free_path(path);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0root->fs_info->enospc_unlink =3D 0;

Could it be, that the missing space for the orphan item, is the reason
for our warning?

[  105.209232] ------------[ cut here ]------------
[  105.214458] WARNING: at fs/btrfs/inode.c:2114
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[  105.223794] Hardware name: ProLiant DL180 G6
[  105.228930] Modules linked in: btrfs zlib_deflate libcrc32c bonding
ipv6 serio_raw pcspkr ghes hed iTCO_wdt iTCO_vendor_support
i7core_edac edac_core ixgbe dca mdio iomemory_vsl(P) hpsa squashfs
[last unloaded: scsi_wait_scan]
[  105.253539] Pid: 1774, comm: kworker/0:2 Tainted: P
3.0.6-1.fits.2.el6.x86_64 #1
[  105.263015] Call Trace:
[  105.265956]  [<ffffffff8106344f>] warn_slowpath_common+0x7f/0xc0
[  105.272841]  [<ffffffff810634aa>] warn_slowpath_null+0x1a/0x20
[  105.279503]  [<ffffffffa022bef0>] btrfs_orphan_commit_root+0xb0/0xc0=
 [btrfs]
[  105.287564]  [<ffffffffa0226ce5>] commit_fs_roots+0xc5/0x1b0 [btrfs]
[  105.294824]  [<ffffffffa0227c36>]
btrfs_commit_transaction+0x3c6/0x820 [btrfs]
[  105.303044]  [<ffffffff810507c0>] ? __dequeue_entity+0x30/0x50
[  105.309745]  [<ffffffff81086410>] ? wake_up_bit+0x40/0x40
[  105.315944]  [<ffffffffa0228090>] ?
btrfs_commit_transaction+0x820/0x820 [btrfs]
[  105.324404]  [<ffffffffa02280af>] do_async_commit+0x1f/0x30 [btrfs]
[  105.331590]  [<ffffffff8107e8b8>] process_one_work+0x128/0x450
[  105.338291]  [<ffffffff810816cb>] worker_thread+0x17b/0x3c0
[  105.344708]  [<ffffffff81081550>] ? manage_workers+0x220/0x220
[  105.351407]  [<ffffffff81085d96>] kthread+0x96/0xa0
[  105.357040]  [<ffffffff815639c4>] kernel_thread_helper+0x4/0x10
[  105.363824]  [<ffffffff81085d00>] ? kthread_worker_fn+0x1a0/0x1a0
[  105.370776]  [<ffffffff815639c0>] ? gs_change+0x13/0x13
[  105.376771] ---[ end trace 144230b62b45be67 ]---

Thanks,
Christian

> @@ -2901,6 +2903,11 @@ out:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ERR_PTR(err);
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 ret =3D btrfs_block_rsv_migrate(trans->block_rsv,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &root->fs_info->global_block_rsv,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 btrfs_calc_trans_metadata_size(root, 1));
> + =A0 =A0 =A0 BUG_ON(ret);
> +
> =A0 =A0 =A0 =A0trans->block_rsv =3D &root->fs_info->global_block_rsv;
> =A0 =A0 =A0 =A0return trans;
> =A0}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
