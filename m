Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44862 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2HICwM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Aug 2012 22:52:12 -0400
Date: Wed, 8 Aug 2012 19:52:11 -0700
From: Marc MERLIN <marc@merlins.org>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs panic in 3.5.0
Message-ID: <20120809025211.GA12014@merlins.org>
References: <20120807174047.GE24635@merlins.org> <50215AFF.1080800@gmx.net> <20120807184736.GA22686@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120807184736.GA22686@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 07, 2012 at 11:47:36AM -0700, Marc MERLIN wrote:
> On Tue, Aug 07, 2012 at 08:14:23PM +0200, Arne Jansen wrote:
> > On 08/07/2012 07:40 PM, Marc MERLIN wrote:
> > > Unfortunately I only have a screenshot.
> > > 
> > > Apparently the panic was in 
> > > btrfs_set_lock_blocking_rw
> > > with a RIP in btrfs_cow_block
> > 
> > Can you please resolve btrfs_cow_block+0x3b to a line number?
> > 
> > gdb btrfs.ko
> > (gdb) info line *btrfs_cow_block+0x3b
> 
> So, I'm not very good at this, sorry if I'm doing it wrong:
> gandalfthegreat:~# gdb /lib/modules/3.5.0-amd64-preempt-noide-20120410/kernel/fs/btrfs/btrfs.ko
> Reading symbols from /lib/modules/3.5.0-amd64-preempt-noide-20120410/kernel/fs/btrfs/btrfs.ko...(no debugging symbols found)...done.
> (gdb) info line *btrfs_cow_block+0x3b
> No line number information available for address 0x9a6e
> 
> Mmmh, it seems that I'm missing a kernel option that adds symbols in modules?
> 
> I can add it for my next kernel compile. Do you have the config option name
> off hand?
> 
> I put my module here if that helps:
> http://marc.merlins.org/tmp/btrfs.ko

I felt bad for having a kernel without debug symbols it seems, so I looked
at my kernel config and I do have:
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set

Any idea what else I'm missing to provide better debug info if I have a
problem again?

And is it reasonably easy to take the .ko apparently without line numbers,
like the one I gave you, and infer the line of code for a function offset?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
