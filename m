Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f193.google.com ([209.85.128.193]:46803 "EHLO
	mail-ve0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758150AbaCDUnd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Mar 2014 15:43:33 -0500
Received: by mail-ve0-f193.google.com with SMTP id oz11so23286veb.4
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Mar 2014 12:43:32 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 4 Mar 2014 15:43:32 -0500
Message-ID: <CAJtFHUSDpVVZAJtRdgrTw3JiW-8k0kY0Qp6vck+dypNZxdLgsw@mail.gmail.com>
Subject: Getting profile conversion to finish
From: E V <eliventer@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm having difficulty getting a profile conversion from raid0 ->
single to finish. Is there a way to tell the filesystem to stop all
new allocations for the raid0 profile, before the full balance
finishes? Otherwise I feel like I'm in a sisyphian push of blocks into
higher block numbers.

Since the profile conversion seems to fail frequently with ENOSPC even
though space isn't an issue:

$ (btrfs file show && btrfs file df /mirror && df -h /mirror)
Label: isibackup  uuid: 550c0f77-8f75-40f3-a64e-42c87a0c8e8d
        Total devices 3 FS bytes used 61.35TiB
        devid    1 size 30.01TiB used 20.16TiB path /dev/sdb
        devid    2 size 30.01TiB used 20.16TiB path /dev/sdc
        devid    3 size 40.02TiB used 29.15TiB path /dev/sdd

Btrfs v3.12-dirty
Data, RAID0: total=11.58TiB, used=11.57TiB
Data, single: total=57.64TiB, used=49.68TiB
System, RAID1: total=40.00MiB, used=7.06MiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=134.00GiB, used=90.15GiB
Metadata, single: total=8.00MiB, used=0.00
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb        101T   62T   38T  63% /mirror

 I wrote a little script to try the profile conversion, and when it
fails try a regular balance which always seems to work fine, ala:

e=550000000000000
i=479300000000000
step=100000000000
btrfs balance start -dusage=0,vrange=0..$e /mirror
while [ $i -lt $e ]
do
    h=$((i-step))
    if ! btrfs balance start
-dprofiles=raid0,convert=single,vrange=0..$i /mirror
    then
        btrfs balance start -dvrange=$h..$i /mirror
    fi
    i=$((i+step))
done

However while this is ongoing, new data written to the filesystem
sometimes gets written to the raid0 profile. So making progress
appears quite slow, maybe 0.5 TB a week from data raid0 -> data
single. Thus the question can I tell it to stop allocating new raid0
space some how, and only use single for new data?
