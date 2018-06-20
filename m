Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55713 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751166AbeFTNr0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 09:47:26 -0400
Date: Wed, 20 Jun 2018 15:44:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/4] btrfs: always wait on ordered extents at fsync time
Message-ID: <20180620134434.GZ24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180523155836.4622-1-josef@toxicpanda.com>
 <CAL3q7H4efWBiovBP3XQtTQVP1tSL+a3hBtaOm36H=ss_F0mCFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4efWBiovBP3XQtTQVP1tSL+a3hBtaOm36H=ss_F0mCFw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 24, 2018 at 11:49:04AM +0100, Filipe Manana wrote:
> On Wed, May 23, 2018 at 4:58 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> > From: Josef Bacik <jbacik@fb.com>
> >
> > There's a priority inversion that exists currently with btrfs fsync.  In
> > some cases we will collect outstanding ordered extents onto a list and
> > only wait on them at the very last second.  However this "very last
> > second" falls inside of a transaction handle, so if we are in a lower
> > priority cgroup we can end up holding the transaction open for longer
> > than needed, so if a high priority cgroup is also trying to fsync()
> > it'll see latency.
> >
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/file.c | 56 ++++----------------------------------------------------
> >  1 file changed, 4 insertions(+), 52 deletions(-)
> >
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 5772f0cbedef..2b1c36612384 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -2069,53 +2069,12 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> >         atomic_inc(&root->log_batch);
> >         full_sync = test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
> >                              &BTRFS_I(inode)->runtime_flags);
> > +
> >         /*
> > -        * We might have have had more pages made dirty after calling
> > -        * start_ordered_ops and before acquiring the inode's i_mutex.
> > +        * We have to do this here to avoid the priority inversion of waiting on
> > +        * IO of a lower priority task while holding a transaciton open.
> >          */
> > -       if (full_sync) {
> > -               /*
> > -                * For a full sync, we need to make sure any ordered operations
> > -                * start and finish before we start logging the inode, so that
> > -                * all extents are persisted and the respective file extent
> > -                * items are in the fs/subvol btree.
> > -                */
> > -               ret = btrfs_wait_ordered_range(inode, start, len);
> > -       } else {
> > -               /*
> > -                * Start any new ordered operations before starting to log the
> > -                * inode. We will wait for them to finish in btrfs_sync_log().
> > -                *
> > -                * Right before acquiring the inode's mutex, we might have new
> > -                * writes dirtying pages, which won't immediately start the
> > -                * respective ordered operations - that is done through the
> > -                * fill_delalloc callbacks invoked from the writepage and
> > -                * writepages address space operations. So make sure we start
> > -                * all ordered operations before starting to log our inode. Not
> > -                * doing this means that while logging the inode, writeback
> > -                * could start and invoke writepage/writepages, which would call
> > -                * the fill_delalloc callbacks (cow_file_range,
> > -                * submit_compressed_extents). These callbacks add first an
> > -                * extent map to the modified list of extents and then create
> > -                * the respective ordered operation, which means in
> > -                * tree-log.c:btrfs_log_inode() we might capture all existing
> > -                * ordered operations (with btrfs_get_logged_extents()) before
> > -                * the fill_delalloc callback adds its ordered operation, and by
> > -                * the time we visit the modified list of extent maps (with
> > -                * btrfs_log_changed_extents()), we see and process the extent
> > -                * map they created. We then use the extent map to construct a
> > -                * file extent item for logging without waiting for the
> > -                * respective ordered operation to finish - this file extent
> > -                * item points to a disk location that might not have yet been
> > -                * written to, containing random data - so after a crash a log
> > -                * replay will make our inode have file extent items that point
> > -                * to disk locations containing invalid data, as we returned
> > -                * success to userspace without waiting for the respective
> > -                * ordered operation to finish, because it wasn't captured by
> > -                * btrfs_get_logged_extents().
> > -                */
> > -               ret = start_ordered_ops(inode, start, end);
> > -       }
> > +       ret = btrfs_wait_ordered_range(inode, start, len);
> >         if (ret) {
> >                 inode_unlock(inode);
> >                 goto out;
> > @@ -2240,13 +2199,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> >                                 goto out;
> >                         }
> >                 }
> > -               if (!full_sync) {
> > -                       ret = btrfs_wait_ordered_range(inode, start, len);
> > -                       if (ret) {
> > -                               btrfs_end_transaction(trans);
> > -                               goto out;
> > -                       }
> > -               }
> >                 ret = btrfs_commit_transaction(trans);
> >         } else {
> >                 ret = btrfs_end_transaction(trans);
> 
> There's more code in this function that can go away after this.
> The logic to check if the inode is already in the log can now be
> simplified since we always for the ordered extents to complete before
> deciding whether the inode needs to be blogged. The big commet about
> it can go away too:
> 
> https://friendpaste.com/5MHqvkBmdIQgrySryhhjMy

The paste is still alive, the change looks good, can you please send is
as a proper patch? The other patches are in misc-next now. Thanks.
