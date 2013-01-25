Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:39422 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab3AYUhU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 15:37:20 -0500
Date: Fri, 25 Jan 2013 15:37:17 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Andrew McNabb <amcnabb@mcnabbs.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs stability
Message-ID: <20130125203717.GA3257@localhost.localdomain>
References: <20130125200514.GD4217@mcnabbs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130125200514.GD4217@mcnabbs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 25, 2013 at 01:05:14PM -0700, Andrew McNabb wrote:
> I tried creating a multi-device btrfs filesystem for the first time (on
> Fedora 18 with 3.7.2-204.fc18.x86_64), and I ran into some problems.  I
> had heard that btrfs is now reasonably stable, and though I expected to
> possibly see a problem here or there, I was a little surprised at just
> how many problems I encountered in such a short period of time.  I now
> have about a thousand error messages in my kernel logs related to
> several different problems.  Is this roughly the expected level of
> stability for btrfs with multiple devices, or am I just particularly
> lucky? :)
> 
> Am I correct in assuming that I'll need to switch to md for a few months
> and try btrfs again later, or are there known problems in the specific
> kernel I'm running that I could avoid by trying a different version?
> 
> For the sake of being specific, I'll detail a few of the problems I've
> hit:
> 
> These two may have been caused by a possibly faulty disk (I'm still
> trying to determine whether it was faulty or whether the bug was purely
> in btrfs):
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=903794

This one is just a allocator warning because the relocator doesn't do the right
accounting for relocation.  It's just complainig, we need to fix it but it won't
keep it from working.

> https://bugzilla.redhat.com/show_bug.cgi?id=904143

This I'm almost certain (I have to check) was just a result of me making fsync
faster and forgetting to remove this warn on.  It's fixed upstream.  Again,
nothing to worry about, but annoying.

> 
> This one was triggered when I tried to remove a possibly faulty disk:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=904197
> 

Ok this is a bug, I can fix this.  Basically we tried to read from the faulty
disk, it failed, we read from the other copy, and then tried to write the good
copy back to the failed disk and when we saw that the IO wasn't actually going
to go to the bad disk we panic'ed.  Silly but easy enough to understand/fix.

> With a freshly created filesystem, I got a kernel bug, associated with a
> hang in most filesystem operations.  This occurred in the middle of
> ordinary operation and without any sort of hardware-related errors in
> the kernel logs.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=904223
> 

So this is from the fsync stuff, and I'm sure I fixed this somewhere but I can't
account for where I did it.  Can you give btrfs-next a try and see if you can
still reproduce.  Thanks,

Josef
