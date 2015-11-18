Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43209 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070AbbKRACc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Nov 2015 19:02:32 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZyqCk-00079k-DE
	for linux-btrfs@vger.kernel.org; Wed, 18 Nov 2015 01:02:30 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 01:02:30 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 01:02:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] Fix balance regression in 4.4-rc
Date: Wed, 18 Nov 2015 00:02:25 +0000 (UTC)
Message-ID: <pan$29163$566bcbd$785370e7$a2d14489@cox.net>
References: <564B0F9C.6060707@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstätte posted on Tue, 17 Nov 2015 12:29:32 +0100 as excerpted:

> There's a regression in 4.4-rc since commit bc3094673f22 (btrfs: extend
> balance filter usage to take minimum and maximum) in that existing
> (non-ranged) balance with -dusage=x no longer works; all chunks are
> skipped.

Not being a dev I won't attempt to comment on the patch itself, but the 
title, please prefix the patch title with either btrfs: if it's for the 
kernel (as here), or btrfs-progs: if for userspace.

I was a bit confused here, thinking userspace, when it's apparently a 
kernel patch.  (The significance here being that I've not upgraded to 4.4-
rc kernel yet, and now probably won't until this gets in, since I tend to 
use -dusage=x balance filters reasonably frequently.  If I had already 
upgraded, I'd have probably dropped the patch into my autoapply dir until 
it was applied upstream.)

So...

[PATCH] Fix balance regression in 4.4-rc

... would become...

[PATCH] btrfs: fix balance regression in 4.4-rc

(Initial capitalization, fix/Fix, seems to be poster's choice.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

