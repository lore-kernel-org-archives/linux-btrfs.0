Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34143 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab3LEKkj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Dec 2013 05:40:39 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VoWMI-0003sL-BZ
	for linux-btrfs@vger.kernel.org; Thu, 05 Dec 2013 11:40:38 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Dec 2013 11:40:38 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Dec 2013 11:40:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ERROR: send ioctl failed with -12: Cannot allocate memory
Date: Thu, 5 Dec 2013 10:40:17 +0000 (UTC)
Message-ID: <pan$4241a$4b7f93$d94ca09a$ad1032fe@cox.net>
References: <52A01A29.3020005@jrs-s.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jim Salter posted on Thu, 05 Dec 2013 01:16:09 -0500 as excerpted:

> Sending a 585G snapshot from box1 to box2:

>      59%
>      ERROR: unexpected EOF in stream.
> 
> Send failed a little over halfway through with "Cannot allocate memory"
> error.  Which is surprising, given that this is a relatively lightly
> loaded 32G server.

What kernel are you running?  There are a number of very recent memory 
leak patches, so recently that even 3.12 may not have them, especially if 
you're not on the latest stable update.  If you're running the latest 
3.13-r2 or a live-git kernel, you'll have those fixes, but there may be 
others still in the pipeline, as memory leaks seem to be the focus right 
now and as I said several have been very recently fixed.

If you're running the very latest 3.13 git kernels and are still seeing 
it, then I expect the devs will be very interested indeed, because that 
does seem to be one of the major focuses ATM, so might as well get it 
fixed while it's hot!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

