Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37089 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbcEOXai (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 May 2016 19:30:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b25UP-0001v3-7v
	for linux-btrfs@vger.kernel.org; Mon, 16 May 2016 01:30:25 +0200
Received: from ip5f5ae06c.dynamic.kabel-deutschland.de ([95.90.224.108])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 01:30:25 +0200
Received: from hurikhan77 by ip5f5ae06c.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 01:30:25 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs RAID-1 vs md RAID-1?
Date: Mon, 16 May 2016 01:29:59 +0200
Message-ID: <20160516012959.2768c42c@jupiter.sol.kaishome.de>
References: <83719f27dd5cdc406fd3fd24e7b82a9f@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 15 May 2016 19:24:47 +0900
schrieb Tomasz Chmielewski <mangoo@wpkg.org>:

> I'm trying to read two large files in parallel from a 2-disk RAID-1 
> btrfs setup (using kernel 4.5.3).
> 
> According to iostat, one of the disks is 100% saturated, while the
> other disk is around 0% busy.
> 
> Is it expected?
> 
> With two readers from the same disk, each file is being read with ~50 
> MB/s from disk (with just one reader from disk, the speed goes up to 
> around ~150 MB/s).
> 
> 
> In md RAID, with many readers, it will try to distribute the reads - 
> after md manual on http://linux.die.net/man/4/md:
> 
>      Raid1
>      (...)
>      Data is read from any one device. The driver attempts to
> distribute read requests across all devices
>      to maximise performance.
> 
>      Raid5
>      (...)
>      This also allows more parallelism when reading, as read requests
> are distributed over all the devices
>      in the array instead of all but one.
> 
> 
> Are there any plans to improve this is btrfs?
> 
> 
> Tomasz Chmielewski
> http://wpkg.org

Here is an idea that could need improvement:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/17985


-- 
Regards,
Kai

Replies to list-only preferred.

