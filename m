Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933870AbcDEW2G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Apr 2016 18:28:06 -0400
Date: Tue, 5 Apr 2016 15:28:04 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com, clm@fb.com
Subject: Re: Qgroups wrong after snapshot create
Message-ID: <20160405222804.GC2187@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20160404230657.GA2187@wotan.suse.de>
 <57031465.8070006@cn.fujitsu.com>
 <20160405221654.GB2187@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160405221654.GB2187@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 05, 2016 at 03:16:54PM -0700, Mark Fasheh wrote:
> On Tue, Apr 05, 2016 at 09:27:01AM +0800, Qu Wenruo wrote:
> > Mark Fasheh wrote on 2016/04/04 16:06 -0700:
> > >Hi,
> > >
> > >Making a snapshot gets us the wrong qgroup numbers. This is very easy to
> > >reproduce. From a fresh btrfs filesystem, simply enable qgroups and create a
> > >snapshot. In this example we have mounted a newly created fresh filesystem
> > >and mounted it at /btrfs:
> > >
> > ># btrfs quota enable /btrfs
> > ># btrfs sub sna /btrfs/ /btrfs/snap1
> > ># btrfs qg show /btrfs
> > >
> > >qgroupid         rfer         excl
> > >--------         ----         ----
> > >0/5          32.00KiB     32.00KiB
> > >0/257        16.00KiB     16.00KiB
> > >
> > 
> > Also reproduced it.
> > 
> > My first idea is, old snapshot qgroup hack is involved.
> > 
> > Unlike btrfs_inc/dec_extent_ref(), snapshotting just use a dirty
> > hack to handle it:
> > Copy rfer from source subvolume, and directly set excl to nodesize.
> > 
> > If such work is before adding snapshot inode into src subvolume, it
> > may be the reason causing the bug.
> 
> Ok, thanks very much for looking into this Qu.
> 
> 
> > >In the example above, the default subvolume (0/5) should read 16KiB
> > >referenced and 16KiB exclusive.
> > >
> > >A rescan fixes things, so we know the rescan process is doing the math
> > >right:
> > >
> > ># btrfs quota rescan /btrfs
> > ># btrfs qgroup show /btrfs
> > >qgroupid         rfer         excl
> > >--------         ----         ----
> > >0/5          16.00KiB     16.00KiB
> > >0/257        16.00KiB     16.00KiB
> > >
> > 
> > So the base of qgroup code is not affected, or we may need another
> > painful rework.
> 
> Yeah as far as I can tell the core algorithm is fine. We're just running the
> extents incorrectly somehow.

Btw, I should add - my biggest fear was an algorithm change which would have
made older versions of btrfsck incompatible. It seems though we can still
use it for checking qgroups.
	--Mark

--
Mark Fasheh
