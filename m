Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56194 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbbDXDbR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 23:31:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YlUKP-0000Vj-53
	for linux-btrfs@vger.kernel.org; Fri, 24 Apr 2015 05:30:57 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 05:30:57 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 05:30:57 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to repair a BTRFS block?
Date: Fri, 24 Apr 2015 03:30:24 +0000 (UTC)
Message-ID: <pan$3eb65$73d44307$1ec5b26c$82e641a1@cox.net>
References: <55320BAE.1030007@gnieh.org> <5539345C.1040905@gnieh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Monperrus posted on Thu, 23 Apr 2015 20:05:16 +0200 as excerpted:

> # btrfs scrub status /
> scrub status for e11013b3-b244-4d1a-a9c7-3956db1a699c
>     scrub started at Thu Apr 23 19:07:45 2015
>     and finished after 372 seconds
>     total bytes scrubbed: 167.13GiB with 13 errors
>     error details: read=13 corrected errors: 0,
>     uncorrectable errors: 13, unverified errors: 0
> 
> Before going to my backups, how can know the files impacted by those
> uncorrectable errors?

The kernel log (dmesg, also logged to syslog/journald on most systems) 
from during the scrub should capture more information on those errors.  
You didn't check that?  (Checked or not, you obviously didn't post it.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

