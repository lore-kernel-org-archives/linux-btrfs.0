Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41161 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbcGOG4V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 02:56:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bNx2o-0008Cr-Nb
	for linux-btrfs@vger.kernel.org; Fri, 15 Jul 2016 08:56:18 +0200
Received: from ip1f11faed.dynamic.kabel-deutschland.de ([31.17.250.237])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 08:56:18 +0200
Received: from hurikhan77 by ip1f11faed.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 08:56:18 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
Date: Fri, 15 Jul 2016 08:56:04 +0200
Message-ID: <20160715085604.57ebf411@jupiter.sol.kaishome.de>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
	<55BAFEF9.1070107@cn.fujitsu.com>
	<CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
	<55BB0A39.1050208@cn.fujitsu.com>
	<CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com>
	<CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
	<55C017E7.40704@cn.fujitsu.com>
	<CAJ3TwYTd_8-uwn-osNsf6UAuxGvoJCeWmxWYNHmzXoF_+yrABA@mail.gmail.com>
	<55C02AF9.3070600@cn.fujitsu.com>
	<CAJ3TwYQUX-CgqSXMxxU+6tcb0_0tuJbwKqHHPufCnsDBYuXycw@mail.gmail.com>
	<55C0A1ED.6020407@gmail.com>
	<CAJ3TwYQgm2f4SQFOO_vgGLP0V71q+oesbjFxTjhEJnrXYLe4fQ@mail.gmail.com>
	<55C1F3DD.7020603@gmail.com>
	<CAJ3TwYSW+SvbBrh1u_x+c3HTRx03qSR6BoH5cj_VzCXxZYv6EA@mail.gmail.com>
	<126f9f09-4e28-3c12-5384-63032e17942f@cn.fujitsu.com>
	<CAJ3TwYRXwDVVfT0TRRiM9dEw-7TvY8qG=WvMYKczZOv6wkFWAQ@mail.gmail.com>
	<fd718727-9b54-ba58-5f39-63066181d13e@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 15 Jul 2016 13:24:45 +0800
schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:

> > as for defrag, all my partitions are already on
> > autodefrag, so I assume that should be good. Or is manual once in a
> > while a good idea as well?  
> AFAIK autodefrag will only help if you're doing appending write.
> 
> Manual one will help more, but since btrfs has problem defraging
> extents shared by different subvolumes, I doubt the effect if you
> have a lot of subvolumes/snapshots.

"btrfs fi defrag" is said to only defrag metadata if you are pointing
it to directories only without recursion. It could maybe help that case
without unsharing the extents:

find /btrfs-subvol0 -type d -print0 | xargs -0 btrfs fi defrag

-- 
Regards,
Kai

Replies to list-only preferred.

