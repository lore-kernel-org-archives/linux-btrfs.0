Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from varnett.perilith.com ([69.164.205.202]:57888 "EHLO
        varnett.perilith.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753790AbeDSWPb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 18:15:31 -0400
Received: from bottomless.cesspool.net (c-69-181-137-240.hsd1.ca.comcast.net [69.181.137.240])
        (Authenticated sender: drew@bloechl.us)
        by varnett.perilith.com (Postfix) with ESMTPSA id 2EC1F2B33C
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 17:08:50 -0500 (CDT)
Date: Thu, 19 Apr 2018 15:08:48 -0700
From: Drew Bloechl <drew@cesspool.net>
To: linux-btrfs@vger.kernel.org
Subject: Recovery from full metadata with all device space consumed?
Message-ID: <20180419220848.GB24508@bottomless.cesspool.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got a btrfs filesystem that I can't seem to get back to a useful
state. The symptom I started with is that rename() operations started
dying with ENOSPC, and it looks like the metadata allocation on the
filesystem is full:

# btrfs fi df /broken
Data, RAID0: total=3.63TiB, used=67.00GiB
System, RAID1: total=8.00MiB, used=224.00KiB
Metadata, RAID1: total=3.00GiB, used=2.50GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

All of the consumable space on the backing devices also seems to be in
use:

# btrfs fi show /broken
Label: 'mon_data'  uuid: 85e52555-7d6d-4346-8b37-8278447eb590
	Total devices 4 FS bytes used 69.50GiB
	devid    1 size 931.51GiB used 931.51GiB path /dev/sda1
	devid    2 size 931.51GiB used 931.51GiB path /dev/sdb1
	devid    3 size 931.51GiB used 931.51GiB path /dev/sdc1
	devid    4 size 931.51GiB used 931.51GiB path /dev/sdd1

Even the smallest balance operation I can start fails (this doesn't
change even with an extra temporary device added to the filesystem):

# btrfs balance start -v -dusage=1 /broken
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=1
ERROR: error during balancing '/broken': No space left on device
There may be more info in syslog - try dmesg | tail
# dmesg | tail -1
[11554.296805] BTRFS info (device sdc1): 757 enospc errors during
balance

The current kernel is 4.15.0 from Debian's stretch-backports
(specifically linux-image-4.15.0-0.bpo.2-amd64), but it was Debian's
4.9.30 when the filesystem got into this state. I upgraded it in the
hopes that a newer kernel would be smarter, but no dice.

btrfs-progs is currently at v4.7.3.

Most of what this filesystem stores is Prometheus 1.8's TSDB for its
metrics, which are constantly written at around 50MB/second. The
filesystem never really gets full as far as data goes, but there's a lot
of never-ending churn for what data is there.

Question 1: Are there other steps that can be tried to rescue a
filesystem in this state? I still have it mounted in the same state, and
I'm willing to try other things or extract debugging info.

Question 2: Is there something I could have done to prevent this from
happening in the first place?

Thanks!
