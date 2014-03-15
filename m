Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37611 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbaCOL0x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 07:26:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WOmjr-0004Mp-IP
	for linux-btrfs@vger.kernel.org; Sat, 15 Mar 2014 12:26:51 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Mar 2014 12:26:51 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Mar 2014 12:26:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: discard synchronous on most SSDs?
Date: Sat, 15 Mar 2014 11:26:27 +0000 (UTC)
Message-ID: <pan$86f37$20eb1911$444fa726$8400b046@cox.net>
References: <1756989.4ep0Vdupld@tethys>
	<yq1bnx8y2mi.fsf@sermon.lab.mkp.net> <4448214.x9oPWjPhdL@quad>
	<1566234.HjNzCBAKa5@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Samuel posted on Sat, 15 Mar 2014 17:48:56 +1100 as excerpted:

> $ sudo smartctl --identify /dev/sdb | fgrep 'Trim bit in DATA SET
> MANAGEMENT'
>  169      0          1   Trim bit in DATA SET MANAGEMENT command
>  supported
> $
> 
> If that command returns nothing then it's not reported as supported (and
> I've tested that).  You can get the same info with hdparm -I.

> My puzzle now is that I have two SSD drives that report supporting NCQ
> TRIM (one confirmed via product info) but report only supporting SATA
> 3.0 not 3.1.

My SATA 2.5 SSDs reported earlier, report support for it too, so it's 
apparently not SATA 3.1 limited.  (Note that I'm simply grepping word 
169, in the command below.  Since word 169 is trim support...)

sudo smartctl --identify /dev/sda | grep '^ 169'
 169      -     0x0001   Data Set Management support
 169      0          1   Trim bit in DATA SET MANAGEMENT command supported

Either that or that feature bit simply indicates trim support, not NCQ 
trim support.

But it can be noted that if SATA 3.1 requires trim to be NCQ if its 
supported at all (spinning rust would thus get a pass), then claiming 3.1 
support as well as trim support should be the equivalent of claiming NCQ 
trim support, likely with no indicator of whether that trim support is NCQ 
or not, pre-3.1.

... Which would mean that my SATA 2.5 and your SATA 3.0 drives are simply 
indicating trim support, not specifically NCQ trim support.

I guess you'd have to check the SATA 2.5 and 3.0 specs to find that out.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

