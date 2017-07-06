Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35316 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbdGFXBs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jul 2017 19:01:48 -0400
Received: by mail-pf0-f170.google.com with SMTP id c73so7779958pfk.2
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Jul 2017 16:01:43 -0700 (PDT)
Date: Thu, 6 Jul 2017 16:01:41 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org, pwnall@chromium.org
Subject: Re: Leveldb in google-chrome incompatible with btrfs?
Message-ID: <20170706230141.GA22242@vader.DHCP.thefacebook.com>
References: <20170706150046.GB12959@merlins.org>
 <20170706211320.GA12206@vader.DHCP.thefacebook.com>
 <20170706212422.GH30689@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170706212422.GH30689@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 06, 2017 at 02:24:22PM -0700, Marc MERLIN wrote:
> On Thu, Jul 06, 2017 at 02:13:20PM -0700, Omar Sandoval wrote:
> > On Thu, Jul 06, 2017 at 08:00:46AM -0700, Marc MERLIN wrote:
> > > I don't know who else uses google-chrome here, but for me, for as long as
> > > I've used btrfs (3+ years now), I've had no end of troubles recovering from
> > > a linux crash, and google-chrome has had problems recovering my tabs and
> > > usually cmoplains about plenty of problems, some are corruption looking.
> > 
> > I've also had issues with chrome and Btrfs, not just you.
> > 
> > [snip]
> > 
> > > Does anyone know if it's leveldb relying on non POSIX semantics that just
> > > happen to work out on ext4, or if btrfs COW and atomicity doesn't quite
> > > handle multi file updates in a way that is expected by a spec, or by
> > > application developers?
> > 
> > A quick google search turned this up: https://github.com/google/leveldb/issues/195.
> > Unless anything has changed since that issue was last updated, it does
> > sound like LevelDB is making some unsafe assumptions. I'll take a look.
> 
> Thanks Omar, this very much looks related indeed.
> 
> Marc

Hm, tracing a simple program using LevelDB I put together, it looks like
the relevant sequence of events on open is pretty much

create new MANIFEST-nnnnnn
write out new MANIFEST-nnnnnn
fsync() parent directory
fdatasync() MANIFEST-nnnnnn

create temporary CURRENT
write out temporary CURRENT to point to new MANIFEST-nnnnnn name
fdatasync() temporary CURRENT
rename temporary CURRENT to CURRENT

unlink old MANIFEST-nnnnnn

There's no fsync of the parent directory between renaming CURRENT and
unlinking the old MANIFEST, but that shouldn't be an issue on Btrfs.
Either both of those operations will be committed in the same filesystem
transaction, or the rename will be committed before the unlink. I can't
think of any way that the unlink would end up reordered before the
rename.

What doesn't add up about your bug report is that your CURRENT points to
a MANIFEST-010814 way behind all of the other files in that directory,
which are numbered 022745+. If there were a bug here, I'd expect the
stale MANIFEST file would be one older than the new one. The filenames
seem to be allocated sequentially, so that old MANIFEST file CURRENT
refers to must be really old, which doesn't make sense. I don't see how
Btrfs would screw that up :) I'd be interested to see if you can make
the same condition trigger again.
