From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: protect the pending_snapshots list with trans_lock
Date: Tue, 21 Jun 2011 00:32:20 +0200
Message-ID: <20110620223220.GI12709@twin.jikos.cz>
References: <1308079067-20733-1-git-send-email-josef@redhat.com>
 <20110615095329.GZ12709@twin.jikos.cz>
 <1308137405-sup-6493@shiny>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dave@jikos.cz>, Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1308137405-sup-6493@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 15, 2011 at 07:41:37AM -0400, Chris Mason wrote:
> There is definitely a window where two procs can be inside
> create_snapshot() at the same time in the same transaction.

I trust you on that. I was trying to follow the callgraph from
btrfs_strat_transaction called from create_snapshot to see whether and
how two calls may access the list and came to conclusion that there must
be a fresh transaction after the call. There are lots of
join_transaction, commit_transaction calls and I could have lost track.
I'm leaving this to me as a homework, it was very educative anyway.

> Going down to your list:
> 
> > 
> > 2) you need to protect every access to the pending_snapshot:
> > - add in create_snapshot
> 
> create_snapshot is racey.

agreed, the patch fixes it

> 
> > - splice in btrfs_destroy_pending_snapshots
> 
> This can only happen during unmount while there are no writers.
>
> > - list foreach in create_pending_snapshots
> 
> This can only happen during commit while there are no writers

this counts as protection, for both

> > - list_empty in btrfs_commit_transaction
> 
> This is there to make sure that any delayed allocation from the source
> subvol is actually done in the snapshot.  You're right that we should
> have a better check here.  The worst possible case in getting this wrong
> is that the snapshot misses some recent file writes in the original, but
> it will be completely consistent.

I think this is ok and acceptable.


Thanks,
david
