Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759924Ab3BZSYy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 13:24:54 -0500
Date: Tue, 26 Feb 2013 10:24:42 -0800
From: Zach Brown <zab@redhat.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Josef Bacik <jbacik@fusionio.com>, Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3753! These btrfs crashes at
 mount time on log replay are really a problem
Message-ID: <20130226182442.GI1658@lenny.home.zabbo.net>
References: <20130226065102.GC11218@merlins.org>
 <20130226142300.GE19641@localhost.localdomain>
 <20130226162029.GB22367@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130226162029.GB22367@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Am I wrong when saying that ending up with replay journals that have
> unexpected data and that can't be replayed is just inevitable and something
> any journalling filesystem must deal with?

If by journal you mean the btrfs log then yes, strictly speaking, you're
wrong.  btrfs does deal with the kind of incomplete and reordered writes
that you're talking about and it should not result in corruption of what
it calls the log.

But it's a reasonable thing to be confused by.  I'm guessing that you're
being tripped up by what ext3 means by a journal and by what btrfs means
by a log.

The journal in ext3 can be partially written during a crash.  The
journal replay on mount notices this because the commit block isn't
present and just throws it away.  No worries.

The equivalent consistent update mechanism in btrfs is cow tree updates.
The superblock that references new tree blocks written to free space is
itself only written once all those blocks are stable on disk.  If the
tree block writes are interrupted then the superblock isn't updated and
btrfs won't see the partially written blocks.  No worries.

The btrfs "log" is itself just a logical btree *inside these consistent
tree updates* that records logical operations that will need to be
replayed.  For the log to be corrupted, if the btrfs code is perfect,
the storage had to have lied to btrfs and told it that tree update
blocks were stable which caused the superblock write that referenced
them prematurely.

The equivalent problem in the ext3 journal would be a transaction that
has blocks missing but which has a valid commit block.  ext3 couldn't
just throw this transaction away because after the commit block write it
could have been in the process of replaying the transaction blocks at
their final location on disk.  And it's now missing some of those blocks
to replay.  This kind of corruption Shouldn't Happen and the fs can't
just silently ignore it.

I absolutely agree that the error messages should be greatly improved in
this case, yes, and that it shouldn't BUG_ON (it should *never* BUG_ON).

But btrfs is right to refuse to silently revert previously stable
changes by just ignoring the corrupt log.

- z
