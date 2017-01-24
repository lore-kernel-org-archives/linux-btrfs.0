Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from alt42.smtp-out.videotron.ca ([23.233.128.29]:60723 "EHLO
        alt42.smtp-out.videotron.ca" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750707AbdAXTM3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 14:12:29 -0500
Received: from toile.deragon.biz (server1.deragon.biz [192.168.1.3])
        by smtp.localdomain (Postfix) with ESMTP id DB22618044F
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 13:57:24 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 24 Jan 2017 13:57:24 -0500
From: Hans Deragon <hans@deragon.biz>
To: linux-btrfs@vger.kernel.org
Subject: raid1:  cannot add disk to replace faulty because can only mount fs
 as read-only.
Message-ID: <54678ac94c95687e00485d41fa5b5bc9@server1.deragon.biz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings,


Warning: Btrfs user here; no knowledge of the inside working of btrfs. 
If I am in the wrong mailing list, please redirect me and accept my 
apologies.

At home, lacking of disks and free SATA ports, I created a raid1 btrfs 
filesystem by converting an existing single btrfs instance into a 
degraded raid1, then added the other driver. The exact commands I used 
have been lost.

Worked well, until one of my drive died. Total death; the OS does not 
detect it anymore. I bought another drive, but alas, I cannot add it:

# btrfs replace start -B 2 /dev/sdd /mnt/brtfs-raid1-b
ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt/brtfs-raid1-b": 
Read-only file system

Here is the command I used to mount it:

mount -t btrfs -o ro,degraded,recovery,nosuid,nodev,nofail,x-gvfs-show 
/dev/disk/by-uuid/975bdbb3-9a9c-4a72-ad67-6cda545fda5e 
/mnt/brtfs-raid1-b

If I remove 'ro' from the option, I cannot get the filesystem mounted 
because of the following error:

BTRFS: missing devices(1) exceeds the limit(0), writeable mount is not 
allowed

So I am stuck. I can only mount the filesystem as read-only, which 
prevents me to add a disk.

It seams related to bug: 
https://bugzilla.kernel.org/show_bug.cgi?id=60594

I am using Ubuntu 16.04 LTS with kernel 4.4.0-59-generic. Is there any 
hope to add a disk? Else, can I recreate a raid1 with only one disk and 
add another, but never suffer from the same problem again? I did not 
lost any data, but I do have some serious downtime because of this. I 
wish that if a drive fail, the btrfs filesystem still mounts rw and 
leave the OS running, but warns the user of a failing disk and easily 
allow the addition of a new drive to reintroduce redundancy. However, 
this scenarios seams impossible with the current state of affair. Am I 
right?


Best regards and thank you for your contribution to the open source 
movement,
Hans Deragon
