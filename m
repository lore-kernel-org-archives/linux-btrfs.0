Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60319 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbaF0NHJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 09:07:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X0Vrv-0008U7-3e
	for linux-btrfs@vger.kernel.org; Fri, 27 Jun 2014 15:07:07 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 15:07:07 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 15:07:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Blocked tasks on 3.15.1
Date: Fri, 27 Jun 2014 13:06:52 +0000 (UTC)
Message-ID: <pan$81d96$8a4effae$94572f09$472a11ff@cox.net>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Fri, 27 Jun 2014 12:02:43 +0200 as excerpted:

>> I've been getting blocked tasks on 3.15.1 generally at times when the
>> filesystem is somewhat busy (such as doing a backup via scp/clonezilla
>> writing to the disk).
> 
> I've started seeing similar on several servers, after upgrading to 3.15
> or 3.15.1. With 3.16-rc1 it was even crashing for me.
> I've rolled back to the latest 3.14.x, and it's still behaving fine.
> 
> I've signalled it before on the list in "btrfs filesystem hang with
> 3.15-rc3 when doing rsync" thread.

There is a known btrfs lockup bug that was introduced in the commit-
window btrfs pull for 3.16, that was fixed by a pull I believe the day 
before 3.16-rc2.  So 3.16-pre to rc2 is known-bad tho it'll work for a 
few minutes and didn't do any permanent damage that I could see, here.

But from 3.16-rc2 on, the 3.16-pre series has been working fine for me.

For 3.15, I didn't run the pre-releases as I had another project I was 
focusing on, but I experienced no problems with 3.15 itself.  However, my 
use-case is multiple independent small btrfs on partitioned SSD, sub-100-
GB per btrfs, so I'd be less likely to experience the blocked task issues 
that others reported, mostly on TB+ size spinning rust.

And it /did/ seem to me that the frequency of blocked-task reports were 
higher for 3.15 than for previous kernel series, tho 3.15 worked fine for 
me on small btrfs on SSD, the relatively short time I ran it.

Hopefully that problem's fixed on 3.16-rc2+, but as of yet there's not 
enough 3.16-rc2+ reports out there from folks experiencing issues with 
3.15 blocked tasks to rightfully say.  What CAN be said is that the known 
3.16-series commit-window btrfs lockups bug that DID affect me was fixed 
right before rc2, and I'm running rc2+ just fine, here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

