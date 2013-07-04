Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52063 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3GDP3Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 11:29:24 -0400
Received: by mail-wg0-f48.google.com with SMTP id f11so1244739wgh.15
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jul 2013 08:29:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363101208-30184-1-git-send-email-dsterba@suse.cz>
References: <1363101208-30184-1-git-send-email-dsterba@suse.cz>
Date: Thu, 4 Jul 2013 18:29:23 +0300
Message-ID: <CAOcd+r0RM0YD+Ycky9S_h-LtLAkkztL1z-Ppp8W_85DuQP0t7w@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: clean snapshots one by one
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,
I believe this patch has the following problem:

On Tue, Mar 12, 2013 at 5:13 PM, David Sterba <dsterba@suse.cz> wrote:
> Each time pick one dead root from the list and let the caller know if
> it's needed to continue. This should improve responsiveness during
> umount and balance which at some point waits for cleaning all currently
> queued dead roots.
>
> A new dead root is added to the end of the list, so the snapshots
> disappear in the order of deletion.
>
> The snapshot cleaning work is now done only from the cleaner thread and the
> others wake it if needed.
>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>
> v1,v2:
> * http://thread.gmane.org/gmane.comp.file-systems.btrfs/23212
>
> v2->v3:
> * remove run_again from btrfs_clean_one_deleted_snapshot and return 1
>   unconditionally
>
>  fs/btrfs/disk-io.c     |   10 ++++++--
>  fs/btrfs/extent-tree.c |    8 ++++++
>  fs/btrfs/relocation.c  |    3 --
>  fs/btrfs/transaction.c |   56 +++++++++++++++++++++++++++++++----------------
>  fs/btrfs/transaction.h |    2 +-
>  5 files changed, 53 insertions(+), 26 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 988b860..4de2351 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1690,15 +1690,19 @@ static int cleaner_kthread(void *arg)
>         struct btrfs_root *root = arg;
>
>         do {
> +               int again = 0;
> +
>                 if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
> +                   down_read_trylock(&root->fs_info->sb->s_umount) &&
>                     mutex_trylock(&root->fs_info->cleaner_mutex)) {
>                         btrfs_run_delayed_iputs(root);
> -                       btrfs_clean_old_snapshots(root);
> +                       again = btrfs_clean_one_deleted_snapshot(root);
>                         mutex_unlock(&root->fs_info->cleaner_mutex);
>                         btrfs_run_defrag_inodes(root->fs_info);
> +                       up_read(&root->fs_info->sb->s_umount);
>                 }
>
> -               if (!try_to_freeze()) {
> +               if (!try_to_freeze() && !again) {
>                         set_current_state(TASK_INTERRUPTIBLE);
>                         if (!kthread_should_stop())
>                                 schedule();
> @@ -3403,8 +3407,8 @@ int btrfs_commit_super(struct btrfs_root *root)
>
>         mutex_lock(&root->fs_info->cleaner_mutex);
>         btrfs_run_delayed_iputs(root);
> -       btrfs_clean_old_snapshots(root);
>         mutex_unlock(&root->fs_info->cleaner_mutex);
> +       wake_up_process(root->fs_info->cleaner_kthread);
>
>         /* wait until ongoing cleanup work done */
>         down_write(&root->fs_info->cleanup_work_sem);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 742b7a7..a08d0fe 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7263,6 +7263,8 @@ static noinline int walk_up_tree(struct btrfs_trans_handle *trans,
>   * reference count by one. if update_ref is true, this function
>   * also make sure backrefs for the shared block and all lower level
>   * blocks are properly updated.
> + *
> + * If called with for_reloc == 0, may exit early with -EAGAIN
>   */
>  int btrfs_drop_snapshot(struct btrfs_root *root,
>                          struct btrfs_block_rsv *block_rsv, int update_ref,
> @@ -7363,6 +7365,12 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>         wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
>
>         while (1) {
> +               if (!for_reloc && btrfs_fs_closing(root->fs_info)) {
> +                       pr_debug("btrfs: drop snapshot early exit\n");
> +                       err = -EAGAIN;
> +                       goto out_end_trans;
> +               }
Here you exit the loop, but the "drop_progress" in the root item is
incorrect. When the system is remounted, and snapshot deletion
resumes, it seems that it tries to resume from the EXTENT_ITEM that
does not exist anymore, and [1] shows that btrfs_lookup_extent_info()
simply does not find the needed extent.
So then I hit panic in walk_down_tree():
BUG: wc->refs[level - 1] == 0

I fixed it like follows:
There is a place where btrfs_drop_snapshot() checks if it needs to
detach from transaction and re-attach. So I moved the exit point there
and the code is like this:

		if (btrfs_should_end_transaction(trans, tree_root) ||
			(!for_reloc && btrfs_need_cleaner_sleep(root))) {
			ret = btrfs_update_root(trans, tree_root,
						&root->root_key,
						root_item);
			if (ret) {
				btrfs_abort_transaction(trans, tree_root, ret);
				err = ret;
				goto out_end_trans;
			}

			btrfs_end_transaction_throttle(trans, tree_root);
			if (!for_reloc && btrfs_need_cleaner_sleep(root)) {
				err = -EAGAIN;
				goto out_free;
			}
			trans = btrfs_start_transaction(tree_root, 0);
...

With this fix, I do not hit the panic, and snapshot deletion proceeds
and completes alright after mount.

Do you agree to my analysis or I am missing something? It seems that
Josef's btrfs-next still has this issue (as does Chris's for-linus).

> +
>                 ret = walk_down_tree(trans, root, path, wc);
>                 if (ret < 0) {
>                         err = ret;
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 8445000..50deb9ed 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4148,10 +4148,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
>
>         while (1) {
>                 mutex_lock(&fs_info->cleaner_mutex);
> -
> -               btrfs_clean_old_snapshots(fs_info->tree_root);
>                 ret = relocate_block_group(rc);
> -
>                 mutex_unlock(&fs_info->cleaner_mutex);
>                 if (ret < 0) {
>                         err = ret;
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index a0467eb..a2781c3 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -950,7 +950,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
>  int btrfs_add_dead_root(struct btrfs_root *root)
>  {
>         spin_lock(&root->fs_info->trans_lock);
> -       list_add(&root->root_list, &root->fs_info->dead_roots);
> +       list_add_tail(&root->root_list, &root->fs_info->dead_roots);
>         spin_unlock(&root->fs_info->trans_lock);
>         return 0;
>  }
> @@ -1876,31 +1876,49 @@ cleanup_transaction:
>  }
>
>  /*
> - * interface function to delete all the snapshots we have scheduled for deletion
> + * return < 0 if error
> + * 0 if there are no more dead_roots at the time of call
> + * 1 there are more to be processed, call me again
> + *
> + * The return value indicates there are certainly more snapshots to delete, but
> + * if there comes a new one during processing, it may return 0. We don't mind,
> + * because btrfs_commit_super will poke cleaner thread and it will process it a
> + * few seconds later.
>   */
> -int btrfs_clean_old_snapshots(struct btrfs_root *root)
> +int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
>  {
> -       LIST_HEAD(list);
> +       int ret;
>         struct btrfs_fs_info *fs_info = root->fs_info;
>
> +       if (fs_info->sb->s_flags & MS_RDONLY) {
> +               pr_debug("btrfs: cleaner called for RO fs!\n");
> +               return 0;
> +       }
> +
>         spin_lock(&fs_info->trans_lock);
> -       list_splice_init(&fs_info->dead_roots, &list);
> +       if (list_empty(&fs_info->dead_roots)) {
> +               spin_unlock(&fs_info->trans_lock);
> +               return 0;
> +       }
> +       root = list_first_entry(&fs_info->dead_roots,
> +                       struct btrfs_root, root_list);
> +       list_del(&root->root_list);
>         spin_unlock(&fs_info->trans_lock);
>
> -       while (!list_empty(&list)) {
> -               int ret;
> -
> -               root = list_entry(list.next, struct btrfs_root, root_list);
> -               list_del(&root->root_list);
> +       pr_debug("btrfs: cleaner removing %llu\n",
> +                       (unsigned long long)root->objectid);
>
> -               btrfs_kill_all_delayed_nodes(root);
> +       btrfs_kill_all_delayed_nodes(root);
>
> -               if (btrfs_header_backref_rev(root->node) <
> -                   BTRFS_MIXED_BACKREF_REV)
> -                       ret = btrfs_drop_snapshot(root, NULL, 0, 0);
> -               else
> -                       ret =btrfs_drop_snapshot(root, NULL, 1, 0);
> -               BUG_ON(ret < 0);
> -       }
> -       return 0;
> +       if (btrfs_header_backref_rev(root->node) <
> +                       BTRFS_MIXED_BACKREF_REV)
> +               ret = btrfs_drop_snapshot(root, NULL, 0, 0);
> +       else
> +               ret = btrfs_drop_snapshot(root, NULL, 1, 0);
> +       /*
> +        * If we encounter a transaction abort during snapshot cleaning, we
> +        * don't want to crash here
> +        */
> +       BUG_ON(ret < 0 && (ret != -EAGAIN || ret != -EROFS));
> +       return 1;
>  }
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 3c8e0d2..f6edd5e 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -123,7 +123,7 @@ int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
>
>  int btrfs_add_dead_root(struct btrfs_root *root);
>  int btrfs_defrag_root(struct btrfs_root *root);
> -int btrfs_clean_old_snapshots(struct btrfs_root *root);
> +int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root);
>  int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>                              struct btrfs_root *root);
>  int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
> --
> 1.7.9
>

Thanks,
Alex.


[1]
 kernel: [ 1306.640085] ------------[ cut here ]------------
 kernel: [ 1306.640117] WARNING: at
/mnt/work/alex/zadara-btrfs/fs/btrfs/extent-tree.c:823
btrfs_lookup_extent_info+0x39b/0x3a0 [btrfs]()
 kernel: [ 1306.640119] Hardware name: Bochs
 kernel: [ 1306.640120] Modules linked in: dm_btrfs(OF) raid1(OF)
xt_multiport btrfs(OF) xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack iptable_filter ip_tables x_tables ib_iser
rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi xfrm_user xfrm4_tunnel
tunnel4 ipcomp xfrm_ipcomp esp4 ah4 8021q garp stp llc bonding
dm_zcache(OF) dm_iostat(OF) deflate zlib_deflate ctr twofish_generic
twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic
camellia_x86_64 serpent_sse2_x86_64 glue_helper lrw serpent_generic
xts gf128mul blowfish_generic blowfish_x86_64 blowfish_common
ablk_helper cryptd cast5_generic cast_common des_generic xcbc rmd160
scst_vdisk(OF) crypto_null iscsi_scst(OF) af_key xfrm_algo scst(OF)
libcrc32c kvm cirrus ttm drm_kms_helper microcode psmouse
virtio_balloon serio_raw drm sysimgblt sysfillrect syscopyarea
nfsd(OF) nfs_acl nfsv4 i2c_piix4 auth_rpcgss nfs fscache lockd sunrpc
mac_hid lp parport floppy i
 kernel: xgbevf [last unloaded: btrfs]
 kernel: [ 1306.640204] Pid: 31823, comm: btrfs-cleaner Tainted: GF
      O 3.8.13-030813-generic #201305111843
 kernel: [ 1306.640206] Call Trace:
 kernel: [ 1306.640216]  [<ffffffff8105990f>] warn_slowpath_common+0x7f/0xc0
 kernel: [ 1306.640219]  [<ffffffff8105996a>] warn_slowpath_null+0x1a/0x20
 kernel: [ 1306.640228]  [<ffffffffa06c98fb>]
btrfs_lookup_extent_info+0x39b/0x3a0 [btrfs]
 kernel: [ 1306.640242]  [<ffffffffa07046f5>] ?
alloc_extent_buffer+0x355/0x3e0 [btrfs]
 kernel: [ 1306.640251]  [<ffffffffa06cca19>] do_walk_down+0x109/0x600 [btrfs]
 kernel: [ 1306.640255]  [<ffffffff8106b4ef>] ? try_to_del_timer_sync+0x4f/0x70
 kernel: [ 1306.640262]  [<ffffffffa06b8e5a>] ?
btrfs_free_path+0x2a/0x40 [btrfs]
 kernel: [ 1306.640271]  [<ffffffffa06ccfd9>] walk_down_tree+0xc9/0x100 [btrfs]
 kernel: [ 1306.640280]  [<ffffffffa06d066b>]
btrfs_drop_snapshot+0x5eb/0xbe0 [btrfs]
 kernel: [ 1306.640294]  [<ffffffffa072ff70>] ?
btrfs_kill_all_delayed_nodes+0xf0/0x110 [btrfs]
 kernel: [ 1306.640305]  [<ffffffffa06e53a7>]
btrfs_clean_old_snapshots+0x127/0x1d0 [btrfs]
 kernel: [ 1306.640315]  [<ffffffffa06dc740>]
cleaner_kthread+0x300/0x380 [btrfs]
 kernel: [ 1306.640325]  [<ffffffffa06dc440>] ?
btrfs_destroy_delayed_refs.isra.105+0x220/0x220 [btrfs]
 kernel: [ 1306.640329]  [<ffffffff8107f050>] kthread+0xc0/0xd0
 kernel: [ 1306.640331]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
 kernel: [ 1306.640335]  [<ffffffff816f61ec>] ret_from_fork+0x7c/0xb0
 kernel: [ 1306.640337]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
 kernel: [ 1306.640339] ---[ end trace f5a6c532b98c6e92 ]---
 kernel: [ 1306.640343] [31823]btrfs*[do_walk_down:6780] BUG:
wc->refs[level - 1] == 0
 kernel: [ 1306.640343]
 kernel: [ 1306.640345] Pid: 31823, comm: btrfs-cleaner Tainted: GF
   W  O 3.8.13-030813-generic #201305111843
 kernel: [ 1306.640346] Call Trace:
 kernel: [ 1306.640355]  [<ffffffffa06cce77>] do_walk_down+0x567/0x600 [btrfs]
 kernel: [ 1306.640357]  [<ffffffff8106b4ef>] ? try_to_del_timer_sync+0x4f/0x70
 kernel: [ 1306.640365]  [<ffffffffa06b8e5a>] ?
btrfs_free_path+0x2a/0x40 [btrfs]
 kernel: [ 1306.640373]  [<ffffffffa06ccfd9>] walk_down_tree+0xc9/0x100 [btrfs]
 kernel: [ 1306.640382]  [<ffffffffa06d066b>]
btrfs_drop_snapshot+0x5eb/0xbe0 [btrfs]
 kernel: [ 1306.640395]  [<ffffffffa072ff70>] ?
btrfs_kill_all_delayed_nodes+0xf0/0x110 [btrfs]
 kernel: [ 1306.640406]  [<ffffffffa06e53a7>]
btrfs_clean_old_snapshots+0x127/0x1d0 [btrfs]
 kernel: [ 1306.640416]  [<ffffffffa06dc740>]
cleaner_kthread+0x300/0x380 [btrfs]
 kernel: [ 1306.640426]  [<ffffffffa06dc440>] ?
btrfs_destroy_delayed_refs.isra.105+0x220/0x220 [btrfs]
 kernel: [ 1306.640429]  [<ffffffff8107f050>] kthread+0xc0/0xd0
 kernel: [ 1306.640431]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
 kernel: [ 1306.640433]  [<ffffffff816f61ec>] ret_from_fork+0x7c/0xb0
 kernel: [ 1306.640435]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
 kernel: [ 1306.640437] Kernel panic - not syncing: BUG:
wc->refs[level - 1] == 0
