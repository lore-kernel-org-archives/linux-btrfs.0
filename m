From: Chris Mason <chris.mason@oracle.com>
Subject: Re: new integration-danger branch pushed out (kernel)
Date: Tue, 1 Nov 2011 06:55:32 -0400
Message-ID: <20111101105532.GA9554@shiny>
References: <20111101024957.GH4468@shiny>
 <4EAFBA4C.1080201@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EAFBA4C.1080201@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2011 at 05:22:20PM +0800, Liu Bo wrote:
> Hi, 
> 
> On 11/01/2011 10:49 AM, Chris Mason wrote:
> > Hi everyone,
> > 
> > I've pushed out a new integration branch, but it is not for general use.
> > 
> > I'm still going through and hammering on the new logging code code to
> > make sure it is properly backwards compatible with older kernels and
> > that it hasn't introduced any new bugs.
> > 
> > *** Please do not use this code on anything other than test filesystems that
> > can easily be reformatted. ***
> > 
> > In testing the new sub-transid logging code, I've spent a lot of time
> > hunting logging bugs, and writing new tests to try and make sure the
> > logging code is working correctly in general.  Between that and some new
> > tests from Arne, I've had to make some pretty big changes to the code.
> > 
> 
> I'm giving a hard read on the new code, and I notice a slight change:

Thanks a lot for reading it carefully.

> @@ -3006,14 +3179,11 @@ out:
>  static int inode_in_log(struct btrfs_trans_handle *trans,
>                  struct inode *inode)
>  {
> -       struct btrfs_root *root = BTRFS_I(inode)->root;
>         int ret = 0;
>  
> -       mutex_lock(&root->log_mutex);
> -       if (BTRFS_I(inode)->logged_trans == trans->transid &&
> -           BTRFS_I(inode)->last_sub_trans <= root->last_log_commit)
> +       if (BTRFS_I(inode)->logged_trans >= trans->transaction->transid &&
> +           BTRFS_I(inode)->last_trans < BTRFS_I(inode)->logged_trans)
>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                 ret = 1;
> -       mutex_unlock(&root->log_mutex);
>         return ret;
>  }
> 
> since we've moved the "sub_transid++" update to btrfs_sync_log(), the ending of log,
> say there is a case like this:
> 
> transaction ------------------------------------------ start
>                  |
>     sub_trans A  | --- start
>                  |
>                  | --- modify inode X, and set X's last_trans to sub_transid
>  |               |
>  |               | --- fsync inode X, and set X's logged_trans to sub_transid
>  |               |
>  |               | --- in btrfs_sync_log(), sub_transid++
>  |               |
> \|/              | --- end
>                  |
>    sub_trans A+1 | --- start
>                  |
>                  | --- no change to inode X
>                  |
>                  | --- fsync inode X
>                  |
>                  | --- in inode_in_log(), X's last_trans is equal to X's logged_trans,
>                        unchanged X is just in the log, but we need to log X again.
> 
>     ......             ......
> 
> transaction ------------------------------------------ end
> 
> we do not want this, does we?  Or am I missing something?

Correct, this is less optimal.  I was finding races where the transid
increasing at the start of the log trans would lead to one process
missing file and directory updates done by another process.

So I made the patch slightly more conservative.  We're still logging
about 75% less than we used to in every workload I've tried, but we can
definitely refine this in future commits.

Along the way I fixed an old bug in directory logging that meant we
almost always force a full commit for directory fsyncs.  The fix means
we use the directory log more often now, which is faster in some cases
and slower in others.

It also means a bug with delayed metadata insertion triggers more easily
during log replay (we need to flush the delayed ops during log replay).
The bug was hidden before because the directory log wasn't being used
much.

-chris

