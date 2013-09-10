Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:34402 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3IJP4K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 11:56:10 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 30E5D7C06A3
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Sep 2013 09:56:10 -0600 (MDT)
Date: Tue, 10 Sep 2013 11:56:07 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Mark Fasheh <mfasheh@suse.de>
CC: Christoph Hellwig <hch@infradead.org>, Josef Bacik <jbacik@fusionio.com>,
        <viro@ZenIV.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, Chris Mason <chris.mason@fusionio.com>,
        Andrew Vagin <avagin@gmail.com>
Subject: Re: [PATCH][RESEND] vfs: allow /proc/PID/maps to get device from stat
Message-ID: <20130910155607.GC2446@localhost.localdomain>
References: <20130807195718.GC31381@wotan.suse.de>
 <20130807201826.GA23804@infradead.org>
 <20130807205146.GE2397@localhost.localdomain>
 <20130808121349.GC5180@infradead.org>
 <20130808130207.GA16712@localhost.localdomain>
 <20130808134805.GB24181@infradead.org>
 <20130808154454.GF16712@localhost.localdomain>
 <20130812114752.GA2390@infradead.org>
 <20130910153655.GH31381@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130910153655.GH31381@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 10, 2013 at 08:36:55AM -0700, Mark Fasheh wrote:
> On Mon, Aug 12, 2013 at 04:47:52AM -0700, Christoph Hellwig wrote:
> > On Thu, Aug 08, 2013 at 11:44:54AM -0400, Josef Bacik wrote:
> > > On Thu, Aug 08, 2013 at 06:48:05AM -0700, Christoph Hellwig wrote:
> > > > On Thu, Aug 08, 2013 at 09:02:07AM -0400, Josef Bacik wrote:
> > > > > This won't work, try having 10000 subvolumes with dirty inodes and do sync then
> > > > > go skiing, you'll have time :).  Thanks,
> > > > 
> > > > Why would the dirty inodes make any difference?  If you share the bdi
> > > > between the subvolumes the sync workflow should be exactly the same
> > > > still.
> > > > 
> > > 
> > > If we could dis-entangle vfsmounts from sb's and have it so you could have
> > > multiple vfsmounts with just one sb that would solve at least the in-kernel
> > > confusion, but I think we still have the userspace confusion.  Thanks,
> > 
> > I think it would mostly solve userspace confusion, as userspace only
> > sees mounts and the device names.
> > 
> > But please fix this up properly instead of propagating the effects of
> > the nasty btrfs hack that should never have been merged in that form
> > further up the stack.
> 
> Can one of you explain how this solves the problem that userspace is getting
> different devices for the same inode?
> 
> Seriously, I've been looking into it and I'm a bit lost. I followed the
> converstaion until here but I don't see how any of the proposed changes
> actually *fix* anything? Also, what is the relationship between vfsmounts
> and sb today? Wouldn't a bind mount produce the situation of more than 1
> vfsmount per sb that is described above?
> 
> Sincerely, someone who would like to fix this ABI breakage that has been
> going on for years.

And let me restate the problem so we're all on the same page.

Btrfs has subvolumes, completely separate trees within the file system.  These
trees get their own object numbering, which in turn is how we do our inode
numbers.  So if you have multiple subvolumes, they will likely have the same
inode numbers within the same file system.  This screws up things like rsync
which say "hey look, these two inodes are the same, lets skip them."  So we have
an anonymous dev so we can make them look different.

Now if we were to make each subvol its own vfsmount (essentially a bind mount)
and remove the anonymous device that wouldn't fix the problem _at all_.  The
file system would appear to be the same to rsync and it wouldn't back stuff up.
So we still need some way of telling userspace that this object is different.

I'm not convinced vfsmounts is the way to do this, it doesn't do anything other
than add a whole lot of complexity to our mounting/subvolume mechanism that is
already relatively complex.  Thanks,

Josef
