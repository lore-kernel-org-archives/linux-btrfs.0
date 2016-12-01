Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:41364 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752715AbcLAV7m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Dec 2016 16:59:42 -0500
Date: Thu, 1 Dec 2016 13:58:33 -0800 (PST)
From: Eric Wheeler <bcache@lists.ewheeler.net>
To: Marc MERLIN <marc@merlins.org>
cc: Coly Li <i@coly.li>, linux-bcache@vger.kernel.org,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 4.8.8, bcache deadlock and hard lockup
In-Reply-To: <20161201000919.GB13371@merlins.org>
Message-ID: <alpine.LRH.2.11.1612011350290.22682@mail.ewheeler.net>
References: <20161118164643.g7ttuzgsj74d6fbz@merlins.org> <20161118184915.j6dlazbgminxnxzx@merlins.org> <b6c3daab-d990-e873-4d0f-0f0afe2259b1@coly.li> <alpine.LRH.2.11.1611291255350.1914@mail.ewheeler.net> <20161130164646.d6ejlv72hzellddd@merlins.org>
 <alpine.LRH.2.11.1611301553420.22682@mail.ewheeler.net> <20161201000919.GB13371@merlins.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 30 Nov 2016, Marc MERLIN wrote:
> On Wed, Nov 30, 2016 at 03:57:28PM -0800, Eric Wheeler wrote:
> > > I'll start another separate thread with the btrfs folks on how much
> > > pressure is put on the system, but on your side it would be good to help
> > > ensure that bcache doesn't crash the system altogether if too many
> > > requests are allowed to pile up.
> > 
> > Try BFQ.  It is AWESOME and helps reduce the congestion problem with bulk 
> > writes at the request queue on its way to the spinning disk or SSD:
> > 	http://algo.ing.unimo.it/people/paolo/disk_sched/
> > 
> > use the latest BFQ git here, merge it into v4.8.y:
> > 	https://github.com/linusw/linux-bfq/commits/bfq-v8
> > 
> > This doesn't completely fix the dirty_ration problem, but it is far better 
> > than CFQ or deadline in my opinion (and experience).
> 
> That's good to know thanks.
> But for my uninformed opinion, is there anything bcache can do to throttle
> incoming requests if they are piling up, or they're coming from producers
> upstream and bcache has no choice but try and process them as quickly as
> possible without a way to block the sender if too many are coming?

Not really.  The congestion isn't in bcache, its at the disk queue beyond 
bcache, but userspace processes are blocked by the (huge) pagecache dirty 
writeback which happens before bcache gets it and must complete before 
userspace may proceed: 

fs -> pagecache -> bcache -> {ssd,disk}  

The real issue is that the dirty page cache gets really big, flushes, 
waits for downstream devices (bcache->ssd,disk) to finish, and then 
returns to userspace.  The only way to limit dirty cache are those options 
that Linus mentioned.

BFQ can help for processes not tied to the flush because it may re-order 
other process requests ahead of the big flush---so even though a big flush 
is happening and that process is stalled, others might proceed without 
delay.

See this thread, too:
	https://groups.google.com/forum/#!msg/bfq-iosched/M2M_UhbC05A/hf6Ni9JbAQAJ

--
Eric Wheeler



> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
