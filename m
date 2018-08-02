Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47335 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbeHBLGh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2018 07:06:37 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS and databases
Date: Thu, 02 Aug 2018 11:16:18 +0200
Message-ID: <2861903.YXSMuvecdq@merkaba>
In-Reply-To: <20180801085602.GC7524@carfax.org.uk>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com> <20180801085602.GC7524@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills - 01.08.18, 10:56:
> On Wed, Aug 01, 2018 at 05:45:15AM +0200, MegaBrutal wrote:
> > I know it's a decade-old question, but I'd like to hear your
> > thoughts
> > of today. By now, I became a heavy BTRFS user. Almost everywhere I
> > use BTRFS, except in situations when it is obvious there is no
> > benefit (e.g. /var/log, /boot). At home, all my desktop, laptop and
> > server computers are mainly running on BTRFS with only a few file
> > systems on ext4. I even installed BTRFS in corporate productive
> > systems (in those cases, the systems were mainly on ext4; but there
> > were some specific file systems those exploited BTRFS features).
> > 
> > But there is still one question that I can't get over: if you store
> > a
> > database (e.g. MySQL), would you prefer having a BTRFS volume
> > mounted
> > with nodatacow, or would you just simply use ext4?
> 
>    Personally, I'd start with btrfs with autodefrag. It has some
> degree of I/O overhead, but if the database isn't performance-critical
> and already near the limits of the hardware, it's unlikely to make
> much difference. Autodefrag should keep the fragmentation down to a
> minimum.

I read that autodefrag would only help with small databases.

I also read that even on SSDs there is a notable performance penalty. 
4.2 GiB akonadi database  for tons of mails appears to work okayish on 
dual SSD BTRFS RAID 1 here with LZO compression here. However I have no 
comparison, for example how it would run on XFS. And its fragmented 
quite a bit, example for the largest file of 3 GiB – I know this in part 
is also due to LZO compression.

[…].local/share/akonadi/db_data/akonadi> time /usr/sbin/filefrag 
parttable.ibd
parttable.ibd: 45380 extents found
/usr/sbin/filefrag parttable.ibd  0,00s user 0,86s system 41% cpu 2,054 
total

However it digs out those extents quite fast.

I would not feel comfortable with setting this file to nodatacow.


However I wonder: Is this it? Is there nothing that can be improved in 
BTRFS to handle database and VM files in a better way, without altering 
any default settings?

Is it also an issue on ZFS? ZFS does also copy on write. How does ZFS 
handle this? Can anything be learned from it? I never head people 
complain about poor database performance on ZFS, but… I don´t use it and 
I am not subscribed to any ZFS mailing lists, so they may have similar 
issues and I just do not know it.

Well there seems to be a performance penalty at least when compared to 
XFS:

About ZFS Performance
Yves Trudeau, May 15, 2018

https://www.percona.com/blog/2018/05/15/about-zfs-performance/

The article described how you can use NVMe devices as cache to mitigate 
the performance impact. That would hint that BTRFS with VFS Hot Data 
Tracking and relocating data to SSD or NVMe devices could be a way to 
set this up.


But as said I read about bad database performance even on SSDs with 
BTRFS. I do not find the original reference at the moment, but I got 
this for example, however it is from 2015 (on kernel 4.0 which is a bit 
old):

Friends don't let friends use BTRFS for OLTP
2015/09/16 by Tomas Vondra

https://blog.pgaddict.com/posts/friends-dont-let-friends-use-btrfs-for-oltp

Interestingly it also compares with ZFS which is doing much better. So 
maybe there is really something to be learned from ZFS.

I did not get clearly whether the benchmark was on an SSD, as Tomas 
notes the "ssd" mount option, it might have been.

Thanks,
-- 
Martin


