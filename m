Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62354 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3GNODz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jul 2013 10:03:55 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so10013610pdj.14
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 07:03:54 -0700 (PDT)
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Need help mounting broken btrfs Fedora 19
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CACvcmCCQKO6cx+vV0pb-GbiFBGDr2aq6q=Yt5StsDSkq91W9Hw@mail.gmail.com>
Date: Sun, 14 Jul 2013 22:03:48 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <7D6F9B3C-CC33-4F9A-86D7-74C3AFEEF48A@gmail.com>
References: <CACvcmCCQKO6cx+vV0pb-GbiFBGDr2aq6q=Yt5StsDSkq91W9Hw@mail.gmail.com>
To: Dave Barnum <dave@thebarnums.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

You call pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

Miao implement chunk tree recover function, you can try it with like.
	btrfs  chunk-recover /dev
Maybe this can help you.

Thanks,
Wang
> I need some help as may have lost some number of files on a btrfs raid
> 1 volume. I'm not quite sure what happend which, I know, only adds to
> the problem.
> 
> On my computer #1 I had only a month or so ago installed Fedora 19
> Beta and at the time of install chose BTRFS, raid 1. Recently one of
> the drives started complaining that it was going to die. WIthout
> taking it out of the array (perhaps I should have done that) I turned
> off the system and swapped the drive with another. From then on I lost
> my ability to boot the system. I could not get anything to work with
> the new hard drive. Then I put the old hard drive back in so that I
> could try to boot again. Still nothing. At one point I think I was
> able to see grub - but at this point, I'm not. I just get boot disk
> failure.
> 
> Further more on the failing drive, drive A, I can still see the
> patitions but I cannot mount it on another system. On drive B (the
> other half of the mirror) I do not see any partitions. I tried copying
> the partition structure using sfdisk from A to B but that probably was
> not smart.
> 
> I plugged drive A into computer #2 using a live Fedora and Ubuntu CD
> to try to mount the volume. However in both distributions I am unable
> to mount the volume. I've tried mounting using -o degraded but I still
> get the same error. The error I'm seeing when I try to mount the
> filesystem goes like this:
> 
> Quote:
> [10792.307425] device label fedora_ison devid 2 transid 48720 /dev/sdc2
> [10792.308202] btrfs: allowing degraded mounts
> [10792.308206] btrfs: disk space caching is enabled
> [10792.308599] btrfs: failed to read chunk root on sdc2
> [10792.308799] btrfs warning page private not zero on page 20979712
> [10792.320146] btrfs: open_ctree failed
> 
> I believe the superblock may be in tact since when i turn the command
> ./btrfs-show-super /dev/sdc2 I get:
> 
> Quote:
> root@ubuntu:/downloads/btrfs-progs# ./btrfs-show-super /dev/sdc2
> superblock: bytenr=65536, device=/dev/sdc2
> ---------------------------------------------------------
> csum 0xfc19c468 [match]
> bytenr 65536
> flags 0x1
> magic _BHRfS_M [match]
> fsid cbbf7d4c-f7a0-43ff-aed5-77b347d6ff25
> label fedora_ison
> generation 48720
> root 1105526784
> sys_array_size 226
> chunk_root_generation 46504
> root_level 1
> chunk_root 20979712
> chunk_root_level 1
> log_root 0
> log_root_transid 0
> log_root_level 0
> total_bytes 2988521291776
> bytes_used 598216536064
> sectorsize 4096
> nodesize 4096
> leafsize 4096
> stripesize 4096
> root_dir 6
> num_devices 2
> compat_flags 0x0
> compat_ro_flags 0x0
> incompat_flags 0x1
> csum_type 0
> csum_size 4
> cache_generation 48720
> dev_item.uuid 5f61edaa-7f12-4ec5-a024-02f7797e1400
> dev_item.fsid cbbf7d4c-f7a0-43ff-aed5-77b347d6ff25 [match]
> dev_item.type 0
> dev_item.total_bytes 1494260645888
> dev_item.bytes_used 482110078976
> dev_item.io_align 4096
> dev_item.io_width 4096
> dev_item.sector_size 4096
> dev_item.devid 2
> dev_item.dev_group 0
> dev_item.seek_speed 0
> dev_item.bandwidth 0
> dev_item.generation 0
> 
> Could someone help me troubleshoot why I can't mount my volume? I
> would REALLY appreciate it! Perhaps there is a way to repair my broken
> tree structure?
> 
> Thank You!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

