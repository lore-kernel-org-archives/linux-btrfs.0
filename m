Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21079 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbbINTbg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 15:31:36 -0400
Date: Mon, 14 Sep 2015 15:31:27 -0400
From: Chris Mason <clm@fb.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Horrible dbench performance
Message-ID: <20150914193126.GC11307@ret.masoncoding.com>
References: <20150914152820.GA25610@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20150914152820.GA25610@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 14, 2015 at 11:28:21PM +0800, Liu Bo wrote:
> Hi,
> 
> Both [1] and [2] had run dbench on btrfs with fast storage, and 
> showed bad numbers, I got an impression that after refractoring btree lock to
> smart rwlock, we have mitigated this issue..
> 
> Not got a fast-enough ssd handy, does anyone confirm the result showed
> in those link?
> 
> [1]:https://lkml.org/lkml/2015/4/29/793
> [2]:https://lkml.org/lkml/2015/8/21/22
> 

Taking a quick look, its not clear to me which operation the latency
number corresponds to.  I think the sources are picking the worst
latency that any of the children see, and since there are a number of
fsyncs as part of each run, my guess is that our fsync is ending up
slower than the others.

If you just run dbench with one writer on my machine, its ~2x faster
than XFS in tput with half the latency.

If you go up to 200 writers, xfs cruises along at 1,100MB/s and btrfs is
pegged at 281MB/s.  All the CPUs are at 100% system time, all hitting
lock contention on the root of the btree.

If you create a subvolume for each of the clients, btrfs goes up to
3600MB/s and latencies about 3x of XFS.  It runs flat out that way until
it fills the drive.

If someone wants to dive into the latencies, that would be great.  It's
probably fsync, and it's probably CPU bound because Josef changed things
around to do inline crcs (which is the right answer imho).

-chris

