Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:33146 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040Ab2KAJBE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 05:01:04 -0400
Date: Thu, 1 Nov 2012 17:00:00 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/5] Btrfs: fix missing flush when committing a
 transaction
Message-ID: <20121101085959.GD2554@liubo.cn.oracle.com>
References: <509225BA.4080105@cn.fujitsu.com>
 <20121101074443.GC1591@liubo.cn.oracle.com>
 <50922A0D.80103@cn.fujitsu.com>
 <20121101080420.GA2554@liubo.cn.oracle.com>
 <50922FEB.8030900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50922FEB.8030900@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 01, 2012 at 04:16:43PM +0800, Miao Xie wrote:
> On thu, 1 Nov 2012 16:04:27 +0800, Liu Bo wrote:
> > (sorry, forgot to cc linux-btrfs.)
> > On Thu, Nov 01, 2012 at 03:51:41PM +0800, Miao Xie wrote:
> >> On Thu, 1 Nov 2012 15:44:43 +0800, Liu Bo wrote:
> >>> On Thu, Nov 01, 2012 at 03:33:14PM +0800, Miao Xie wrote:
> >>>> Consider the following case:
> >>>> 	Task1				Task2
> >>>> 	start_transaction
> >>>> 					commit_transaction
> >>>> 					  check pending snapshots list and the
> >>>> 					  list is empty.
> >>>> 	add pending snapshot into list
> >>>> 					  skip the delalloc flush
> >>>> 	end_transaction
> >>>> 					  ...
> >>>>
> >>>> And then the problem that the snapshot is different with the source subvolume
> >>>> happen.
> >>>>
> >>>
> >>> This is weird, create_snapshot() will first add pending snapshot into
> >>> list and then commit the transaction itself, regardless of if the
> >>> snapshot is different with others or not.
> >>
> >> But the transaction may be committed by the other task, and the snapshot
> >> creation task just wait until it ends.
> >>
> > 
> > It's possible that a commit tranaction becomes a end transaction when it
> > finds itself is already in commit.
> > 
> > So if snapshot creation starts the transaction, it will increment the
> > transaction's num_writers, why does not the other task wait for its
> > end_transacion?
> > 
> > I doubt if this can really happen anyway...
> > 
> > Can you elaborate the situation more?
> 
> Task1					Task2
> start_transaction
> 					start_transaction
> 					commit_transaction
> 					  set in_commit to 1
> 					  check pending snapshots list and the list is empty.
> add pending snapshot into list
> 					  skip the delalloc flush
> commit_transaction
>   find in_commit is 1
>   end_transaction (num_writer--)
>   wait_for_commit
> 					  num_writer is 1
> 				  	  continue committing the transaction
> 					  ...
> 

Make sense.

Then I think we'd better put the flush part right after setting 'trans_no_join = 1'
since snapshot creation may also join an existing transaction.

thanks,
liubo
