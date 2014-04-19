Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43105 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750777AbaDSEzA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Apr 2014 00:55:00 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Fixing a degraded RAID
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <87ppkeato3.fsf@maru2.md5i.com>
Date: Fri, 18 Apr 2014 22:54:57 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <B1D8651C-BC87-4D00-9C9C-EACECE00FB3F@colorremedies.com>
References: <87y4z2avvz.fsf@maru2.md5i.com> <87ppkeato3.fsf@maru2.md5i.com>
To: Michael Welsh Duggan <mwd@md5i.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 18, 2014, at 9:23 PM, Michael Welsh Duggan <mwd@md5i.com> wrote:

> My mistake.  This was a stupid typo.  The drives were in a RAID 1
> configuration.  Both data and metadata are DUP'd.
> 
> root@maru2:~# /usr/local/src/btrfs-progs/btrfs fi df /mnt/
> Data, RAID1: total=353.00GiB, used=328.24GiB
> System, single: total=32.00MiB, used=56.00KiB
> Metadata, RAID1: total=4.00GiB, used=1.43GiB

Somehow system is set to single instead of raid1. I haven't seen system and metadata be set to different profiles. Only 56KB of system data is being used, but I don't know how that's distributed across three drives when the profile is single.

Chris Murphy

