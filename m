Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43910 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933283AbcFMDyS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 23:54:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bCIx4-0007HP-QY
	for linux-btrfs@vger.kernel.org; Mon, 13 Jun 2016 05:54:16 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jun 2016 05:54:14 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jun 2016 05:54:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
Date: Mon, 13 Jun 2016 03:54:08 +0000 (UTC)
Message-ID: <pan$68dc6$cfb2f3f9$47775110$b24d1225@cox.net>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net>
	<38F2FB04-0617-4DD3-9D48-ED3C4434003D@bueechi.net>
	<0AC846B3-C8B0-45FF-BCA9-F681811A23D7@bueechi.net>
	<CAPmG0jYrstbaBkL98YrwQk4CXxmBOo4nXd=waAJ9tXGc_WpTag@mail.gmail.com>
	<0426BC4B-1E70-4988-94FC-8D56EEBD0796@bueechi.net>
	<CAPmG0jYTd0a3NfzAXSGCBkMxZNQQ0pE+U_bmd3ks4x0OAWL6Rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager posted on Sun, 12 Jun 2016 21:03:22 +0200 as excerpted:

> But now that you anyhow have all data on 3x 6TB drives, you could save
> balancing time by just doing btrfs-replace 6TB to 8TB 3x and then for
> the 4th 8TB just add it and let btrfs do the spreading/balancing over
> time by itself.

That's what I'd suggest.  You have all the data on three of the 6 TB 
drives now.  Just replace one at a time to 8 TB drives.  Then add the 4th 
8 TB drive, and then at your option do a final balance at that point, or 
simply let the normal activity take care of it.

Altho if you're doing mostly add, little delete, without a balance you 
may run out of space prematurely, since raid1 requires two drives with 
unallocated space on them to allocate a new chunk (one copy on each of 
the two), and you'll only have ~2 TB free on each of the three, which 
would be used up with ~2 TB still left free on the last added drive...

So at least a partial balance after adding that 4th 8 TB in is probably a 
good idea.  You can leave that last drive with a couple extra free TB 
compared to the others and cancel the balance at that point, and new 
allocations should take it from there, but unless you're going to be 
deleting several TB of stuff as you add, at least doing a few TB worth of 
balance to the new drive to start the process should result in a pretty 
even spread as it fills up the rest of the way.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

