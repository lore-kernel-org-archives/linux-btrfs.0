Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:58417 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915AbaLPDrJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 22:47:09 -0500
Message-ID: <548FAB3A.7060009@pobox.com>
Date: Mon, 15 Dec 2014 19:47:06 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/7] Print the summary
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>	<1418673780-22000-7-git-send-email-kreijack@inwind.it> <pan$20861$ccededbf$bdcf87a3$8bcef8ae@cox.net>
In-Reply-To: <pan$20861$ccededbf$bdcf87a3$8bcef8ae@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/15/2014 05:58 PM, Duncan wrote:
> * Please s/disk/device/, here and possibly elsewhere.  I know I'm not the
> only one who is trying to make the switch in my own usage, as it looks a
> bit foolish (and/or marks the user as an old fogey who's likely to start
> lecturing about how a GiB isn't "small", as I'm known to do at times!
> =:^) already, as it's only going to be more so over time.

I am actually not fond of "disk" nor "device" as both carry potentially 
false information.

I prefer "slice", not that I am totally happy with that word either. But 
by the time you get through loopback devices, memory map devices, the 
"device files" that represent parts of "partitioned" devices, logical 
"volumes", and god only knows what future "thingies" we will end up 
dealing with... I like the terms that remove false hints.


In linux we (currently, and for the foreseeable future) use the device 
files and so conflate "device" with all the above.

But if the code base and format were to spread to another platform...

And besides, using device carries its own lingual hazzards.

"device 1 is a whole device /dev/sda, while device two is a partition on 
a partition called /dev/sdb1, and device three is on a partition called 
/dev/sdb2 which is really on the same device as the second device." etc.


"slice one is a whole device, /dev/sda; slice two is on a partition 
called /dev/sdb1; slice three is on a partition called /dev/sdb2, which 
shares the same device as slice two."

Much clearer when things get nasty.

"Slice" comes from programming, where arrays of storage can be "sliced" 
and recombined. The term was popularized (if memory serves) by Ada, not 
that Ada became popular. 8-)

You can have slices of anything, so like using a "slice of ram" makes sense.

It just seems like a waste to school yourself to eschew "disk" for 
"device" when the latter carries almost as much problematic baggage as 
the former.
