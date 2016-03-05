Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:40390 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbcCEUJL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 15:09:11 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1acIVh-0004TA-DG
	for linux-btrfs@vger.kernel.org; Sat, 05 Mar 2016 21:09:09 +0100
Date: Sat, 5 Mar 2016 21:09:09 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160305200909.GJ1902@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
> I can't tell what this btrfs-balance script is doing because not every
> btrfs balance command is in the log.

It is. I wrote it to produce reproducible logs.

[1/499]mh@fan:~$ cat btrfs-balance
#!/bin/bash

FS="/mnt/fanbtr"

showdf() {
logger -- btrfs fi df $FS
btrfs fi df $FS 2>&1 | logger
logger -- btrfs fi show /
btrfs fi show / | logger
logger -- btrfs fi usage /
btrfs fi usage / | logger
}

logger -- BEGIN btrfs-balance script
showdf

btrfs balance start  $FS 2>&1 | logger
showdf

logger -- BEGIN btrfs balance start -dprofiles=single $FS
btrfs balance start -dprofiles=single $FS 2>&1 | logger
showdf

logger -- BEGIN btrfs balance start -mprofiles=dup $FS
btrfs balance start -mprofiles=dup $FS 2>&1 | logger
showdf

logger -- BEGIN btrfs balance start --force -sprofiles=dup $FS
btrfs balance start --force -sprofiles=dup $FS 2>&1 | logger
showdf

logger -- BEGIN btrfs balance start $FS
btrfs balance start  $FS 2>&1 | logger
showdf

logger -- END btrfs-balance script
[2/500]mh@fan:~$ 

I see. The logger -- BEGIN is missing for the very first command. My
bad.

> Something is happening with the usage of this file system that's out
> of the ordinary. This is the first time I've seen such a large amount
> of unused metadata allocation. And then for it not only fail to
> balance, but for the allocation amount to increase is a first.

It is just a root filesystem of a workstation running Debian Linux, in
daily use, with daily snapshots of the system, and
ten-minute-increment snapshots of /home, with no cleanup happening for
a few months.

>  So understanding the usage is important to figuring out what's
>  happening. I'd file a bug and include as much information on how the
>  fs got into this state as possible. And also if possible make a
>  btrfs-image using the proper flags to blot out the filenames for
>  privacy.

That would btrfs-image -s?

> And what btrfs-progs tools were used to create this file system. Etc.

The file system is at least two years old, I do not remember, which
version of btrfs-tools was in Debian unstable back then. Is this
information somewhere in the filesystem label? How do I obtain this one?

> The alternative if this can't be fixed, is to recreate the filesystem
> because there's no practical way yet to migrate so many snapshots to a
> new file system.

I am now back to a mid three-digit number of snapshots.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
