Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5338 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324AbcBZO6D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 09:58:03 -0500
Date: Fri, 26 Feb 2016 09:57:40 -0500
From: Chris Mason <clm@fb.com>
To: Roman Mamedov <rm@romanrm.net>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] btrfs: Continue write in case of can_not_nocow
Message-ID: <20160226145740.3mjkh2gxbjqs2kmv@floor.thefacebook.com>
References: <9b89157957abcc87a6ea0530989a4984794484cd.1452078012.git.zhaolei@cn.fujitsu.com>
 <20160226104131.21d98d57@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160226104131.21d98d57@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2016 at 10:41:31AM +0500, Roman Mamedov wrote:
> On Wed, 6 Jan 2016 19:00:17 +0800
> Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
> 
> > btrfs failed in xfstests btrfs/080 with -o nodatacow.
> > 
> > Can be reproduced by following script:
> >   DEV=/dev/vdg
> >   MNT=/mnt/tmp
> > 
> >   umount $DEV &>/dev/null
> >   mkfs.btrfs -f $DEV
> >   mount -o nodatacow $DEV $MNT
> > 
> >   dd if=/dev/zero of=$MNT/test bs=1 count=2048 &
> >   btrfs subvolume snapshot -r $MNT $MNT/test_snap &
> >   wait
> >   --
> >   We can see dd failed on NO_SPACE.
> > 
> > Reason:
> >   __btrfs_buffered_write should run cow write when no_cow impossible,
> >   and current code is designed with above logic.
> >   But check_can_nocow() have 2 type of return value(0 and <0) on
> >   can_not_no_cow, and current code only continue write on first case,
> >   the second case happened in doing subvolume.
> > 
> > Fix:
> >   Continue write when check_can_nocow() return 0 and <0.
> > 
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> Guys please don't forget about this patch. It solves real problem for people,
> http://www.spinics.net/lists/linux-btrfs/msg51276.html
> http://www.spinics.net/lists/linux-btrfs/msg51819.html
> but it's not in 4.4.1, not in 4.4.2... and now not in 4.4.3

Dave already has it queued for the next merge window.  Thanks!

-chris
