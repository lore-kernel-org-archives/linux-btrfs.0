Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51286 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbaHLEUG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 00:20:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XH3Z6-0001tG-6Q
	for linux-btrfs@vger.kernel.org; Tue, 12 Aug 2014 06:20:04 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 06:20:04 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 06:20:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Blocked tasks on 3.15.1
Date: Tue, 12 Aug 2014 04:18:03 +0000 (UTC)
Message-ID: <pan$e7fab$40d0be50$30c4f68e$1b9d7ed2@cox.net>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
	<53C7CD0F.7070603@fb.com>
	<CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com>
	<1745216.hDa4tC2HJJ@merkaba> <53CE7ACF.7070109@fb.com>
	<20140812025521.GA6730@pyropus.ca>
	<20140812025641.GA9244@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liu Bo posted on Tue, 12 Aug 2014 10:56:42 +0800 as excerpted:

> On Mon, Aug 11, 2014 at 08:55:21PM -0600, Charles Cazabon wrote:
>> The blocked tasks issue that got significantly worse in 3.15 -- did
>> anything go into 3.16 related to this?  I didn't see a single "btrfs"
>> in Linus' 3.16 announcement, so I don't know whether it should be
>> better, the same, or worse in this respect...
>> 
>> I haven't seen a definite statement about this on this list, either.
>> 
>> Can someone more familiar with the state of development comment on
>> this?
> 
> Good news is that we've figured out the bug and the patch is already
> under testing :-)

IOW, it's not in 3.16.0, but will hopefully make it into 3.16.2 (it'll 
likely be a too late for 3.16.1).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

