Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4647FC10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 16:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C09821473
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 16:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfDHQVI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 12:21:08 -0400
Received: from aquinas.techsquare.com ([75.125.237.226]:43957 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726742AbfDHQVI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2019 12:21:08 -0400
X-Greylist: delayed 1985 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2019 12:21:08 EDT
Received: from sb by techsquare.com with local (Exim 4.71)
        (envelope-from <sb@techsquare.com>)
        id 1hDWV9-0001qc-Cn
        for linux-btrfs@vger.kernel.org; Mon, 08 Apr 2019 11:48:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23723.27955.359573.44839@techsquare.com>
Date:   Mon, 8 Apr 2019 11:48:03 -0400
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: checksum error...
X-Mailer: VM 8.0.13 under 23.1.1 (x86_64-pc-linux-gnu)
From:   "Scott E. Blomquist" <sb@techsquare.com>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: sb@techsquare.com
X-SA-Exim-Scanned: No (on techsquare.com); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Hi All,

The weekend btrfs scrub/balance came back with this following...

[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271471, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 62378, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 270894, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271453, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271449, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271435, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271432, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271421, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271411, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271401, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271391, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271345, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271253, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271163, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271074, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 270983, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[Sun Apr  7 06:57:10 2019] BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[Sun Apr  7 06:57:10 2019] BTRFS error (device sdb1): unable to fixup (regular) error at logical 274820497408 on dev /dev/sda1

Here is what I have...

    root@cbmm-fsb:~# uname -a
    Linux cbmm-fsb 4.14.24-custom #1 SMP Mon Mar 5 10:10:39 EST 2018 x86_64 x86_64 x86_64 GNU/Linux
    
    root@cbmm-fsb:~# btrfs --version
    btrfs-progs v4.15.1
    
    root@cbmm-fsb:~# btrfs fi show
    Label: none  uuid: d83b1e28-db27-4035-8638-d4b2eb824ff2
           Total devices 2 FS bytes used 80.09TiB
           devid    1 size 76.40TiB used 62.49TiB path /dev/sda1
           devid    2 size 32.74TiB used 18.83TiB path /dev/sdb1
    
    root@cbmm-fsb:~# btrfs fi df /home/cbcl
    Data, single: total=79.80TiB, used=79.80TiB
    System, RAID1: total=32.00MiB, used=9.09MiB
    Metadata, RAID1: total=757.00GiB, used=281.34GiB
    Metadata, DUP: total=22.50GiB, used=19.27GiB
    GlobalReserve, single: total=512.00MiB, used=0.00B
    
sda and sdb are megaraid raid6 with BBU and both are optimal.

Any tips?  Thanks.

sb. Scott Blomquist

