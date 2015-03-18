Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42560 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbbCRBr1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 21:47:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YY34v-0001V5-CX
	for linux-btrfs@vger.kernel.org; Wed, 18 Mar 2015 02:47:25 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 02:47:25 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 02:47:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: System crash while scrubbing on 3.18.x
Date: Wed, 18 Mar 2015 01:47:19 +0000 (UTC)
Message-ID: <pan$ee953$8d560135$1af2f61a$27f52825@cox.net>
References: <54F9005D.5070107@neo-zeon.de>
	<20150306123054.GB18885@localhost.localdomain>
	<54FA081A.8010501@neo-zeon.de> <550710AE.4040803@neo-zeon.de>
	<550863B2.2060609@neo-zeon.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cameron Berkenpas posted on Tue, 17 Mar 2015 10:26:10 -0700 as excerpted:

> I've figured out at least part of the issue.
> 
> I had blk-mq enabled by default (SCSI_MQ_DEFAULT=y). I've since set
> SCSI_MQ_DEFAULT=n, and now I'm completely stable with 4.0-rc4, 3.18.9,
> and presumably all the others. This is on both the bcache and non-bcache
> systems.
> 
> All of my systems with btrfs and SCSI_MQ_DEFAULT=y are stable unless
> they're using a 3ware 9750 controller (which I believe is the 3w-sas
> driver from the top of my head). So either there's a bug with
> blk-mq+3w-sas+btrfs, or just blk-mq+3w-sas. I suspect the latter, but if
> I can find the time, I'll try to test with another filesystem.
> 
> I suspect other controllers/drivers could be affected as well.
> 
> Are any btrfs devs interested in me looking into this further?
> 
> As a side note, in spite of all the crashes I've had through out my
> testing etc, bcache+btrfs hasn't given me any issues like I've seen in
> the past. This is just a few weeks worth of testing, but it seems
> there's at least some sort of basic stability with bcache+btrfs now.

Wow.  Thanks!

I'm not a dev so won't attempt to answer whether they have further 
interest or not, but thanks for keeping with this until you found the 
scsi-mq and 32-sas connection and reported it.  It'll very possibly be of 
use to someone else later, and meanwhile, that's one less instability-
mystery hanging over btrfs alone, now, which surely lets all regulars 
here rest easier. =:^)

And that despite all the crashes during testing, bcache+btrfs didn't 
demonstrate any filesystem instabilities, demonstrates how far both of 
those components has come, each on its own and working together, as 
well.  I know we get bcache+btrfs questions from time to time and the 
stability here even under repeated crashes triggered by unrelated factors 
is something I'm sure many will find reassuring. =:^)

So thanks, again! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

