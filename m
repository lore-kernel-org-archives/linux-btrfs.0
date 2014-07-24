Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38663 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934120AbaGXIPn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 04:15:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XAEBd-0002V9-Jx
	for linux-btrfs@vger.kernel.org; Thu, 24 Jul 2014 10:15:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 10:15:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 10:15:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [BUG] bogus out of space reported when mounted raid1 degraded
Date: Thu, 24 Jul 2014 08:15:25 +0000 (UTC)
Message-ID: <pan$baa06$27e40267$9e1a1203$82dc6ed8@cox.net>
References: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com>
	<BEB1C719-6B2A-46DC-9CBA-A22F53C6407C@colorremedies.com>
	<pan$83a22$939c719d$63069ee2$976101e3@cox.net>
	<48B1705A-635D-4E03-8005-7E7930D970A8@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 23 Jul 2014 19:13:10 -0600 as excerpted:


> On Jul 22, 2014, at 11:24 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> ** ON BTRFS RAID1, TWO DEVICES MUST BE PRESENT IN ORDERED TO ALLOCATE
>> NEW CHUNKS.  MOUNTING DEGRADED WITH A SINGLE DEVICE MEANS NO NEW CHUNK
>> ALLOCATION, WHICH MEANS YOU'RE LIMITED TO FILLING UP EXISTING CHUNKS **
> 
> I can confirm this behavior (see below).

And...

If I'm reading it correctly, patch 9/10 in Miao Xie's new 10-part patch 
series should fix that.

From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 09/10] Btrfs: don't consider the missing device when
 allocating new chunks
Date: Thu, 24 Jul 2014 11:37:14 +0800
Message-ID: <1406173035-29478-9-git-send-email-miaox@cn.fujitsu.com>

While I don't claim to be a dev, based on the comments and my reading of 
the patch (and assuming there's no other location blocking it that needs 
patched as well), that should allow new, effectively single-mode chunks 
to be allocated when a btrfs multi-device raid1 mode filesystem is 
mounted degraded with just a single device.  That should allow normal 
writes to continue altho in single mode, and a balance -Xconvert=raid1 
can be used later to upgrade back to raid1 after a second device is added 
back in.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

