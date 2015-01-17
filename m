Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:41640 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbbAQVpD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Jan 2015 16:45:03 -0500
Received: by mail-qc0-f181.google.com with SMTP id l6so12999605qcy.12
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Jan 2015 13:45:01 -0800 (PST)
Received: from [192.168.11.50] ([98.113.246.12])
        by mx.google.com with ESMTPSA id i51sm7873548qgf.37.2015.01.17.13.45.01
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Jan 2015 13:45:01 -0800 (PST)
Message-ID: <54BAD7DC.2020302@gmail.com>
Date: Sat, 17 Jan 2015 16:45:00 -0500
From: Elliot Wolk <elliot.wolk@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: move subvolume to directory fails
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

renaming read-only subvolumes works fine, as long as you dont move them 
to a new directory.
create a ro snapshot, and mv it to a subdir or a parent directory. it 
fails with 'Read-only file system'. no nested-subvolumes involved, just 
the base and the single snapshot.
is this a bug? is this by design? i cant find any documentation about it 
or any bug reports. all i see is the same advice 'just use mv to rename 
subvols', 'subvols are basically directories', etc.

this makes re-organizing subvolumes difficult, especially if you 
consider send|receive which cannot be snapshotted without breaking the 
parent ids. {for normal subvols, making a snapshot and deleting the old 
is a sufficient workaround}

root:~$ uname -r
3.18-0.towo-siduction-amd64
root:~$ mkfs.btrfs /dev/sdc1 -f
Btrfs v3.17
See http://btrfs.wiki.kernel.org for more information.

Turning ON incompat feature 'extref': increased hardlink limit per file 
to 65536
fs created label (null) on /dev/sdc1
     nodesize 16384 leafsize 16384 sectorsize 4096 size 15.01GiB
root:~$ mkdir test
root:~$ mount -t btrfs /dev/sdc1 test
root:~$ cd test
root:~/test$ touch content
root:~/test$
root:~/test$ btrfs subvol snapshot -r ./ ro_snap
Create a readonly snapshot of './' in './ro_snap'
root:~/test$ mv ro_snap/ ro_snap_applesauce
root:~/test$ mv ro_snap_applesauce/ ro_snap
root:~/test$
root:~/test$ mkdir snapshot_container
root:~/test$ mv ro_snap/ snapshot_container
mv: cannot move ‘ro_snap/’ to ‘snapshot_container/ro_snap’: Read-only 
file system
root:~/test$
root:~/test$ btrfs subvol snapshot -r ./ snapshot_container/ro_snap2
Create a readonly snapshot of './' in 'snapshot_container/ro_snap2'
root:~/test$ mv snapshot_container/ro_snap2/ 
snapshot_container/ro_snap2_applesauce
root:~/test$ mv snapshot_container/ro_snap2_applesauce/ 
snapshot_container/ro_snap2
root:~/test$
root:~/test$ mv snapshot_container/ro_snap2/ .
mv: cannot move ‘snapshot_container/ro_snap2/’ to ‘./ro_snap2’: 
Read-only file system
root:~/test$
root:~/test$ mv snapshot_container/ snapshot_container_applesauce
root:~/test$ mv snapshot_container_applesauce/ro_snap2/ 
snapshot_container_applesauce/ro_snap2_applesauce
root:~/test$ mv snapshot_container_applesauce/ro_snap2_applesauce/ 
snapshot_container_applesauce/ro_snap2
root:~/test$ mv snapshot_container_applesauce/ro_snap2/ .
mv: cannot move ‘snapshot_container_applesauce/ro_snap2/’ to 
‘./ro_snap2’: Read-only file system

