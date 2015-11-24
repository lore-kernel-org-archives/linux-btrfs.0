Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54899 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbbKXG3T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 01:29:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a176J-00022h-0S
	for linux-btrfs@vger.kernel.org; Tue, 24 Nov 2015 07:29:15 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 07:29:14 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 07:29:14 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any
 kernel version
Date: Tue, 24 Nov 2015 06:29:05 +0000 (UTC)
Message-ID: <pan$d557d$a013f357$13f25542$cf762dd9@cox.net>
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
	<20151123175608.GI31035@twin.jikos.cz> <565373B4.2070907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Mon, 23 Nov 2015 15:14:44 -0500 as
excerpted:

>> A remaining option should override the 'running' behaviour and pick the
>> latest mkfs options. Naming it 'defaults' sounds a bit ambiguous so the
>> name is yet to be determined.

> Maybe something like 'recommended' or 'suggested'?

Just keep it simple.  If it enables the latest defaults, just call it 
"latest".  =:^)

Better yet, match compat-3.2, etc, with compat-running and compat-latest, 
making it crystal clear they're parallel options, as well as labeling 
them all compat-*, making it crystal clear what the intended 
functionality is.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

