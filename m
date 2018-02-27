Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:34646 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752107AbeB0NJx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 08:09:53 -0500
Received: by mail-ot0-f176.google.com with SMTP id n74so3707113ota.1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 05:09:52 -0800 (PST)
MIME-Version: 1.0
From: vinayak hegde <vinayakhegdev@gmail.com>
Date: Tue, 27 Feb 2018 18:39:51 +0530
Message-ID: <CAFmraXiqhYUvM3VDGHp3Zj0i5SMH_Koy6Ed4B6W092-SVFSNVg@mail.gmail.com>
Subject: btrfs space used issue
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am using btrfs, But I am seeing du -sh and df -h showing huge size
difference on ssd.

mount:
/dev/drbd1 on /dc/fileunifier.datacache type btrfs
(rw,noatime,nodiratime,flushoncommit,discard,nospace_cache,recovery,commit=5,subvolid=5,subvol=/)


du -sh /dc/fileunifier.datacache/ -  331G

df -h
/dev/drbd1      746G  346G  398G  47% /dc/fileunifier.datacache

btrfs fi usage /dc/fileunifier.datacache/
Overall:
    Device size:         745.19GiB
    Device allocated:         368.06GiB
    Device unallocated:         377.13GiB
    Device missing:             0.00B
    Used:             346.73GiB
    Free (estimated):         396.36GiB    (min: 207.80GiB)
    Data ratio:                  1.00
    Metadata ratio:              2.00
    Global reserve:         176.00MiB    (used: 0.00B)

Data,single: Size:365.00GiB, Used:345.76GiB
   /dev/drbd1     365.00GiB

Metadata,DUP: Size:1.50GiB, Used:493.23MiB
   /dev/drbd1       3.00GiB

System,DUP: Size:32.00MiB, Used:80.00KiB
   /dev/drbd1      64.00MiB

Unallocated:
   /dev/drbd1     377.13GiB


Even if we consider 6G metadata its 331+6 = 337.
where is 9GB used?

Please explain.

Vinayak
