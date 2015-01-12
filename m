Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42895 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbbALEwh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Jan 2015 23:52:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YAWzS-0008Hk-5K
	for linux-btrfs@vger.kernel.org; Mon, 12 Jan 2015 05:52:34 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 05:52:34 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 05:52:34 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: What about storing more crc32 in the unused csum size for
 metadata?
Date: Mon, 12 Jan 2015 04:52:22 +0000 (UTC)
Message-ID: <pan$8d162$d4e83036$79c5caa1$f18c808@cox.net>
References: <54B3323E.3090100@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Mon, 12 Jan 2015 10:32:30 +0800 as excerpted:

> [New layout]
> Take leafsize as 4K for example.
> 
> Sectors:
> |---0---|---1---|---2---|---3---|---4---|---5---|---6---|---7---|
> Sector 0: Csum of the leaf/node (32~4K)(not changed)
> Sector 1: Csum of the first eighths of the leaf/node (32~512)
> Sector 2: Csum of the second eighths of the leaf/node (512~1024)
> ....
> Sector 7: Csum of the last eighths of the leaf/node (3584 ~ 4096)

OK, I've been up too long and should be sleeping, and it may be that's 
affecting my logic, but AFAICT either you're missing something obvious, 
or I am.

There are eight eights, and eight "sectors", but the first one is already 
used, thus leaving seven available.  You have the first eighth (ending at 
byte 512*1) in sector one (zero-based so the second sector), the second 
(ending at byte 512*2=1024) in sector two... the last (eighth) eighth 
(ending at byte 512*8=4096) in sector seven.

Of eighths 3-7 in that ..., which eighth do you skip csumming, or is one 
of them a full quarter instead of an eighth?

Of course if we could make them sevenths...  But making it four quarters 
instead of 7/8 is perhaps more reasonable, with the remaining three 
sectors remaining unused, and if only one fails csum we still save 75% of 
the leaf/node, instead of none of it, currently.

But maybe it makes complete sense as-is and I should be sleeping instead 
of trying to make sense of what is clearly not making sense to me at this 
point...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

