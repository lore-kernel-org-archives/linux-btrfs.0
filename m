Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56750 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2HGSri (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2012 14:47:38 -0400
Date: Tue, 7 Aug 2012 11:47:36 -0700
From: Marc MERLIN <marc@merlins.org>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs panic in 3.5.0
Message-ID: <20120807184736.GA22686@merlins.org>
References: <20120807174047.GE24635@merlins.org> <50215AFF.1080800@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50215AFF.1080800@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 07, 2012 at 08:14:23PM +0200, Arne Jansen wrote:
> On 08/07/2012 07:40 PM, Marc MERLIN wrote:
> > Unfortunately I only have a screenshot.
> > 
> > Apparently the panic was in 
> > btrfs_set_lock_blocking_rw
> > with a RIP in btrfs_cow_block
> 
> Can you please resolve btrfs_cow_block+0x3b to a line number?
> 
> gdb btrfs.ko
> (gdb) info line *btrfs_cow_block+0x3b

So, I'm not very good at this, sorry if I'm doing it wrong:
gandalfthegreat:~# gdb /lib/modules/3.5.0-amd64-preempt-noide-20120410/kernel/fs/btrfs/btrfs.ko
Reading symbols from /lib/modules/3.5.0-amd64-preempt-noide-20120410/kernel/fs/btrfs/btrfs.ko...(no debugging symbols found)...done.
(gdb) info line *btrfs_cow_block+0x3b
No line number information available for address 0x9a6e

Mmmh, it seems that I'm missing a kernel option that adds symbols in modules?

I can add it for my next kernel compile. Do you have the config option name
off hand?

I put my module here if that helps:
http://marc.merlins.org/tmp/btrfs.ko

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
