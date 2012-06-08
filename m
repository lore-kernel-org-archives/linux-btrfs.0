Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54845 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2FHI00 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jun 2012 04:26:26 -0400
Received: by eaak11 with SMTP id k11so876125eaa.19
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jun 2012 01:26:25 -0700 (PDT)
Message-ID: <4FD1B72D.3010002@gmail.com>
Date: Fri, 08 Jun 2012 11:26:21 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs filesystems can only be mounted after an unclean shutdown if
 btrfsck is run and immediately killed!
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
I have two multi-disk btrfs filesystems on a Arch linux 3.4.0 system. 
After a power failure, both filesystems refuse to mount

[   10.402284] Btrfs loaded
[   10.402714] device fsid 1e7c18a4-02d6-44b1-8eaf-c01378009cd3 devid 4 
transid 65282 /dev/sdc
[   10.403108] btrfs: force zlib compression
[   10.403130] btrfs: enabling inode map caching
[   10.403152] btrfs: disk space caching is enabled
[   10.403377] btrfs: failed to read the system array on sdc
[   10.403557] btrfs: open_ctree failed
[   10.431763] device fsid 7f7be913-e359-400f-8bdb-7ef48aad3f03 devid 2 
transid 3916 /dev/sdb
[   10.432180] btrfs: force zlib compression
[   10.433040] btrfs: enabling inode map caching
[   10.433892] btrfs: disk space caching is enabled
[   10.434930] btrfs: failed to read the system array on sdb
[   10.435945] btrfs: open_ctree failed


fstab:

UUID=1e7c18a4-02d6-44b1-8eaf-c01378009cd3 /storage/btrfs btrfs 
noatime,compress-force=zlib,space_cache,inode_cache 0 0
UUID=7f7be913-e359-400f-8bdb-7ef48aad3f03 /storage/btrfs2 btrfs 
noatime,compress-force=zlib,space_cache,inode_cache 0 0


The funny thing is that if i run btrfsck for one second on the first 
filesystem and then kill it with ctrl-c, then both filesystems can be 
mounted without any problems!

I have this problem for many months, probably for all 3.x kernels and 
maybe a bit older, all git btrfs tools since at least late last year.

  [root@linuxserver ~/btrfs-progs]# btrfs fi show /dev/sdb
Label: none  uuid: 7f7be913-e359-400f-8bdb-7ef48aad3f03
         Total devices 2 FS bytes used 1.54TB
         devid    1 size 1.82TB used 1.04TB path /dev/sda
         devid    2 size 1.82TB used 1.04TB path /dev/sdb

Btrfs Btrfs v0.19
  [root@linuxserver ~/btrfs-progs]# btrfs fi show /dev/sdf
Label: none  uuid: 1e7c18a4-02d6-44b1-8eaf-c01378009cd3
         Total devices 4 FS bytes used 4.33TB
         devid    5 size 1.82TB used 1.82TB path /dev/sdg
         devid    4 size 1.82TB used 1.82TB path /dev/sdc
         devid    3 size 1.82TB used 1.79TB path /dev/sdf
         devid    1 size 1.82TB used 1.82TB path /dev/sdd

Btrfs Btrfs v0.19
