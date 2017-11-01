Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:47041 "EHLO
        smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753753AbdKAG0m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 02:26:42 -0400
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
To: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <f17a1de9-8340-dae3-3b29-0e04440ca2a3@rqc.ru>
Date: Wed, 1 Nov 2017 09:19:38 +0300
MIME-Version: 1.0
In-Reply-To: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm active user of backup using btrfs snapshots. Generally it works with 
some caveats.

You seem to have two tasks: (1) same-volume snapshots (I would not call 
them backups) and (2) updating some backup volume (preferably on a 
different box). By solving them separately you can avoid some complexity 
like accidental remove of snapshot that's still needed for updating 
backup volume.

> To reconcile those conflicting goals, the only idea I have come up
> with so far is to use btrfs send-receive to perform incremental
> backups as described here:
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup .
As already said by Romain Mamedov, rsync is viable alternative to 
send-receive with much less hassle. According to some reports it can 
even be faster.

> Given the hourly snapshots, incremental backups are the only practical
> option. They take mere moments. Full backups could take an hour or
> more, which won't work with hourly backups.
I don't see much sense in re-doing full backups to the same physical 
device. If you care about backup integrity, it is probably more 
important to invest in backups verification. (OTOH, while you didn't 
reveal data size, if full backup takes just an hour on your system then 
why not?)

> We will delete most snapshots on the live volume, but retain many (or
> all) snapshots on the backup block device. Is that a good strategy,
> given my goals?
Depending on the way you use it, retaining even a dozen snapshots on a 
live volume might hurt performance (for high-performance databases) or 
be completely transparent (for user folders). You may want to experiment 
with this number.

In any case I'd not recommend retaining ALL snapshots on backup device, 
even if you have infinite space. Such filesystem would be as dangerous 
as the demon core, only good for adding more snapshots (not even 
deleting them), and any little mistake will blow everything up. Keep a 
few dozen, hundred at most.

Unlike other backup systems, you can fairly easily remove snapshots in 
the middle of sequence, use this opportunity. My thinout rule is: remove 
snapshot if resulting gap will be less than some fraction (e.g. 1/4) of 
its age. One day I'll publish portable solution on github.

> Given this minimal retention of snapshots on the live volume, should I
> defrag it (assuming there is at least 50% free space available on the
> device)? (BTW, is defrag OK on an NVMe drive? or an SSD?)
>
> In the above procedure, would I perform that defrag before or after
> taking the snapshot? Or should I use autodefrag?
I ended up using autodefrag, didn't try manual defragmentation. I don't 
use SSDs as backup volumes.

> Should I consider a dedup tool like one of these?
Certainly NOT for snapshot-based backups: it is already deduplicated 
almost as much as possible, dedup tools can only make it *less* 
deduplicated.

> * Footnote: On the backup device, maybe we will never delete
> snapshots. In any event, that's not a concern now. We'll retain many,
> many snapshots on the backup device.
Again, DO NOT do this, btrfs in its current state does not support it. 
Good rule of thumb for time of some operations is data size multiplied 
by number of snapshots (raised to some power >= 1) and divided by IO/CPU 
speed. By creating snapshots it is very easy to create petabytes of data 
for kernel to process, which it won't be able to do in many years.

--

With Best Regards,
Marat Khalili

