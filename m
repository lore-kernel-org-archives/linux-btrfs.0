Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:59689 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbcG2QNQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 12:13:16 -0400
Date: Fri, 29 Jul 2016 18:13:11 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Transaction aborted in btrfs_rename2
Message-ID: <20160729161311.GA15356@angband.pl>
References: <20160606114732.GA30582@angband.pl>
 <bded73ce-3b5c-3ba0-0785-79d3ffaca34c@suse.com>
 <9373294e-c59b-0360-8481-328f03216926@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9373294e-c59b-0360-8481-328f03216926@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 29, 2016 at 11:43:29AM -0400, Jeff Mahoney wrote:
> On 6/6/16 10:13 AM, Jeff Mahoney wrote:
> > On 6/6/16 7:47 AM, Adam Borowski wrote:
> >> Hi!
> >> I just got this thrice, in 4.7-rc1 and 4.7-rc2:
> >>
> >> [ 1836.672368] ------------[ cut here ]------------
> >> [ 1836.672382] WARNING: CPU: 1 PID: 16348 at fs/btrfs/inode.c:9820 btrfs_rename2+0xcd2/0x2a50
> >> [ 1836.672385] BTRFS: Transaction aborted (error -2)
> >> [ 1836.672396] CPU: 1 PID: 16348 Comm: gcc-6 Tainted: P           O    4.7.0-rc2-debug+ #3
> >> [ 1836.672415] Call Trace:
> >> [ 1836.672423]  [<ffffffff8165be6d>] dump_stack+0x4e/0x71
> >> [ 1836.672429]  [<ffffffff81110c1c>] __warn+0x10c/0x150
> >> [ 1836.672433]  [<ffffffff81110caa>] warn_slowpath_fmt+0x4a/0x50
> >> [ 1836.672437]  [<ffffffff814f4842>] btrfs_rename2+0xcd2/0x2a50
> >> [ 1836.672443]  [<ffffffff814dfcfb>] ? btrfs_permission+0x5b/0xc0
> >> [ 1836.672448]  [<ffffffff81d288c8>] ? down_write+0x18/0x60
> >> [ 1836.672453]  [<ffffffff8133a0cc>] vfs_rename+0x7cc/0xc30
> >> [ 1836.672457]  [<ffffffff8133dc8b>] SyS_rename+0x32b/0x420
> >> [ 1836.672461]  [<ffffffff81d2ab9f>] entry_SYSCALL_64_fastpath+0x17/0x93
> >> [ 1836.672464] ---[ end trace 6405b6e3d0e6c945 ]---
> >> [ 1836.672468] BTRFS warning (device sda1): btrfs_rename:9820: Aborting unused transaction(No such entry).
> >> [ 1836.675505] BTRFS warning (device sda1): btrfs_rename:9820: Aborting unused transaction(No such entry).
> >> <repeated 1152 times>
> > 
> > Oh, interesting.  We're seeing this on our 4.4-based kernels as well but
> > only on arm64.  That it's triggering on x86_64 is a good data point.
> > I'm hunting this one today.
> 
> I was finally able to track down what this was on arm64, and I'm afraid
> the news won't help you much.  It was a bug in gcc 4.8.5 instruction
> scheduling around function return that caused the stack pointer to be
> restored to the position at the beginning of the function while the
> stack was still being used via a separate register.  If an interrupt
> arrived between those two instructions, you'd get stack corruption that
> would present as bad hash values.
> 
> Are you still able to reproduce this on x86_64?

Nope, not in quite a while.  I haven't used middle 4.7 rcs so I don't know
when it went away.

I use gcc-6, too.

-- 
An imaginary friend squared is a real enemy.
