Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42067 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbbFQVyT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 17:54:19 -0400
Date: Wed, 17 Jun 2015 14:54:14 -0700
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Message-ID: <20150617215414.GQ16468@merlins.org>
References: <20140908015124.GA21441@merlins.org>
 <CAL3q7H70SGvWamdeuvF1id-pnP0o4PskgJMb7qE+CfGBB5vd1w@mail.gmail.com>
 <20140915001836.GU8530@merlins.org>
 <20150511214412.GE15670@merlins.org>
 <CAL3q7H7SYfka5MK=8XZkw1m7PGjyR-1fzrD0tP_=dhznQ5QdGQ@mail.gmail.com>
 <20150617175805.GO16468@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150617175805.GO16468@merlins.org>
Subject: Re: btrfs differential receive has become excrutiatingly slow on one
 machine
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 10:58:05AM -0700, Marc MERLIN wrote:
> You requested strace -T in the past. I'm showing an exerpt of system calls that take
> more than 1 second.
> 
> When I see this, I get worried:
> truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/Maildir.google/lists2/new/1432663866_0.19916.legolas,U=427356,FMD5=7e806062200fb6d33546530d24aac86c:2,", 21043) = 0 <19.335333>
> 
> Or this:
> unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/src/linux-3.19.8-amd64-i915-volpreempt-s20150421/drivers/media/tuners/mt2266.mod.dwo") = 0 <28.298224>
> unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/Maildir.google/INBOX/cur/1432061846_0.2789.legolas,U=381014,FMD5=7e33429f656f1e6e9d79b29c3f82c57e:2,") = 0 <45.084068>
> 
> 19 seconds for a truncate or 28 or 45 seconds for an unlink cannot be right of course.

Interesting. The restore only took 2.5h.
It's still too long but not as bad as I thought.

But now I think I understand what's going on, because of the frequent
pauses of a few seconds to 30s or more, this totally destroys the tcp
flow, causing the sender to stop, and re-start sending slowly, ramp up
the speed, only to be stopped again.

No wonder that given that it can take 12h or more when I have send to
receive talk over the network.

So now the question is why the receive pauses for so long, and pseudo-randomly.

Is there anything I can provide on that filesystem that would help?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
