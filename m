Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35435 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbbCRUnQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 16:43:16 -0400
Received: by pabyw6 with SMTP id yw6so53025967pab.2
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 13:43:15 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: K Richard Pixley <rpixley@graphitesystems.com>
Subject: syntax for deleting subvolumes?
message-id: <5509E34F.6010504@graphitesystems.com>
Date: Wed, 18 Mar 2015 13:42:55 -0700
mime-version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm having trouble deleting a subvolume.

[root@new-alfred ~]# uname -a
Linux new-alfred.corp.graphitesystems.com 3.10.0-123.el7.x86_64 #1 SMP 
Mon May 5 11:16:57 EDT 2014 x86_64 x86_64 x86_64 GNU/Linux
[root@new-alfred ~]#   btrfs --version
Btrfs v3.16.2
[root@new-alfred ~]#   btrfs fi show
Label: 'rhel_bark'  uuid: d3c6c783-c190-4675-99f2-b83f3c462656
         Total devices 2 FS bytes used 14.25GiB
         devid    1 size 461.38GiB used 7.03GiB path /dev/sda2
         devid    2 size 465.76GiB used 12.01GiB path /dev/sdb1

Btrfs v3.16.2
[root@new-alfred ~]#   btrfs fi df /
Data, single: total=15.01GiB, used=13.19GiB
System, RAID1: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=2.00GiB, used=1.07GiB
Metadata, single: total=8.00MiB, used=0.00
[root@new-alfred ~]# btrfs subvolume list /
ID 257 gen 1483 top level 5 path root
ID 258 gen 1466 top level 5 path home
[root@new-alfred ~]# btrfs subvolume delete home
Transaction commit: none (default)
ERROR: error accessing 'home'
[root@new-alfred ~]# btrfs subvolume delete /home
Transaction commit: none (default)
ERROR: error accessing '/home'

What format do I need to use to delete the "home" subvolume?

--rich
