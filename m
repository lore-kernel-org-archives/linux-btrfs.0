Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33997 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbaESNG2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 09:06:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WmNGo-0001rn-QO
	for linux-btrfs@vger.kernel.org; Mon, 19 May 2014 15:06:22 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 15:06:22 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 15:06:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Convert btrfs software code to ASIC
Date: Mon, 19 May 2014 13:06:11 +0000 (UTC)
Message-ID: <pan$baa26$f0b99545$2d209bf8$14063927@cox.net>
References: <CAF_AmaOyqgxn8rPs4rKugUz9ZkGoc4mt+Q8Q-nLJF_hPxUufZw@mail.gmail.com>
	<CAG1y0sf9tW+151DMvihWgRFnbUs3Q=uKyL3W4_heU7rYBQz0=w@mail.gmail.com>
	<CAF_AmaOJF4W5uABSvrtBGg7NUzcmE03Qtom+THKFEP_oYH3gmg@mail.gmail.com>
	<B7F2379062E32745A8651FBDB20F64592FCF3D03@Server.waterlogic.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Paul Jones posted on Mon, 19 May 2014 12:24:53 +0000 as excerpted:

>> On Mon, May 19, 2014 at 3:40 PM, Le Nguyen Tran <lntran.de@gmail.com>
>> wrote:
>>>
>>> I have a plan to develop an IC controller for Network Attached
>>> Storage (NAS). The main idea is converting software code into
>>> hardware implementation.
>>>
>>> I plan to use btrfs as the file system specification for my NAS.

> Perhaps a better idea would be to use a low-cost low-power som module
> to run Linux and btrfs code, and use an FPGA/ASIC to offload
> compression/encryption/checksums and to possibly act as a raid
> controller. Since btrfs will be under heavy development for the
> foreseeable future I doubt it would be a good idea to lock it into
> silicon. Using this approach the mature technologies can be hardware
> accelerated, and the software parts are available for easy upgrades.
> It also significantly reduces risk for your project, and VCs like that
> sort of thing!

This is a very good idea and what I was about to suggest.  Certainly, 
btrfs is still not fully stable, and I really would hate to see the 
current implementation etched in silicon at this time.  However, a hybrid 
approach where the mature bits such as (de-/)compression/checksums/
encryption are hardware etched/accelerated while the more general and 
still developing code is deployed as upgradeable firmware on a system-on-
module sounds like a very good idea indeed, particularly if that firmware 
is deployed as a user-modifiable/replaceable free-as-in-freedom kernel in 
keeping with the spirit of the GPL under which the Linux kernel and thus 
btrfs are written.

In other words... I doubt very much that any list regular here familiar 
with the continuing flow of bugs we see, as well as the roadmapped but 
not yet implemented features that people wanting a hardware 
implementation would certainly be interested in, would find the idea of a 
hardware implementation of anything like current code anything but 
nightmare material. =:^\  Maybe in a couple years... but even then, 
upgradeable firmware with critical mature bits offloaded for hardware 
acceleration sounds like a far better idea.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

