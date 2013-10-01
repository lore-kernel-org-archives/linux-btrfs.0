Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:7479 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754834Ab3JABFk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Sep 2013 21:05:40 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:49176 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VQoPC-000Rlg-NH
	for linux-btrfs@vger.kernel.org; Mon, 30 Sep 2013 19:05:39 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Progress of device deletion?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <2E504581-FA34-425A-B14B-EF3F16FC655C@colorremedies.com>
Date: Mon, 30 Sep 2013 19:05:36 -0600
Message-Id: <F4008F3B-594D-4003-BC06-82B9E18AA023@colorremedies.com>
References: <alpine.DEB.2.10.1309290902050.24007@shack.dolda2000.com> <2E504581-FA34-425A-B14B-EF3F16FC655C@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 30, 2013, at 8:27 AM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Sep 29, 2013, at 1:13 AM, Fredrik Tolf <fredrik@dolda2000.com> wrote:
>> 
>> Is there any way I can find out what's going on?
> 
> For whatever reason, it started out with every drive practically full, in terms of chunk allocation.
> 
> e.g.        devid    5 size 2.73TB used 2.71TB path /dev/sdh1
> 
> I don't know if the code works this way, but it needs to do a balance (or partial one) to make room before it can start migrating actual complete chunks from 4 disks to 2 disks. And my guess is that it's not yet done balancing sdg1 still.
> 
> Post kernel version, btrfs-progs version, and dmesg from the time the delete command was initiated.

Without knowing more information about how it's expected to behave (now and near future), I think if I were you I would have added a couple of drives to the volume first so that it had more maneuvering room. It probably seems weird to add drives to remove drives, but sometimes (always?) Btrfs really gets a bit piggish about allocating a lot more chunks than there is data. Or maybe it's not deallocating space as aggressively as it could. So it can get to a point where even though there isn't that much data in the volume (in your case 1.5x the drive size, and you have 4 drives) yet all of it's effectively allocated. So to back out of that takes free space. Then once the chunks are better allocated, you'd have been able to remove the drives. Open question if I would have removed 2, then another 2. Or removed 4.

And for all I know adding one drive might be enough even though it's raid0. *shrug* New territory.



Chris Murphy