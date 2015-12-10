Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16940 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbbLJVfb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 16:35:31 -0500
Date: Thu, 10 Dec 2015 13:35:16 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>, Dave Jones <davej@codemonkey.org.uk>,
        jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: !PageLocked BUG_ON hit in clear_page_dirty_for_io
Message-ID: <20151210213515.GB11639@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
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

Looks like a bisect with 4.3 might target the commit.

Thanks,

-liubo
> 
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
