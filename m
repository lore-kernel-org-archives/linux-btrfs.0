Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:33434 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726821AbeIMWE4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 18:04:56 -0400
Date: Thu, 13 Sep 2018 09:54:27 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: skip set_page_dirty if eb is dirty
Message-ID: <20180913165426.hxoeqwnqk4wvksne@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1536703587-94565-1-git-send-email-bo.liu@linux.alibaba.com>
 <e74ad1e7-4b37-a1c6-596b-56dc4fcf96ba@suse.com>
 <20180912192745.elkmdpl5hyrawxks@US-160370MP2.local>
 <20180913112959.GT2154@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180913112959.GT2154@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 13, 2018 at 01:29:59PM +0200, David Sterba wrote:
> On Wed, Sep 12, 2018 at 12:27:46PM -0700, Liu Bo wrote:
> > On Wed, Sep 12, 2018 at 09:37:20AM +0300, Nikolay Borisov wrote:
> > > 
> > > 
> > > On 12.09.2018 01:06, Liu Bo wrote:
> > > > As long as @eb is marked with EXTENT_BUFFER_DIRTY, all of its pages
> > > > are dirty, so no need to set pages dirty again.
> > > > 
> > > > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > > 
> > > Does make it any performance difference, numbers?
> > >
> > 
> > To be honest, the performance difference would be trivial in a normal
> > big test round.  But I just looked into the difference from my ftrace,
> > removing the loop can reduce the time spent by 10us in my box.
> 
> 10us was for the case where the pages were dirty already and the for
> cycle was then skipped?
> 
> set_page_dirty is not lightweight, calls down to various functions and
> holds locks. I can't tell if this is still fast enough on your machine
> so that it really takes 10us.
>

Sorry for not making it clear, on my box 10us was spent in the 'for'
loop, which iterates 4 pages and 4 calls for set_page_dirty().

thanks,
-liubo

> The conditional dirtying is definetelly worth though,
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
