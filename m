Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35093 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbbKNQkH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Nov 2015 11:40:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zxdrw-0001jY-CG
	for linux-btrfs@vger.kernel.org; Sat, 14 Nov 2015 17:40:04 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2015 17:40:04 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2015 17:40:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: More memory more jitters?
Date: Sat, 14 Nov 2015 16:37:14 +0000 (UTC)
Message-ID: <pan$ce09f$d4f4e93$fd67914e$33e263e1@cox.net>
References: <CAOcLnUfVNvRLYdeQG_kTZyXaceaLCez=XsQ8PXwEyaXPeYiMwg@mail.gmail.com>
	<20151114143112.GK24333@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Sat, 14 Nov 2015 14:31:12 +0000 as excerpted:

>> I have read the Gotcha[1] page:
>> 
>>    Files with a lot of random writes can become heavily fragmented
>> (10000+ extents) causing trashing on HDDs and excessive multi-second
>> spikes of CPU load on systems with an SSD or **large amount a RAM**.
>> 
>> Why could large amount of memory worsen the problem?
> 
>    Because the kernel will hang on to lots of changes in RAM for
> longer. With less memory, there's more pressure to write out dirty pages
> to disk, so the changes get written out in smaller pieces more often.
> With more memory, the changes being written out get "lumpier".
> 
>> If **too much** memory is a problem, is it possible to limit the memory
>> btrfs use?
> 
>    There's some VM knobs you can twiddle, I believe, but I haven't
> really played with them myself -- I'm sure there's more knowledgable
> people around here who can suggest suitable things to play with.

Yes.  Don't have time to explain now, but I will later, if nobody beats 
me to it.



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

