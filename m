Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:50563 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaCYFQF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 01:16:05 -0400
Received: by mail-ob0-f177.google.com with SMTP id wo20so6815093obc.36
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 22:16:03 -0700 (PDT)
MIME-Version: 1.0
From: Slava Barinov <rayslava@gmail.com>
Date: Tue, 25 Mar 2014 09:15:43 +0400
Message-ID: <CADef55oE1UQbmEnvXcXuYxEwdR=ktYsC2C+QzTjQWu7h5vA7NQ@mail.gmail.com>
Subject: "Asymmetric" RAID0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

 I've been using a single drive btrfs for some time and when free space
 became too low I've added an additional drive and rebalanced FS with
 RAID0 data and RAID1 System and Metadata storage.

 Now I have the following configuration:

# btrfs fi show /btr
Label: none  uuid: f9d78880-10a7-439b-8ebd-14d815edbc19
    Total devices 2 FS bytes used 415.45GiB
    devid    1 size 931.51GiB used 222.03GiB path /dev/sdc
    devid    2 size 431.51GiB used 222.03GiB path /dev/sdb

# btrfs fi df /btr
Data, RAID0: total=424.00GiB, used=406.81GiB
System, RAID1: total=32.00MiB, used=40.00KiB
Metadata, RAID1: total=10.00GiB, used=8.64GiB

# df -h
Filesystem                               Size  Used Avail Use% Mounted on
/dev/sdb                                 1.4T  424G  437G  50% /btr

 I suppose I should trust to btrfs fi df, not df utility.

 So the main question is if such "asymmetric" RAID0 configuration
 possible at all and why does btrfs ignore ~500 GB of free space on
 /dev/sdc drive?

 Also it's interesting what will happen when I add 20 GB more data to
 my FS. Should I be prepared to usual btrfs low-space problems?

Best regards,
Slava Barinov.
