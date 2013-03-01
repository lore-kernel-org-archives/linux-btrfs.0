Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab3CAPdk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Mar 2013 10:33:40 -0500
Date: Fri, 1 Mar 2013 16:33:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: try harder to allocate raid56 stripe cache
Message-ID: <20130301153338.GV27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362150180-13792-1-git-send-email-dsterba@suse.cz>
 <20130301151426.GA10225@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130301151426.GA10225@shiny.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 01, 2013 at 10:14:26AM -0500, Chris Mason wrote:
> On Fri, Mar 01, 2013 at 08:03:00AM -0700, David Sterba wrote:
> > The stripe hash table is large, starting with allocation order 4 and can go as
> > high as order 7 in case lock debugging is turned on and structure padding
> > happens.
> 
> Thanks Dave, I had this on my todo list but it dropped off.  We don't
> really need the stripe cache for most mounts.  The code was initially
> setup to only allocate it when we read a raid5/6 block group, but I ran
> into trouble for the sys array.

Yeah, the cmpxchg looks strange for a one-time allocation.

> Still, it should really be changed to only load the cache when we hit
> raid5/6 goodness.

That makes sense, but even in that case I suggest to use the the vmalloc
fallback.

The smallest size I've calculated is ~49k and the one I'm observing with
all the debugging switches turned on is 360544. The 64k kmalloc bucket
has a slightly bigger chance to keep one or two entries available so we
don't need vmalloc most of the time. In the remaining cases we would see
spurious mount failures and this impedes automated testing.

david
