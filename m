Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:42990 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab3A1XVm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 18:21:42 -0500
Date: Mon, 28 Jan 2013 18:21:40 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: David Sterba <dsterba@suse.cz>
CC: polack christian <baobab874@gmail.com>,
        mailing list linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck and ctree version
Message-ID: <20130128232140.GA23893@shiny.globalsuite.net>
References: <CAC6BJd=gbiV+14yk=ghyUozp99Q6QCE6ip_FAp2WoPZTNYNVvw@mail.gmail.com>
 <20130128220308.GI16977@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130128220308.GI16977@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 03:03:08PM -0700, David Sterba wrote:
> On Mon, Jan 28, 2013 at 03:07:13PM +0100, polack christian wrote:
> > i did use btrfsck to recover it
> > i got the tool from
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> > 
> > and i got this error message:
> > ...
> > Check tree block failed, want=294555648, have=0
> > Check tree block failed, want=294559744, have=0
> > Check tree block failed, want=294559744, have=0
> > btrfsck: ctree.c:1690: leaf_space_used: Assertion `!(data_len < 0)' failed.
> > Aborted (core dumped)
> > 
> > looking at
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
> 
> but this is a kernel source repository, not progs, I wonder
> 
> > this error in ctree.c have been corrected by this commit
> > 
> > http://git.kernel.org/?p=linux/kernel/git/josef/btrfs-next.git;a=commit;h=41be1f3b40b87de33cd2e7463dce88596dbdccc4
> 
> how this could happen. I have looked at the whether it does not silently
> fix a bug, nothing wrong I can see now.  How did you verify that the
> patch fixes the fsck problem?

It sounds much more like the reboot or remount cleared the cache on the
block device.

-chris

