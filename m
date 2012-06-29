Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:58000 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab2F2NFN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 09:05:13 -0400
Date: Fri, 29 Jun 2012 09:05:10 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix dio write vs buffered read race V2
Message-ID: <20120629130510.GY17638@shiny>
References: <1340718176-4999-1-git-send-email-jbacik@fusionio.com>
 <4FEBD0EC.6070802@cn.fujitsu.com>
 <20120628123422.GB1729@localhost.localdomain>
 <4FED107B.9020308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FED107B.9020308@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 28, 2012 at 08:18:35PM -0600, Miao Xie wrote:
> On Thu, 28 Jun 2012 08:34:23 -0400, Josef Bacik wrote:
> > On Wed, Jun 27, 2012 at 09:35:08PM -0600, Miao Xie wrote:
> >> On Tue, 26 Jun 2012 09:42:56 -0400, Josef Bacik wrote:
> >>> From: Josef Bacik <josef@redhat.com>
> >>>
> >>> Miao pointed out there's a problem with mixing dio writes and buffered
> >>> reads.  If the read happens between us invalidating the page range and
> >>> actually locking the extent we can bring in pages into page cache.  Then
> >>> once the write finishes if somebody tries to read again it will just find
> >>> uptodate pages and we'll read stale data.  So we need to lock the extent and
> >>> check for uptodate bits in the range.  If there are uptodate bits we need to
> >>> unlock and invalidate again.  This will keep this race from happening since
> >>> we will hold the extent locked until we create the ordered extent, and then
> >>> teh read side always waits for ordered extents.  Thanks,
> >>
> >> This patch still can not work well. It is because we don't update i_size in time.
> >> 	Writer		Worker		Reader
> >> 	lock_extent
> >> 	do direct io
> >> 	end io
> >> 			finish io
> >> 			unlock_extent
> >> 					lock_extent
> >> 					check the pos is beyond EOF or not
> >> 					  beyond EOF, zero the page and set it uptodate
> >> 					unlock_extent
> >> 	update i_size
> >>
> >> So I think we must update the i_size in time, and I wrote a small patch to do it:
> >>
> > 
> > We should probably be updating i_size when we create an extent past EOF in the
> > write stuff, not during endio, I will work this out and fold it into my patch.
> > Good catch.
> 
> It is better that update i_size in endio, I think. because during endio, we are sure that
> the data is flushed into the disk successfully, and can update i_size at ease. and if the
> error happens when flushing the data into the disk, we also needn't reset i_size.

I think the i_size update should happen sooner.  The rest of the
filesystems work that way, and it will have fewer interaction problems
with the VM.

-chris
