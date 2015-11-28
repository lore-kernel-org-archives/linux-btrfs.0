Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43027 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbbK1GPK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 01:15:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a2Ymm-00020I-20
	for linux-btrfs@vger.kernel.org; Sat, 28 Nov 2015 07:15:04 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 07:15:04 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 07:15:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs: fix misleading warning when space cache failed
 to load
Date: Sat, 28 Nov 2015 06:11:11 +0000 (UTC)
Message-ID: <pan$e5666$605427a0$1d2f736b$c2fb9624@cox.net>
References: <56588584.3030705@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstätte posted on Fri, 27 Nov 2015 17:32:04 +0100 as excerpted:

> When an inconsistent space cache is detected during loading we log a
> warning that users frequently mistake as instruction to invalidate the
> cache manually, even though this is not required. Fix the message to
> indicate that the cache will be rebuilt automatically.
> 
> Signed-off-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>

+1.  The message as-is, /is/ confusing, and this fixes it. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

