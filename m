Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:48241 "EHLO
	arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbbLKD7q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 22:59:46 -0500
Date: Thu, 10 Dec 2015 22:59:34 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>, jbacik@fb.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: Re: !PageLocked BUG_ON hit in clear_page_dirty_for_io
Message-ID: <20151211035934.GA31872@codemonkey.org.uk>
References: <20151209042528.GA2413@codemonkey.org.uk>
 <20151210190220.GA11257@ret.masoncoding.com>
 <20151210193555.GA23535@codemonkey.org.uk>
 <20151210213024.GC11257@ret.masoncoding.com>
 <20151210225720.GA2437@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151210225720.GA2437@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 10, 2015 at 05:57:20PM -0500, Dave Jones wrote:
 > On Thu, Dec 10, 2015 at 04:30:24PM -0500, Chris Mason wrote:
 >  > On Thu, Dec 10, 2015 at 02:35:55PM -0500, Dave Jones wrote:
 >  > > On Thu, Dec 10, 2015 at 02:02:20PM -0500, Chris Mason wrote:
 >  > >  > On Tue, Dec 08, 2015 at 11:25:28PM -0500, Dave Jones wrote:
 >  > >  > > Not sure if I've already reported this one, but I've been seeing this
 >  > >  > > a lot this last couple days.
 >  > >  > > 
 >  > >  > > kernel BUG at mm/page-writeback.c:2654!
 >  > >  > > invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN
 >  > >  > > CPU: 1 PID: 2566 Comm: trinity-c1 Tainted: G        W       4.4.0-rc4-think+ #14
 >  > >  > > task: ffff880462811b80 ti: ffff8800cd808000 task.ti: ffff8800cd808000
 >  > >  > > RIP: 0010:[<ffffffff8826ff40>]  [<ffffffff8826ff40>] clear_page_dirty_for_io+0x180/0x1d0
 >  > >  > 
 >  > >  > Huh, are you able to reproduce at will?  From this code path it should
 >  > >  > mean somebody else is unlocking a page they don't own.
 >  > > 
 >  > > pretty easily yeah. I hit it maybe a couple dozen times yesterday.
 >  > > So if you've got some idea of printk's to spray anywhere I can give
 >  > > that a shot.
 >  > 
 >  > I'd rather try to trigger it here.  Going to have to add some way to
 >  > record which stack trace last unlocked and/or freed the page.
 > 
 > I'm using..
 > 
 > trinity -q -l off -C8 -a64 -x fsync -x fdatasync -x syncfs -x sync --enable-fds=testfile,pseudo
 > 
 > interestingly, if I just use 'testfile' by itself, I can't reproduce it.
 > (That means "create a bunch a few files in current dir and use their fds")
 > the "pseudo" bit means "also use fds from /proc, /sys and /dev".

Actually scratch that. I finally got it to reproduce with just 'testfile'.
Which makes sense, given its a btrfs bug we're chasing, not anything to do
with sys/proc

	Dave
