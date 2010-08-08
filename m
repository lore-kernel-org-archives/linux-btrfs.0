From: "A. James Lewis" <james@fsck.co.uk>
Subject: Re: 2.6.35 performance results
Date: Sun, 08 Aug 2010 05:18:24 +0100
Message-ID: <1281241104.2492.11.camel@hardline>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


> On Fri, Aug 06, 2010 at 01:44:11PM -0500, Steven Pratt wrote:
> > Here is the latest set of performance runs from the 2.6.35-rc5 tree.
> > Included is a refresh of all the other filesystems with some changes
> > for barriers on and off since this has been somewhat of a hot topic
> > recently.
> > 
> > New data linked in to the history graphs here:
> > http://btrfs.boxacle.net/repository/raid/history/History.html
> > 
> > From a BTRFS performance perspective, we took a major regression on
> > write heavy workloads. As much as a 10x hit!  The problems seems to
> > be due to this changeset:
> > http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=5da9d01b66458b180a6bee0e637a1d0a3effc622
> 
> Ouch!  The problem is we're not being aggressive enough about
> allocating chunks for data, which makes the flusher come in and start
> data IO.
> 
> Thanks a lot for finding the regression, my machine definitely didn't
> show this.
> 
> I'll reproduce and fix it up.
> 
The guys testing this in Ubuntu's Maverick Alpha's have noticed this too... 

It happens only in some configurations... for example, I tested in a VM 
and did not see any issue, but when installing for real on the same hardware
performance fell through the floor.

https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/601299?comments=all

> 
> -chris
> 
> > Btrfs: Shrink delay allocated space in a synchronized
> > 
> > Shrink delayed allocation space in a synchronized manner is more
> > controllable than flushing all delay allocated space in an async
> > thread.
> > 
> > This changeset introduced "btrfs_start_one_delalloc_inode" in
> > http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commitdiff;h=5da9d01b66458b180a6bee0e637a1d0a3effc622
> > 
> > In heavy write workloads this new function is now dominating the profiles:
> > 
> > samples  %        app name                 symbol name
> > 8914973  65.1261  btrfs.ko                 btrfs_start_one_delalloc_inode
> > 1024841   7.4867  vmlinux-2.6.35-rc5-autokern1 rb_get_reader_page
> > 716046    5.2309  vmlinux-2.6.35-rc5-autokern1 ring_buffer_consume
> > 315354    2.3037  oprofile.ko              add_event_entry
> > 202484    1.4792  vmlinux-2.6.35-rc5-autokern1 write_inode_now
> > 195018    1.4247  btrfs.ko                 btrfs_tree_lock
> > 
> > 
> > Appears to be major contention on the spin lock, as this gets worse
> > with more threads.  This needs to be redone.
> > 
> > 
> > Steve
> 

