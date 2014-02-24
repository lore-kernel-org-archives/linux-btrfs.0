Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39289 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaBXGck (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 01:32:40 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WHp5i-000486-Ex
	for linux-btrfs@vger.kernel.org; Mon, 24 Feb 2014 07:32:38 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 07:32:38 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 07:32:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs userland interface isn't 32/64bit clean (breaks lsattr
 and btrfs send)
Date: Mon, 24 Feb 2014 06:32:14 +0000 (UTC)
Message-ID: <pan$78eb$fa967f30$1d30da9e$2510275d@cox.net>
References: <20140224055103.GA15937@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 23 Feb 2014 21:51:03 -0800 as excerpted:

> In the end I pinned it down to this:
> 3.13.5's kernel/userland interface fails if my kernel is 64bit and my
> userland 32bit.

This is a known issue.  There's patches in the pipeline for 32-bit 
userspace on a 64-bit kernel, already.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

