Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:33827 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab2FZM4P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 08:56:15 -0400
Date: Tue, 26 Jun 2012 08:56:11 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: "Chris L. Mason" <clmason@fusionio.com>, Josef Bacik <JBacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2] Btrfs: fix old data problem caused by aio vs dio
Message-ID: <20120626125611.GB2046@localhost.localdomain>
References: <4FE95195.3080402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FE95195.3080402@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 12:07:17AM -0600, Miao Xie wrote:
> The 209th case of xfstests failed because of the race between aio and dio. The
> detail reason is following:
> 	Task1		Task2			Btrfs-worker
> 			invalidate pages
> 	read pages
> 			do direct io
> 			invalidate pages fail*
> 						finish ordered io
> 	read data from
> 	pages
> 

This just papers over the problem and makes DIO touch page cache which it
shouldn't be doing if it's working properly, so NAK.  We need to figure out why
exactly my patch didn't work, since it should be working.  The write should be
doing

lock_extent
setup ordered extent
unlock_extent

and the read should be doing

lock_extent
check for ordered extent
	if there is one unlock and wait and then loop
do read
unlock_extent

there should be no room for races in here.  The patch I sent earlier should have
caught if we had done a read between the invalidate and the locking and should
be invalidating the range again and then checking.  If this isn't working then
something else is going sideways and we really need to figure out what it is
rather than just working around the issue, as it will likely bite us in a
different way later.  Thanks,

Josef
