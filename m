Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:36667 "EHLO
	mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbcHKRcE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 13:32:04 -0400
Received: by mail-qt0-f177.google.com with SMTP id 52so1220562qtq.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Aug 2016 10:32:04 -0700 (PDT)
MIME-Version: 1.0
From: Rakesh Sankeshi <rakesh.sankeshi@gmail.com>
Date: Thu, 11 Aug 2016 10:32:03 -0700
Message-ID: <CAGj_d3D2OZt2nY622rp9NzxgAfKZ2iN1kLSQ2Ras-0fM+1+-ig@mail.gmail.com>
Subject: btrfs quota issues
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I set 200GB limit to one user and 100GB to another user.

as soon as I reached 139GB and 53GB each, hitting the quota errors.
anyway to workaround quota functionality on btrfs LZO compressed
filesystem?



4.7.0-040700-generic #201608021801 SMP

btrfs-progs v4.7


Label: none  uuid: 66a78faf-2052-4864-8a52-c5aec7a56ab8

Total devices 2 FS bytes used 150.62GiB

devid    1 size 1.00TiB used 78.01GiB path /dev/xvdc

devid    2 size 1.00TiB used 78.01GiB path /dev/xvde


Data, RAID0: total=150.00GiB, used=149.12GiB

System, RAID1: total=8.00MiB, used=16.00KiB

Metadata, RAID1: total=3.00GiB, used=1.49GiB

GlobalReserve, single: total=512.00MiB, used=0.00B


Filesystem      Size  Used Avail Use% Mounted on

/dev/xvdc       2.0T  153G  1.9T   8% /test_lzo
