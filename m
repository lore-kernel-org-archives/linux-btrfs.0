Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43631 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030AbcAOQMm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 11:12:42 -0500
Date: Fri, 15 Jan 2016 11:12:24 -0500
From: Chris Mason <clm@fb.com>
To: <dsterba@suse.cz>, Zhao Lei <zhaolei@cn.fujitsu.com>,
        "'btrfs'" <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Fujitsu for 4.5
Message-ID: <20160115161224.GA38730@clm-mbp.thefacebook.com>
References: <01ad01d14de4$b9489900$2bd9cb00$@cn.fujitsu.com>
 <20160114141710.GW4227@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160114141710.GW4227@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 14, 2016 at 03:17:10PM +0100, David Sterba wrote:
> On Wed, Jan 13, 2016 at 05:28:12PM +0800, Zhao Lei wrote:
> > This is collection of some bug fix, enhance and cleanup from fujitsu
> > against btrfs for v4.5, mainly for reada, plus some small fix and cleanup
> > for scrub and raid56.
> > 
> > All patchs are in btrfs-maillist, rebased on top of integration-4.5.
> > 
> > Would you please consider merging the following fixes to integration-4.5 branch?
> 
> > Zhao Lei (26):
> ...
> >   btrfs: reada: Avoid many times of empty loop
> >   btrfs: reada: Move is_need_to_readahead contition earlier
> >   btrfs: reada: add all reachable mirrors into reada device list
> >   btrfs: reada: bypass adding extent when all zone failed
> >   btrfs: reada: Remove level argument in severial functions
> >   btrfs: reada: move reada_extent_put to place after __readahead_hook()
> >   btrfs: reada: Pass reada_extent into __readahead_hook directly
> >   btrfs: reada: Use fs_info instead of root in __readahead_hook's
> >     argument
> >   btrfs: reada: Jump into cleanup in direct way for __readahead_hook()
> >   btrfs: reada: Fix a debug code typo
> ...
> >   btrfs: reada: limit max works count
> >   btrfs: reada: simplify dev->reada_in_flight processing
> 
> I have reviewed the readahead patches and ack them for 4.5.

My plan is to send the first 4.5 pull on Monday with the current
integration.  I hit an oom during overnight runs, and I'm double
checking things after that.

I'll get the reada stuff merged for a second pull.

-chris

