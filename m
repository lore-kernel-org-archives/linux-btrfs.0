Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56169 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbaBRWpi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 17:45:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WFtQ0-0002bQ-0U
	for linux-btrfs@vger.kernel.org; Tue, 18 Feb 2014 23:45:36 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Feb 2014 23:45:36 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Feb 2014 23:45:36 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Read i/o errs and disk replacement
Date: Tue, 18 Feb 2014 22:45:11 +0000 (UTC)
Message-ID: <pan$c1dcd$ac5efec2$1a07a461$61630cbf@cox.net>
References: <8051054.BLVnDBVVi7@fuckup>
	<4122CB7E-0AF1-4808-9FF6-91E875D6E1E9@colorremedies.com>
	<116064537.O3CH7laqNI@fuckup>
	<6B9DC823-92CF-4ECC-979F-C512072DF883@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 18 Feb 2014 15:02:51 -0700 as excerpted:

>  Also, what model drives are being used? If they are
> consumer drives, they almost certainly have long error recoveries over
> 30 minutes.

FWIW, that should be 30 seconds, not 30 minutes (OUCH!).  The below 
context sort of makes that clear for those good enough at reading between 
the lines, thus the suggestion to change the kernel timeout to 121 
seconds, but just in case...

> And if the drive is trying to honor the read request for
> more than 30 seconds, the default SCSI block layer will time out and
> produce messages like what we see here. So you probably need to change
> the SCSI block layer timeout. To set the command timer to something else
> use:
> 
> echo <value> /sys/block/<device>/device/timeout
> 
> Where value is e.g. 121 since many consumer drives time out at 120
> seconds this means the kernel will wait 121 seconds before starting its
> error handling (which includes resetting the drive and then the bus).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

