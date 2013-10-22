Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54512 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab3JVVHI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 17:07:08 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id E4AA67C06A7
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 15:07:07 -0600 (MDT)
Date: Tue, 22 Oct 2013 17:07:05 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Phil Davis <pmdhazy@gmail.com>, <linux-btrfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: btrfs send 'leaks' open files
Message-ID: <20131022210705.GC10632@localhost.localdomain>
References: <CAERquQ78pOig3oQoom2e0Jcsv1i3-_8ET0ewAWUUo+nt2vk4Mg@mail.gmail.com>
 <20131022172249.GV13318@ZenIV.linux.org.uk>
 <20131022204105.GA13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20131022204105.GA13318@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 22, 2013 at 09:41:05PM +0100, Al Viro wrote:
> On Tue, Oct 22, 2013 at 06:22:49PM +0100, Al Viro wrote:
> > On Sun, Oct 20, 2013 at 11:33:56AM +0100, Phil Davis wrote:
> > 
> > > The reason I think btrfs send is leaking open files is if you watch
> > > /proc/sys/fs/file-nr you see the
> > > number of open files increasing  but if you kill the btrfs send
> > > process then the open
> > > files count reduces back down.  In fact suspending the process also
> > > reduces the open file count but
> > > resuming it then makes the count start increasing again.
> > 
> > What does lsof show while you are running that?  AFAICS, btrfs_ioctl_send()
> > should be neutral wrt file references - we do fget() on entry and
> > fput() of the result on exit, with nothing else looking relevant in
> > sight...  OTOH, btrfs-progs number of calls of that ioctl() seems to
> > be bounded by the length of argument list.  So the interesting questions
> > are
> > 	a) how many btrfs send instances are running at the time?
> > 	b) what do their arg lists look like?
> > 	c) who (if anyone) has all those opened files in their descriptor
> > tables?
> 
> 
> aaaarrrgh.....  OK, I see what's going on.  We have a normal process doing
> a normal syscall (well, inasmuch as ioctl(2) can be called normal).  It's
> just that this syscall happens to open and close an obscene amount of
> struct file as it goes.  Which leads to all those struct file sitting there
> and waiting for task_work_run() to do __fput().  In the meanwhile we keep
> allocating new ones (and closing them).  All without returning to userland.
> 
> Result: O(regular files in snapshot) struct file instances by the time it
> ends.  Of course, once we return to userland (or get killed by OOM),
> we have task_work_run() called and all those suckers go away.
> 
> Note that decrementing the opened files counter earlier will do nothing
> to OOM - it *is* caused by the bloody huge pile of struct file / struct
> dentry / struct inode.  We really need to flush that shite somehow - or
> avoid producing it in the first place.
> 
> The trouble is, I'm not sure that doing __fput() here is really safe - the
> call chains are long and convoluted and I don't see what the locking
> environment is.  IOW, I'm not sure that it's really deadlock-free with
> fput() done synchronously.  btrfs_release_file() seems to be doing some
> non-trivial work if we had the file truncated by somebody else, so...
> 
> Does using vfs_read() in send_write() really make things much simpler for
> us?  That's the only reason to bother with that dentry_open() at all;
> we could bloody well just copy the data from page cache without bothering
> with struct file, set_fs(), etc.
> 
> Comments?

I agree, we should probably just drop the vfs_read() call and do the hard work
ourselves.  I will look into doing this in the near future.  Thanks,

Josef
