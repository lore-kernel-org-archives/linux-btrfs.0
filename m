Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:47235 "EHLO
	arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbbLJX6S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 18:58:18 -0500
Date: Thu, 10 Dec 2015 18:58:06 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>, jbacik@fb.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: Re: !PageLocked BUG_ON hit in clear_page_dirty_for_io
Message-ID: <20151210235806.GB2437@codemonkey.org.uk>
References: <20151209042528.GA2413@codemonkey.org.uk>
 <20151210190220.GA11257@ret.masoncoding.com>
 <20151210193555.GA23535@codemonkey.org.uk>
 <20151210213024.GC11257@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151210213024.GC11257@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 10, 2015 at 04:30:24PM -0500, Chris Mason wrote:
 > On Thu, Dec 10, 2015 at 02:35:55PM -0500, Dave Jones wrote:
 > > On Thu, Dec 10, 2015 at 02:02:20PM -0500, Chris Mason wrote:
 > >  > On Tue, Dec 08, 2015 at 11:25:28PM -0500, Dave Jones wrote:
 > >  > > Not sure if I've already reported this one, but I've been seeing this
 > >  > > a lot this last couple days.
 > >  > > 
 > >  > > kernel BUG at mm/page-writeback.c:2654!
 > >  > > invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN
 > >  > > CPU: 1 PID: 2566 Comm: trinity-c1 Tainted: G        W       4.4.0-rc4-think+ #14
 > >  > > task: ffff880462811b80 ti: ffff8800cd808000 task.ti: ffff8800cd808000
 > >  > > RIP: 0010:[<ffffffff8826ff40>]  [<ffffffff8826ff40>] clear_page_dirty_for_io+0x180/0x1d0
 > >  > 
 > >  > Huh, are you able to reproduce at will?  From this code path it should
 > >  > mean somebody else is unlocking a page they don't own.
 > > 
 > > pretty easily yeah. I hit it maybe a couple dozen times yesterday.
 > > So if you've got some idea of printk's to spray anywhere I can give
 > > that a shot.
 > 
 > I'd rather try to trigger it here.  Going to have to add some way to
 > record which stack trace last unlocked and/or freed the page.

perhaps a clue.. this is the log fragment from the last trinity run..

[child4:1416] [25] splice(fd_in=257, off_in=0x0, fd_out=257, off_out=0x0, len=0xe000, flags=0x0) = -1 (Invalid argument)
[child4:1416] [26] pwrite64(fd=257, buf=0x2253530, count=782, pos=0x40404000) 
[child5:1414] [28] semop(semid=-16274, tsops=0x0, nsops=0x2000000000c6b4d5) = -1 (Invalid argument)
[child5:1414] [29] mlockall(flags=0x1) 
[child6:1427] [50] getgid() = 1000
[child6:1427] [51] mlock(addr=0x7f4c00d62000, len=0) 
[child7:1402] [79] setuid(uid=0x790617fe) = -1 (Invalid argument)
[child7:1402] [80] write(fd=257, buf=0x2255d90, count=2296) 

the oops I got was in write(), so it looked like a parallel write() with pwrite() was the trigger.

Sure enough, doing a run with -c write -c pwrite64 reproduces it even faster.

	Dave

