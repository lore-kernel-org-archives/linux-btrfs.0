Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:44192 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778Ab2F0ObO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 10:31:14 -0400
Date: Wed, 27 Jun 2012 16:31:10 +0200
From: David Sterba <dave@jikos.cz>
To: David Nicol <davidnicol@gmail.com>
Cc: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Subject: Re: waiting for deferred cleanup operations
Message-ID: <20120627143110.GU28144@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAFwScO_ENB2tDKpXozCqz09PjH6sCRvDCB-Pr2XJSy2HTerwFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFwScO_ENB2tDKpXozCqz09PjH6sCRvDCB-Pr2XJSy2HTerwFQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 08:55:20PM -0500, David Nicol wrote:
> I've noticed that the patches I posted here two years ago about an
> ioctl to allow userspace to wait for deferred ops to complete aren't
> included in the "has all patches posted to mailing list" git repo. Is
> this an oversight or is there a problem with the proposed architecture
> or implementation?

I think the the "has all patches posted to mailing list" has an implicit
addendum "since btrfs-next has emerged". Your patch has higher chances
to be included into -next if you sent an updated version.

Your original proposal is limited to waiting for the cleaner thread,
which is one of those that cause stalled umounts and imho deserves more
finer control or status.

Simply waiting is not enough, I've seen cleaner or defrag on a root
subvol running for days. A way to cancel the operations would be more
useful here. This asks for a more generic interface for threads that do
not yet have their own control ioctls (like scrub or balance).

I've counted these:

* defrag - triggered by 'btrfs fi defrag'
* device add - this holds the uuid mutex and the same mutex is needed
               for mkfs which blocks
* device del - dtto, plus it needs fully cancellable balance/relocation
* cleaner
* free space / inode cache writeout

the criterias are whether the operation blocks umount, ro-remount or
other filesystem-wide operations (like mkfs) or generally slows down the
throughput.

The set of operations on the threads:

* wait
* pause - eg. when cleaner activity is not desired atm
* cancel - either Ctrl-C/kill -9 or separate command via 'btrfs'
* resume - explicitly wake the thread and let it continue or just check
           for work
* status - paused/active/idle

I don't know if you'd want to implement this in full, I guess not.
Besides this is yet in a RFC stage.

But I'll object to adding just the BTRFS_IOC_CLEANER_WAIT ioctl.

> Is the patch as seen there good, and were I to update it to apply
> against current source would there
> be any problem with tracking it for mainstream inclusion?

In it's current form, the patch looks like a prototype, not ready for
inclusion, IMHO.


david
