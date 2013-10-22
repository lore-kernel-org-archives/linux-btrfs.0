Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab3JVVWK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 17:22:10 -0400
Date: Tue, 22 Oct 2013 14:22:08 -0700
From: Zach Brown <zab@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Phil Davis <pmdhazy@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs send 'leaks' open files
Message-ID: <20131022212208.GE23125@lenny.home.zabbo.net>
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
> sight...

Agreed, the fget/fput of sctx->send_filp doesn't seem interesting.
There's only one possible delayed fput() for each ioctl.

I haven't *really* followed the delayed fput mechanics.. are we worried
about a ton of delayed fputs building up before the ioctl returns to
user space?

The sctx->cur_inode_filp is opened and closed for each file that differs
between the two trees such that the destination is brought up to date by
writing.  That can be O(storage) files if the source snapshot is empty
and the destination snapshot is a full file system.  All in one ioctl.

Sooooo, put whatever call it is that synchronizes the delayed fputs in
close_cur_inode_file() and see if the leak persists?

- z
