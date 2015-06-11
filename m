Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:33185 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbbFKP0L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 11:26:11 -0400
Received: by qkhg32 with SMTP id g32so4581499qkh.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2015 08:26:11 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Jun 2015 08:26:11 -0700
Message-ID: <CAEMJtDs=U5+YO9sbVvjxLthdxp6JvZO=07EMhcU5Smif_1m5QQ@mail.gmail.com>
Subject: Can't mount btrfs volume on rbd
From: Steve Dainard <sdainard@spd1.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm getting an error when attempting to mount a volume on a host that
was forceably powered off:

# mount /dev/rbd4 climate-downscale-CMIP5/
mount: mount /dev/rbd4 on /mnt/climate-downscale-CMIP5 failed: Stale file handle

/var/log/messages:
Jun 10 15:31:07 node1 kernel: rbd4: unknown partition table

# parted /dev/rbd4 print
Model: Unknown (unknown)
Disk /dev/rbd4: 36.5TB
Sector size (logical/physical): 512B/512B
Partition Table: loop
Disk Flags:

Number  Start  End     Size    File system  Flags
 1      0.00B  36.5TB  36.5TB  btrfs

# btrfs check --repair /dev/rbd4
enabling repair mode
Checking filesystem on /dev/rbd4
UUID: dfe6b0c8-2866-4318-abc2-e1e75c891a5e
checking extents
cmds-check.c:2274: check_owner_ref: Assertion `rec->is_root` failed.
btrfs[0x4175cc]
btrfs[0x41b873]
btrfs[0x41c3fe]
btrfs[0x41dc1d]
btrfs[0x406922]


OS: CentOS 7.1
btrfs-progs: 3.16.2
Ceph: version: 0.94.1/CentOS 7.1

I haven't found any references to 'stale file handle' on btrfs.

The underlying block device is ceph rbd, so I've posted to both lists
for any feedback. Also once I reformatted btrfs I didn't get a mount
error.

The btrfs volume has been reformatted so I won't be able to do much
post mortem but I'm wondering if anyone has some insight.

Thanks,
Steve
