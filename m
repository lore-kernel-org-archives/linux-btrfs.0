Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45744 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab3I2CbX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 22:31:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VQ6n2-0000ZF-Qm
	for linux-btrfs@vger.kernel.org; Sun, 29 Sep 2013 04:31:20 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 04:31:20 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 04:31:20 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Corrupt btrfs filesystem recovery... (Due to *sata* errors)
Date: Sun, 29 Sep 2013 03:31:10 +0100
Message-ID: <l283d5$egr$1@ger.gmane.org>
References: <l27agq$u5a$1@ger.gmane.org> <87F045E8-CBB5-4818-B60B-0325EC87A56D@colorremedies.com> <l27mgf$qmn$1@ger.gmane.org> <53F0C9F1-BF66-47DA-BAE9-7E0C3B7030EF@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
In-Reply-To: <53F0C9F1-BF66-47DA-BAE9-7E0C3B7030EF@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

Thanks for good comment/discussion.

On 29/09/13 03:06, Chris Murphy wrote:
> 
> On Sep 28, 2013, at 4:51 PM, Martin <m_btrfs@ml1.co.uk> wrote:
> 

> Stick with forced 3Gbps, but I think it's worth while to find out
> what the actual problem is. One day you forget about this 3Gbps SATA
> link, upgrade or regress to another kernel and you don't have the
> 3Gbps forced speed on the parameter line, and poof - you've got more
> problems again. The hardware shouldn't negotiate a 6Gbps link and
> then do a backwards swan dive at 30,000' with your data as if it's an
> after thought.

I've got an engineer's curiosity so that one is very definitely marked
for revisiting at some time... If only to blog that x-y-z combination is
a tar pit for your data...


>> In any case, for the existing HDD - motherboard combination, using
>> sata2 rather than sata3 speeds shouldn't noticeably impact
>> performance. (Other than sata2 works reliably and so is infinitely
>> better for this case!)
> 
> It's true.

Well, the IO data rate for badblocks is exactly the same as before,
limited by the speed of the physical rust spinning and data density...


> I would also separately unmount the file system, note the latest
> kernel message, then mount the file system and see if there are any
> kernel messages that might indicate recognition of problems with the
> fs.
> 
> I would not use btrfsck --repair until someone says it's a good idea.
> That person would not be me.

It is sat unmounted until some informed opinion is gained...


Thanks again for your notes,

Regards,
Martin




