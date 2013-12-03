Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:49827 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3LCRNt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Dec 2013 12:13:49 -0500
Received: by mail-wg0-f45.google.com with SMTP id y10so11994170wgg.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Dec 2013 09:13:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1381726796-27191-5-git-send-email-bo.li.liu@oracle.com>
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
	<1381726796-27191-5-git-send-email-bo.li.liu@oracle.com>
Date: Tue, 3 Dec 2013 19:13:48 +0200
Message-ID: <CAOcd+r17jar_CxrYhwQX4eeKLiFgjHDuLdptes04gG_LXtozrg@mail.gmail.com>
Subject: Re: [PATCH v7 04/13] Btrfs: disable qgroups accounting when
 quata_enable is 0
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Liu Bo <bo.li.liu@oracle.com>, Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu, Jan,

What happens to "struct qgroup_update"s sitting in
trans->qgroup_ref_list in case the transaction aborts? It seems that
they are not freed.

For example, if we are in btrfs_commit_transaction() and:
- call create_pending_snapshots()
- call btrfs_run_delayed_items() and this fails
So we go to cleanup_transaction() without calling
btrfs_delayed_refs_qgroup_accounting(), which would have been called
by btrfs_run_delayed_refs().

I receive kmemleak warnings about these thingies not being freed,
although on an older kernel. However, looking at Josef's tree, this
still seems to be the case.

Thanks,
Alex.


On Mon, Oct 14, 2013 at 7:59 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> It's unnecessary to do qgroups accounting without enabling quota.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/ctree.c       |    2 +-
>  fs/btrfs/delayed-ref.c |   18 ++++++++++++++----
>  fs/btrfs/qgroup.c      |    3 +++
>  3 files changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 61b5bcd..fb89235 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -407,7 +407,7 @@ u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
>
>         tree_mod_log_write_lock(fs_info);
>         spin_lock(&fs_info->tree_mod_seq_lock);
> -       if (!elem->seq) {
> +       if (elem && !elem->seq) {
>                 elem->seq = btrfs_inc_tree_mod_seq_major(fs_info);
>                 list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
>         }
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 9e1a1c9..3ec3d08 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -691,8 +691,13 @@ static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>         ref->is_head = 0;
>         ref->in_tree = 1;
>
> -       if (need_ref_seq(for_cow, ref_root))
> -               seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
> +       if (need_ref_seq(for_cow, ref_root)) {
> +               struct seq_list *elem = NULL;
> +
> +               if (fs_info->quota_enabled)
> +                       elem = &trans->delayed_ref_elem;
> +               seq = btrfs_get_tree_mod_seq(fs_info, elem);
> +       }
>         ref->seq = seq;
>
>         full_ref = btrfs_delayed_node_to_tree_ref(ref);
> @@ -750,8 +755,13 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>         ref->is_head = 0;
>         ref->in_tree = 1;
>
> -       if (need_ref_seq(for_cow, ref_root))
> -               seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
> +       if (need_ref_seq(for_cow, ref_root)) {
> +               struct seq_list *elem = NULL;
> +
> +               if (fs_info->quota_enabled)
> +                       elem = &trans->delayed_ref_elem;
> +               seq = btrfs_get_tree_mod_seq(fs_info, elem);
> +       }
>         ref->seq = seq;
>
>         full_ref = btrfs_delayed_node_to_data_ref(ref);
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 4e6ef49..1cb58f9 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1188,6 +1188,9 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
>  {
>         struct qgroup_update *u;
>
> +       if (!trans->root->fs_info->quota_enabled)
> +               return 0;
> +
>         BUG_ON(!trans->delayed_ref_elem.seq);
>         u = kmalloc(sizeof(*u), GFP_NOFS);
>         if (!u)
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
