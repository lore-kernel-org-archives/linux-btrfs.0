Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49451 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755729AbaCSQxh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 12:53:37 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:53238 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WQJkC-003tv7-CI
	for linux-btrfs@vger.kernel.org; Wed, 19 Mar 2014 10:53:33 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How to handle a RAID5 arrawy with a failing drive? -> raid5 mostly works, just no rebuilds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140319154031.GP6143@merlins.org>
Date: Wed, 19 Mar 2014 10:53:33 -0600
Message-Id: <EBE67530-BDC7-487C-826D-A0E65259BCBA@colorremedies.com>
References: <1394983430-20440-1-git-send-email-fdmanana@gmail.com> <1395002246-3840-1-git-send-email-fdmanana@gmail.com> <20140316222026.GU16946@merlins.org> <pan$2239d$446ec5c7$d67506b7$f25a7c65@cox.net> <20140319060902.GM6143@merlins.org> <CD1D8CED-8BC2-4C16-AE9E-0C47DC954CFA@colorremedies.com> <20140319154031.GP6143@merlins.org>
To: Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 19, 2014, at 9:40 AM, Marc MERLIN <marc@merlins.org> wrote:
> 
> After adding a drive, I couldn't quite tell if it was striping over 11
> drive2 or 10, but it felt that at least at times, it was striping over 11
> drives with write failures on the missing drive.
> I can't prove it, but I'm thinking the new data I was writing was being
> striped in degraded mode.

Well it does sound fragile after all to add a drive to a degraded array, especially when it's not expressly treating the faulty drive as faulty. I think iotop will show what block devices are being written to. And in a VM it's easy (albeit rudimentary) with sparse files, as you can see them grow.

> 
> Yes, although it's limited, you apparently only lose new data that was added
> after you went into degraded mode and only if you add another drive where
> you write more data.
> In real life this shouldn't be too common, even if it is indeed a bug.

It's entirely plausible a drive power/data cable becomes lose, runs for hours degraded before the wayward device is reseated. It'll be common enough. It's definitely not OK for all of that data in the interim to vanish just because the volume has resumed from degraded to normal. Two states of data, normal vs degraded, is scary. It sounds like totally silent data loss. So yeah if it's reproducible it's worthy of a separate bug.


Chris Murphy

