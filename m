Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxout016.mail.hostpoint.ch ([217.26.49.176]:64663 "EHLO
	mxout016.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819AbcFPAJl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 20:09:41 -0400
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
	by mxout016.mail.hostpoint.ch with esmtp (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bDKsM-0007x6-Pg
	for linux-btrfs@vger.kernel.org; Thu, 16 Jun 2016 02:09:38 +0200
Received: from 217-162-125-82.dynamic.hispeed.ch ([217.162.125.82] helo=imac.lan)
	by asmtp013.mail.hostpoint.ch with esmtpa (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bDKsM-000PKi-Nl
	for linux-btrfs@vger.kernel.org; Thu, 16 Jun 2016 02:09:38 +0200
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
From: boli <btrfs@bueechi.net>
In-Reply-To: <pan$b3671$36ea03da$e28136e8$8de0280e@cox.net>
Date: Thu, 16 Jun 2016 02:09:38 +0200
Message-Id: <2FE8C51A-285F-48E5-B939-CA5977B3A75B@bueechi.net>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net> <38F2FB04-0617-4DD3-9D48-ED3C4434003D@bueechi.net> <0AC846B3-C8B0-45FF-BCA9-F681811A23D7@bueechi.net> <e4c67cb3-b5f3-5dbb-1fb1-4d9a3b9a2f60@gmail.com> <E0C7FC1F-AEEE-4A79-9031-51FF616D027B@bueechi.net> <pan$b3671$36ea03da$e28136e8$8de0280e@cox.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> So I was back to a 4-drive raid1, with 3x 6 TB drives and 1x 8 TB drive
>> (though that 8 TB drive had very little data on it). Then I tried to
>> "remove" (without "-r" this time) the 6 TB drive with the least amount
>> of data on it (one had 4.0 TiB, where the other two had 5.45 TiB each).
>> This failed after a few minutes because of "no space left on device".
>> 
>> […]
>> 
>> For now I avoided that by removing one of the other two (rather full) 6
>> TB drives at random, and this has been going on for the last 20 hours or
>> so. Thanks to running it in a screen I can check the progress this time
>> around, and it's doing its thing at ~41 MiB/s, or ~7 hours per TiB, on
>> average.
> 
> The ENOSPC errors are likely due to the fact that the raid1 allocator 
> needs _two_ devices with free space.  If your 6T devices get too full, 
> even if the 8T device is nearly empty, you'll run into ENOSPC, because 
> you have just one device with unallocated space and the raid1 allocator 
> needs two.

I see, now this makes total sense. Two of the 6 TB drives were almost completely full, at 5.45 used of 5.46 TiB capacity. Note to self: Maybe I should start using the --si option to make such a condition more obvious when mentally comparing to the advertised capacity of 6 TB (when comparing to to 5.46 TiB would have been correct)

"remove"-ing one of these almost-full-drives did finish successfully, and a "replace" of the 3rd 6 TB drive onto a second 8 TB drive is currently in progress (at high speed).

> btrfs device usage should help diagnose this condition, with btrfs 
> filesystem show also showing the individual device space allocation but 
> not as much other information as usage will.

I had mostly been using btrfs filesystem usage, thanks for the reminder about device usage, which is easier to read in this case.

> If you run into this, you may just have to do the hardware yank and 
> replace-missing thing again, yanking a 6T and replacing with an 8T.  
> Don't forget the resize.  That should leave you with two devices with 
> free space and thus hopefully allow normal raid1 reallocation with a 
> device remove again.

Good to know. For now this doesn't seem necessary, even the other drive that was almost completely full before looks much better now at 4.8/5.46 TiB or 5.27/6.0 TB in --si :), as some data was moved to the first 8 TB drive during the last "remove".

So far everything is looking good, thanks very much for the help everyone.

