Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:60883 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933595AbaLKBRb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 20:17:31 -0500
Message-ID: <5488F0A8.7070503@pobox.com>
Date: Wed, 10 Dec 2014 17:17:28 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: "sys.syphus" <syssyphus@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Balance & scrub & defrag
References: <CAAe=sHWSR=G0+hJCbLCQfgBB_b9VQxu2Q8JETMuRgz79fcBUbg@mail.gmail.com>
In-Reply-To: <CAAe=sHWSR=G0+hJCbLCQfgBB_b9VQxu2Q8JETMuRgz79fcBUbg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/10/2014 02:15 PM, sys.syphus wrote:
> I am working on a script that i can run daily that will do maintenance
> on my btrfs mountpoints. is there any reason not to concurrently do
> all of the above? possibly including discards as well.
>
>
> also, is there anything existing currently that will do maintenance on
> btrfs so i don't have to reinvent the wheel?
>
> #!/bin/bash
> btrfs filesystem defragment -r -v /media/btrfs/  &
> btrfs scrub start /media/btrfs/ &
> btrfs balance start /media/btrfs/ &
>
>
> watch -d -n 30 "btrfs balance status /media/btrfs/; btrfs scrub status
> /media/btrfs/"


I'd recommend doing "none of the above" on a daily basis. One of the 
goals of the filesystem design is to remove the need for any of these 
operations on any regular basis. You are just going to bog down your 
system and increase you heat and wear profiles for no good reason.

Those tools should be used if you notice something fishy like recent 
decreases in efficiency or errors in your log files.

A _monthly_ scrub is maybe worth scheduling if you have a lot of churn 
in your disk contents.

Defragging should be done after significant content additions/changes 
(like replacing a lot of files via package management) and limited to 
the directories most likely changed.

Balancing is almost never necessary and can be anti-helpful if a 
experiences random updates in batches (because the nicely packed file 
may end up far, far away from the active data extent where its COW 
events are taking place.

Resist the urge to tinker with production systems. The exposure 
(rewriting stable data is just the chance to destabilize your data, 
balancing your drive can take two files that always change together and 
put them far away from one another, etc) is not worth the nearly 
non-existent chance of benefit. Once the system is "good" just leave it 
that way until you notice something "not good" coming on the horizon.

If you feel you _must_ do these tasks then doing them all at once, where 
possible, will just make both tasks take longer. If you are transcribing 
a file over on one side of the disk to defrag it, and you are 
transcribing an extent on the other side of the disk to balance it, you 
are just bouncing your disk heads back-and-forth and wasing wall-clock time.

So yea, it's not windows, it doesn't need the defrag hammer.

Trying to over-manage the system will prevent it from seeking its 
dynamic (and so predictable) equilibrium.
