Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34745 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbbKZQ2Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 11:28:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a1zP0-0008P4-HN
	for linux-btrfs@vger.kernel.org; Thu, 26 Nov 2015 17:28:10 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 17:28:10 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 17:28:10 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Using Btrfs on single drives
Date: Thu, 26 Nov 2015 16:27:44 +0000 (UTC)
Message-ID: <pan$aef24$6d93700d$fffc9f7c$ca227eb6@cox.net>
References: <CA+LE0jwrdpjmJhwmG9Yv5HjqZh28-yp3Man8NSmXqCoB=JJ=Ew@mail.gmail.com>
	<CA+LE0jyvd8f=z8GR7V2=cLzV3Khfn1YpEHka5-6k0JiSPa5-+Q@mail.gmail.com>
	<pan$eeab5$356873bd$675c810f$20fe76ea@cox.net>
	<201511251820.25758.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Wed, 25 Nov 2015 18:20:25 +1100 as excerpted:

> On Sun, 15 Nov 2015 03:01:57 PM Duncan wrote:
>> That looks to me like native drive limitations.
>> 
>> Due to the fact that a modern hard drive spins at the same speed no
>> matter where the read/write head is located, when it's reading/writing
>> to the first part of the drive -- the outside -- much more linear drive
>> distance will pass under the read/write heads in say a tenth of a
>> second than will be the case as the last part of the drive is filled --
>> the inside -- and throughput will be much higher at the first of the
>> drive.
> 
> http://www.coker.com.au/bonnie++/zcav/results.html
> 
> The above page has the results of my ZCAV benchmark (part of the
> Bonnie++ suite) which shows this.  You can safely tun ZCAV in read mode
> on a device that's got a filesystem on it so it's not too late to test
> these things.

Thanks.  Those graphs are pretty clear.

As you, I'd have thought there'd be far fewer zones (3-4) than it turns 
out there are (8ish).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

