Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41206 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbcA3NbE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jan 2016 08:31:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aPVcE-00023h-4O
	for linux-btrfs@vger.kernel.org; Sat, 30 Jan 2016 14:31:02 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jan 2016 14:31:02 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jan 2016 14:31:02 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Pointers to Btrfs Testplan/Testcases
Date: Sat, 30 Jan 2016 13:30:54 +0000 (UTC)
Message-ID: <pan$5dcb5$1d9f47d2$78dd60b8$d9455195@cox.net>
References: <201601300847.u0U8kmnI021997@webminal.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lakshmipathi.G posted on Sat, 30 Jan 2016 09:46:48 +0100 as excerpted:

> I'm preparing/consolidating Btrfs testplan. Other than the testscripts
> available under btrfs-progs/tests repo (found
> https://fedoraproject.org/wiki/QA:Testcase_btrfs but its mainly for
> Installation) any pointers to wiki/testopia etc which will provide more
> details on it? I would like to avoid duplicate efforts. thanks.

As you suggest, the btrfs-progs tests are primarily to verify userspace 
functionality after build; they aren't really designed for the more 
general case.  For that, btrfs, along with ext4 and of course xfs, now 
use xfstests, which isn't just for xfs any more.  In addition to the 
general filesystem functionality tests, xfstests contains a full suite of 
btrfs-specific tests for btrfs-specific functionality, and patches to 
xfstests to catch new btrfs regressions should they occur again are not 
only routinely seen on this list, but are often actively requested, if 
not originally posted along with the patches fixing whatever btrfs bugs.  
If you search the list archive on xfstests you'll see many examples.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

