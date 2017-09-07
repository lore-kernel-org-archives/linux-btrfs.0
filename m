Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48423 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdIGAvo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Sep 2017 20:51:44 -0400
Date: Wed, 6 Sep 2017 17:48:10 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: avoid wake_up if possible
Message-ID: <20170907004810.GD16924@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170901221430.10131-2-bo.li.liu@oracle.com>
 <20170906141904.GN31874@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170906141904.GN31874@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 06, 2017 at 04:19:04PM +0200, David Sterba wrote:
> On Fri, Sep 01, 2017 at 04:14:27PM -0600, Liu Bo wrote:
> > wake_up() will go to check whether someone is on the waiting list with
> > holding spin_lock().
> >
> > Around some btrfs code, we don't check waitqueue_active() firstly, so
> > the spin_lock() pair in wake_up() is called even if no one is waiting
> > on the queue.
> > 
> > There are more wake_up()s without waitqueue_active(), but these two
> > are the hottest one I've run into so far.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Can you please split the patch and address both separately, as they are
> not affecting the same data structure? It would be good to mention the
> other parts of code specifically (not just "around some code"), or
> briefly describe the state transitions where it matters for the wake
> ups.
>

OK.

> A missed wakeup appears as if the system is hung, but it's not a
> deadlock and we don't have much help debugging that when it happens. I'd
> like to review that in a way where I can make sure you have checked all
> the possible lost wakeups.

Good point, but it seems that we could only prove it on code level
(like the comments put around the code).

-liubo
