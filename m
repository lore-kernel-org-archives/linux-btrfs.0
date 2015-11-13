Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51696 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966AbbKMSZm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 13:25:42 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1ZxILO-0005Tv-1J by authid <merlin>
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 09:41:02 -0800
Date: Fri, 13 Nov 2015 09:41:01 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Where is the disk space?
Message-ID: <20151113174101.GC19249@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

root@polgara:/mnt/btrfs_root# du -sh *
28G     @
28G     @_hourly.20151113_08:04:01
4.0K    @_last
4.0K    @_last_rw
28G     @_rw.20151113_00:02:01
root@polgara:/mnt/btrfs_root# df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb5        56G   40G  5.4G  89% /mnt/btrfs_root

root@polgara:/mnt/btrfs_root# btrfs fi df .
Data, single: total=39.85GiB, used=38.52GiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=6.00GiB, used=579.17MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=208.00MiB, used=0.00B

root@polgara:/mnt/btrfs_root# btrfs fi show .
Label: 'btrfs_root'  uuid: a2a1ed7b-6bfe-4e83-bc10-727126ed17bf
        Total devices 1 FS bytes used 39.09GiB
        devid    1 size 55.88GiB used 51.88GiB path /dev/sdb5

btrfs-progs v4.0-dirty
root@polgara:/mnt/btrfs_root# 

root@polgara:/mnt/btrfs_root# btrfs balance start -dusage=80 -v /mnt/btrfs_root
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=80
Done, had to relocate 1 out of 55 chunks

Sadly, it's only running 3.17.8 because of complicated reasons, but still, 

1) I have 28GB used (modulo a few files between the btrfs send snapshots and
current status)

2) fi show shows I'm using 39GB, not sure where the extra 11GB came from

3) fi df agrees with fi show

4) regular df agrees on used too, but shows 5GB free instead of 15GB despite
the filesystem being balanced.

I did have a bunch of snapshots that I did delete a while ago now, but it
looks like their blocks aren't being reclaimed.

Any ideas?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
