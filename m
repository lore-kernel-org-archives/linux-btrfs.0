Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:59540 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaBXNs4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 08:48:56 -0500
Received: by mail-vc0-f170.google.com with SMTP id hu8so5772542vcb.29
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 05:48:55 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 24 Feb 2014 13:48:55 +0000
Message-ID: <CAMU1PDh6crrOW02oqz6jqvG+rAG6W3mb+V=gHEy37FB1q0UpOg@mail.gmail.com>
Subject: How to identify if a partition containing a btrfs volume is mounted
 and where
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am trying to enhance GParted (http://www.gparted.org/) to better
support btrfs, specifically multi-device ones.  GParted displays the
busy status (mounted or not) and the mount point of each partition.

For a single device file system this is easy.  Entry in /proc/mounts
for the partition identifies it's mounted and provides the mount
point.

In the general case for btrfs I don't know how to get from device name
containing a btrfs volume to knowing if it's mounted and where?
btrfs filesystem show can identify the devices in a btrfs, but if the
mounting device was removed from the file system this linkage is
broken.

# mkfs.btrfs /dev/sdb2 /dev/sdb3 /dev/sdb4
# mount /dev/sdb2 /mnt/1
# btrfs device delete /dev/sdb2 /mnt/1

So /dev/sdb2 is no longer part of the file system, but it's still
mounted using it.

# grep btrfs /proc/mounts
/dev/sdb2 /mnt/1 btrfs rw,seclabel,relatime,ssd,space_cache 0 0
# btrfs filesystem show /dev/sdb3
Label: none  uuid: d1e98472-e562-466c-8fa4-ddcaee757c20
    Total devices 2 FS bytes used 156.00KB
    devid    3 size 2.00GB used 961.56MB path /dev/sdb4
    devid    2 size 2.00GB used 552.00MB path /dev/sdb3

So in there a way to determine whether a specific partition containing
a btrfs volume is mounted and on what mount point?

Thanks,
Mike
