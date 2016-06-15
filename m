Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42354 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933222AbcFOPVM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 11:21:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bDCcu-00008L-Q1
	for linux-btrfs@vger.kernel.org; Wed, 15 Jun 2016 17:21:10 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 17:21:08 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 17:21:08 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Balance fails with unallocated diskspace
Date: Wed, 15 Jun 2016 15:21:03 +0000 (UTC)
Message-ID: <pan$ea7fd$2f56e349$db0ce34a$6e2e77cd@cox.net>
References: <CALy3tB3YaTAYrZLhA7X0CTCUNLm7JCAyVX0WSdp1K48TNfFAUA@mail.gmail.com>
	<CALy3tB28Kx6aHTj+B-g68foh2bKSb0cnPcy7D-QQw3WPb9Wz4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nisse Karlsson posted on Wed, 15 Jun 2016 11:58:36 +0200 as excerpted:

> Since I have about 1.5TB unallocated space it's my understanding that
> this shouldn't be a problem, or am I completely wrong?

Quick partial answer...

It's not just unallocated space in total that matters, but also the 
number of devices with unallocated space.  To write raid10 chunks 
requires four devices.  To write raid1 chunks requires two.

However, your usage output does indicate several hundred gigs of 
unallocated space on multiple devices, so convert to raid1 shouldn't be 
ENOSPCing...  That it is would indicate a bug.  There have been various 
bugs of this sort, but I'm just a list regular, not a dev, and I'm not 
sure of the current status, whether any such bugs are currently known or 
not.

You don't mention kernel version in your post and I don't have time to 
look up the bug ATM, but you might try the latest 4.1 and 4.4 LTS kernels 
as well as the latest 4.6 and 4.7-rc kernels to see if it makes a 
difference.  If it's a problem with 4.6 and 4.7-rc then it becomes 
interesting, and if it works with 4.4 or 4.1, even more so.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

