Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33263 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdDNELM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Apr 2017 00:11:12 -0400
Received: by mail-pg0-f53.google.com with SMTP id x125so39148803pgb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Apr 2017 21:11:11 -0700 (PDT)
MIME-Version: 1.0
From: Alexandru Guzu <alexguzu@gmail.com>
Date: Fri, 14 Apr 2017 00:11:10 -0400
Message-ID: <CAPktuGu9HqL=0VS+apM9r6CSRbxBcZzX5=HmF1K_51wYHyRbiw@mail.gmail.com>
Subject: Remounting read-write after error is not allowed
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am not sure how to better summarize this but I'll give a more
detailed description.

I am using btrfs tools v4.4, I setup up a btrfs partition on an
external USB2 drive and I started to play with it.
The partition was about HALF full when I decided to run duperemove on
it. This took a while but it eventually hung.

the logs around the hung say something like:

    usb 1-1.1: USB disconnect, device number 3
    usb 1-1.5: USB disconnect, device number 5
    ...
    BTRFS error (device sdg2): bdev /dev/sdg2 errs: wr 0, rd 1, flush
0, corrupt 0, gen 0
    ...
    Call Trace:
    [<ffffffffc03d031f>] btrfs_ioctl+0x25bf/0x28b0 [btrfs]
    [<ffffffff814fbf53>] ? tty_insert_flip_string_fixed_flag+0x83/0xe0
    [<ffffffff810c3bd4>] ? __wake_up+0x44/0x50
    [<ffffffff814f0db1>] ? tty_write_unlock+0x31/0x40
    [<ffffffff814fae16>] ? tty_ldisc_deref+0x16/0x20
    [<ffffffff81222caf>] do_vfs_ioctl+0x29f/0x490
    [<ffffffff8120f099>] ? vfs_write+0x149/0x1a0
    [<ffffffff8120df8f>] ? do_sys_open+0x1bf/0x2a0
    [<ffffffff81222f19>] SyS_ioctl+0x79/0x90
    [<ffffffff8183c672>] entry_SYSCALL_64_fastpath+0x16/0x71
    ...
    usb-storage 1-1.5:1.0: USB Mass Storage device detected
    ...
    sd 7:0:0:0: [sdh] Attached SCSI disk
    EXT4-fs (sdh1): recovery complete
    EXT4-fs (sdh1): mounted filesystem with ordered data mode. Opts: (null)
    BTRFS error (device sdg2): bdev /dev/sdh2 errs: wr 0, rd 5, flush
0, corrupt 0, gen 0
    ...
    BTRFS warning (device sdg2): error -5 while searching for
dev_stats item for device /dev/sdh2
    BTRFS warning (device sdg2): Skipping commit of aborted transaction.
    ...
    BTRFS: error (device sdg2) in cleanup_transaction:1746: errno=-5 IO failure
    BTRFS info (device sdg2): forced readonly

More complete logs at:
pastebin.com/LqyWQamy

Basically the device can only be mounted as read-only, but no files
are accessible.

- Doing an `ls` on a folder gives "Input/output error".

- doing a `btrfs check` without --repair gives:

    Checking filesystem on /dev/sdh2
    UUID: 227fbb6c-ae72-4b81-8e65-942a0ddc6ef7
    checking extents
    checking free space cache
    checking fs roots
    checking csums
    checking root refs
    found 247566471406 bytes used err is 0
    total csum bytes: 241513756
    total tree bytes: 366084096
    total fs tree bytes: 90259456
    total extent tree bytes: 10010624
    btree space waste bytes: 35406538
    file data blocks allocated: 23837459185664
     referenced 252963553280

So I guess no errors.

I can only mount it as read-only, and when I do a SCRUB it finishes in
0 seconds saying it was ABORTED.

I have no issue accessing the other EXT4 partition or dd-ing the btrfs
partition to /dev/null, so I doubt it is a disk issue.

I have not tried btrfs-zero-log because I do not see those kernel errors.
All I see when I mount it is lots of messages such as:
bdev /dev/sdh2 errs: wr 20, rd 28049, flush 0, corrupt 0, gen 0

I have not tried btrfs check --repair because I do not fully
understand the output of btrfs check.

Now, I have backups of the data, but I was wondering if and how can
BTRFS recover from this type of failure that can be quite common
(pulled plug).

Thanks.
- Alex.
