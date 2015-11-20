Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55401 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbbKTCLv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 21:11:51 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZzbAy-0000zW-Qn
	for linux-btrfs@vger.kernel.org; Fri, 20 Nov 2015 03:11:48 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 03:11:48 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 03:11:48 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
Date: Fri, 20 Nov 2015 02:11:42 +0000 (UTC)
Message-ID: <pan$7d183$c0b735b0$44af3f79$b541cb8b@cox.net>
References: <564CC90F.3060703@gmail.com> <564DC072.4060508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Thu, 19 Nov 2015 07:28:34 -0500 as
excerpted:

> (having all updates installed on Ubuntu doesn't really count in this
> case, they're pretty bad sometimes about not properly tracking upstream
> development[)]

No kidding.  I'm involved with an upstream that had a security patch and 
version-bump a number of years ago.  An Ubuntu bug was filed... and it 
sat in the bug queue IIRC untouched until it was obsoleted by newer 
releases, where the new version /was/ included.  At least Fedora (which I 
remember a poster confirming the update on) and Gentoo (which I run, 
personally filed a bug with, and saw the security bump) made the version 
bump available as an update.

Apparently, as it wasn't a headline component (one would /hope/ they at 
least get security updates out for /them/, and they evidently do for at 
least some as they do publish security updates, but at this point I'd 
wonder how consistently they do for others), Ubuntu simply didn't care.  
Made /me/ glad I wasn't on Ubuntu, that's for sure!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

