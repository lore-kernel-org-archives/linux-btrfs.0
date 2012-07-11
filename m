Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:36678 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab2GKMbu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jul 2012 08:31:50 -0400
Date: Wed, 11 Jul 2012 08:31:47 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC] Btrfs: improve multi-thread buffer read
Message-ID: <20120711123147.GH7529@localhost.localdomain>
References: <1341919679-13792-1-git-send-email-liubo2009@cn.fujitsu.com>
 <20120710185822.GE7529@localhost.localdomain>
 <4FFCDDA3.4000002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FFCDDA3.4000002@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 10, 2012 at 07:57:55PM -0600, Liu Bo wrote:
> On 07/11/2012 02:58 AM, Josef Bacik wrote:
> 
> > On Tue, Jul 10, 2012 at 05:27:59AM -0600, Liu Bo wrote:
> >> While testing with my buffer read fio jobs[1], I find that btrfs does not
> >> perform well enough.
> >>
> >> Here is a scenario in fio jobs:
> >>
> >> We have 4 threads, "t1 t2 t3 t4", starting to buffer read a same file,
> >> and all of them will race on add_to_page_cache_lru(), and if one thread
> >> successfully puts its page into the page cache, it takes the responsibility
> >> to read the page's data.
> >>
> >> And what's more, reading a page needs a period of time to finish, in which
> >> other threads can slide in and process rest pages:
> >>
> >>      t1          t2          t3          t4
> >>    add Page1
> >>    read Page1  add Page2
> >>      |         read Page2  add Page3
> >>      |            |        read Page3  add Page4
> >>      |            |           |        read Page4
> >> -----|------------|-----------|-----------|--------
> >>      v            v           v           v
> >>     bio          bio         bio         bio
> >>
> >> Now we have four bios, each of which holds only one page since we need to
> >> maintain consecutive pages in bio.  Thus, we can end up with far more bios
> >> than we need.
> >>
> >> Here we're going to
> >> a) delay the real read-page section and
> >> b) try to put more pages into page cache.
> >>
> >> With that said, we can make each bio hold more pages and reduce the number
> >> of bios we need.
> >>
> >> Here is some numbers taken from fio results:
> >>          w/o patch                 w patch
> >>        -------------  --------  ---------------
> >> READ:    745MB/s        +32%       987MB/s
> >>
> > 
> > Um, I have this in btrfs-next
> > 
> > Btrfs: use large extent range for read and its endio
> > 
> > that seems to do the same thing, did you not want to do that anymore?  Thanks,
> > 
> 
> 
> 
> I'm still hard working on that patchset. :)
> 
> Although the patchset is well worthy of testing, it is not good enough for btrfs upstream.
> 
> While doing some tuning work on it, I realized that I could make this improvement without
> the help of rwlock extent state stuff, so I made this smaller and cleaner patch for upstream
> so that we could gain some performance here first.
> 

So do you want me to drop the rwlock stuff and take this instead?  Take a look
at whats in btrfs-next and tell me what I should drop.  Thanks,

Josef
