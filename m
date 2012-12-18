Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:33989 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab2LRNit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 08:38:49 -0500
Date: Tue, 18 Dec 2012 08:38:46 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: fix remount vs autodefrag
Message-ID: <20121218133846.GA2403@localhost.localdomain>
References: <50B32FE7.5080908@cn.fujitsu.com>
 <50B3362D.1030409@cn.fujitsu.com>
 <20121214175106.GH3152@localhost.localdomain>
 <50CEC8C5.8010201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50CEC8C5.8010201@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 17, 2012 at 12:24:53AM -0700, Miao Xie wrote:
> On 	fri, 14 Dec 2012 12:51:06 -0500, Josef Bacik wrote:
> > On Mon, Nov 26, 2012 at 02:28:13AM -0700, Miao Xie wrote:
> >> If we remount the fs to close the auto defragment or make the fs R/O, we should
> >> stop the auto defragment.
> >>
> >> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> > 
> > I'm dropping this patch, it causes a deadlock since defrag will need to reserve
> > metadata which could call writeback_sb_nr_if_idle which does a
> > down_read(&sb->s_umount).  Figure out another way to fix this and I'll apply it.
> > Thanks,
> 
> Hi, Josef
> 
> I forget to point out this patch is based on my patches:
> 	[PATCH 1/2 RESEND] vfs: re-implement writeback_inodes_sb(_nr)_if_idle() and rename them
> 	[PATCH 2/2 RESEND] Btrfs: flush all the dirty pages if try_to_writeback_inodes_sb_nr() fails
> 
> But I found you implemented a new writeback_sb_nr_if_idle()(Btrfs: fix autodefrag and umount lockup),
> with this new function, my patch(Btrfs: fix remount vs autodefrag) also can wrok well.
> 

Yeah I'll pull them on now.  Once Al takes the vfs patch we can drop my local
function, so when that happens send a patch to remove it please.  Thanks,

Josef
