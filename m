Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:39592 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752156AbeCMNHw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 09:07:52 -0400
Received: by mail-it0-f44.google.com with SMTP id l187-v6so14543ith.4
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Mar 2018 06:07:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHS0cb_Pp8z5d_iKKX8MsDX5ixxVQLMyu94eir_a-AJsnhzqUQ@mail.gmail.com>
References: <CAHS0cb_Pp8z5d_iKKX8MsDX5ixxVQLMyu94eir_a-AJsnhzqUQ@mail.gmail.com>
From: Valerio Pachera <sirio81@gmail.com>
Date: Tue, 13 Mar 2018 14:07:50 +0100
Message-ID: <CAHS0cb_77AcDUyV1iPAMN-CkYfOx_d4ZhSzhrKB=-ZVBU4jWYQ@mail.gmail.com>
Subject: Fwd: Used space discrepancy
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Short version:

656G used (df -h)
450G used (du -sh)
10G used by snapshots
196G discrepancy <-----

I don't undertand what is using 196G.

df -h /mnt/dati/
File system            Dim. Usati Dispon. Uso% Montato su
/dev/mapper/vg00-dati  919G  656G    262G  72% /mnt/dati

du -sh /mnt/dati/folder1,2,3
450G

I have a subvolume with 10 snapshots.
I know that 10G of data has been copied, so snapshots should hold no
more than 10G.

There's not a huge amount of metadata:

btrfs fi df /mnt/dati
Data, single: total=774.00GiB, used=654.42GiB
System, single: total=32.00MiB, used=92.00KiB
Metadata, single: total=2.00GiB, used=1007.42MiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Why such a big difference between 'df -h' and 'du -sh' ?

uname -a
Linux cubo-ats 4.9.0-0.bpo.5-amd64 #1 SMP Debian
4.9.65-3+deb9u2~bpo8+1 (2017-01-05) x86_64 GNU/Linux

btrfs --version
btrfs-progs v4.7.3

btrfs fi show
Label: none  uuid: f0a8ff89-608e-4ca2-bde9-8dc09b91accf
        Total devices 1 FS bytes used 655.40GiB
        devid    1 size 918.35GiB used 776.03GiB path /dev/mapper/vg00-dati
