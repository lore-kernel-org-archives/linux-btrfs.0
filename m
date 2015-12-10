Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:45748 "EHLO
	arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbbLJTgH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 14:36:07 -0500
Date: Thu, 10 Dec 2015 14:35:55 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>, jbacik@fb.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: Re: !PageLocked BUG_ON hit in clear_page_dirty_for_io
Message-ID: <20151210193555.GA23535@codemonkey.org.uk>
References: <20151209042528.GA2413@codemonkey.org.uk>
 <20151210190220.GA11257@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151210190220.GA11257@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 10, 2015 at 02:02:20PM -0500, Chris Mason wrote:
 > On Tue, Dec 08, 2015 at 11:25:28PM -0500, Dave Jones wrote:
 > > Not sure if I've already reported this one, but I've been seeing this
 > > a lot this last couple days.
 > > 
 > > kernel BUG at mm/page-writeback.c:2654!
 > > invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN
 > > CPU: 1 PID: 2566 Comm: trinity-c1 Tainted: G        W       4.4.0-rc4-think+ #14
 > > task: ffff880462811b80 ti: ffff8800cd808000 task.ti: ffff8800cd808000
 > > RIP: 0010:[<ffffffff8826ff40>]  [<ffffffff8826ff40>] clear_page_dirty_for_io+0x180/0x1d0
 > 
 > Huh, are you able to reproduce at will?  From this code path it should
 > mean somebody else is unlocking a page they don't own.

pretty easily yeah. I hit it maybe a couple dozen times yesterday.
So if you've got some idea of printk's to spray anywhere I can give
that a shot.

	Dave


