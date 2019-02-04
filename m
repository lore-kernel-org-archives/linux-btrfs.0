Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D026C282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 11:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74C952082F
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 11:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfBDLym (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 06:54:42 -0500
Received: from rigel.uberspace.de ([95.143.172.238]:59810 "EHLO
        rigel.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbfBDLym (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 06:54:42 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2019 06:54:42 EST
Received: (qmail 6051 invoked from network); 4 Feb 2019 11:48:00 -0000
Received: from localhost (HELO webmail.rigel.uberspace.de) (127.0.0.1)
  by ::1 with SMTP; 4 Feb 2019 11:48:00 -0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 04 Feb 2019 12:47:59 +0100
From:   Moritz M <mailinglist@moritzmueller.ee>
To:     linux-btrfs@vger.kernel.org
Subject: Help needed, server is unresponsive after btrfs balance
Message-ID: <6c9257eb3b6451b67bd8b082e06a7735@moritzmueller.ee>
X-Sender: mailinglist@moritzmueller.ee
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I'm running a Ubuntu server with a btrfs RAID1 consisting of three HDDs.

I do balancing daily via

> btrfs balance start -dusage=50 -dlimit=2 -musage=50 -mlimit=4 /

It usually takes between 1 - 10 minutes.

But today the server was unresponsive (no ssh connect possible, no 
direct login via keyboard possible)  even after 7 hours.

I had a similar situation two weeks ago. I did not find anything and 
finally checked and repaired the filesystem with

> btrfs check --repair /dev/sda3

Which found some qgroup related problems:

> enabling repair mode
> Checking filesystem on /dev/sda3
> UUID: cf8c4bb2-6a75-4e1d-983c-19583a93a546
> No device size related problem found
> cache and super generation don't match, space cache will be invalidated
> Counts for qgroup id: 0/257 are different
> our:		referenced 127300112384 referenced compressed 127300112384
> disk:		referenced 18446743939800129536 referenced compressed 
> 18446743939800129536
> diff:		referenced 261209534464 referenced compressed 261209534464
> our:		exclusive 56360521728 exclusive compressed 56360521728
> disk:		exclusive 56360521728 exclusive compressed 56360521728
…
> Repair qgroup 0/257

Today I had to boot a Live system, mount the btrfs filessystem with
-o skip_balance and cancel the balancing there.

Mounting took ~30 mins and in journalctl of the Live system I found this

> Feb 04 09:42:28 ubuntu kernel: INFO: task btrfs-transacti:7527 blocked 
> for
> more than 120 seconds.
> Feb 04 09:42:28 ubuntu kernel:       Not tainted
> 4.15.0-29-generic #31-Ubuntu
> Feb 04 09:42:28 ubuntu kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Feb 04 09:42:28 ubuntu kernel: btrfs-transacti D    0  7527      2 
> 0x80000000
> Feb 04 09:42:28 ubuntu kernel: Call Trace:
> Feb 04 09:42:28 ubuntu kernel:  __schedule+0x291/0x8a0
> Feb 04 09:42:28 ubuntu kernel:  schedule+0x2c/0x80
> Feb 04 09:42:28 ubuntu kernel:  btrfs_commit_transaction+0x81d/0x8f0 
> [btrfs]
> Feb 04 09:42:28 ubuntu kernel:  ? wait_woken+0x80/0x80
> Feb 04 09:42:28 ubuntu kernel:  transaction_kthread+0x18d/0x1b0 [btrfs]
> Feb 04 09:42:28 ubuntu kernel:  kthread+0x121/0x140
> Feb 04 09:42:28 ubuntu kernel:  ? btrfs_cleanup_transaction+0x560/0x560
> [btrfs] Feb 04 09:42:28 ubuntu kernel:  ?
> kthread_create_worker_on_cpu+0x70/0x70 Feb 04 09:42:28 ubuntu kernel:  
> ?
> do_syscall_64+0x73/0x130
> Feb 04 09:42:28 ubuntu kernel:  ? SyS_exit_group+0x14/0x20

After rebooting the server acted normal. The only thing I could find in 
the journalctl was:

> Feb 04 02:00:02 server kernel: BTRFS info (device sda3): relocating 
> block
> group 7246746484736 flags data|raid1
> 
> Feb 04 02:05:23 server kernel: BTRFS info (device sda3): found 3 
> extents
> Feb 04 02:06:12 server kernel: BTRFS info (device sda3): found 3 
> extents
> Feb 04 02:07:01 server kernel: BTRFS info (device sda3): relocating 
> block
> group 7059915407360 flags metadata|raid1

Btrfs balancing starts at 02:00.

Can anybody give me a hint what causes this?

I suspect some kind of hardware failure but can't find anything. Any 
idea where to look?

My setup:
> Linux server 4.15.0-45-generic #48-Ubuntu SMP Tue Jan 29 16:28:13 UTC 
> 2019
> x86_64 x86_64 x86_64 GNU/Linux
> 
> btrfs-progs v4.15.1
> 
> Label: 'rootfs'  uuid: cf8c4bb2-6a75-4e1d-983c-19583a93a546
> 
>         Total devices 3 FS bytes used 620.55GiB
>         devid    1 size 923.13GiB used 446.03GiB path /dev/sdc3
>         devid    2 size 923.13GiB used 449.00GiB path /dev/sda3
>         devid    3 size 923.13GiB used 447.03GiB path /dev/sdb3
> 
> Data, RAID1: total=667.00GiB, used=617.65GiB
> System, RAID1: total=32.00MiB, used=176.00KiB
> Metadata, RAID1: total=4.00GiB, used=2.90GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

Dmesg output is not provided there was nothing after reboot.

Thanks

Moritz
