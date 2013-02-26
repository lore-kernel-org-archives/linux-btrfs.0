Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:44702 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab3BZOXI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 09:23:08 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 45F629A03DE
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 07:23:08 -0700 (MST)
Date: Tue, 26 Feb 2013 09:23:00 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3753! These btrfs crashes at
 mount time on log replay are really a problem
Message-ID: <20130226142300.GE19641@localhost.localdomain>
References: <20130226065102.GC11218@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130226065102.GC11218@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 25, 2013 at 11:51:02PM -0700, Marc MERLIN wrote:
> TL;DR;
> WARNING: at fs/btrfs/tree-log.c:1984 walk_down_log_tree+0x51/0x307()
> WARNING: at fs/btrfs/tree-log.c:1988 walk_down_log_tree+0x6c/0x307()
> kernel BUG at fs/btrfs/volumes.c:3753!
> 
> It's way time for btrfs to stop crashing your system with no recovery flag
> that works to clear the log if the log can't be replayed. Hell, on non
> development systems, it should just auto discard the log if it can't be
> replayed without user input.
> 
> 
> Details:
> It's been almost a year that I'm doing my best to test btrfs and report
> bugs, but how quickly it crashes on mount if anything is off, is a huge
> usability problem.
> 
> I just again, lost use of my machine today after an unrelated problem caused
> a crash/reboot, and incomplete btrfs writes to my device.
> That happens, it's life.
> 
> But after that, I get to roll a dice of whether btrfs will recover, or just
> crash on mount.
> It's slightly more liveable if it's a scratch filesystem on a developer box,
> you just don't mount it.
> It's really really sucky if it's your root filesystem and you need to boot
> from a rescue partition/media to recover each time.
> 
> Then, I spent 3 hours reproducing the crash again, with netconsole working
> so that I can get a useful bugreport, which I send here.

So how did you reproduce it?  I'll take a fs_image, but being able to reproduce
the problem is more valuable.  Thanks,
