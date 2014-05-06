Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39452 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbaEFTmN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 15:42:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WhjXD-0006Vw-Tj
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 19:52:08 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 19:52:07 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 19:52:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Using mount -o bind vs mount -o subvol=vol
Date: Tue, 6 May 2014 17:34:11 +0000 (UTC)
Message-ID: <pan$db71b$28ae8fc2$4747ca76$c08f8373@cox.net>
References: <20140504004732.GE9061@merlins.org>
	<5365E74B.6020805@swiftspirit.co.za> <20140505005644.GB10159@merlins.org>
	<53670FEA.8050806@swiftspirit.co.za> <20140505103617.0e66f5a9@natsu>
	<536735FB.6020205@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide posted on Mon, 05 May 2014 08:55:55 +0200 as excerpted:

> You are 100% right, though. The scale is very small. By negligible, the
> "penalty" is at most a few CPU cycles. When compared to the wait time on
> a spindle, it really doesn't matter much.

The analogy I've used before is that of taking a trip (which the data 
effectively is, between the device and the CPU).

We've booked a 10-day cruise and are now debating what we plan on taking 
to and from the boarding dock.  Will taking the local bus with a couple 
of transfers, or a taxi that will take us there in one trip but there's 
road construction and thus a detour, or a helicopter to fly directly,  
get us back from the cruise faster?

Obviously, taking the helicopter (at least for the return leg) will get 
us back a bit faster, but we're talking perhaps a couple hours difference 
at the end of a 10 day cruise!

=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

