Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:40365 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbbLWLVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 06:21:22 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Neuer User <auslands-kv@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs und lvm-cache?
Date: Wed, 23 Dec 2015 12:21:20 +0100
Message-ID: <1527885.5NheBqth0k@merkaba>
In-Reply-To: <n5du09$9rn$1@ger.gmane.org>
References: <n5du09$9rn$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 23. Dezember 2015, 11:45:28 CET schrieb Neuer User:
> Hello

Hi.

> I want to setup a small homeserver, based on a HP Microserver Gen8 (4GB
> RAM, 2x3TB HDD + 1x120GB SSD) and Proxmox as distro.
> 
> The server will be used to host a (small) number of virtual machines,
> most of them being LXC containers, few being KVM machines. One of the
> LXC containers will host a fileserver with app 1 TB of data and another
> one a backup system for the desktops / laptops in my household, thus
> probably holding quite a lot of files. The lxc containers will use the
> filesystem of the proxmox host, the KVM machines probably raw disk files
> (or qcow2).
> 
> I would like to combine high data integrity with some speed, so I
> thought of the following layout:
> 
> - both hdd and ssd in one LVM VG
> - one LV on each hdd, containing a btrfs filesystem
> - both btrfs LV configured as RAID1
> - the single SDD used as a LVM cache device for both HDD LVs to speed up
> random access, where possible
> 
> Now, I wonder if that is a good architecture to go for. Any input on
> that? Is btrfs the right way to go for, or should I better go for ZFS
> (and purchase some more gigs of RAM)?
> 
> Will there be any problems arising from the lvmcache? btrfs only sees
> the HDDs, LVM does the SDD handling.

As far as I understand this way you basically loose the RAID 1 semantics of 
BTRFS. While the data is redundant on the HDDs, it is not redundant on the 
SSD. It may work for a pure read cache, but for write-through you definately 
loose any data integrity protection a RAID 1 gives you.

Of course, you can use two SSDs and have them work as RAID 1 as well.

There is a patch set for in-BTRFS SSD-caching. It consists of a patch set to 
add hot data tracking to VFS and a patch set for adding support in BTRFS. But 
I didn´t see anything of these in quite some time.

Happy christmas,
-- 
Martin
