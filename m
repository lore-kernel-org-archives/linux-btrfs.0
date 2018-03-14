Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:43819 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbeCNEJb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 00:09:31 -0400
Received: by mail-oi0-f51.google.com with SMTP id a207so1602146oii.10
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Mar 2018 21:09:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180314042507.f20bbf949ce07f88ca01cb38@reasonset.net>
References: <20180313065743.c3ec9ade3e90dc4fc4b5adc9@reasonset.net>
 <f4e1a551-fc29-f7e8-a738-76365af403f7@gmx.com> <20180313131928.5f3f1d053eaf50424b6dbff8@reasonset.net>
 <c938a753-deb6-39bb-0f17-701ec1e0226b@gmx.com> <20180314042507.f20bbf949ce07f88ca01cb38@reasonset.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 13 Mar 2018 22:09:30 -0600
Message-ID: <CAJCQCtRaUUSWOWGQzJqZVddV9639O0B8eiZzNKTB0DPYowLWoA@mail.gmail.com>
Subject: Re: Btrfs broken in massive transfar
To: MASAKI haruka <yek@reasonset.net>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 13, 2018 at 1:25 PM, MASAKI haruka <yek@reasonset.net> wrote:
> journal(Kernel log), 7th try (to be readonly):
>
> ---
>  3月 12 16:25:51 lily kernel: BTRFS info (device dm-6): creating UUID tree
>  3月 12 16:25:53 lily iscsid[1406]: Connection-1:0 to [target: iqn.1994-11.com.netgear:eggplant-01:edc9adcf:btr1group, portal: 192.168.1.166,3260] through [iface: default] is shutdown.
>  3月 12 16:25:53 lily iscsid[1406]: IPC qtask write failed: Broken pipe
>  3月 12 16:26:18 lily kernel:  connection1:0: detected conn error (1020)
>  3月 12 16:26:19 lily iscsid[1406]: Kernel reported iSCSI connection 1:0 error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
>  3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
>  3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 Sense Key : 0x2 [current] [descriptor]
>  3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 ASC=0x8 ASCQ=0x0
>  3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 CDB: opcode=0x8a 8a 00 00 00 00 00 00 42 5c 00 00 00 34 00 00 00
>  3月 12 16:26:21 lily kernel: print_req_error: I/O error, dev sdg, sector 4348928


Looks like network problems. Is one of these Btrfs volumes on an iSCSI
device? Because there's a bunch of iSCSI errors followed by an I/O
error with sector LBA reported, and then you get a bunch of Btrfs
write errors.

What's the relationship between /dev/sdg and device (dm-6)
/dev/mapper/hymaster_1 ?


>
> Note: This system's structure is;
> Computer (Linux 4.14/4.15) - btrfs (original) - dm-crypt plain - internal 4 disks
>  \_ btrfs (destination) - dm-crypt plain - iSCSI (single) - NAS - Hardware RAID5 - 8 disks

dm-6 is what btrfs is directly using and is complaining about, and I
will guess that this is a dmcrypt device backed by /dev/sdg which is
iSCSI to the NAS. Correct? Looks like either network problems, or
possibly there is a real hardware problem with an error that's only
partly passing through iSCSI. I can't parse this:

 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 UNKNOWN(0x2003)
Result: hostbyte=0x00 driverbyte=0x08
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 Sense Key : 0x2
[current] [descriptor]
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 ASC=0x8 ASCQ=0x0
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 CDB: opcode=0x8a
8a 00 00 00 00 00 cd 6f 0b 80 00 00 2a 20 00 00

Anyway, Btrfs detects the write failures, and is going read-only in
order to prevent corrupting the file system. So I think you've got
some iSCSI troubleshooting to do, and fix that. Doesn't seem like it's
a Btrfs specific problem to me.





-- 
Chris Murphy
