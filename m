Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f45.google.com ([209.85.212.45]:56917 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3JDIvJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Oct 2013 04:51:09 -0400
Received: by mail-vb0-f45.google.com with SMTP id e15so2091458vbg.4
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Oct 2013 01:51:08 -0700 (PDT)
MIME-Version: 1.0
From: Daniele Buono <thegood85@gmail.com>
Date: Fri, 4 Oct 2013 10:50:38 +0200
Message-ID: <CAJp-iiDf1whohpH1yf79d46NGvLTysP=KK6R3PVCR+7jMmkYaw@mail.gmail.com>
Subject: Recovering btrfs fs after "failed to read chunk root"
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I'm writing my (dis)adventure with btrfs here hoping to help the
developers or someone with similar problems.

I had a btrfs filesystem at work, using two 1TB disks, raid1 for both
data and metadata.

A week ago one of the two disks start having hundreds of relocated
sectors, so I decide to change it.
I remove the failing disk, mount with -o degraded and every works fine.
The day later I decide to use an usb drive to temporarily work as the
secondary copy.
Now the usb drive had some GB less then the old drive, so I add the
drive plus a small partition of another disk to avoid space problems
on the rebalancing.

I start the "btrfs device delete missing" and btrfs starts rebalancing
the drive. After a while I get

Sep 30 11:35:31 tambura kernel: [264654.275303] kernel BUG at
fs/btrfs/relocation.c:1055!

The complete error is here http://paste.fedoraproject.org/44139/

I look around and find that the problem has been fixed with the latest
linux kernel (however, not yet marked as stable). Having a fedora 19,
I manage to install kernel 3.12.0-0.rc2.git3.1.fc21.x86_64 from
rawhide, reboot and try again.

The rebalancing works well this time but is, as expected, very slow
(about 50GB in half a day). I return home and leave the pc runnung all
the night. The morning I find this:

Sep 30 23:11:53 tambura kernel: [37787.652143] BTRFS error (device
sdc2) in btrfs_create_pending_block_groups:8516: errno=-5 IO failure
Sep 30 23:11:53 tambura kernel: [37787.652145] BTRFS info (device
sdc2): forced readonly

the whole messages.log is here: http://paste.fedoraproject.org/44143/24287138/

N.B: sdc2 is the partition of the new drive that, however, has no
relocated nor pending sectors according to SMART data.

I do not panic (the drive seems readable and the fs mounted) and
decide to reboot the pc.
It hangs during the reboot so I turn it off after some minutes and restart.

Now it comes the fun:
btrfs: allowing degraded mounts
btrfs: disk space caching is enabled
btrfs: failed to read chunk root on sdb1
btrfs: open_ctree failed

>From this point I found no way of accessing my data. Nothing works,
including mount -o recovery and even btrfs-restore.

I find this discussion:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg25990.html

So I tried several times with btrfs chunk-recover:

If I keep all the disks, it goes like this:
[root@tambura btrfs-progs]# ./btrfs chunk-recover -v /dev/sdb1 > log_2.txt
All Devices:
        Device: id = 3, name = /dev/sdc2
        Device: id = 4, name = /dev/sda2
        Device: id = 1, name = /dev/sdb1
btrfs: cmds-chunk.c:125: process_extent_buffer: Assertion
`!(exist->nmirrors >= 2)' failed.

So I did try removing sdc2 (that is the drive where btrfs was
replicating data) and the chunk-recover works fine, but end like this:

Fail to recover the chunk tree.

The complete output is here: http://cwillu.com:8080/131.114.3.240/4

After some digging (by adding printf on errors) I found that the
problem lies in the function

"build_device_maps_by_chunk_records"

But I can't tell you more for the moment.


Now, the good part of the story is that the disk with relocated
sectors was not too bad after all, and I managed to recover all the
lost files from there; so, I'm not really interested in recovering
this filesystem.

However, I'm writing this hoping that it may help the developers in
some way, perhaps improving the chunk-recover function.
If usefuly, I can "offer" my filesystem for testing new versions of
the chunk-recover, or any other tool.


Daniele Buono
PhD Student in Computer Science
Department of Computer Science, University of Pisa
