Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:34968 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbeHXQ7N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 12:59:13 -0400
Received: by mail-it0-f45.google.com with SMTP id 139-v6so1961477itf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2018 06:24:33 -0700 (PDT)
MIME-Version: 1.0
From: Menion <menion@gmail.com>
Date: Fri, 24 Aug 2018 15:24:20 +0200
Message-ID: <CAJVZm6dwNq18gykoVJBTLDf1WVsf2E1s1rpEp32HLXcOvA_+_A@mail.gmail.com>
Subject: rm or mv of directories (with subdirectories) hang with no message
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all
I have been experiencing an issue that I believe can be quite easily
reproduced attempting to recursively rm (mv is also affected) a
directory containing some subdirectories and files.
The problem affects my system that run root BTRFS filesystem created
by Ubuntu server installer (so kernel 4.4.0 at the time of creation)
on an eMMC, and a storage RAID5 array (5x8Tb HDD) created with kernel
4.15.x
I have been observing this issue since kernel 4.15, now I run kernel
4.17.3 and hit the issue again
The issue pops up when you try to "rm -Rf" a directory that contains
some subdirectories with some files inside.
I have intentionally written "some" because I don't know how many
subdirectories are necessary to reproduce the problem, but don't
expect to have the problem with a couple of subdir and few dozen of
files inside.
You launch "rm -Rf" and after an insane amount of time (half an hour
or more) the process is still running. You can CTRL+Z and kill it. If
you start to "rm -Rf" one by one the subdirectories, starting from
inner one, you can remove all the way to the upper directory, meaning
that the filesystem is ok.
There is absolutely ZERO log in dmesg, meaning no log from neither
BTRFS, SCSI or USB (in my case the RAID5 array it is an external USB
enclosure).
Note that it affect a single BTRFS on eMMC and a BTRFS RAID5 on USB
enclosure, so it really seem being BTRFS releated.
Step to reproduce (as it happened just right now):
Clone CoreELEC (multimedia JeOS) and compile:

git clone https://github.com/CoreELEC/CoreELEC.git
cd CoreELEC
git checkout tags/8.95.0
PROJECT=Amlogic DEVICE=S912 ARCH=arm make image

Leave it running for 2-3 hours so it can download and decompress
packages, increasing the level of subdirectories and files. Then kill
the compilation and try to remove the root directory: "rm -Rf
CoreELEC" (or mv it to another medium)
Result: it should takes some minutes, but after half an hour rm
process is still running.
Bye
