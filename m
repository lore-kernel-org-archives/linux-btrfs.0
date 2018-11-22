Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C2BC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 12:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D31120684
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 12:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="mIw4CPZq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D31120684
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=virtall.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390956AbeKVXKe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 18:10:34 -0500
Received: from mail.virtall.com ([46.4.129.203]:47150 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729105AbeKVXKe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 18:10:34 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id DB6E73699C71
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 12:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1542889880;
        bh=Pw1ZjUE1Y6Okl8vLOKxyIjuPx5vOrn23693C+bOeiR0=;
        h=Date:From:To:Subject;
        b=mIw4CPZqSSsZUG9/hKkxylboGBI3+1N75XqQEQU/io7K0MPS0GZ645BZY5Z0P9Uvu
         q5Xcv3KbO2dObrV/f1Z0WL444LsaOGR67YLO9wUynIntlUK4vhS/ddpWWv6oIkdtxe
         POiGpICfHiab5zW1l9IJTgvCwiU9IDAt97lyrMrvCA5931zSoo9qmL12EQZ6re7Kzl
         bPb5fiViw6an31ldXkNUyoZP/V5HsD8RwwSbIRwsVaHyEQb3aw3hwprcF5KBkCM/01
         2SGoG368WM4WMlxVlGJ14ZGmJGRFym4TrVlzaBeeHURUAfAiIXvKvxVK2zmLiVaEqv
         pI8LvFff+Ycww==
X-Fuglu-Suspect: 793105ca82cf45e09c99abc1a35a45af
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 12:31:17 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 22 Nov 2018 21:31:17 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: btrfs-cleaner 100% busy on an idle filesystem with 4.19.3
Message-ID: <ca2de2a36290496ccf41b6ed23c799d8@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Yet another system upgraded to 4.19 and showing strange issues.

btrfs-cleaner is showing as ~90-100% busy in iotop:

    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
   1340 be/4 root        0.00 B/s    0.00 B/s  0.00 % 92.88 % 
[btrfs-cleaner]


Note disk read, disk write are 0.00 B/s.


iostat -mx 1 shows all disks are ~100% busy, yet there are 0 reads and 0 
writes to them:

Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  
%rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sda              0.00    0.00      0.00      0.00     0.00     0.00   
0.00   0.00    0.00    0.00   0.91     0.00     0.00   0.00  90.80
sdb              0.00    0.00      0.00      0.00     0.00     0.00   
0.00   0.00    0.00    0.00   1.00     0.00     0.00   0.00 100.00
sdc              0.00    0.00      0.00      0.00     0.00     0.00   
0.00   0.00    0.00    0.00   1.00     0.00     0.00   0.00 100.00



btrfs-cleaner persists 100% busy after reboots. The system is generally 
not very responsive.



# echo w > /proc/sysrq-trigger

# dmesg -c
[  931.585611] sysrq: SysRq : Show Blocked State
[  931.585715]   task                        PC stack   pid father
[  931.590168] btrfs-cleaner   D    0  1340      2 0x80000000
[  931.590175] Call Trace:
[  931.590190]  __schedule+0x29e/0x840
[  931.590195]  schedule+0x2c/0x80
[  931.590199]  schedule_timeout+0x258/0x360
[  931.590204]  io_schedule_timeout+0x1e/0x50
[  931.590208]  wait_for_completion_io+0xb7/0x140
[  931.590214]  ? wake_up_q+0x80/0x80
[  931.590219]  submit_bio_wait+0x61/0x90
[  931.590225]  blkdev_issue_discard+0x7a/0xd0
[  931.590266]  btrfs_issue_discard+0x123/0x160 [btrfs]
[  931.590299]  btrfs_discard_extent+0xd8/0x160 [btrfs]
[  931.590335]  btrfs_finish_extent_commit+0xe2/0x240 [btrfs]
[  931.590382]  btrfs_commit_transaction+0x573/0x840 [btrfs]
[  931.590415]  ? btrfs_block_rsv_check+0x25/0x70 [btrfs]
[  931.590456]  __btrfs_end_transaction+0x2be/0x2d0 [btrfs]
[  931.590493]  btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
[  931.590530]  btrfs_drop_snapshot+0x489/0x800 [btrfs]
[  931.590567]  btrfs_clean_one_deleted_snapshot+0xbb/0xf0 [btrfs]
[  931.590607]  cleaner_kthread+0x136/0x160 [btrfs]
[  931.590612]  kthread+0x120/0x140
[  931.590646]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
[  931.590658]  ? kthread_bind+0x40/0x40
[  931.590661]  ret_from_fork+0x22/0x40




After rebooting to 4.19.3, I've started seeing read errors. There were 
no errors with a previous kernel (4.17.14); disks are healthy according 
to SMART; no errors reported when we read the whole surface with dd.

# grep -i btrfs.*corrected /var/log/syslog|wc -l
156

Things like:

Nov 22 12:17:43 lxd05 kernel: [  711.538836] BTRFS info (device sda2): 
read error corrected: ino 0 off 3739083145216 (dev /dev/sdc2 sector 
101088384)
Nov 22 12:17:43 lxd05 kernel: [  711.538905] BTRFS info (device sda2): 
read error corrected: ino 0 off 3739083149312 (dev /dev/sdc2 sector 
101088392)
Nov 22 12:17:43 lxd05 kernel: [  711.538958] BTRFS info (device sda2): 
read error corrected: ino 0 off 3739083153408 (dev /dev/sdc2 sector 
101088400)
Nov 22 12:17:43 lxd05 kernel: [  711.539006] BTRFS info (device sda2): 
read error corrected: ino 0 off 3739083157504 (dev /dev/sdc2 sector 
101088408)


Yet - 0 errors, according to stats, not sure if it's expected or not:

# btrfs device stats /data/lxd
[/dev/sda2].write_io_errs    0
[/dev/sda2].read_io_errs     0
[/dev/sda2].flush_io_errs    0
[/dev/sda2].corruption_errs  0
[/dev/sda2].generation_errs  0
[/dev/sdb2].write_io_errs    0
[/dev/sdb2].read_io_errs     0
[/dev/sdb2].flush_io_errs    0
[/dev/sdb2].corruption_errs  0
[/dev/sdb2].generation_errs  0
[/dev/sdc2].write_io_errs    0
[/dev/sdc2].read_io_errs     0
[/dev/sdc2].flush_io_errs    0
[/dev/sdc2].corruption_errs  0
[/dev/sdc2].generation_errs  0


# btrfs fi usage /data/lxd
Overall:
     Device size:                   5.18TiB
     Device allocated:              2.36TiB
     Device unallocated:            2.83TiB
     Device missing:                  0.00B
     Used:                          1.93TiB
     Free (estimated):              1.62TiB      (min: 1.62TiB)
     Data ratio:                       2.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:1.17TiB, Used:983.87GiB
    /dev/sda2     796.00GiB
    /dev/sdb2     799.00GiB
    /dev/sdc2     797.00GiB

Metadata,RAID1: Size:10.00GiB, Used:4.09GiB
    /dev/sda2       8.00GiB
    /dev/sdb2       5.00GiB
    /dev/sdc2       7.00GiB

System,RAID1: Size:64.00MiB, Used:224.00KiB
    /dev/sda2      32.00MiB
    /dev/sdb2      64.00MiB
    /dev/sdc2      32.00MiB

Unallocated:
    /dev/sda2     964.46GiB
    /dev/sdb2     964.43GiB
    /dev/sdc2     964.46GiB


# btrfs fi df /data/lxd
Data, RAID1: total=1.17TiB, used=983.04GiB
System, RAID1: total=64.00MiB, used=224.00KiB
Metadata, RAID1: total=10.00GiB, used=4.08GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


# btrfs fi show /data/lxd
Label: 'lxd5'  uuid: 2b77b498-a644-430b-9dd9-2ad3d381448a
         Total devices 3 FS bytes used 987.12GiB
         devid    1 size 1.73TiB used 804.03GiB path /dev/sda2
         devid    2 size 1.73TiB used 804.06GiB path /dev/sdb2
         devid    3 size 1.73TiB used 804.03GiB path /dev/sdc2


Tomasz Chmielewski
https://lxadm.com
