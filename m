Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:52948 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab3AKOtz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 09:49:55 -0500
Date: Fri, 11 Jan 2013 09:49:52 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Marc MERLIN <marc@merlins.org>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3707 still not fixed in 3.7.1
 (btrfs-zero-log required) but shown as "RIP btrfs_num_copies"
Message-ID: <20130111144952.GA1876@localhost.localdomain>
References: <20130108164958.GA2044@merlins.org>
 <20130108182541.GE2389@localhost.localdomain>
 <20130108184603.GG2044@merlins.org>
 <20130110162009.GF16943@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130110162009.GF16943@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 10, 2013 at 09:20:09AM -0700, Marc MERLIN wrote:
> On Tue, Jan 08, 2013 at 10:46:03AM -0800, Marc MERLIN wrote:
> > On Tue, Jan 08, 2013 at 01:25:41PM -0500, Josef Bacik wrote:
> > > On Tue, Jan 08, 2013 at 09:49:58AM -0700, Marc MERLIN wrote:
> > > > Unfortunately my laptop deadlocks from time to time, and too often
> > > > it triggers this bug in btrfs which is quite hard to recover from.
> > > > 
> > > 
> > > You are getting bad tree blocks which really isn't the tree logs fault.  Can you
> > > scrub your file system and make sure there's not some sort of latent issue going
> > > on?  And if you have problems again please try btrfs-next as I've fixed a few
> > > log replay bugs recently.  Thanks,
> > 
> > Thanks for your answer.
> > 
> > I've only read about scrub in a mirorr situation, as per
> > https://blogs.oracle.com/wim/entry/btrfs_scrub_go_fix_corruptions
> > 
> > It's a single device here, so if there are problems, I'm not sure how scrub
> > will be able to fix them.
> > Would you like me to go ahead and do it anyway?
> > 

Well its mostly to verify you have some sort of latent corruption sitting
around.  If you have DUP it will be able to fix it, but if you don't we'll at
least know something else is wrong and we can try and work out if fsck will fix
it.

> > And before I further remove potential debug state
> > 1) what about this problem?
> > btrfs-image: btrfs-image.c:518: create_metadump: Assertion `!(ret < 0)'
> > failed.
> > Aborted

Probably just related to whatever corruption it is you are seeing.

> > 
> > 2) anything else you want me to get off my filesystem before I scrub it?

Nope, hopefully it should be non-destructive.  Thanks,

Josef
