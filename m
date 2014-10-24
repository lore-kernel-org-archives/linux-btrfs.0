Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36064 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaJXBdx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 21:33:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XhTlG-0001bV-BA
	for linux-btrfs@vger.kernel.org; Fri, 24 Oct 2014 03:33:50 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Oct 2014 03:33:50 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Oct 2014 03:33:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Poll: time to switch skinny-metadata on by default?
Date: Fri, 24 Oct 2014 01:33:39 +0000 (UTC)
Message-ID: <pan$c6d4f$2fb03bde$c07e7d4a$f7039042@cox.net>
References: <20141016113337.GC22943@twin.jikos.cz>
	<20141020163403.GW22943@twin.jikos.cz>
	<pan$32992$bbc3a80d$ad912ad2$31fcc5ce@cox.net>
	<CAGfcS_nTbXQQTOC+QcBX8dbwk18Qbf-+JonQSw4WP6MOFg2z7A@mail.gmail.com>
	<pan$19856$ee791297$ceeef1ce$27ae8dc@cox.net>
	<CAKFHe2RxEZo25+3ye6fLmfadSbVZ5rri8h_FPt5iAy3-AiSqPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tobias Geerinckx-Rice posted on Thu, 23 Oct 2014 16:47:19 +0200 as
excerpted:

> On 22 October 2014 04:08, Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> Since the kernel has code for both "fat" metadata and skinny-metadata,
>> they can exist side-by-side and the kernel will use whichever code is
>> appropriate.
> 
> I understand that the fat extent code will probably never be removed for
> compatibility reasons, but do wonder why it's still the default.
> Caution?

Caution, backward kernel compatibility, and simply timing.

The skinny code is newer, and there were several skinny-metadata related 
bugs in the first couple kernel cycles it was available, so not making it 
the immediate default was certainly wise.  Tho the new code has been 
reasonably stable for awhile, now.  But that's exactly why this 
discussion, is it time to make the new code the default yet, or not, 
because it hasn't been done yet.

Additionally, some people want to keep the flexibility to mount with old 
kernels.  Consider a distro installation and rescue image (ISO or USB), 
for instance.  Those can be used for rescue purposes for not only the 
life of that distro release, but for sometime afterward.  If the only 
rescue image you can find is a two year old image and it won't mount your 
btrfs because the on-device format has changed since then and your 
filesystem is the newer format, you're going to be one frustrated btrfs 
user!

> Petr Janecek's balancing problem [1] and similar bugs aside: is there a
> functional reason to prefer "fat" over skinny metadata for future file
> systems?

Other than keeping backward compatibility to work with old rescue images 
and the like, as discussed above, not that I'm aware of.  IOW, I know of 
no corner-case where fat metadata is now more efficient or more stable.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

