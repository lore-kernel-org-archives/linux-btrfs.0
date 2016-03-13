Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:60548 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbcCMUu2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 16:50:28 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afCy2-0004wT-Di
	for linux-btrfs@vger.kernel.org; Sun, 13 Mar 2016 21:50:26 +0100
Date: Sun, 13 Mar 2016 21:50:26 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160313205026.GU2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160312195746.GJ2334@torres.zugschlus.de>
 <CAJCQCtSmHAs_zMt3kHdCL9Nd+aAMW-2nDSNYXhizwan8OL3mGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtSmHAs_zMt3kHdCL9Nd+aAMW-2nDSNYXhizwan8OL3mGw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 13, 2016 at 01:43:50PM -0600, Chris Murphy wrote:
> On Sat, Mar 12, 2016 at 12:57 PM, Marc Haber
> <mh+linux-btrfs@zugschlus.de> wrote:
> > On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
> >> Something is happening with the usage of this file system that's out
> >> of the ordinary. This is the first time I've seen such a large amount
> >> of unused metadata allocation. And then for it not only fail to
> >> balance, but for the allocation amount to increase is a first. So
> >> understanding the usage is important to figuring out what's happening.
> >> I'd file a bug and include as much information on how the fs got into
> >> this state as possible. And also if possible make a btrfs-image using
> >> the proper flags to blot out the filenames for privacy. And what
> >> btrfs-progs tools were used to create this file system. Etc.
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=114451
> >
> > Please advise if there is something missing.
> 
> No enospc_debug mount option used for kernel messages.

I apologize for not having this mentioned, but why do you think that
it wasn't active?

|[28/527]mh@fan:~$ grep enospc /proc/mounts
|/dev/mapper/fanbtr / btrfs rw,noatime,nodiratime,ssd,space_cache,enospc_debug,subvolid=257,subvol=/fan-root 0 0
|/dev/mapper/fanbtr /mnt/snapshots/fanbtr btrfs rw,noatime,nodiratime,ssd,space_cache,enospc_debug,subvolid=266,subvol=/snapshots 0 0
|[29/528]mh@fan:~$

>  And no indication you applied Qu's patch mentioned on March 1 to get
>  more info with enospc_debug mount:
> 
> >Oh, I'm sorry that the output is not necessary, it's better to use the newer patch:
> >https://patchwork.kernel.org/patch/8462881/
> >With the newer patch, you will need to use enospc_debug mount option to get the debug information.

That one didn't make it in 4.4.5 yet?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
