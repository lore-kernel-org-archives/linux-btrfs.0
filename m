Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58266 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbbDXEi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 00:38:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YlVNf-0001uQ-4F
	for linux-btrfs@vger.kernel.org; Fri, 24 Apr 2015 06:38:23 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 06:38:23 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 06:38:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 0/3] btrfs-progs: restore symlinks
Date: Fri, 24 Apr 2015 04:38:16 +0000 (UTC)
Message-ID: <pan$e7045$f8d3aef7$794e780e$da3a4c69@cox.net>
References: <55392221.6090502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dan Merillat posted on Thu, 23 Apr 2015 12:47:29 -0400 as excerpted:

> Hopefully this is sufficiently paranoid, tested with PATH_MAX length
> symlinks, existing files, insufficient permissions, dangling symlinks. I
> think I got the coding style correct this time, I'll fix and resend if
> not.
> 
> Includes a trivial fix from my metadata patch, the documentation got
> lost in the merge.

Thanks for all this.  I've only had to use restore once and hopefully 
won't be using it again in the near future, but having it restore the 
metadata and symlinks as well would surely have made the experience 
easier.  There's a lot of people going to benefit from these patches over 
time as btrfs gains usage and the inevitable breakage happens to some of 
those filesystems. =:^/

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

