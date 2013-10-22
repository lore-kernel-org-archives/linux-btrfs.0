Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:49871 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab3JVUlG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 16:41:06 -0400
Date: Tue, 22 Oct 2013 21:41:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Phil Davis <pmdhazy@gmail.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: btrfs send 'leaks' open files
Message-ID: <20131022204105.GA13318@ZenIV.linux.org.uk>
References: <CAERquQ78pOig3oQoom2e0Jcsv1i3-_8ET0ewAWUUo+nt2vk4Mg@mail.gmail.com>
 <20131022172249.GV13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131022172249.GV13318@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 22, 2013 at 06:22:49PM +0100, Al Viro wrote:
> On Sun, Oct 20, 2013 at 11:33:56AM +0100, Phil Davis wrote:
> 
> > The reason I think btrfs send is leaking open files is if you watch
> > /proc/sys/fs/file-nr you see the
> > number of open files increasing  but if you kill the btrfs send
> > process then the open
> > files count reduces back down.  In fact suspending the process also
> > reduces the open file count but
> > resuming it then makes the count start increasing again.
> 
> What does lsof show while you are running that?  AFAICS, btrfs_ioctl_send()
> should be neutral wrt file references - we do fget() on entry and
> fput() of the result on exit, with nothing else looking relevant in
> sight...  OTOH, btrfs-progs number of calls of that ioctl() seems to
> be bounded by the length of argument list.  So the interesting questions
> are
> 	a) how many btrfs send instances are running at the time?
> 	b) what do their arg lists look like?
> 	c) who (if anyone) has all those opened files in their descriptor
> tables?


aaaarrrgh.....  OK, I see what's going on.  We have a normal process doing
a normal syscall (well, inasmuch as ioctl(2) can be called normal).  It's
just that this syscall happens to open and close an obscene amount of
struct file as it goes.  Which leads to all those struct file sitting there
and waiting for task_work_run() to do __fput().  In the meanwhile we keep
allocating new ones (and closing them).  All without returning to userland.

Result: O(regular files in snapshot) struct file instances by the time it
ends.  Of course, once we return to userland (or get killed by OOM),
we have task_work_run() called and all those suckers go away.

Note that decrementing the opened files counter earlier will do nothing
to OOM - it *is* caused by the bloody huge pile of struct file / struct
dentry / struct inode.  We really need to flush that shite somehow - or
avoid producing it in the first place.

The trouble is, I'm not sure that doing __fput() here is really safe - the
call chains are long and convoluted and I don't see what the locking
environment is.  IOW, I'm not sure that it's really deadlock-free with
fput() done synchronously.  btrfs_release_file() seems to be doing some
non-trivial work if we had the file truncated by somebody else, so...

Does using vfs_read() in send_write() really make things much simpler for
us?  That's the only reason to bother with that dentry_open() at all;
we could bloody well just copy the data from page cache without bothering
with struct file, set_fs(), etc.

Comments?
