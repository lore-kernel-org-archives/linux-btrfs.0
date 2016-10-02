Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36482 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750856AbcJBSR6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Oct 2016 14:17:58 -0400
Received: by mail-wm0-f68.google.com with SMTP id b184so11346196wma.3
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 11:17:58 -0700 (PDT)
Received: from localhost (host86-130-216-236.range86-130.btcentralplus.com. [86.130.216.236])
        by smtp.gmail.com with ESMTPSA id o196sm14106313wmg.8.2016.10.02.11.17.55
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 02 Oct 2016 11:17:55 -0700 (PDT)
Date: Sun, 2 Oct 2016 19:17:54 +0100
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Unable to open ctree
Message-ID: <20161002181754.wxved3j66dzrvfoc@tiamat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I'm a everyday user of btrfs. The system is a laptop with UEFI partition
and the following partition scheme:
# blkid 
/dev/sda1: UUID="." TYPE="vfat" PARTUUID="."
/dev/sda2: UUID="." TYPE="swap" PARTUUID="."
/dev/sda3: LABEL="root" UUID="." UUID_SUB="." TYPE="btrfs" PARTUUID="."
/dev/sda4: LABEL="home" UUID="." UUID_SUB="." TYPE="btrfs" PARTUUID="."

The partitions are surely not out of space:
# btrfs fi show
Label: 'root'  uuid: c7a773e0-e2be-4482-acdc-dbfa4c13c98c
    	Total devices 1 FS bytes used 9.98GiB
		devid    1 size 74.52GiB used 13.03GiB path /dev/sda3

Label: 'home'  uuid: 63f5219f-399a-4cce-be86-a8c7400853bd
		Total devices 1 FS bytes used 17.65GiB
		devid    1 size 188.87GiB used 25.03GiB path /dev/sda4

When the "root" partition is to be mounted during boot up it fails and I
am dropped on an emergency shell. The dmesg output is:

[  716.434137] BTRFS info (device sda3): disk space caching is enabled
[  716.434147] BTRFS info (device sda3): has skinny extents
[  716.436538] BTRFS info (device sda3): bdev /dev/sda3 errs: wr 0, rd
0, flush 0, corrupt 32, gen 0
[  716.439182] BTRFS warning (device sda3): sda3 checksum verify failed
on 11185160192 wanted 2670F0AB found FDB2F5BD level 0
[  716.439195] BTRFS error (device sda3): failed to read block groups:
-5
[  716.481402] BTRFS: open_ctree failed

The btrfs check /dev/sdc3 output is https://ptpb.pw/nc1d

dmesg output: https://ptpb.pw/G0Wv

The kernel I was running is right before this failure was 4.7.5 (with ck
patchset custom compiled) and there was not any kernel panics - just a
restart. Currently runnign through latest Archlinux liveCD

# uname -a
Linux archiso 4.7.5-1-ARCH #1 SMP PREEMPT Sat Sep 24 13:04:22 CEST 2016
x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.7.3

As this is the root partition I am not able to access it without a
liveCD. Can I perform any kind of steps to recaclulate checksums?

Thanks

-- 
Leonidas Spyropoulos

A: Because it messes up the order in which people normally read text.
Q: Why is it such a bad thing?
A: Top-posting.
Q: What is the most annoying thing on usenet and in e-mail?

