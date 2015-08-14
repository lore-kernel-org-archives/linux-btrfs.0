Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48394 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbbHNAap (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 20:30:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZQ2tP-0007Ie-GH
	for linux-btrfs@vger.kernel.org; Fri, 14 Aug 2015 02:30:43 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 02:30:43 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 02:30:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
Date: Fri, 14 Aug 2015 00:30:33 +0000 (UTC)
Message-ID: <pan$9bab3$33004c18$3a12cc04$86d0a7bb@cox.net>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
	<55BADEC4.3020409@cn.fujitsu.com>
	<CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
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
	<55C1F3DD.7020603@gmail.com> <1439505513.484813682@apps.rackspace.com>
	<CAJCQCtQ2fK4S_RJRzg3EE+0qu4ipFtDVfshWuxjnF2nzpF8vLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 13 Aug 2015 17:19:41 -0600 as excerpted:

> Well I think others have suggested 3000 snapshots and quite a few things
> will get very slow. But then also you have autodefrag and I forget the
> interaction of this with many snapshots since the snapshot aware defrag
> code was removed.

Autodefrag shouldn't have any snapshots mount-time-related interaction, 
with snapshot-aware-defrag disabled.  The interaction between defrag 
(auto or not) and snapshots will be additional data space usage, since 
with snapshot-aware disabled, defrag only works with the current copy, 
thus forcing it to COW the extents elsewhere while not freeing the old 
extents as they're still referenced by the snapshots, but it shouldn't 
affect mount-time.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

