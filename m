From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: protect the pending_snapshots list with trans_lock
Date: Wed, 15 Jun 2011 07:41:37 -0400
Message-ID: <1308137405-sup-6493@shiny>
References: <1308079067-20733-1-git-send-email-josef@redhat.com> <20110615095329.GZ12709@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110615095329.GZ12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from David Sterba's message of 2011-06-15 05:53:29 -0400:
> Hi,
> 
> On Tue, Jun 14, 2011 at 03:17:47PM -0400, Josef Bacik wrote:
> > Currently there is nothing protecting the pending_snapshots list on the
> > transaction.  We only hold the directory mutex that we are snapshotting and a
> > read lock on the subvol_sem, so we could race with somebody else creating a
> > snapshot in a different directory and end up with list corruption.  So protect
> > this list with the trans_lock.  Thanks,
> 
> it's correct that the pending_snapshots list is not protected, but I do
> not see a way how to corrupt the list.
> 
> The callchain goes like this:
> 
> <user called ioctl>
>   btrfs_ioctl_snap_create_transid
>     btrfs_mksubvol
>       create_snapshot
> 
> the interesting stuff happens inside create_snapshot:
> 
> * alloc pending snapshot struct
> * start transaction (btrfs_start_transaction)
> * reserve metadata
> * list_add pending_snapshot to the transaction
> * commit the transaction (sync or async)
> * free pending snapshot struct
> 
> the snapshots are really created from btrfs_commit_transaction,
> create_pending_snapshots(), which does not protect the
> trans->pending_snapshots list, just traverses it. There is a potential
> corruption too but ...
> 
> ... there is the 'start transaction' call, which tries very hard to
> start a new transaction, ie. this call returns a new transaction handle.
> To prove this point needs more space, I will skip it now. The important
> thing for our case is that new transaction waits for the current to
> unblock.
> 
> Then, each snap create will have its own transaction and own
> pending_snapshots list, and will create just one snapshot per
> transaction, because any concurrently running ioctl snap create will block
> in the start_transaction call.
> 
> Therefore I think that either
> 
> 1) there is no locking needed around pending_snapshots (under assumption
> one snapshot per transaction), or

There is definitely a window where two procs can be inside
create_snapshot() at the same time in the same transaction.  You're
correct that the window is small, but its there.  We're not racing with
the bulk of the work done at transaction commit time though.

Going down to your list:

> 
> 2) you need to protect every access to the pending_snapshot:
> - add in create_snapshot

create_snapshot is racey.

> - splice in btrfs_destroy_pending_snapshots

This can only happen during unmount while there are no writers.

> - list foreach in create_pending_snapshots

This can only happen during commit while there are no writers

> - list_empty in btrfs_commit_transaction

This is there to make sure that any delayed allocation from the source
subvol is actually done in the snapshot.  You're right that we should
have a better check here.  The worst possible case in getting this wrong
is that the snapshot misses some recent file writes in the original, but
it will be completely consistent.

-chris
