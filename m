Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45976 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbbLNH7u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 02:59:50 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Marc MERLIN <marc@merlins.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: still kworker at 100% cpu in all of device size allocated with chunks situations with write load (was: Re: Still not production ready)
Date: Mon, 14 Dec 2015 08:59:48 +0100
Message-ID: <1564094.hdGdVPRvJz@merkaba>
In-Reply-To: <20151213231914.GJ2662@merlins.org>
References: <8336788.myI8ELqtIK@merkaba> <20151213231914.GJ2662@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 13. Dezember 2015, 15:19:14 CET schrieb Marc MERLIN:
> On Sun, Dec 13, 2015 at 11:35:08PM +0100, Martin Steigerwald wrote:
> > Hi!
> > 
> > For me it is still not production ready. Again I ran into:
> > 
> > btrfs kworker thread uses up 100% of a Sandybridge core for minutes on
> > random write into big file
> > https://bugzilla.kernel.org/show_bug.cgi?id=90401
> 
> Sorry you're having issues. I haven't seen this before myself.
> I couldn't find the kernel version you're using in your Email or the bug
> you filed (quick scan).
> 
> That's kind of important :)

I definately know this much. :) It happened with 4.3 yesterday. The other 
kernel version was 3.18. Information should be in the bug report. Yeah, 3.18 
as mentioned in the Kernel Version field. And 4.3 as I mentioned in the last 
comment of the bug report.

The scrubbing issue is I think since 4.3, I also seen it with 4.4-rc2/rc4 I 
believe, but I didn´t go back then to check more toroughly. I didn´t report 
the scrubbing issue with bugzilla yet as I got no feedback on my mailing list 
posts so far. I will bump the thread in a moment and suggest we discuss free 
space issue here and scrubbing issue in the other thread. I went back to 4.3 
cause 4.4-rc2/4 does not even boot on my machine most of the times. I also 
reported this (BTRFS unrelated one).

Thanks,
-- 
Martin
