Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:32913 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbcLDSaK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 13:30:10 -0500
Received: by mail-yw0-f181.google.com with SMTP id r204so243470306ywb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Dec 2016 10:30:10 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 4 Dec 2016 11:30:09 -0700
Message-ID: <CAJCQCtQcz6W-UD5eDAiWG1QJk3tSF7boN2haG_Du=PD_U6rx1g@mail.gmail.com>
Subject: btrfs fi du is unreliable
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

[chris@f25s ~]$ uname -r
4.8.11-300.fc25.x86_64
[chris@f25s ~]$ rpm -q btrfs-progs
btrfs-progs-4.8.5-1.fc26.x86_64


I'm not finding any pattern to this so far, but it's definitely not
always reliable. Here is today's example.

[chris@f25s ~]$ sudo btrfs fi du -s /mnt/second/jackson.2015/
     Total   Exclusive  Set shared  Filename
 111.67GiB   111.67GiB       0.00B  /mnt/second/jackson.2015/

Super. This is correct. The jackson.2015 subvolume contains only
exclusively used data, there are no snapshots, and there are no
reflinks involved for any files.


[chris@f25s ~]$ sudo btrfs send  /mnt/second/jackson.2015/ | sudo
btrfs receive /mnt/int/

Send the subvolume to a different btrfs volume. This is not an
incremental send. After completion however:


[chris@f25s ~]$ sudo btrfs fi du -s /mnt/int/jackson.2015/
     Total   Exclusive  Set shared  Filename
 111.67GiB    37.20GiB    29.93GiB  /mnt/int/jackson.2015/

That makes zero sense. What's going on here?


Chris Murphy
