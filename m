Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:51055 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab3C1Hyv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 03:54:51 -0400
Received: by mail-la0-f52.google.com with SMTP id fs12so17241632lab.11
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 00:54:50 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 28 Mar 2013 08:54:49 +0100
Message-ID: <CAPsrAuBg9Mv3Ai=ZPMMF413Jw0kqA9ET9e_jnBjrqPhmqoQY+A@mail.gmail.com>
Subject: question about replacing a drive in raid10
From: Joeri Vanthienen <mail@joerivanthienen.be>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have a question about replacing a drive in raid10 (and linux kernel 3.8.4).
A bad disk was physical removed from the server. After this a new disk
was added with "btrfs device add /dev/sdg /btrfs" to the raid10 btrfs
FS.
After this the server was rebooted and I mounted the filesystem in
degraded mode. It seems that a previous started balance continued.

At this point I want to remove the missing device from the pooI (btrfs
device delete missing /btrfs). Is this safe to do ?
The disk usage numbers look weird to me, also the limited amount of
data written to the new disk after the balance.
And I think the balance also failed.
All data is still accessible and I hope this stays the case after
removing the missing device :)

"Mar 27 17:41:06 SANOS1 kernel: btrfs: allowing degraded mounts
Mar 27 17:41:06 SANOS1 kernel: btrfs: disk space caching is enabled
Mar 27 17:41:06 SANOS1 kernel: btrfs: bdev (null) errs: wr 3243008, rd
2, flush 430, corrupt 0, gen 0
Mar 27 17:41:06 SANOS1 kernel: btrfs: bdev /dev/sdl errs: wr 144, rd
0, flush 48, corrupt 129, gen 41
Mar 27 17:41:06 SANOS1 kernel: btrfs: bdev /dev/sdk errs: wr 0, rd 5,
flush 0, corrupt 0, gen 0
Mar 27 17:41:10 SANOS1 kernel: btrfs: continuing balance
Mar 27 17:41:18 SANOS1 kernel: btrfs: relocating block group
4541886169088 flags 65
Mar 27 17:41:41 SANOS1 kernel: btrfs: found 1956 extents
Mar 27 17:42:03 SANOS1 kernel: btrfs: found 1954 extents
"

# mount | grep btrfs
/dev/sdd on /btrfs type btrfs (rw,relatime,degraded,space_cache)

 # btrfs filesystem df /btrfs/
Data, RAID10: total=2.60TB, used=2.57TB
System, RAID10: total=63.88MB, used=244.00KB
System: total=4.00MB, used=0.00
Metadata, RAID10: total=11.00GB, used=8.51GB

 # btrfs filesystem show
Label: 'firstpool'  uuid: 517e8cfa-4275-4589-8da4-6a46ad613daa
        Total devices 15 FS bytes used 2.58TB
        devid   13 size 931.51GB used 381.58GB path /dev/sdp
        devid   14 size 931.51GB used 381.58GB path /dev/sdq
        devid   12 size 931.51GB used 381.58GB path /dev/sdo
        devid   11 size 931.51GB used 381.58GB path /dev/sdn
        devid   10 size 931.51GB used 381.58GB path /dev/sdm
        devid    9 size 931.51GB used 381.58GB path /dev/sdl
        devid    8 size 931.51GB used 380.58GB path /dev/sdk
        devid    7 size 931.51GB used 380.58GB path /dev/sdj
        devid   16 size 931.51GB used 20.44GB path /dev/sdg
        devid    6 size 931.51GB used 381.58GB path /dev/sdi
        devid    5 size 931.51GB used 381.58GB path /dev/sdh
        devid   15 size 931.51GB used 380.58GB path /dev/sdf
        devid    2 size 931.51GB used 381.58GB path /dev/sde
        devid    1 size 931.51GB used 380.58GB path /dev/sdd
        *** Some devices missing

# btrfs filesystem balance status -v /btrfs/
ERROR: balance status on '/btrfs/' failed - Not in progress

Btrfs progs = v0.19+
