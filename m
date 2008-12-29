From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: multiple device usage
Date: Mon, 29 Dec 2008 11:49:19 +0100
Message-ID: <20081229114919.59f7114d.skraw@ithnet.com>
References: <556243856@web.de>
	<49559672.7060204@gmail.com>
	<000c01c9682d$16b30da0$6602a8c0@bui.materna.com>
	<977a2be20812280526y10eb4646i18cdc17c3af072f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Roland <devzero@web.de>, "Yan Zheng" <ukernel@gmail.com>,
	linux-btrfs@vger.kernel.org
To: "yanhai zhu" <zhu.yanhai@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <977a2be20812280526y10eb4646i18cdc17c3af072f3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 28 Dec 2008 21:26:11 +0800
"yanhai zhu" <zhu.yanhai@gmail.com> wrote:

> > so i can do btrfs-vol -r /dev/sdb while it`s being mounted, pull the disk ,
> > replace it with a bigger one, rescan-scsi-bus, mkfs.btrfs the new disk and
>                                                  ~~~~~~~~~~~~~~~~~~~~~~~
>                                                 This step will fail, you will
> get a "/dev/sdb is mounted" by mkfs.btrfs, but for other slots it's ok.

Really, what average-joe-user needs btrfs for his not-always-mounted
data-partition? Why shouldn't he just use any other fs for that?
All users needing _uptime_ of their fs cannot simply unmount and wait hours
for some cool feature to (hopefully) complete (without failures).
Why does nobody talk about the real world? What's the use of features that
cannot complete their job in users' lifetime due to everybody filling up TBs
of data on their harddisks. How long does it really take to replace a full 300
GB hd with a 800 GB in a multi volume btrfs ?
Please play with real amounts of data and judge for yourself the use of
offline-fs-features.
The times of classical PC use are gone, today people have just about
everything on their hds, music collection, dvd collection, mails, documents of
all kinds, sourcecode trees, name-one. 500 GB hds are very cheap. A _new_ fs
not able to cope with these new usage-patterns is in fact _useless_.

Regards,
Stephan


 
> > then re-add - all while mount telling me, that /dev/sdb is still in use !?
> 
> 2008/12/27 Roland <devzero@web.de>:
> >>> i have some difficulty in understanding multi-device handling in depth.
> >>>
> >>> as
> >>> http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
> >>> tells,
> >>>
> >>> btrfs can span over multiple devices at the same time. (great feature,
> >>> btw !)
> >>>
> >>> ok then:
> >>>
> >>> mkfs.btrfs -m single -d single  /dev/sdb /dev/sdc - creates a btrfs
> >>> spanning
> >>> over /dev/sdb and sdc
> >>>
> >>> mount /dev/sdb /btrfs - mounts it
> >>>
> >>> btrfs-vol -b /btrfs - does a rebalancing of all data and metadata
> >>>
> >>> btrfs-vol -r /dev/sdc - removes one of the volumes and redistributes any
> >>> extends in use on sdc to sdb (killer feature!!!)
> >>>
> >>> but what if i want to remove /dev/sdb ? (as that one is in use for the
> >>> mount)
> >>>
> >>
> >> Devices in btrfs are equal, so you can do this. The only glitch is
> >> /proc/mounts and mount(8) get confused.
> >
> > so i can do btrfs-vol -r /dev/sdb while it`s being mounted, pull the disk ,
> > replace it with a bigger one, rescan-scsi-bus, mkfs.btrfs the new disk and
> > then re-add - all while mount telling me, that /dev/sdb is still in use !?
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> -- 
> Regards,
> Zhu Yanhai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

