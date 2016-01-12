Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45764 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139AbcALAUS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 19:20:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aImh4-0005Wf-So
	for linux-btrfs@vger.kernel.org; Tue, 12 Jan 2016 01:20:15 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 01:20:14 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 01:20:14 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs-progs: Format change for btrfs fi df
Date: Tue, 12 Jan 2016 00:20:09 +0000 (UTC)
Message-ID: <pan$32077$664eed64$6034389c$264c6b0d@cox.net>
References: <1450070396-20744-1-git-send-email-quwenruo@cn.fujitsu.com>
	<568B23E4.5040809@cn.fujitsu.com> <20160111155108.GH4227@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Mon, 11 Jan 2016 16:51:08 +0100 as excerpted:

> Hi
> 
> On Tue, Jan 05, 2016 at 10:01:08AM +0800, Qu Wenruo wrote:
>> Would you please consider merge this patch?
>> 
>> As current output is already quite confusing for a lot of users who are
>> not familiar with btrfs.
> 
> I understand it's confusing but as there's some history behind this
> option I need to think about the consequences. I'd rather keep it in the
> output, removing stuff is likely to cause breakage in scripts etc. OTOH,
> the 'fi df' was supposed to be a debugging helper but not everybody is
> used to 'fi usage' yet.

Not only is not everybody used to btrfs fi usage yet, but because it's 
still broken in various cases as well as relatively new, btrfs fi df 
along with btrfs fi sh remains the recommended way of getting that 
information.

Of course we can't go back in time to introduce btrfs fi usage earlier, 
but the sooner it works on all btrfs, including mixed-mode, which I know 
it doesn't properly support yet, and raid56, which IIRC it didn't support 
but I can't directly test, without producing weird EiB readings, the 
sooner we'll be able to generally recommend it except for people using 
what will eventually be very old tools, where the first recommendation is 
to upgrade in any case.

But for now, because fi usage doesn't work in a significant number of 
cases, recommending that people use and post fi df and fi sh remains the 
easiest way to dependably get the needed information, without going off 
into paragraphs of exception explanation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

