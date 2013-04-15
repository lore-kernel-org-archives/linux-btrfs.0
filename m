Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63832 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab3DONZR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 09:25:17 -0400
Received: by mail-pd0-f179.google.com with SMTP id x11so2482544pdj.24
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2013 06:25:16 -0700 (PDT)
Message-ID: <516BFFB6.2090706@gmail.com>
Date: Mon, 15 Apr 2013 21:25:10 +0800
From: Dongsheng Song <dongsheng.song@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: How to rescue my data from raid1 metadata with raid0 data ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

When I created my btrfs filesystem, I use the command:

mkfs.btrfs -m raid1 -d raid0 /dev/sda5 /dev/sdb5

# btrfs fi df /srv/raid0/
Data, RAID0: total=1.92TB, used=1.46TB
System, RAID1: total=32.00MB, used=164.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=39.26GB, used=8.84GB

Today, my first disk broken, I want to copy all integrated files to 
/dev/sdb5 which not have data on /dev/sda5,
then remove /dev/sda5 from this btrfs file system, is it possible ?

# btrfs fi show
Label: 'dre log files'  uuid: d14f42ca-8784-463e-b85a-b94a5b9f70a2
         Total devices 2 FS bytes used 1.46TB
         devid    1 size 1.00TB used 1.00TB path /dev/sdb5
         *** Some devices missing

With the latest btrfs-progs v0.20-rc1 and kernel 3.7.5, I try to delete 
the missing device, but failed:

# ./btrfs device delete missing /srv/raid0
ERROR: error removing the device 'missing' - Invalid argument

[6191459.658962] btrfs: bdev /dev/sda5 errs: wr 96543, rd 1, flush 0, 
corrupt 0, gen 0
[6191459.665981] btrfs: bdev /dev/sda5 errs: wr 96544, rd 1, flush 0, 
corrupt 0, gen 0
[6191459.668319] btrfs: bdev /dev/sda5 errs: wr 96545, rd 1, flush 0, 
corrupt 0, gen 0
[6191459.682605] btrfs: bdev /dev/sda5 errs: wr 96546, rd 1, flush 0, 
corrupt 0, gen 0
[6191459.684672] btrfs: bdev /dev/sda5 errs: wr 96547, rd 1, flush 0, 
corrupt 0, gen 0
[6191459.699748] btrfs: bdev /dev/sda5 errs: wr 96548, rd 1, flush 0, 
corrupt 0, gen 0
[6191459.702150] btrfs: bdev /dev/sda5 errs: wr 96549, rd 1, flush 0, 
corrupt 0, gen 0
[6191459.704791] btrfs: bdev /dev/sda5 errs: wr 96550, rd 1, flush 0, 
corrupt 0, gen 0
[6191459.707257] btrfs: bdev /dev/sda5 errs: wr 96551, rd 1, flush 0, 
corrupt 0, gen 0
[6191459.749754] lost page write due to I/O error on /dev/sda5
[6191459.749763] btrfs: bdev /dev/sda5 errs: wr 96552, rd 1, flush 0, 
corrupt 0, gen 0
[6191459.751572] lost page write due to I/O error on /dev/sda5
[6191459.751585] lost page write due to I/O error on /dev/sda5
[6191468.705857] btrfs: unable to go below two devices on raid1

Thanks,
Dongsheng

