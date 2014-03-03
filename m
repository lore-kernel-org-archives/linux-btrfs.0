Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47892 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753581AbaCCUls convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 15:41:48 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:63018 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WKZgH-003oD4-Dm
	for linux-btrfs@vger.kernel.org; Mon, 03 Mar 2014 13:41:45 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: ENOSPC errors during raid1 rebalance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <loom.20140303T200845-874@post.gmane.org>
Date: Mon, 3 Mar 2014 13:41:43 -0700
Message-Id: <523E1747-8B25-48F8-8DAD-D40021F42DAC@colorremedies.com>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com> <pan$b5b02$85505b$f53ee629$e32b9776@cox.net> <loom.20140303T191959-983@post.gmane.org> <D35E6741-2350-4910-B785-5584F730EDA9@colorremedies.com> <loom.20140303T200845-874@post.gmane.org>
To: Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 3, 2014, at 12:24 PM, Michael Russo <mike@papersolve.com> wrote:

> Chris Murphy <lists <at> colorremedies.com> writes:
> 
>> It might be worth adding enospc_debug as a mount option 
> 
> These messages only appear when I mount with enospc_debug.

Gotcha. I think Hugo has the best next step. Defragment.

> As for whether btrfs-convert should be recommended, I 
> mean probably not, but when you've got a big media drive filled 
> with music, pictures, and movies, with no other place to store it, 

Sure I understand the use case. And I think it should work. But I'm wondering whether it's more highly regarded than merely just be functional, or not.

> and you've experienced corruption where 5% of your MP3 files
> have 10 seconds of another MP3 stuck in the middle of them
> somehow,  and suddenly realize you NEED a checksumming 
> next-generation file system like btrfs, you're going to convert!

That's not good. It sounds to me like misdirected writes. Or file system corruption. Anyone else?

Btrfs can detect and (with data redundancy) can correct for torn and misdirected writes, among other problems. But 5% of 1TB is 50GB. That's a lot of corrupt data. I think what you need is to replace one or more drives, or look for problems elsewhere. Using Btrfs is not bad in this case, but it's also a crutch for a bigger problem that shouldn't be happening in the first place.

Chris Murphy

