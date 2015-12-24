Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43298 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbbLXPaF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 10:30:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aC7q7-0005Wy-Cj
	for linux-btrfs@vger.kernel.org; Thu, 24 Dec 2015 16:30:03 +0100
Received: from 178-83-240-22.dynamic.hispeed.ch ([178.83.240.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 16:30:03 +0100
Received: from auslands-kv by 178-83-240-22.dynamic.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 16:30:03 +0100
To: linux-btrfs@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Re: btrfs und lvm-cache?
Date: Thu, 24 Dec 2015 16:29:14 +0100
Message-ID: <n5h30b$8vd$1@ger.gmane.org>
References: <n5du09$9rn$1@ger.gmane.org> <567C07A6.7080503@siedziba.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <567C07A6.7080503@siedziba.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 24.12.2015 um 15:56 schrieb Piotr Pawłow:
> Hello,
>> - both hdd and ssd in one LVM VG
>> - one LV on each hdd, containing a btrfs filesystem
>> - both btrfs LV configured as RAID1
>> - the single SDD used as a LVM cache device for both HDD LVs to speed up
>> random access, where possible
> 
> I have a setup like this for my /home. It works but it's a crappy solution.
> 
Indeed? Exactly like this? Great to hear. But sad to hear it is not a
good solution.

> The effective capacity for caching is halved, and it takes twice as much
> time to fully cache your working set, because you get a cache miss at
> least once for each mirror.
> 
> There are also some gotchas:
> 
> - you should use "device=" mount options, or else there is a danger of
> btrfs mounting origin devices and even mixing cached and origin in one
> FS. I completely broke my FS before realizing what's going on.

Hmm, strange. I thought btrfs should not even know of the lvmcache. It
would just try to mount the HDD LVs and the caching is done
automatically via lvmcache?

> - you should use writethrough mode if you only have one SSD. There was a
> bug in LVM where it wouldn't save the caching mode and revert to
> writeback after restart, so make sure you use the latest version of LVM
> tools.
Do you know, which version is good?

> - if your SSD dies, you may have to use vgcfgbackup, manual config edit,
> then vgcfgrestore to remove the cache, because last time I checked, LVM
> tools still were handling writethrough cache the same as writeback,
> disallowing volume activation without the cache and removal of missing
> cache.
> 
Sounds complicated, but possible. Pity that LVM does not auto-remove the
cache if it is not there...

> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


