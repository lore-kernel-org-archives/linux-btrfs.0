Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:14382 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753982Ab3HDXNo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Aug 2013 19:13:44 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:62691 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1V67Ud-001WYv-Ih
	for linux-btrfs@vger.kernel.org; Sun, 04 Aug 2013 17:13:43 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Recovery advice
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$b7e2c$bf7f3666$af6e4a6$909b9d97@cox.net>
Date: Sun, 4 Aug 2013 17:13:40 -0600
Message-Id: <12D50478-9881-49FB-B4D7-BC57DD1A9075@colorremedies.com>
References: <CAPs0BijizOo0c566U6-uAe1voCr-W2SVHkMeT1sirTfi4jgeSg@mail.gmail. com> <kpu1da-elm.ln1@hurikhan.ath.cx> <pan$b7e2c$bf7f3666$af6e4a6$909b9d97@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 4, 2013, at 4:19 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> Kai Krakow posted on Sun, 04 Aug 2013 14:41:54 +0200 as excerpted:
> 
>> It is a RAID-1 so why bother with the faulty drive? Just wipe it, put it
>> back in, then run a btrfs balance... There should be no data loss
>> because all data is stored twice (two-way mirroring).
> 
> The caveat would be if it didn't start as btrfs raid1, and there's still 
> some data (or possibly metadata if it was the single drive at one point 
> or they're ssds, as btrfs defaults to metadata single in ssd mode) that 
> hasn't been duped elsewhere.

I agree. I think tossing the data on the problematic device is a bit of a hammer. It may be necessary, but I don't think enough information has been provided to conclusively determine all other options have been explored. What kernel versions have been used? What does dmesg record beginning at the time of a normal mount attempt with all four devices available? What does btrfsck (without repair) report? Are there any prior kernel messages related to the controller or libata messages related to the suspect drive? What's the smartctl -x output for the suspect drive? Has mounting with -o recovery been attempted, and if so what were the messages recorded?

Chris Murphy