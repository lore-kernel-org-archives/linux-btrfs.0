Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38159 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966725AbeEYQN2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 12:13:28 -0400
Date: Fri, 25 May 2018 18:10:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v4 4/6] Btrfs: prevent ioctls from interfering with a
 swap file
Message-ID: <20180525161042.GR6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1527197312.git.osandov@fb.com>
 <296f04a07350c9cc2032e03f78c1a7284747fb50.1527197312.git.osandov@fb.com>
 <20180525145055.GN6649@twin.jikos.cz>
 <20180525160058.GA29193@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180525160058.GA29193@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 25, 2018 at 09:00:58AM -0700, Omar Sandoval wrote:
> On Fri, May 25, 2018 at 04:50:55PM +0200, David Sterba wrote:
> > On Thu, May 24, 2018 at 02:41:28PM -0700, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > When a swap file is active, we must make sure that the extents of the
> > > file are not moved and that they don't become shared. That means that
> > > the following are not safe:
> > > 
> > > - chattr +c (enable compression)
> > > - reflink
> > > - dedupe
> > > - snapshot
> > > - defrag
> > > - balance
> > > - device remove/replace/resize
> > > 
> > > Don't allow those to happen on an active swap file. Balance and device
> > > remove/replace/resize in particular are disallowed entirely; in the
> > > future, we can relax this so that relocation skips/errors out only on
> > > chunks containing an active swap file.
> > 
> > Hm, disabling the entire balance is too intrusive. It's clear that the
> > swapfile causes a lot of trouble when it goes against the dynamic
> > capabilities of btrfs (relocation and the functionality that builds on
> > it).
> > 
> > Skipping the swapfile extents should be implemented at minimum.
> 
> Sure thing, this should definitely be possible. For balance, we can skip
> them; for resize or delete, it of course has to fail if it encounters
> swap extents. I'll take a stab at it.

We can detect if there's an active swap file on the filesystem before
shrink, delete or replace is started so the user is not surprised if it
fails in the end, or not start the operations at all and give some hints
what to do.

> > We can
> > add some heuristics that will group the swap extents to a small number
> > of chunks so the impact of unmovable chunks is limited.
> > 
> > I haven't looked at the implementation, but it might be possible to
> > internally find a different location for the swap extent once it's not
> > used for the actual paged data.
> > 
> > In an ideal case, the swap extents could span entire chunks (1G) and not
> > mix with regular data/metadata.
> > 
> > > Note that we don't have to worry about chattr -C (disable nocow), which
> > > we ignore for non-empty files, because an active swapfile must be
> > > non-empty and can't be truncated. We also don't have to worry about
> > > autodefrag because it's only done on COW files. Truncate and fallocate
> > > are already taken care of by the generic code. Device add doesn't do
> > > relocation so it's not an issue, either.
> > 
> > Ok, fine the remaining easy cases are covered.
> > 
> > I don't know if you mentioned that elsewhere (as design questions are
> > in this patch), the allocation profile is single, or is it also possible
> > to have striped or duplicated swap extents?
> 
> That's briefly mentioned in the last patch, only single data is
> supported, although I think I can easily relax that to also allow RAID0.
> Anything else is much harder to support, but we need to start somewhere.

Of course, support for single is absolutelly fine for the first
implementation.
