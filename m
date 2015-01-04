Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37368 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbbADDZF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Jan 2015 22:25:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y7boM-00067K-TK
	for linux-btrfs@vger.kernel.org; Sun, 04 Jan 2015 04:25:03 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 04:25:02 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 04:25:02 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: I need to P. are we almost there yet?
Date: Sun, 4 Jan 2015 03:24:07 +0000 (UTC)
Message-ID: <pan$8ee61$1a422331$bc1be88f$33af022f@cox.net>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
	<54A7D3D1.10508@shiftmail.org>
	<pan$872b8$2e173aaa$59613c61$c4e30dfd@cox.net>
	<20150104025835.02f0d6b8@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Sun, 04 Jan 2015 02:58:35 +0500 as excerpted:

> On Sat, 3 Jan 2015 13:11:57 +0000 (UTC)
> Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> > What about using btrfs on top of MD raid?
>> 
>> The problem with that is data integrity.  mdraid doesn't have it. 
>> btrfs does.
> 
> Most importantly however, you aren't any worse off with Btrfs on top of
> MD, than with Btrfs on a single device, or with Ext4/XFS/JFS/etc on top
> of MD.

Good point! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

