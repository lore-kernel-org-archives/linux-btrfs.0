From: Maria <maria@ponstudios.se>
Subject: Re: btrfs using inside xen domU and online resizing
Date: Thu, 06 Jan 2011 18:26:48 +0100
Message-ID: <1294334808.9526.95.camel@mainframe>
References: <1294276200.26566.14.camel@mobile>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: v.tolstov@selfip.ru
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294276200.26566.14.camel@mobile>
List-ID: <linux-btrfs.vger.kernel.org>

tor 2011-01-06 klockan 04:10 +0300 skrev Vasiliy G Tolstov:
> Hello. I have two questions:
> 
> 1) When btrfs can be used in systems, that can be rebooted unexpectedly?
> btrfs fsck is ready to use? does after power failure or hard reboot file
> system can be damaged and can't be corrected?
If you turn of the write-cache of the underlying disks, btrfs should
survive it. I have btrfs on top of dm-crypt and no write-cache, and it
has survived all crashes so far. But you never know, so I backupp
regularly. Fsck is not ready yet.


> 2) When i use xen domU virtual machine a can dynamically change capacity
> of block device (/dev/xvda for example) it can be grows and shrinks.  Is
> that possible to use one btrfs file system on all device without
> partition table ? In current implementation (i'm use ext3). After block
> device change it size, i need to recreate partition table and do
> resize2fs.  But in case of root fs i need reboot to update partition
> table, because file system is in use. If linux can boot from plain btrfs
> device without partition table , as i think - i can resize block device
> and do mount -o remount,maxsize /dev/xvda and btrfs resized
> automatic... 
> Is that possible?
Why not use LVM?
If you do not have a partition table (or only one partition) you can
only have one file system on the disk, so why not use the entire disk in
the first place?

// Maria

> Thank You for all suggestions and answers.


