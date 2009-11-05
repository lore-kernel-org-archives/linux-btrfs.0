From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: cleanup transaction starting and fix
	current->journal_info setting
Date: Thu, 5 Nov 2009 13:39:13 -0500
Message-ID: <20091105183913.GB22737@dhcp231-156.rdu.redhat.com>
References: <20091103151612.GB5541@localhost.localdomain> <Pine.LNX.4.64.0911031530250.10665@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0911031530250.10665@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 05, 2009 at 10:08:11AM -0800, Sage Weil wrote:
> On Tue, 3 Nov 2009, Josef Bacik wrote:
> 
> > We use journal_info to tell if we're in a nested transaction to make sure we
> > don't commit the transaction within a nested transaction.  We use another
> 
> Might this also make btrfs_start_transaction() safe to call when another 
> transaction is already open?  (i.e., let us choose between START and JOIN 
> to avoid wait_current_trans() if journal_info != NULL?)
> 
> If so, that would nicely solve the deadlocks with the alternate 
> transaction ioctl I'm putting together (and, if we drop the current ioctl, 
> make the existing open_ioctl_trans counter and associated checks go away).  
> I was looking at adding something to current->fs (struct fs_struct) to 
> flag if we're part of a user transaction, but if journal_info is already 
> being used that would be much cleaner.
> 

We talked about this on IRC, there are some cases where we specifically want the
join semantics since its an operation that is performance critical and may
really need to be done without waiting for the transaction to finish and not be
an actual embedded transaction.  Thanks,

Josef
