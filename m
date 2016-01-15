Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:32924 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbcAOHE3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 02:04:29 -0500
Received: by mail-qg0-f52.google.com with SMTP id b35so371720569qge.0
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 23:04:29 -0800 (PST)
MIME-Version: 1.0
From: bbrendon@gmail.com
Date: Thu, 14 Jan 2016 23:03:49 -0800
Message-ID: <CADrfcdae8Z7towaXpuA=dtq-GP-hMxJZp69UP5TayH20_ZMvBw@mail.gmail.com>
Subject: kernel crash when balancing raid56 after low on space
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looking for a bit of help getting this FS balanced. I'm getting a
kernel crash and readonly file system error:
[ 9357.096562] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]

dmesg output. http://pastebin.com/c9xKvpZ0

This problem began because of performance issues. Basically the FS
appeared to be hung. (I think because it got to about 100GB free) I
added a drive and started a rebalance which somehow also hung. I then
aborted the whole thing, upgraded from 4.3 to 4.4 and after a long
wait the FS mounted. I deleted more snaps and now when I start a
balance, the FS goes read-only.

Thanks for any help you can provide! -Brendon

# uname -a
Linux humvee 4.4.0 #1 SMP Thu Jan 14 15:54:03 PST 2016 x86_64 GNU/Linux

#  btrfs --version
btrfs-progs v4.3
#

# btrfs fi show
Label: 'tank0'  uuid: d25217dd-91f1-4add-8c07-66eacff9fb28
        Total devices 6 FS bytes used 6.22TiB
        devid    1 size 3.64TiB used 3.52TiB path /dev/sdc
        devid    2 size 3.64TiB used 3.52TiB path /dev/sdd
        devid    3 size 3.64TiB used 3.52TiB path /dev/sde
        devid    4 size 3.64TiB used 3.52TiB path /dev/sdf
        devid    5 size 3.64TiB used 3.52TiB path /dev/sdg
        devid    6 size 3.64TiB used 1.00GiB path /dev/sdh

btrfs-progs v4.3
#
#  btrfs fi df /tank0
Data, RAID6: total=10.55TiB, used=6.21TiB
System, RAID6: total=96.00MiB, used=880.00KiB
Metadata, RAID6: total=19.59GiB, used=10.34GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
#
