Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:29031 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751079Ab3JAF0T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 01:26:19 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Progress of device deletion?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$d4ca0$5ff8830c$a79d58d4$78936022@cox.net>
Date: Mon, 30 Sep 2013 23:26:16 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <2754C186-FACD-4621-9876-2328C90978CC@colorremedies.com>
References: <alpine.DEB.2.10.1309290902050.24007@shack.dolda2000.com> <2E504581-FA34-425A-B14B-EF3F16FC655C@colorremedies.com> <F4008F3B-594D-4003-BC06-82B9E18AA023@colorremedies.com> <pan$d4ca0$5ff8830c$a79d58d4$78936022@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 30, 2013, at 10:43 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> Meanwhile, I really do have to question the use case where the risks of a 
> single dead device killing a raid0 (or for that matter, running still 
> experimental btrfs) are fine, but spending days doing data maintenance on 
> data not valuable enough to put on anything but experimental btrfs raid0, 
> is warranted over simply blowing the data away and starting with brand 
> new mkfs-ed filesystems.

Yes of course. It must be a test case, and I think for non-experimental stable Btrfs it's reasonable to have reliable device delete regardless of the raid level because it's offered. And after all maybe the use case involves enterprise SSDs, each of which should have a less than 1% chance of failing during their service life. (Naturally, that's going to go a lot faster than days.)


> That a strong hint to me that either the raid0 
> use case is wrong, or the days of data move and reshape instead of 
> blowing it away and recreating brand new filesystems, is wrong, and that 
> one or the other should be reevaluated.

I think it's the wrong use case today, except for testing it. It's legit to try and blow things up, simply because it's offered functionality, so long as the idea is "I really would like to have this workflow actually work in 2-5 years". Otherwise it is sortof a rat hole.

The other thing, clearly the OP is surprised it's taking anywhere near this long. Had he known in advance, he probably would have made a different choice.

Chris Murphy

