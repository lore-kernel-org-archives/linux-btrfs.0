Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45512 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbeHUMFZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 08:05:25 -0400
Received: by mail-pf1-f195.google.com with SMTP id i26-v6so8156235pfo.12
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 01:46:10 -0700 (PDT)
Date: Tue, 21 Aug 2018 01:46:07 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v4 4/6] Btrfs: prevent ioctls from interfering with a
 swap file
Message-ID: <20180821084607.GA2119@vader>
References: <cover.1527197312.git.osandov@fb.com>
 <296f04a07350c9cc2032e03f78c1a7284747fb50.1527197312.git.osandov@fb.com>
 <20180525145055.GN6649@twin.jikos.cz>
 <20180525160058.GA29193@vader>
 <20180525161042.GR6649@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180525161042.GR6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 25, 2018 at 06:10:43PM +0200, David Sterba wrote:
> On Fri, May 25, 2018 at 09:00:58AM -0700, Omar Sandoval wrote:
> > On Fri, May 25, 2018 at 04:50:55PM +0200, David Sterba wrote:
> > > On Thu, May 24, 2018 at 02:41:28PM -0700, Omar Sandoval wrote:
> > > > From: Omar Sandoval <osandov@fb.com>
> > > > 
> > > > When a swap file is active, we must make sure that the extents of the
> > > > file are not moved and that they don't become shared. That means that
> > > > the following are not safe:
> > > > 
> > > > - chattr +c (enable compression)
> > > > - reflink
> > > > - dedupe
> > > > - snapshot
> > > > - defrag
> > > > - balance
> > > > - device remove/replace/resize
> > > > 
> > > > Don't allow those to happen on an active swap file. Balance and device
> > > > remove/replace/resize in particular are disallowed entirely; in the
> > > > future, we can relax this so that relocation skips/errors out only on
> > > > chunks containing an active swap file.
> > > 
> > > Hm, disabling the entire balance is too intrusive. It's clear that the
> > > swapfile causes a lot of trouble when it goes against the dynamic
> > > capabilities of btrfs (relocation and the functionality that builds on
> > > it).
> > > 
> > > Skipping the swapfile extents should be implemented at minimum.
> > 
> > Sure thing, this should definitely be possible. For balance, we can skip
> > them; for resize or delete, it of course has to fail if it encounters
> > swap extents. I'll take a stab at it.
> 
> We can detect if there's an active swap file on the filesystem before
> shrink, delete or replace is started so the user is not surprised if it
> fails in the end, or not start the operations at all and give some hints
> what to do.

I looked at this some more, it's not pretty... Basically, we need to

- Add a counter of active swap extents to struct btrfs_block_group_cache
- At activate time, map the file extent to a block group and increment the counter
- At relocation time, check the counter, and either error out or skip as
  appropriate
- At deactivate time, decrement all of the block group counters. Easier
  said than done because the file could in theory have new extents
  allocated beyond EOF

The last point is the tricky one. The straightforward way to implement
deactivate would be to walk all of the extents of the file in the same
way we did for activate, but the extents may have changed. So, we have
to remember which extents were activated (or get that information from
the generic swap code somehow). This seems fragile.

Does anyone see a better approach? Is it worth the trouble?
