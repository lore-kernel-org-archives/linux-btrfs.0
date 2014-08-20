Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52702 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaHTEGG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 00:06:06 -0400
Date: Tue, 19 Aug 2014 20:22:05 -0700
From: Marc MERLIN <marc@merlins.org>
To: M G Berberich <btrfs@oss.m-berberich.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Questions on using BtrFS for fileserver
Message-ID: <20140820032205.GL3875@merlins.org>
References: <20140819162151.GA15166@forwiss.uni-passau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140819162151.GA15166@forwiss.uni-passau.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 19, 2014 at 06:21:52PM +0200, M G Berberich wrote:
> · incremental send/receive works.
 
Yes.

> · There is no support for hotspares (spare disks that automatically
>   replaces faulty disk).

Correct

> · BtrFS with RAID1 is fairly stable.

>From what I know.

> · RAID 5/6 spreads all data over all devices, leading to performance
>   problems on large diskarrays, and there is no option to limit the
>   numbers of disk per stripe so far.

Not sure about the performance issue, but either way, don't use RAID5/6
with btrfs for anything else than playing around. The code is not
finished.

> · If a disk failes, does BtrFS rebalance automatically? (This would
>   give a a kind o hotspare behavior)
 
No, not for raid5/6.

> · Are there any reports/papers/web-pages about BtrFS-systems this size
>   in use? Praises, complains, performance-reviews, whatever…

Use md-raid5 which is known and true, and put btrfs on top.
And still have backups, be ready for btrfs to become unusable (speed
and/or deadlocks), get trashed, or some other problem.
It's not guaranteed to happen, but the odds are far from being 0 either,
so either your data is throwaway, or have good backups.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
