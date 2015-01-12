Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39328 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbbALNgj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 08:36:39 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YAfAb-00019T-Ib
	for linux-btrfs@vger.kernel.org; Mon, 12 Jan 2015 14:36:37 +0100
Received: from p4ff58349.dip0.t-ipconnect.de ([79.245.131.73])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 14:36:37 +0100
Received: from holger.hoffstaette by p4ff58349.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 14:36:37 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Stuck balance, 3.18.0
Date: Mon, 12 Jan 2015 13:36:27 +0000 (UTC)
Message-ID: <pan.2015.01.12.13.36.27@googlemail.com>
References: <20150112112158.GM32182@carfax.org.uk>
	<20150112122710.GO32182@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 12 Jan 2015 12:27:12 +0000, Hugo Mills wrote:

> On Mon, Jan 12, 2015 at 11:21:58AM +0000, Hugo Mills wrote:
>>    I've just added a new disk to my main storage filesystem. Running
>> the obligatory balance to spread the data out, it's managed about 14%
>> of the job, and then has gone into some kind of tight loop. No chunks
>> have been found or balanced in the last 2 hours, and one kworker thread
>> is pegged at 100%. There were no unusual or unexpected messages in the
>> logs. Balance cancel has been waiting for the last 10 minutes without
>> effect (as would be expected with the other symptoms).
> 
>    OK, an hour after I executed the cancel, and three hours after it
> apparently jammed up, the cancel completed. I have restarted the balance
> from the point it left off, and I'll see if it does something similar
> again.

I've looked through the patches I use since 3.18.0 and nothing too 
obvious stood out (to me), except for several patches from Filipe for 
fixes that revolve around the chunk reaper, which sound like they might 
result in confused threads. Also moving to 3.18.2 probably won't hurt, 
it's not like there are no bugs in the kernel itself -  I recently 
managed to find a really wrong corner case in NFS that has gone unnoticed 
since 3.16.

Finally: instead of balancing everything at once maybe try a piecemeal 
approach with the limit filter? Wrap it in a script, spread out the work 
of balancing 3-5 chunks a time..

-h

