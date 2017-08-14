Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33668 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750876AbdHNNnh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 09:43:37 -0400
Received: by mail-io0-f169.google.com with SMTP id j32so38593143iod.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 06:43:37 -0700 (PDT)
Subject: Re: Building a BTRFS test machine
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>, linux-btrfs@vger.kernel.org
References: <CAN4oSBdO8GfBQA1CrLVa1atA+QJquCy63KBqOHhh49Uz=1sgjQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a4502791-fba5-1668-757f-e827ef1229e5@gmail.com>
Date: Mon, 14 Aug 2017 09:43:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAN4oSBdO8GfBQA1CrLVa1atA+QJquCy63KBqOHhh49Uz=1sgjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-13 21:01, Cerem Cem ASLAN wrote:
> Would that be useful to build a BTRFS test machine, which will perform
> both software tests (btrfs send | btrfs receive, read/write random
> data etc.) and hardware tests, such as abrupt power off test, abruptly
> removing a raid-X disk physically, etc.
In general, yes.  There are already a couple of people (at least myself 
and Adam Borowski) who pick out patches we have interest in from the 
mailing list and test them in VM's, but having more people involved in 
testing is never a bad thing (cross verification of the testing is very 
helpful, because it can help identify when one of the test systems is 
suspect).

Based on my own experience, if you do go with a VM, I've found that QEMU 
with LVM as the backing storage is probably one of the simplest setups 
to automate.  You can easily script things like adding and removing 
disks, and using LVM for storage means you can add and remove (and 
snapshot) backend devices as needed.
> 
> If it would be useful, what tests should it cover?
Qu covered this well, so there's not much for me to add here.

My own testing is pretty consistent with what Qu mentioned, plus a few 
special cases I've set up myself that I still need to get pushed 
upstream somewhere.  For reference, the big ones I test that aren't 
(AFAIK at least) in any of the standard test sets are:

* Large scale bulk parallel creation and removal of subvolumes.  I've 
got a script that creates a 16 subvolumes, and then in parallel 
snapshots them 65536 times each, and then calls `btrfs subvolume delete` 
on all 1048576 subvolumes simultaneously.  This is _really_ good at 
showing performance differences in handling of snapshots and subvolumes.

* Large scale bulk reflink creation and deletion.  Similar to the above, 
but using a 1GB file and the clone ioctl to create a similar number of 
reflinked files.

* Scaling performance of directories with very large numbers of entries. 
  In essence, I create directories with power of 2 numbers of files 
starting at 512 and ending with 1048576, with random names and random 
metadata, and see how long `ls -als` takes on the directory.  This came 
about because of performance issues seen on a file server where I work 
with a directory that has well over four thousand files in it that got 
noticeably worse performance with BTRFS than with ext4.

* Kernel handling of mixed profile filesystems.  I've got a script that 
generates a BTRFS filesystem with a data, metadata, and system chunk of 
each possible profile (single, dup, raid0, raid1, raid10, raid5, and 
raid6), and then makes sure the kernel can mount this and that balances 
to each profile work correctly.
