Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from varnett.perilith.com ([69.164.205.202]:58188 "EHLO
        varnett.perilith.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753537AbeDSXMl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 19:12:41 -0400
Received: from bottomless.cesspool.net (c-69-181-137-240.hsd1.ca.comcast.net [69.181.137.240])
        (Authenticated sender: drew@bloechl.us)
        by varnett.perilith.com (Postfix) with ESMTPSA id A43E82B33C
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 18:12:40 -0500 (CDT)
Date: Thu, 19 Apr 2018 16:12:39 -0700
From: Drew Bloechl <drew@cesspool.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: Recovery from full metadata with all device space consumed?
Message-ID: <20180419231239.GD24508@bottomless.cesspool.net>
References: <20180419220848.GB24508@bottomless.cesspool.net>
 <20180419224357.GI13551@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180419224357.GI13551@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 19, 2018 at 10:43:57PM +0000, Hugo Mills wrote:
>    Given that both data and metadata levels here require paired
> chunks, try adding _two_ temporary devices so that it can allocate a
> new block group.

Thank you very much, that seems to have done the trick:

# fallocate -l 4GiB /var/tmp/btrfs-temp-1
# fallocate -l 4GiB /var/tmp/btrfs-temp-2
# losetup -f /var/tmp/btrfs-temp-1
# losetup -f /var/tmp/btrfs-temp-2
# btrfs device add /dev/loop0 /broken
Performing full device TRIM (4.00GiB) ...
# btrfs device add /dev/loop1 /broken
Performing full device TRIM (4.00GiB) ...
# btrfs balance start -v -dusage=1 /broken
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=1

I'm guessing that'll take a while to complete, but meanwhile, in another
terminal:

# btrfs fi show /broken
Label: 'mon_data'  uuid: 85e52555-7d6d-4346-8b37-8278447eb590
	Total devices 6 FS bytes used 69.53GiB
	devid    1 size 931.51GiB used 731.02GiB path /dev/sda1
	devid    2 size 931.51GiB used 731.02GiB path /dev/sdb1
	devid    3 size 931.51GiB used 730.03GiB path /dev/sdc1
	devid    4 size 931.51GiB used 730.03GiB path /dev/sdd1
	devid    5 size 4.00GiB used 1.00GiB path /dev/loop0
	devid    6 size 4.00GiB used 1.00GiB path /dev/loop1

# btrfs fi df /broken
Data, RAID0: total=2.77TiB, used=67.00GiB
System, RAID1: total=8.00MiB, used=192.00KiB
Metadata, RAID1: total=4.00GiB, used=2.49GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Do I understand correctly that this could require up to 3 extra devices,
if for instance you arrived in this situation with a RAID6 data profile?
Or is the number even higher for profiles like RAID10?
