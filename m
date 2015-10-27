Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51530 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbbJ0Gje (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 02:39:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zqxuu-0003zF-OL
	for linux-btrfs@vger.kernel.org; Tue, 27 Oct 2015 07:39:32 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 07:39:32 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 07:39:32 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Bad fs performance, IO freezes
Date: Tue, 27 Oct 2015 06:39:25 +0000 (UTC)
Message-ID: <pan$f1907$281e469a$9ad1b02d$53b95aea@cox.net>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
	<562E37F4.9080602@oracle.com>
	<CA+9GZUjnrdA-O24bbY4KGAxcLOk26uohS8cF+Z=vLjOT88-rwQ@mail.gmail.com>
	<CA+9GZUi9jiJ9RBezrh7Xi4_1eBpyeNBdrs+hYxsECaa_a9_csA@mail.gmail.com>
	<CA+9GZUipGeuNuVP2=g2+gbWpJWxbeHVQEcQ5QYfOCWjkv5JDcQ@mail.gmail.com>
	<CA+9GZUhAZRYto0Rm3Edy0j3gFfGZbfWpqunA3vzraxwh-ANORg@mail.gmail.com>
	<CA+9GZUjTt7C4rjSgui3M65S_WEQ3zsLEjw39x=_Ots=N8Jn3eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cheater00 . posted on Tue, 27 Oct 2015 03:00:05 +0100 as excerpted:

> currently my computer freezes every several seconds for half a second or
> so. Using it feels like I'm playing musical chairs with the kernel.
> I have just one download happening on utorrent right now - this is what
> the graph looks like:
> http://i.imgur.com/LqhMtrJ.png and every time a new spike happens, a
> freeze happens just before that... that's the only time those freezes
> happen, too.

Is it perchance every 30 seconds?  (The graph seems to indicate more like 
50 second cycles, but...)

Because that's btrfs' normal commit time.  If it is, there's a mount 
option to change the commit time (the wiki says commit=N, N=30 by 
default, since kernel 3.12).  You could try fiddling with that, say 
setting it to 15 or 60, not necessarily to fix the problem (tho 60 
seconds might increase the problem while making it less frequent, while 
15 might make it more frequent but less of a problem), but to see if the 
cycle changes with the commit time option, or stays @ 30 seconds.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

