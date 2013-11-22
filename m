Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33802 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab3KVRsV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 12:48:21 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 153679A0372
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 10:48:21 -0700 (MST)
Date: Fri, 22 Nov 2013 12:48:19 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: reclaim the reserved metadata space at
 background
Message-ID: <20131122174819.GA26620@localhost.localdomain>
References: <1385041398-8521-1-git-send-email-miaox@cn.fujitsu.com>
 <1385041398-8521-5-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1385041398-8521-5-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 21, 2013 at 09:43:18PM +0800, Miao Xie wrote:
> Before applying this patch, the task had to reclaim the metadata space
> by itself if the metadata space was not enough. And When the task started
> the space reclamation, all the other tasks which wanted to reserve the
> metadata space were blocked. At some cases, they would be blocked for
> a long time, it made the performance fluctuate wildly.
> 

So the reason the flushing is done this way is because of this level of hell
called "early enospc."  Basically we'd get people flushing randomly and other
users would come in and use the reclaimed space, so whoever was flushing would
often ENOSPC because they thought they did everything they could to flush and
still couldn't make allocations.  This approach is a nice balance keeping the
old "one at a time" flushers and adding a background flusher, but I still worry
about people competing with the background flushing.

Consider the case where the background flusher has started and taken all of the
ordered extents on the system to flush (and lets assume that we only have
reservations tied up in ordered extents, which is very possible).  Then a task
comes in to make a reservation but it can't because it doesn't have space, so it
tries to flush.  But the inline flushing stuff doesn't find any ordered extents
to flush because they've been spliced off the list by the background flusher.
So we bail out and do -ENOSPC even though there is plenty of space.

What I would like to see is some way for a flusher who has to flush inline be
able to see that there is a background flusher and wait for it to finish its
work before doing its own flushing.  If I have to start tracking down early
ENOSPC problems again I may very well quit doing file system work forever.
Thanks,

Josef
