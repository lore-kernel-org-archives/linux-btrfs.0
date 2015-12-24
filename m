Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:40619 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbbLXPDU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 10:03:20 -0500
Subject: Re: btrfs und lvm-cache?
To: Neuer User <auslands-kv@gmx.de>, linux-btrfs@vger.kernel.org
References: <n5du09$9rn$1@ger.gmane.org>
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <pp@siedziba.pl>
Message-ID: <567C07A6.7080503@siedziba.pl>
Date: Thu, 24 Dec 2015 15:56:38 +0100
MIME-Version: 1.0
In-Reply-To: <n5du09$9rn$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
> - both hdd and ssd in one LVM VG
> - one LV on each hdd, containing a btrfs filesystem
> - both btrfs LV configured as RAID1
> - the single SDD used as a LVM cache device for both HDD LVs to speed up
> random access, where possible

I have a setup like this for my /home. It works but it's a crappy solution.

The effective capacity for caching is halved, and it takes twice as much 
time to fully cache your working set, because you get a cache miss at 
least once for each mirror.

There are also some gotchas:

- you should use "device=" mount options, or else there is a danger of 
btrfs mounting origin devices and even mixing cached and origin in one 
FS. I completely broke my FS before realizing what's going on.
- you should use writethrough mode if you only have one SSD. There was a 
bug in LVM where it wouldn't save the caching mode and revert to 
writeback after restart, so make sure you use the latest version of LVM 
tools.
- if your SSD dies, you may have to use vgcfgbackup, manual config edit, 
then vgcfgrestore to remove the cache, because last time I checked, LVM 
tools still were handling writethrough cache the same as writeback, 
disallowing volume activation without the cache and removal of missing 
cache.

