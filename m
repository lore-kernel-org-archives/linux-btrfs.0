Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49580 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab3BZTJU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 14:09:20 -0500
Date: Tue, 26 Feb 2013 11:09:17 -0800
From: Marc MERLIN <marc@merlins.org>
To: Zach Brown <zab@redhat.com>
Cc: Josef Bacik <jbacik@fusionio.com>, Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3753! These btrfs crashes at mount time on log replay are really a problem
Message-ID: <20130226190917.GF22367@merlins.org>
References: <20130226065102.GC11218@merlins.org> <20130226142300.GE19641@localhost.localdomain> <20130226162029.GB22367@merlins.org> <20130226182442.GI1658@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130226182442.GI1658@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 10:24:42AM -0800, Zach Brown wrote:
> > Am I wrong when saying that ending up with replay journals that have
> > unexpected data and that can't be replayed is just inevitable and something
> > any journalling filesystem must deal with?
> 
> If by journal you mean the btrfs log then yes, strictly speaking, you're

I did and used the wrong term, sorry.

> wrong.  btrfs does deal with the kind of incomplete and reordered writes
> that you're talking about and it should not result in corruption of what
> it calls the log.

Got it. So in theory what I'm seeing really shouldn't happen, unless there
is a corruption bug, or hardware fault.

> But it's a reasonable thing to be confused by.  I'm guessing that you're
> being tripped up by what ext3 means by a journal and by what btrfs means
> by a log.

yes :)

> The journal in ext3 can be partially written during a crash.  The
> journal replay on mount notices this because the commit block isn't
> present and just throws it away.  No worries.

That's indeed what I meant.

> The equivalent consistent update mechanism in btrfs is cow tree updates.
> The superblock that references new tree blocks written to free space is
> itself only written once all those blocks are stable on disk.  If the
> tree block writes are interrupted then the superblock isn't updated and
> btrfs won't see the partially written blocks.  No worries.

Ok. So basically what I seem to be hitting, are seemingly complete tree
blocks in the log, that aren't complete or consistent afterall, triggering 
BUG() in the end.

> replayed.  For the log to be corrupted, if the btrfs code is perfect,
> the storage had to have lied to btrfs and told it that tree update
> blocks were stable which caused the superblock write that referenced
> them prematurely.
 
That makes sense. Is dmcrypt with discard passthrough potentially able to 
tell btrfs that writes did make it to disk when in fact someonly some of
them have?

> The equivalent problem in the ext3 journal would be a transaction that
> has blocks missing but which has a valid commit block.  ext3 couldn't
> just throw this transaction away because after the commit block write it
> could have been in the process of replaying the transaction blocks at
> their final location on disk.  And it's now missing some of those blocks
> to replay.  This kind of corruption Shouldn't Happen and the fs can't
> just silently ignore it.
 
I understand that, and I'm not advocating silent ignores either.

> I absolutely agree that the error messages should be greatly improved in
> this case, yes, and that it shouldn't BUG_ON (it should *never* BUG_ON).
> 
> But btrfs is right to refuse to silently revert previously stable
> changes by just ignoring the corrupt log.

That's the part I'm a bit confused about.
It could complain, it could require a 'recovery' option on the kernel
command line (which does exist but doesn't work for this purpose), but
effectively it forces me to indeed ignore seemingly stable changes which
are indeed unusable, and the code knows they are, except that I have to go
back to boot media and go through hoops to get a netconsole dump/crash
before that, and then use btrfs-zero-log.

Once btrfs knows that the last log entry(ies) are corrupted in some way, it
could dump a bunch of diag data in the kernel, then delete the unusable log and
continue with the mount, which is effectively what I do myself right now.

Unless I'm mistaken, this really only causes me to lose some amount of data
that was written just before the crash/reboot. This is usually ok for most
users and typically expected anyway (although not as desirable in the case
of a database server of course).

I understand that this might not want to be a default, but it should be
something that could be done from the kernel command line, and allow the
mount to continue and the boot to succeed (including the kernel debug log to
make it to local disk, where it can then be Emailed since serial console or
netconsole is not something you can do easily)

Does that sound reasonable?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
