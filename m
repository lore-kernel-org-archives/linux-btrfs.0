Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:35177 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758615Ab2JZMhO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 08:37:14 -0400
Date: Fri, 26 Oct 2012 08:37:11 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BUG in btrfs_set_item_key_safe
Message-ID: <20121026123711.GC23729@shiny>
References: <508A2F3F.3030500@jan-o-sch.net>
 <20121026121941.GB23729@shiny>
 <508A824E.805@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <508A824E.805@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 26, 2012 at 06:30:06AM -0600, Jan Schmidt wrote:
> On Fri, October 26, 2012 at 14:19 (+0200), Chris Mason wrote:
> > On Fri, Oct 26, 2012 at 12:35:43AM -0600, Jan Schmidt wrote:
> >> Hi,
> >>
> >> while running extensive qgroup and tree mod log tests I got to the following
> >> BUG, which is probably not related to tree mod log:
> > 
> > So our keys are out of order...are you able to reproduce this?
> 
> No reproducer yet. My tests ran fine for about 15 hours before that happened.
> I'll have an extensive amount of (tree mod log related) debug information if I
> should get there again.
> 
> My guess is that it's not related to tree mod log, though, as there are tree log
> functions (fs/btrfs/tree-log.c) on the stack. I don't think rewinded buffers can
> make it there.
> 
> I'll call back when I'll hit this again.

This is more likely to be memory corruption.  I'd suggest turning on
slab debug and CONFIG_DEBUG_PAGE_ALLOC...hopefully you'll get a faster
crash.

-chris

