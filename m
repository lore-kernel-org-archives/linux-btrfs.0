Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51004 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbbLIQs0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 11:48:26 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a6huj-0005jg-8m
	for linux-btrfs@vger.kernel.org; Wed, 09 Dec 2015 17:48:25 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 17:48:25 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 17:48:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Missing half of available space (resend)
Date: Wed, 9 Dec 2015 16:48:13 +0000 (UTC)
Message-ID: <pan$2b447$368e596$ba3d70ae$2f6cd5d4@cox.net>
References: <1449637341.20669.0.camel@love2code.net>
	<CAJCQCtQrfRxrvmGT2ZA4WM6YLN5oy-+_k+NmDpv475SAtCoVNw@mail.gmail.com>
	<1449642609.20669.7.camel@love2code.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Hampton posted on Wed, 09 Dec 2015 01:30:09 -0500 as excerpted:

> Seems I need to upgrade my tools.  That command was added in 3.18 and I
> only have the 3.12 tools.

Definitely so, especially because you're running raid6, which wasn't 
stable until 4.1 for both kernel and userspace.  3.12?  I guess it did 
have the very basic raid56 support, but it's definitely nothing I'd 
trust, at that old not for btrfs in general, but FOR SURE not raid56.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

