Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:49236 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3JVRj2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 13:39:28 -0400
Date: Tue, 22 Oct 2013 18:39:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Phil Davis <pmdhazy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send 'leaks' open files
Message-ID: <20131022173927.GW13318@ZenIV.linux.org.uk>
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

Argh...  WTF do people keep misusing filp_close()?  close_cur_inode_file()
should just use fput() and be done with that..  Anyway, ->cur_inode_filp
also doesn't look as a likely candidate for leak - even if we missed calling
close_cur_inode_file(), we'd get no more dentry_open() done by
open_cur_inode_file() for that sctx, which would limit us to at most one
per BTRFS_IOC_SEND.  IOW, there still seems to be something in userland
calling that ioctl a lot...

Anyway, lsof result ought to distinguish that case - we'd get a shitload of
opened files not in descriptor tables...
