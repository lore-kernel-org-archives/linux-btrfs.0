Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50910 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757712Ab3BVXqN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 18:46:13 -0500
Date: Sat, 23 Feb 2013 00:46:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH] btrfs: clean snapshots one by one
Message-ID: <20130222234608.GP27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360599099-30657-1-git-send-email-dsterba@suse.cz>
 <CAOcd+r152Ot9RYjGfCc_sW46BNKuKrhEN=xR_hw_9QKSu5Agpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOcd+r152Ot9RYjGfCc_sW46BNKuKrhEN=xR_hw_9QKSu5Agpw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 17, 2013 at 09:55:23PM +0200, Alex Lyakas wrote:
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -1635,15 +1635,17 @@ static int cleaner_kthread(void *arg)
> >         struct btrfs_root *root = arg;
> >
> >         do {
> > +               int again = 0;
> > +
> >                 if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
> >                     mutex_trylock(&root->fs_info->cleaner_mutex)) {
> >                         btrfs_run_delayed_iputs(root);
> > -                       btrfs_clean_old_snapshots(root);
> > +                       again = btrfs_clean_one_deleted_snapshot(root);
> >                         mutex_unlock(&root->fs_info->cleaner_mutex);
> >                         btrfs_run_defrag_inodes(root->fs_info);
> >                 }
> >
> > -               if (!try_to_freeze()) {
> > +               if (!try_to_freeze() && !again) {
> >                         set_current_state(TASK_INTERRUPTIBLE);
> >                         if (!kthread_should_stop())
> >                                 schedule();
> > @@ -3301,8 +3303,8 @@ int btrfs_commit_super(struct btrfs_root *root)
> >
> >         mutex_lock(&root->fs_info->cleaner_mutex);
> >         btrfs_run_delayed_iputs(root);
> > -       btrfs_clean_old_snapshots(root);
> >         mutex_unlock(&root->fs_info->cleaner_mutex);
> > +       wake_up_process(root->fs_info->cleaner_kthread);
> I am probably missing something, but if the cleaner wakes up here,
> won't it attempt cleaning the next snap? Because I don't see the
> cleaner checking anywhere that we are unmounting. Or at this point
> dead_roots is supposed to be empty?

No, you're right, the check of umount semaphore is missing (was in the
dusted patchset and was titled 'avoid cleaner deadlock' which we solve
now in another way, so I did not realize the patch is actually needed).
So, this hunk should do it:

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1627,11 +1627,13 @@ static int cleaner_kthread(void *arg)
                int again = 0;

                if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
+                   down_read_trylock(&root->fs_info->sb->s_umount) &&
                    mutex_trylock(&root->fs_info->cleaner_mutex)) {
                        btrfs_run_delayed_iputs(root);
                        again = btrfs_clean_one_deleted_snapshot(root);
                        mutex_unlock(&root->fs_info->cleaner_mutex);
                        btrfs_run_defrag_inodes(root->fs_info);
+                       up_read(&root->fs_info->sb->s_umount);
                }

                if (!try_to_freeze() && !again) {
---

Seems that also checking for btrfs_fs_closing != 0 would help here.

And to the second part, no dead_roots is not supposed to be empty.

> > @@ -1783,31 +1783,50 @@ cleanup_transaction:
> >  }
> >
> >  /*
> > - * interface function to delete all the snapshots we have scheduled for deletion
> > + * return < 0 if error
> > + * 0 if there are no more dead_roots at the time of call
> > + * 1 there are more to be processed, call me again
> > + *
> > + * The return value indicates there are certainly more snapshots to delete, but
> > + * if there comes a new one during processing, it may return 0. We don't mind,
> > + * because btrfs_commit_super will poke cleaner thread and it will process it a
> > + * few seconds later.
> >   */
> > -int btrfs_clean_old_snapshots(struct btrfs_root *root)
> > +int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
> >  {
> > -       LIST_HEAD(list);
> > +       int ret;
> > +       int run_again = 1;
> >         struct btrfs_fs_info *fs_info = root->fs_info;
> >
> > +       if (root->fs_info->sb->s_flags & MS_RDONLY) {
> > +               pr_debug(G "btrfs: cleaner called for RO fs!\n");
> > +               return 0;
> > +       }
> > +
> >         spin_lock(&fs_info->trans_lock);
> > -       list_splice_init(&fs_info->dead_roots, &list);
> > +       if (list_empty(&fs_info->dead_roots)) {
> > +               spin_unlock(&fs_info->trans_lock);
> > +               return 0;
> > +       }
> > +       root = list_first_entry(&fs_info->dead_roots,
> > +                       struct btrfs_root, root_list);
> > +       list_del(&root->root_list);
> >         spin_unlock(&fs_info->trans_lock);
> >
> > -       while (!list_empty(&list)) {
> > -               int ret;
> > -
> > -               root = list_entry(list.next, struct btrfs_root, root_list);
> > -               list_del(&root->root_list);
> > +       pr_debug("btrfs: cleaner removing %llu\n",
> > +                       (unsigned long long)root->objectid);
> >
> > -               btrfs_kill_all_delayed_nodes(root);
> > +       btrfs_kill_all_delayed_nodes(root);
> >
> > -               if (btrfs_header_backref_rev(root->node) <
> > -                   BTRFS_MIXED_BACKREF_REV)
> > -                       ret = btrfs_drop_snapshot(root, NULL, 0, 0);
> > -               else
> > -                       ret =btrfs_drop_snapshot(root, NULL, 1, 0);
> > -               BUG_ON(ret < 0);
> > -       }
> > -       return 0;
> > +       if (btrfs_header_backref_rev(root->node) <
> > +                       BTRFS_MIXED_BACKREF_REV)
> > +               ret = btrfs_drop_snapshot(root, NULL, 0, 0);
> > +       else
> > +               ret = btrfs_drop_snapshot(root, NULL, 1, 0);
> > +       /*
> > +        * If we encounter a transaction abort during snapshot cleaning, we
> > +        * don't want to crash here
> > +        */
> > +       BUG_ON(ret < 0 && (ret != -EAGAIN || ret != -EROFS));
> > +       return run_again || ret == -EAGAIN;
> Can you tell me when btrfs_drop_snapshot is supposed to return EAGAIN?

That's another inconsistency of this patch, sorry.

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6976,6 +6976,12 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
        wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);

        while (1) {
+               if (btrfs_fs_closing(root->fs_info)) {
+                       printk(KERN_DEBUG "btrfs: drop snapshot early exit\n");
+                       err = -EAGAIN;
+                       goto out_end_trans;
+               }
+
                ret = walk_down_tree(trans, root, path, wc);
                if (ret < 0) {
                        err = ret;
---

ie. the main loop in drop_snapshot checks for fs going down and returns EAGAIN
in that case. Initially the hunk was there, but drop_snapshot is also called
from inside reloc loop and the callers do not expect to end it early. (Though
it's possible to enhance the exit paths, it's beyond of this patch now.)

Fortunatelly there's the for_reloc argument in

6921 int btrfs_drop_snapshot(struct btrfs_root *root,
6922                          struct btrfs_block_rsv *block_rsv, int update_ref,
6923                          int for_reloc)
6924 {

so we can safely exit early only if it's not in reloc.

Thanks for your comments, I'll send updated version.


david
