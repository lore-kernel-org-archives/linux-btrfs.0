Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38931 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3LMFnM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 00:43:12 -0500
Date: Fri, 13 Dec 2013 13:42:57 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v7 04/13] Btrfs: disable qgroups accounting when
 quata_enable is 0
Message-ID: <20131213054256.GA14429@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
 <1381726796-27191-5-git-send-email-bo.li.liu@oracle.com>
 <CAOcd+r17jar_CxrYhwQX4eeKLiFgjHDuLdptes04gG_LXtozrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOcd+r17jar_CxrYhwQX4eeKLiFgjHDuLdptes04gG_LXtozrg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 03, 2013 at 07:13:48PM +0200, Alex Lyakas wrote:
> Hi Liu, Jan,
> 
> What happens to "struct qgroup_update"s sitting in
> trans->qgroup_ref_list in case the transaction aborts? It seems that
> they are not freed.
> 
> For example, if we are in btrfs_commit_transaction() and:
> - call create_pending_snapshots()
> - call btrfs_run_delayed_items() and this fails
> So we go to cleanup_transaction() without calling
> btrfs_delayed_refs_qgroup_accounting(), which would have been called
> by btrfs_run_delayed_refs().
> 
> I receive kmemleak warnings about these thingies not being freed,
> although on an older kernel. However, looking at Josef's tree, this
> still seems to be the case.

I think you're right, but I'm sure because I cannot reproduce that somehow,
so I suggest to add a assert_qgroups_uptodate() in cleanup_transaction() in
order to catch that leak if there is.

thanks,
-liubo

> 
> Thanks,
> Alex.
> 
> 
> On Mon, Oct 14, 2013 at 7:59 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > It's unnecessary to do qgroups accounting without enabling quota.
> >
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/ctree.c       |    2 +-
> >  fs/btrfs/delayed-ref.c |   18 ++++++++++++++----
> >  fs/btrfs/qgroup.c      |    3 +++
> >  3 files changed, 18 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index 61b5bcd..fb89235 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -407,7 +407,7 @@ u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
> >
> >         tree_mod_log_write_lock(fs_info);
> >         spin_lock(&fs_info->tree_mod_seq_lock);
> > -       if (!elem->seq) {
> > +       if (elem && !elem->seq) {
> >                 elem->seq = btrfs_inc_tree_mod_seq_major(fs_info);
> >                 list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
> >         }
> > diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> > index 9e1a1c9..3ec3d08 100644
> > --- a/fs/btrfs/delayed-ref.c
> > +++ b/fs/btrfs/delayed-ref.c
> > @@ -691,8 +691,13 @@ static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
> >         ref->is_head = 0;
> >         ref->in_tree = 1;
> >
> > -       if (need_ref_seq(for_cow, ref_root))
> > -               seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
> > +       if (need_ref_seq(for_cow, ref_root)) {
> > +               struct seq_list *elem = NULL;
> > +
> > +               if (fs_info->quota_enabled)
> > +                       elem = &trans->delayed_ref_elem;
> > +               seq = btrfs_get_tree_mod_seq(fs_info, elem);
> > +       }
> >         ref->seq = seq;
> >
> >         full_ref = btrfs_delayed_node_to_tree_ref(ref);
> > @@ -750,8 +755,13 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
> >         ref->is_head = 0;
> >         ref->in_tree = 1;
> >
> > -       if (need_ref_seq(for_cow, ref_root))
> > -               seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
> > +       if (need_ref_seq(for_cow, ref_root)) {
> > +               struct seq_list *elem = NULL;
> > +
> > +               if (fs_info->quota_enabled)
> > +                       elem = &trans->delayed_ref_elem;
> > +               seq = btrfs_get_tree_mod_seq(fs_info, elem);
> > +       }
> >         ref->seq = seq;
> >
> >         full_ref = btrfs_delayed_node_to_data_ref(ref);
> > diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> > index 4e6ef49..1cb58f9 100644
> > --- a/fs/btrfs/qgroup.c
> > +++ b/fs/btrfs/qgroup.c
> > @@ -1188,6 +1188,9 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
> >  {
> >         struct qgroup_update *u;
> >
> > +       if (!trans->root->fs_info->quota_enabled)
> > +               return 0;
> > +
> >         BUG_ON(!trans->delayed_ref_elem.seq);
> >         u = kmalloc(sizeof(*u), GFP_NOFS);
> >         if (!u)
> > --
> > 1.7.7
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
