Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47991 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3KJQsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Nov 2013 11:48:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VfYBo-0006Cx-JI
	for linux-btrfs@vger.kernel.org; Sun, 10 Nov 2013 17:48:44 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Nov 2013 17:48:44 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Nov 2013 17:48:44 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS error after clearing cache
Date: Sun, 10 Nov 2013 16:48:23 +0000 (UTC)
Message-ID: <pan$10e67$943b37ba$7489e414$5b88b6d8@cox.net>
References: <527fb112ee75b5.68693988@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

yzb3 posted on Sun, 10 Nov 2013 17:15:14 +0100 as excerpted:

> The output of dmesg | grep trfs (no 'b', because it is inconsistent)

You know about grep's -i, --ignore-case option, right?  (The GNU grep 
manpage says -i is POSIX specified, so should be grep-origin agnostic.)

But your case for log consistency remains a valid point none-the-less.  
-i shouldn't be necessary.  Consistency is good! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

