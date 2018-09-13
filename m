Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46438 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727720AbeIMQjF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 12:39:05 -0400
Date: Thu, 13 Sep 2018 13:29:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: skip set_page_dirty if eb is dirty
Message-ID: <20180913112959.GT2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1536703587-94565-1-git-send-email-bo.liu@linux.alibaba.com>
 <e74ad1e7-4b37-a1c6-596b-56dc4fcf96ba@suse.com>
 <20180912192745.elkmdpl5hyrawxks@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180912192745.elkmdpl5hyrawxks@US-160370MP2.local>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 12:27:46PM -0700, Liu Bo wrote:
> On Wed, Sep 12, 2018 at 09:37:20AM +0300, Nikolay Borisov wrote:
> > 
> > 
> > On 12.09.2018 01:06, Liu Bo wrote:
> > > As long as @eb is marked with EXTENT_BUFFER_DIRTY, all of its pages
> > > are dirty, so no need to set pages dirty again.
> > > 
> > > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > 
> > Does make it any performance difference, numbers?
> >
> 
> To be honest, the performance difference would be trivial in a normal
> big test round.  But I just looked into the difference from my ftrace,
> removing the loop can reduce the time spent by 10us in my box.

10us was for the case where the pages were dirty already and the for
cycle was then skipped?

set_page_dirty is not lightweight, calls down to various functions and
holds locks. I can't tell if this is still fast enough on your machine
so that it really takes 10us.

The conditional dirtying is definetelly worth though,

Reviewed-by: David Sterba <dsterba@suse.com>
