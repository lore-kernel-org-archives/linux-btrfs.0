Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60012 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbbLWKpl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 05:45:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBgvG-0004MH-In
	for linux-btrfs@vger.kernel.org; Wed, 23 Dec 2015 11:45:34 +0100
Received: from 178-83-240-22.dynamic.hispeed.ch ([178.83.240.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 11:45:34 +0100
Received: from auslands-kv by 178-83-240-22.dynamic.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 11:45:34 +0100
To: linux-btrfs@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: btrfs und lvm-cache?
Date: Wed, 23 Dec 2015 11:45:28 +0100
Message-ID: <n5du09$9rn$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

I want to setup a small homeserver, based on a HP Microserver Gen8 (4GB
RAM, 2x3TB HDD + 1x120GB SSD) and Proxmox as distro.

The server will be used to host a (small) number of virtual machines,
most of them being LXC containers, few being KVM machines. One of the
LXC containers will host a fileserver with app 1 TB of data and another
one a backup system for the desktops / laptops in my household, thus
probably holding quite a lot of files. The lxc containers will use the
filesystem of the proxmox host, the KVM machines probably raw disk files
(or qcow2).

I would like to combine high data integrity with some speed, so I
thought of the following layout:

- both hdd and ssd in one LVM VG
- one LV on each hdd, containing a btrfs filesystem
- both btrfs LV configured as RAID1
- the single SDD used as a LVM cache device for both HDD LVs to speed up
random access, where possible

Now, I wonder if that is a good architecture to go for. Any input on
that? Is btrfs the right way to go for, or should I better go for ZFS
(and purchase some more gigs of RAM)?

Will there be any problems arising from the lvmcache? btrfs only sees
the HDDs, LVM does the SDD handling.

Thanks for any input. I like btrfs very much, but data integrity is
important for this.

Michael


