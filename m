Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50803 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbeGQIdc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 04:33:32 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Wolf <wolf@wolfsden.cz>, linux-btrfs@vger.kernel.org
Subject: Re: Healthy amount of free space?
Date: Tue, 17 Jul 2018 10:02:03 +0200
Message-ID: <2197534.TZSffJRfLT@merkaba>
In-Reply-To: <1dd72720-1beb-a5e6-5bd4-88d6af5f02bd@suse.com>
References: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz> <1dd72720-1beb-a5e6-5bd4-88d6af5f02bd@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Nikolay.

Nikolay Borisov - 17.07.18, 09:20:
> On 16.07.2018 23:58, Wolf wrote:
> > Greetings,
> > I would like to ask what what is healthy amount of free space to
> > keep on each device for btrfs to be happy?
> > 
> > This is how my disk array currently looks like
> > 
> >     [root@dennas ~]# btrfs fi usage /raid
> >     
> >     Overall:
> >         Device size:                  29.11TiB
> >         Device allocated:             21.26TiB
> >         Device unallocated:            7.85TiB
> >         Device missing:                  0.00B
> >         Used:                         21.18TiB
> >         Free (estimated):              3.96TiB      (min: 3.96TiB)
> >         Data ratio:                       2.00
> >         Metadata ratio:                   2.00
> >         Global reserve:              512.00MiB      (used: 0.00B)
[…]
> > Btrfs does quite good job of evenly using space on all devices. No,
> > how low can I let that go? In other words, with how much space
> > free/unallocated remaining space should I consider adding new disk?
> 
> Btrfs will start running into problems when you run out of unallocated
> space. So the best advice will be monitor your device unallocated,
> once it gets really low - like 2-3 gb I will suggest you run balance
> which will try to free up unallocated space by rewriting data more
> compactly into sparsely populated block groups. If after running
> balance you haven't really freed any space then you should consider
> adding a new drive and running balance to even out the spread of
> data/metadata.

What are these issues exactly?

I have

% btrfs fi us -T /home
Overall:
    Device size:                 340.00GiB
    Device allocated:            340.00GiB
    Device unallocated:            2.00MiB
    Device missing:                  0.00B
    Used:                        308.37GiB
    Free (estimated):             14.65GiB      (min: 14.65GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

                          Data      Metadata System              
Id Path                   RAID1     RAID1    RAID1    Unallocated
-- ---------------------- --------- -------- -------- -----------
 1 /dev/mapper/msata-home 165.89GiB  4.08GiB 32.00MiB     1.00MiB
 2 /dev/mapper/sata-home  165.89GiB  4.08GiB 32.00MiB     1.00MiB
-- ---------------------- --------- -------- -------- -----------
   Total                  165.89GiB  4.08GiB 32.00MiB     2.00MiB
   Used                   151.24GiB  2.95GiB 48.00KiB

on a RAID-1 filesystem one, part of the time two Plasma desktops + 
KDEPIM and Akonadi + Baloo desktop search + you name it write to like 
mad.

Since kernel 4.5 or 4.6 this simply works. Before that sometimes BTRFS 
crawled to an halt on searching for free blocks, and I had to switch off 
the laptop uncleanly. If that happened, a balance helped for a while. 
But since 4.5 or 4.6 this did not happen anymore.

I found with SLES 12 SP 3 or so there is btrfsmaintenance running a 
balance weekly. Which created an issue on our Proxmox + Ceph on Intel 
NUC based opensource demo lab. This is for sure no recommended 
configuration for Ceph and Ceph is quite slow on these 2,5 inch 
harddisks and 1 GBit network link, despite albeit somewhat minimal, 
limited to 5 GiB m.2 SSD caching. What happened it that the VM crawled 
to a halt and the kernel gave task hung for more than 120 seconds 
messages. The VM was basically unusable during the balance. Sure that 
should not happen with a "proper" setup, also it also did not happen 
without the automatic balance.

Also what would happen on a hypervisor setup with several thousands of 
VMs with BTRFS, when several 100 of them decide to start the balance at 
a similar time? It could probably bring the I/O system below to an halt, 
as many enterprise storage systems are designed to sustain burst I/O 
loads, but not maximum utilization during an extended period of time.

I am really wondering what to recommend in my Linux performance tuning 
and analysis courses. On my own laptop I do not do regular balances so 
far. Due to my thinking: If it is not broken, do not fix it.

My personal opinion here also is: If the filesystem degrades that much 
that it becomes unusable without regular maintenance from user space, 
the filesystem needs to be fixed. Ideally I would not have to worry on 
whether to regularly balance an BTRFS or not. In other words: I should 
not have to visit a performance analysis and tuning course in order to 
use a computer with BTRFS filesystem.

Thanks,
-- 
Martin


