Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34668 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbbJWKBl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Oct 2015 06:01:41 -0400
Received: by iow1 with SMTP id 1so118906711iow.1
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2015 03:01:41 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1445565891-28121-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1445565891-28121-1-git-send-email-quwenruo@cn.fujitsu.com>
Date: Fri, 23 Oct 2015 11:01:41 +0100
Message-ID: <CAL3q7H4VNEjw2a88fJdLdXu_ksoUttPLG-rPeF3ZhkRjFWNuCA@mail.gmail.com>
Subject: Re: [PATCH v4] btrfs: qgroup: Don't copy extent buffer to do qgroup rescan
From: Filipe Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 23, 2015 at 3:04 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Ancient qgroup code call memcpy() on a extent buffer and use it for leaf
> iteration.
>
> As extent buffer contains lock, pointers to pages, it's never sane to do
> such copy.
>
> The following bug may be caused by this insane operation:
> [92098.841309] general protection fault: 0000 [#1] SMP
> [92098.841338] Modules linked in: ...
> [92098.841814] CPU: 1 PID: 24655 Comm: kworker/u4:12 Not tainted
> 4.3.0-rc1 #1
> [92098.841868] Workqueue: btrfs-qgroup-rescan btrfs_qgroup_rescan_helper
> [btrfs]
> [92098.842261] Call Trace:
> [92098.842277]  [<ffffffffc035a5d8>] ? read_extent_buffer+0xb8/0x110
> [btrfs]
> [92098.842304]  [<ffffffffc0396d00>] ? btrfs_find_all_roots+0x60/0x70
> [btrfs]
> [92098.842329]  [<ffffffffc039af3d>]
> btrfs_qgroup_rescan_worker+0x28d/0x5a0 [btrfs]
>
> Where btrfs_qgroup_rescan_worker+0x28d is btrfs_disk_key_to_cpu(),
> called in reading key from the copied extent_buffer.
>
> This patch will use btrfs_clone_extent_buffer() to a better copy of
> extent buffer to deal such case.
>
> Reported-by: Stephane Lesimple <stephane_btrfs@lesimple.fr>
> Suggested-by: Filipe Manana <fdmanana@kernel.org>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v2:
>   Follow the parameter change in previous patch.
> v3:
>   None
> v4:
>   Use btrfs_clone_extent_buffer() other than introducing new facilities
> ---
>  fs/btrfs/qgroup.c | 28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 158633c..5534629 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2192,10 +2192,10 @@ void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
>   */
>  static int
>  qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
> -                  struct btrfs_trans_handle *trans,
> -                  struct extent_buffer *scratch_leaf)
> +                  struct btrfs_trans_handle *trans)
>  {
>         struct btrfs_key found;
> +       struct extent_buffer *scratch_leaf = NULL;
>         struct ulist *roots = NULL;
>         struct seq_list tree_mod_seq_elem = SEQ_LIST_INIT(tree_mod_seq_elem);
>         u64 num_bytes;
> @@ -2233,9 +2233,17 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
>         fs_info->qgroup_rescan_progress.objectid = found.objectid + 1;
>
>         btrfs_get_tree_mod_seq(fs_info, &tree_mod_seq_elem);
> -       memcpy(scratch_leaf, path->nodes[0], sizeof(*scratch_leaf));
> -       slot = path->slots[0];
> +       scratch_leaf = btrfs_clone_extent_buffer(path->nodes[0]);
> +       if (!scratch_leaf) {
> +               ret = -ENOMEM;
> +               mutex_unlock(&fs_info->qgroup_rescan_lock);
> +               goto out;
> +       }
> +       extent_buffer_get(scratch_leaf);
> +       btrfs_tree_read_lock(scratch_leaf);
> +       btrfs_set_lock_blocking_rw(scratch_leaf, BTRFS_READ_LOCK);
>         btrfs_release_path(path);
> +       slot = path->slots[0];

Hi Qu,

You need to get the slot before releasing the path.
btrfs_release_path() sets all slots to 0.

thanks

>         mutex_unlock(&fs_info->qgroup_rescan_lock);
>
>         for (; slot < btrfs_header_nritems(scratch_leaf); ++slot) {
> @@ -2259,6 +2267,10 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
>                         goto out;
>         }
>  out:
> +       if (scratch_leaf) {
> +               btrfs_tree_read_unlock_blocking(scratch_leaf);
> +               free_extent_buffer(scratch_leaf);
> +       }
>         btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
>
>         return ret;
> @@ -2270,16 +2282,12 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>                                                      qgroup_rescan_work);
>         struct btrfs_path *path;
>         struct btrfs_trans_handle *trans = NULL;
> -       struct extent_buffer *scratch_leaf = NULL;
>         int err = -ENOMEM;
>         int ret = 0;
>
>         path = btrfs_alloc_path();
>         if (!path)
>                 goto out;
> -       scratch_leaf = kmalloc(sizeof(*scratch_leaf), GFP_NOFS);
> -       if (!scratch_leaf)
> -               goto out;
>
>         err = 0;
>         while (!err) {
> @@ -2291,8 +2299,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>                 if (!fs_info->quota_enabled) {
>                         err = -EINTR;
>                 } else {
> -                       err = qgroup_rescan_leaf(fs_info, path, trans,
> -                                                scratch_leaf);
> +                       err = qgroup_rescan_leaf(fs_info, path, trans);
>                 }
>                 if (err > 0)
>                         btrfs_commit_transaction(trans, fs_info->fs_root);
> @@ -2301,7 +2308,6 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>         }
>
>  out:
> -       kfree(scratch_leaf);
>         btrfs_free_path(path);
>
>         mutex_lock(&fs_info->qgroup_rescan_lock);
> --
> 2.6.2
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
