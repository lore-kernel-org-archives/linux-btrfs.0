From: James <torpesco@gmail.com>
Subject: Single drive volume + second drive -> RAID1?
Date: Mon, 23 Jan 2012 00:36:15 -0800
Message-ID: <CAEPoJ-1PXu9Pt9E1EEudJ5NN-RunT4POJtjzo=BVRiOn_F97ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I had one drive of a two-drive volume fail recently. Discovered what I
thought was RAID1 was actually RAID0 data with RAID1 metadata... but
fortunately the drive that died went slowly and I got my data off.

Anyway...

I bought one drive to replace the failing one. I'd like to end up with
RAID1. Back in July I set up a server for my brother and (unless I'm
forgetting a different path we ended up taking), I thought what I did
was:
 1. mkfs.btrfs on a single drive but tell it to use RAID1
 2. copy data on
 3. once the second drive for the RAID1 was available, add it to the
volume and rebalance (or something)

Since I had to get all the data off the volume with the failing drive,
I tried doing the above. All my data is on the new drive, but when I
add the other good drive to the volume, I just see it as a volume
containing two drives, not as RAID1.

Is there any way for me to get my current single disk volume into a
RAID1 volume by adding the other drive? I didn't save the reference,
but I thought I read something last night about being able to create a
"RAID1" volume with a single disk as having been a bug.

Thanks,
James.
