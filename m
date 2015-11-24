Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55731 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbbKXG4x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 01:56:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a17Wy-0000uw-TQ
	for linux-btrfs@vger.kernel.org; Tue, 24 Nov 2015 07:56:48 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 07:56:48 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 07:56:48 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: shall distros run btrfsck on boot?
Date: Tue, 24 Nov 2015 06:56:35 +0000 (UTC)
Message-ID: <pan$d4967$d0c5632e$fa0a61b0$e3c076ef@cox.net>
References: <1448337754.14125.33.camel@scientia.net>
	<pan$32768$921cbe34$6a22269c$2c7db710@cox.net>
	<1448340211.14125.44.camel@scientia.net>
	<pan$c9010$71046470$f37154a0$cd8b55eb@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Tue, 24 Nov 2015 06:46:18 +0000 as excerpted:

> That wouldn't be entirely uncommon, because as Eric mentions, btrfs
> check is intended to be thorough, where the kernel mount-time check is
> intended to be fast.
> 
> But of course, as Eric also mentions, that's yet another reason you
> don't want btrfs check running at boot... it's *SSLLLOOWWWWW*, because
> it's being thorough.

Oops!  Mis-attribution.  Qu not Eric.

(I had read both replies in my email but only saw Eric's on the list, 
which I read in my news client via gmane's list2news service, when I 
composed the above.  So I presumed the points I remembered being made 
were from Eric's post, when it was Qu's.) 

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

