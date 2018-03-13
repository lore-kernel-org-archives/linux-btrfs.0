Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:36560 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbeCMO7q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 10:59:46 -0400
Received: by mail-it0-f42.google.com with SMTP id u5-v6so519710itc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Mar 2018 07:59:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e934275d-2ff0-7d46-fd5d-421d6bd2ad9b@gmail.com>
References: <CAHS0cb_Pp8z5d_iKKX8MsDX5ixxVQLMyu94eir_a-AJsnhzqUQ@mail.gmail.com>
 <CAHS0cb_77AcDUyV1iPAMN-CkYfOx_d4ZhSzhrKB=-ZVBU4jWYQ@mail.gmail.com> <e934275d-2ff0-7d46-fd5d-421d6bd2ad9b@gmail.com>
From: Valerio Pachera <sirio81@gmail.com>
Date: Tue, 13 Mar 2018 15:59:44 +0100
Message-ID: <CAHS0cb-ByqYX1bkK7qDQY=1N7EqHgjR9U0R5J3NGa7Q-J2z-vQ@mail.gmail.com>
Subject: Re: Fwd: Used space discrepancy
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2018-03-13 14:31 GMT+01:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
> In your case, start by just calling `du` on the _whole_ volume.  There's
> probably some space you're missing that isn't in snapshots and isn't used
> under the folder/folders you told it to look at.

du -sh /mnt/dati/
1,8T    /mnt/dati/

df -h /mnt/dati/
File system            Dim. Usati Dispon. Uso% Montato su
/dev/mapper/vg00-dati  919G  656G    262G  72% /mnt/dati

ls -lah /mnt/dati/
totale 4,0K
drwxr-xr-x 1 root     root      644 mar 12 22:18 .
drwxr-xr-x 4 root     root     4,0K set  9  2016 ..
drwxr-xr-x 1 root     root      314 gen 31 15:28 archivio
drwxr-xr-x 1 root     root       14 gen 11 11:32 backup
drwxr-xr-x 1 www-data www-data  422 set 26 10:29 cloud
drwx------ 1 root     root        0 feb 24  2014 lost+found
drwxr-xr-x 1 root     root       62 gen 31 16:27 win2016_files
drwxr-xr-x 1 root     root       62 gen 31 16:27 win2016_files.20180301221156
drwxr-xr-x 1 root     root       62 gen 31 16:27 win2016_files.20180302221241
drwxr-xr-x 1 root     root       62 gen 31 16:27 win2016_files.20180303221230
drwxr-xr-x 1 root     root       62 gen 31 16:27 win2016_files.20180305221827
drwxr-xr-x 1 root     root       62 gen 31 16:27 win2016_files.20180306221228
drwxr-xr-x 1 root     root       62 gen 31 16:27 win2016_files.20180307221258
drwxr-xr-x 1 root     root       62 gen 31 16:27 win2016_files.20180308221256
drwxr-xr-x 1 root     root       62 gen 31 16:27 win2016_files.20180309221252
drwxr-xr-x 1 root     root       62 gen 31 16:27 win2016_files.20180310221230
drwxr-xr-x 1 root     root       62 gen 31 16:27 win2016_files.20180312221818

cd /mnt/dati
du -sh archivio/ backup/ cloud/ win2016_files | sort -rh
188G    backup/
130G    win2016_files
92G     cloud/
40G     archivio/

As you can see there's not really much to look at.

Note: once a month I run

btrfs balance start -v -musage=0 /mnt/dati

May this influence the used space somehow?
