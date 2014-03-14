Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob16.myregisteredsite.com ([209.17.115.54]:57622 "EHLO
	atl4mhob16.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbaCNNph (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 09:45:37 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.114])
	by atl4mhob16.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s2EDjavA027608
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 09:45:36 -0400
Message-ID: <5323082B.50600@chinilu.com>
Date: Fri, 14 Mar 2014 06:46:19 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup for a raid1
References: <1564384.fRV1HUkfCq@fuchsia>	<pan$60e7c$45de97e1$2fb9daeb$288befdc@cox.net>	<1549230.7yEi5AM4H9@fuchsia> <pan$4e795$762009e5$6f734697$16ccd0b0@cox.net>
In-Reply-To: <pan$4e795$762009e5$6f734697$16ccd0b0@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Actually, an interesting concept would be to have the initial two drive 
RAID 1 mirrored by 2 additional drives in 4-way configuration on a 
second machine at a remote location on a private high speed network with 
both machines up 24/7.  In that case, if such a configuration would 
work, either machine could be obliterated and the data would survive 
fully intact in full duplex mode.  It would just need to be remounted 
from the backup system and away it goes.  Just thinking of interesting 
possibilities with n-way mirroring.  Oh how I would love to have n-way 
mirroring to play with!



On 03/14/2014 04:24 AM, Duncan wrote:
> Michael Schuerig posted on Fri, 14 Mar 2014 09:56:20 +0100 as excerpted:
>
> [Duncan posted...]
>
>>> 3) Disconnect the backup device(s).  (Don't btrfs device delete, this
>>> would remove the copy.  Just disconnect.)
> Hmm...  Looking back at what I wrote...
>
> Presumably either have the filesystem unmounted for the disconnect (and
> ideally, the system off, tho with modern drives in theory that's not an
> issue, but still good if it can be done), or at least remounted read-only.
>
> I had guessed that was implicit, but making it explicit is probably best
> all around, just in case.  At least I can rest better with it, having
> made that explicit.
>

