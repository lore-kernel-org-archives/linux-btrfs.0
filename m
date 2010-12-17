From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs subvolume snapshot hung in btrfs_commit_transaction
Date: Fri, 17 Dec 2010 09:52:10 -0500
Message-ID: <1292597464-sup-8595@think>
References: <20101212034339.GA26170@idallen.ca> <20101212081359.GA7389@idallen.ca> <20101214022324.GA21001@idallen.ca> <1292550402-sup-6711@think> <20101217044511.GD9177@idallen.ca>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Ian! D. Allen" <idallen@idallen.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20101217044511.GD9177@idallen.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Ian! D. Allen's message of 2010-12-16 23:45:12 -0500:
> On Thu, Dec 16, 2010 at 08:47:05PM -0500, Chris Mason wrote:
> > I think this hang is something that sage fixed.  Which kernel is this
> > ubuntu including?
> 
> All that detail is posted in the second message in the thread you quoted:
> 
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg07448.html

The 2.6.35 kernel didn't have Sage's fix.  I'd say the deadlock will be
fixed in the current btrfs-unstable git tree (against 2.6.36).

> 
> Is the btrfsck snapshot error (from Tuesday) fixed too?

I'm looking into that one, I think it is a btrfsck bug.

-chris
