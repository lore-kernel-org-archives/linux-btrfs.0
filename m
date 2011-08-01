From: Chris Mason <chris.mason@oracle.com>
Subject: Re: PLEASE TEST: Everybody who is seeing weird and long hangs
Date: Mon, 01 Aug 2011 14:21:02 -0400
Message-ID: <1312222583-sup-6514@shiny>
References: <4E36C47E.70309@redhat.com> <1312213264-sup-9624@shiny> <4E36CE56.1060206@redhat.com> <1312220929-sup-8405@shiny> <4E36E9FF.9050805@redhat.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4E36E9FF.9050805@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2011-08-01 14:01:35 -0400:
> On 08/01/2011 01:54 PM, Chris Mason wrote:
> > Excerpts from Josef Bacik's message of 2011-08-01 12:03:34 -0400:
> >> On 08/01/2011 11:45 AM, Chris Mason wrote:
> >>> Excerpts from Josef Bacik's message of 2011-08-01 11:21:34 -0400:
> >>>> Hello,
> >>>>
> >>>> We've seen a lot of reports of people having these constant long pauses
> >>>> when doing things like sync or such.  The stack traces usually all look
> >>>> the same, one is btrfs-transaction stuck in btrfs_wait_marked_extents
> >>>> and one is btrfs-submit-# stuck in get_request_wait.  I had originally
> >>>> thought this was due to the new plugging stuff, but I think it just
> >>>> makes the problem happen more quickly as we've seen that 2.6.38 which we
> >>>> thought was ok will still have the problem happen if given enough time.
> >>>>
> >>>> I _think_ this is because of the way we write out metadata in the
> >>>> transaction commit phase.  We're doing write_on_page for every dirty
> >>>> page in the btree during the commit.  This sucks because basically we
> >>>> end up with one bio per page, which makes us blow out our nr_requests
> >>>> constantly, which is why btrfs-submit-# is always stuck in
> >>>> get_request_wait.  What we need to do instead is use filemap_fdatawrite
> >>>> which will do a WB_SYNC_ALL but will do it via writepages, so hopefully
> >>>> we will get less bios and this problem will go away.  Please try this
> >>>> very hastily put together patch if you are experiencing this problem and
> >>>> let me know if it fixes it for you.  Thanks,
> >>>
> >>> I'm definitely curious to hear if this helps, but I think it might cause
> >>> a different set of problems.  It writes everything that is dirty on the
> >>> btree, which includes a lot of things we've cow'd in the current
> >>> transaction and marked dirty.  They will have to go through COW again
> >>> if someone wants to modify them again.
> >>>
> >>
> >> But this is happening in the commit after we've done all of our work, we
> >> shouldn't be dirtying anything else at this point right?
> > 
> > The commit code is setup to unblock people before we start the IO:
> > 
> >        trans->transaction->blocked = 0;
> >         spin_lock(&root->fs_info->trans_lock);
> >         root->fs_info->running_transaction = NULL;
> >         root->fs_info->trans_no_join = 0;
> >         spin_unlock(&root->fs_info->trans_lock);
> >         mutex_unlock(&root->fs_info->reloc_mutex);
> >         
> >         wake_up(&root->fs_info->transaction_wait);
> > 
> >         ret = btrfs_write_and_wait_transaction(trans, root);
> > 
> > So, we should have concurrent FS mods for a new transaction while we are
> > writing out this old transaction.
> > 
> 
> Ah right, but then this brings up another question, we shouldn't cow
> them again since we would have set the new transid.  And isn't this kind
> of bad, since somebody could come in and dirty a piece of metadata
> before we have a chance to write it out for this transaction, so we end
> up writing out the new data instead of what we are trying to commit?

I think we're mixing together different ideas here.  If we're doing a
commit on transaction N, we allow N+1 to start while we're doing the
btrfs_write_and_wait_transaction().  N+1 might allocate and dirty a new
block, which btrfs_write_and_wait_transaction might start IO on.

Strictly speaking this isn't a problem.  It doesn't break any rules of
COW because we're allowed to write metadata at any time.  But, once we
do write it, we must COW it again if we want to change it.  So, anything
that btrfs_write_and_wait_transaction() catches from transaction N+1 is
likely to make more work for us because future mods will have to
allocate a new block.  Basically it's wasted IO.

But, it's also free IO, assuming it was contiguous.  The problem is that
write_cache_pages isn't actually making sure it was contiguous, so we
end up doing many more writes than we could have.

-chris
