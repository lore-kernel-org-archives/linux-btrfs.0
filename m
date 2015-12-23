Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33917 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934182AbbLWUZE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 15:25:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBpy3-000596-4K
	for linux-btrfs@vger.kernel.org; Wed, 23 Dec 2015 21:25:03 +0100
Received: from 178-83-240-22.dynamic.hispeed.ch ([178.83.240.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 21:25:03 +0100
Received: from auslands-kv by 178-83-240-22.dynamic.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 21:25:03 +0100
To: linux-btrfs@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Re: btrfs und lvm-cache?
Date: Wed, 23 Dec 2015 21:24:43 +0100
Message-ID: <n5evuc$9j3$1@ger.gmane.org>
References: <n5du09$9rn$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <n5du09$9rn$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One other thing:

I read that btrfs has some options that are turned off for SSDs as they
might be harmful or so. In my case btrfs, however, would not know about
the SSD and probably use its HDD optimized settings. The result,
however, would be forwared also to the SSD via lvmcache. Do I see that
right? Would that give any serious problems?

Am 23.12.2015 um 11:45 schrieb Neuer User:
> Hello
> 
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
> 
> Thanks for any input. I like btrfs very much, but data integrity is
> important for this.
> 
> Michael
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


