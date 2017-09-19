Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33132 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750921AbdISDqE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 23:46:04 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1du9Tt-0003SC-Py
        for linux-btrfs@vger.kernel.org; Tue, 19 Sep 2017 05:45:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Help Recovering BTRFS array
Date: Tue, 19 Sep 2017 03:45:46 +0000 (UTC)
Message-ID: <pan$9e3e5$2f9856f7$962326f5$3ac936bc@cox.net>
References: <15e95fb9dad.106adde5c581450.625084479133539284@gcfam.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

grondinm posted on Mon, 18 Sep 2017 14:14:08 -0300 as excerpted:

> superblock: bytenr=65536, device=/dev/md0
> ---------------------------------------------------------
> ERROR: bad magic on superblock on /dev/md0 at 65536
> 
> superblock: bytenr=67108864, device=/dev/md0
> ---------------------------------------------------------
> ERROR: bad magic on superblock on /dev/md0 at 67108864
> 
> superblock: bytenr=274877906944, device=/dev/md0
> ---------------------------------------------------------
> ERROR: bad magic on superblock on /dev/md0 at 274877906944
> 
> Now i'm really panicked. Is the FS toast? Can any recovery be attempted?

First I'm a user and list regular, not a dev.  With luck they can help 
beyond the below suggestions...

However, there's no need to panic in any case, due to the sysadmin's 
first rule of backups: The true value of any data is defined by the 
number of backups of that data you consider(ed) it worth having.

As a result, there are precisely two possibilities, neither one of which 
calls for panic.

1) No need to panic because you have a backup, and recovery is as simple 
as restoring from that backup.

2) You don't have a backup, in which case the lack of that backup means 
you have defined the value of the data as only trivial, worth less than 
the time/trouble/resources you saved by not making that backup.  Because 
the data is only of trivial value anyway, and you saved the more valuable 
assets of the time/trouble/resources you would have put into that backup 
were the data of more than trivial value, you've still saved the stuff 
you considered most valuable, so again, no need to panic.

It's a binary state.  There's no third possibility available, and no 
possibility you lost what your actions, or lack of them in the case of no 
backup, defined as of most value to you.

(As for the freshness of that backup, the same rule applies, but to the 
data delta between the state as of the backup and the current state.  If 
the value of the changed data is worth it to you to have it backed up, 
you'll have freshened your backup.  If not, you defined it to be as of 
such trivial value as to not be worth the time/trouble/resources to do 
so.)


That said, at the time you're calculating the value of the data against 
the value of the time/trouble/resources required to back it up, the loss 
potential remains theoretical.  Once something actually happens to the 
data, it's no longer theoretical, and the data, while of trivial enough 
value to be worth the risk when it was theoretical, may still be valuable 
enough to you to spend at least some time/trouble on trying to recover it.

In that case, since you can still mount, I'd suggest mounting read-only 
to prevent any further damage, and then do a copy off of the data you 
can, to a different, unaffected, filesystem.

Then if there's still data you want that you couldn't simply copy off, 
you can try btrfs restore.  While I do have backups here, a couple times 
when things went bad, btrfs restore was able to get back pretty much 
everything to current, while were I to have had to restore from backups, 
I'd have lost enough changed data to hurt, even if I had defined it as of 
trivial enough value when the risk remained theoretical that I hadn't yet 
freshened the backup.  (Since then I upgraded the rest of my storage to 
ssd, thus lowering the time and hassle cost of backups, encouraging me to 
do them more frequently.  Talking about which, I need to freshen them in 
the near future.  It's now on my list for my next day off...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

