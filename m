Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:34803 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751700AbdCBAfp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Mar 2017 19:35:45 -0500
Received: by mail-yw0-f178.google.com with SMTP id p77so45988983ywg.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Mar 2017 16:35:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGqmi76oFUFtD1TDjns_BFujkRc8fHSpL6Wt5yYt3SX0QPf+5A@mail.gmail.com>
References: <CAGqmi76oFUFtD1TDjns_BFujkRc8fHSpL6Wt5yYt3SX0QPf+5A@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 1 Mar 2017 17:35:35 -0700
Message-ID: <CAJCQCtQV96DZDRXYXy4misjqrt_CQi+AmtC+o=-mTyv6N_POsQ@mail.gmail.com>
Subject: Re: Please add more info to dmesg output on I/O error
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 1, 2017 at 9:04 AM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> Hi, today i try move my FS from old HDD to new SSD
> While processing i catch I/O error and device remove operation was canceled
>
> Dmesg:
> [ 1015.010241] blk_update_request: I/O error, dev sda, sector 81353664
> [ 1015.010246] BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0,
> rd 23, flush 0, corrupt 0, gen 0
> [ 1015.010282] ata5: EH complete
> [ 1017.016721] ata5.00: exception Emask 0x0 SAct 0x10000 SErr 0x0 action 0x0
> [ 1017.016730] ata5.00: irq_stat 0x40000008
> [ 1017.016737] ata5.00: failed command: READ FPDMA QUEUED
> [ 1017.016748] ata5.00: cmd 60/08:80:c0:5b:d9/00:00:04:00:00/40 tag 16
> ncq dma 4096 in
>                        res 41/40:00:c0:5b:d9/00:00:04:00:00/40 Emask
> 0x409 (media error) <F>
> [ 1017.016754] ata5.00: status: { DRDY ERR }
> [ 1017.016757] ata5.00: error: { UNC }
> [ 1017.029479] ata5.00: configured for UDMA/133
> [ 1017.029506] sd 4:0:0:0: [sda] tag#16 UNKNOWN(0x2003) Result:
> hostbyte=0x00 driverbyte=0x08
> [ 1017.029511] sd 4:0:0:0: [sda] tag#16 Sense Key : 0x3 [current]
> [ 1017.029516] sd 4:0:0:0: [sda] tag#16 ASC=0x11 ASCQ=0x4
> [ 1017.029520] sd 4:0:0:0: [sda] tag#16 CDB: opcode=0x28 28 00 04 d9
> 5b c0 00 00 08 00

This is an error reported by the drive to libata. It's not a Btrfs
error or bug. The UNC suggests it's an uncorrectable error, so whether
Btrfs can compensate depends on whether there's redundancy for the
affected sector(s).



> At now, i fixed this problem by doing scrub FS and delete damaged
> files, but scrub are slow, and if btrfs show me a more info on I/O
> error, it's will be more helpful
> i.e. something like i getting by scrub:
> [ 1260.559180] BTRFS warning (device sdb1): i/o error at logical
> 40569896960 on dev /dev/sda1, sector 81351616, root 309, inode 55135,
> offset 71278592, length 4096, links 1 (path:
> nefelim4ag/.config/skypeforlinux/Cache/data_3)

That suggests the problem is with data, not metadata. What is the data
and metadata profile?



-- 
Chris Murphy
