Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53733 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756124AbaGTAxF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jul 2014 20:53:05 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: ENOSPC errors during balance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140719225810.7a28d13b@marcec>
Date: Sat, 19 Jul 2014 18:53:03 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <1236DA1E-80DE-4240-840E-97CB131D8966@colorremedies.com>
References: <20140719221051.57378a41@marcec> <20140719225810.7a28d13b@marcec>
To: Marc Joliet <marcec@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 19, 2014, at 2:58 PM, Marc Joliet <marcec@gmx.de> wrote:

> Am Sat, 19 Jul 2014 22:10:51 +0200
> schrieb Marc Joliet <marcec@gmx.de>:
> 
> [...]
>> Another random idea:  the number of errors decreased the second time I ran
>> balance (from 4 to 2), I could run another full balance and see if it keeps
>> decreasing.
> 
> Well, this time there were still 2 ENOSPC errors.  But I can show the df output
> after such an ENOSPC error, to illustrate what I meant with the sudden surge
> in total usage:
> 
> # btrfs filesystem df /run/media/marcec/MARCEC_BACKUP 
> Data, single: total=236.00GiB, used=229.04GiB
> System, DUP: total=32.00MiB, used=36.00KiB
> Metadata, DUP: total=4.00GiB, used=3.20GiB
> unknown, single: total=512.00MiB, used=0.00
> 
> And then after running a balance and (almost) immediately cancelling:
> 
> # btrfs filesystem df /run/media/marcec/MARCEC_BACKUP 
> Data, single: total=230.00GiB, used=229.04GiB
> System, DUP: total=32.00MiB, used=36.00KiB
> Metadata, DUP: total=4.00GiB, used=3.20GiB
> unknown, single: total=512.00MiB, used=0.00

I think it's a bit weird. Two options: a. Keep using the file system, with judicious backups, if a dev wants more info they'll reply to the thread; b. Migrate the data to a new file system, first capture the file system with btrfs-image in case a dev wants more info and you've since blown away the filesystem, and then move it to a new btrfs fs. I'd use send/receive for this to preserve subvolumes and snapshots.


Chris Murphy