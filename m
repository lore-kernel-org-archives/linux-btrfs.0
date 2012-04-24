From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: complete page writeback before doing ordered
 extents
Date: Tue, 24 Apr 2012 10:15:29 -0400
Message-ID: <20120424141529.GI22794@shiny>
References: <1335202424-7135-1-git-send-email-josef@redhat.com>
 <4F9606EF.2080005@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F9606EF.2080005@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2012 at 09:50:39AM +0800, Liu Bo wrote:
> On 04/24/2012 01:33 AM, Josef Bacik wrote:
> 
> > We can deadlock waiting for pages to end writeback because we are doing an
> > allocation while hold a tree lock since the ordered extent stuff will
> > require tree locks.  A quick easy way to fix this is to end page writeback
> > before we do our ordered io stuff, which works fine since we don't really
> > need the page for this to work.  Eventually we want to make this work happen
> > as soon as the io is completed and then push the ordered extent stuff off to
> > a worker thread, but at this stage we need this deadlock fixed with changing
> > as little as possible.  Thanks,
> > 
> 
> 
> Hi Josef,
> 
> I'm ok with the patch, but could you show us more details about the deadlock between allocation and endio?

Josef and I have been talking about this one off-list for a while.  It's
a deadlock I tracked down in my overnight stress runs.

Basically what we have is the io-less dirty throttling code saying there
are too many pages in writeback, and so new allocations are backing up
and waiting for pages to leave writeback.

But the pages can't leave writeback because we're waiting on more memory
to complete the metadata changes at endio time.  Strictly speaking the
VM is doing something wrong here, our NOFS allocations shouldn't be
waiting for writeback to finish.

But, strictly speaking we're doing something wrong too, we're doing too
many allocations with pages tied up in writeback.

So this splits the page from the metadata changes.  We're still doing
the metadata changes after the IO is complete, but we're doing them
after we've let the pages go.

-chris
