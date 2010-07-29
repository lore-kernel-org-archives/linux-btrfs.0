From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
Date: Thu, 29 Jul 2010 19:09:50 +0200
Message-ID: <201007291909.51978.johannes.hirte@fem.tu-ilmenau.de>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de> <4C44066A.3080701@cn.fujitsu.com> <201007222007.24574.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Dave Chinner <david@fromorbit.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	zheng.yan@oracle.com, Jens Axboe <axboe@kernel.dk>,
	linux-fsdevel@vger.kernel.org
To: miaox@cn.fujitsu.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201007222007.24574.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag 22 Juli 2010, 20:07:23 schrieb Johannes Hirte:
> Am Montag 19 Juli 2010, 10:01:46 schrieb Miao Xie:
> > On Thu, 15 Jul 2010 20:14:51 +0200, Johannes Hirte wrote:
> > > Am Donnerstag 15 Juli 2010, 02:11:04 schrieb Dave Chinner:
> > >> On Wed, Jul 14, 2010 at 05:25:23PM +0200, Johannes Hirte wrote:
> > >>> Am Donnerstag 08 Juli 2010, 16:31:09 schrieb Chris Mason:
> > >>> I'm not sure if btrfs is to blame for this error. After the errors I
> > >>> switched to XFS on this system and got now this error:
> > >>> 
> > >>> ls -l .kde4/share/apps/akregator/data/
> > >>> ls: cannot access .kde4/share/apps/akregator/data/feeds.opml:
> > >>> Structure needs cleaning
> > >>> total 4
> > >>> ?????????? ? ?    ?        ?            ? feeds.opml
> > >> 
> > >> What is the error reported in dmesg when the XFS filesytem shuts down?
> > > 
> > > Nothing. I double checked the logs. There are only the messages when
> > > mounting the filesystem. No other errors are reported than the
> > > inaccessible file and the output from xfs_check.
> > 
> > Is there anything wrong with your disks or memory?
> > Sometimes the bad memory can break the filesystem. I have met this kind
> > of problem some time ago.
> 
> I don't think that's the case. I've checked the RAM with memtest86+ and got
> no errors. I got the errors with two different disks, the first one with
> btrfs the second one now with XFS. Before changing to the second disk,
> I've run badblocks on it to be sure it has no errors.

I think I've found it. The bug was introduced by 

commit 7f0e7bed936a0c422641a046551829a01341dd80
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Jun 8 18:14:34 2010 +0200

    writeback: fix writeback completion notifications
    
    The code dealing with bdi_work->state and completion of a bdi_work is a
    major mess currently.  This patch makes sure we directly use one set of
    flags to deal with it, and use it consistently, which means:
    
     - always notify about completion from the rcu callback.  We only ever
       wait for it from on-stack callers, so this simplification does not
       even cause a theoretical slowdown currently.  It also makes sure we
       don't miss out on the notification if we ever add other callers to
       wait for it.
     - make earlier completion notification depending on the on-stack
       allocation, not the sync mode.  If we introduce new callers that
       want to do WB_SYNC_NONE writeback from on-stack callers this will
       be nessecary.
    
    Also rename bdi_wait_on_work_clear to bdi_wait_on_work_done and inline
    a few small functions into their only caller to make the code
    understandable.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

and seems to be fixed by

commit 83ba7b071f30f7c01f72518ad72d5cd203c27502
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Jul 6 08:59:53 2010 +0200

    writeback: simplify the write back thread queue
    
    First remove items from work_list as soon as we start working on them.This
    means we don't have to track any pending or visited state and can get
    rid of all the RCU magic freeing the work items - we can simply free
    them once the operation has finished.  Second use a real completion for
    tracking synchronous requests - if the caller sets the completion pointer
    we complete it, otherwise use it as a boolean indicator that we can free
    the work item directly.  Third unify struct wb_writeback_args and struct
    bdi_work into a single data structure, wb_writeback_work.  Previous we
    set all parameters into a struct wb_writeback_args, copied it into
    struct bdi_work, copied it again on the stack to use it there.  Instead
    of just allocate one structure dynamically or on the stack and use it
    all the way through the stack.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

I was able to reproduce the bug by unpacking a big tar-file and deleting this files multiple times. Normally with btrfs the kernel crashed within 20 runs. After commit 83ba7b071f30f7c01f72518ad72d5cd203c27502 it survived more than 500 runs.


regards,
  Johannes
