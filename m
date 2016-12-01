Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41495 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756237AbcLAAJ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 19:09:26 -0500
Date: Wed, 30 Nov 2016 16:09:19 -0800
From: Marc MERLIN <marc@merlins.org>
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Coly Li <i@coly.li>, linux-bcache@vger.kernel.org,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 4.8.8, bcache deadlock and hard lockup
Message-ID: <20161201000919.GB13371@merlins.org>
References: <20161118164643.g7ttuzgsj74d6fbz@merlins.org> <20161118184915.j6dlazbgminxnxzx@merlins.org> <b6c3daab-d990-e873-4d0f-0f0afe2259b1@coly.li> <alpine.LRH.2.11.1611291255350.1914@mail.ewheeler.net> <20161130164646.d6ejlv72hzellddd@merlins.org> <alpine.LRH.2.11.1611301553420.22682@mail.ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LRH.2.11.1611301553420.22682@mail.ewheeler.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 30, 2016 at 03:57:28PM -0800, Eric Wheeler wrote:
> > I'll start another separate thread with the btrfs folks on how much
> > pressure is put on the system, but on your side it would be good to help
> > ensure that bcache doesn't crash the system altogether if too many
> > requests are allowed to pile up.
> 
> Try BFQ.  It is AWESOME and helps reduce the congestion problem with bulk 
> writes at the request queue on its way to the spinning disk or SSD:
> 	http://algo.ing.unimo.it/people/paolo/disk_sched/
> 
> use the latest BFQ git here, merge it into v4.8.y:
> 	https://github.com/linusw/linux-bfq/commits/bfq-v8
> 
> This doesn't completely fix the dirty_ration problem, but it is far better 
> than CFQ or deadline in my opinion (and experience).

That's good to know thanks.
But for my uninformed opinion, is there anything bcache can do to throttle
incoming requests if they are piling up, or they're coming from producers
upstream and bcache has no choice but try and process them as quickly as
possible without a way to block the sender if too many are coming?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
