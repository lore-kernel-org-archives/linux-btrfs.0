Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:51077 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaC1N5D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Mar 2014 09:57:03 -0400
Received: by mail-vc0-f177.google.com with SMTP id if17so5750445vcb.22
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 06:57:02 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 28 Mar 2014 09:57:02 -0400
Message-ID: <CAJtFHUSbuOPy=r23-+_vB8zCJ7eMDJWtMYzGB+ntMVGncX=9gA@mail.gmail.com>
Subject: What's enospc_debug telling me?
From: E V <eliventer@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Doing a data balance profile conversion raid0->single fails with
enospc, even given lots of space. So tried out enospc_debug:

Mar 28 08:48:44 btrfs: relocating block group 579997815275520 flags 9
Mar 28 08:58:06 space_info 1 has 1574929309696 free, is not full
Mar 28 08:58:06 space_info total=70404177657856, used=68829248086016,
pinned=0, reserved=0, may_use=3175444480, readonly=262144
Mar 28 08:58:06 block group 579901178511360 has 3221225472 bytes,
3221225472 used 0 pinned 0 reserved
Mar 28 08:58:06 block group has cluster?: no
Mar 28 08:58:06 0 blocks of free space at or bigger than bytes is
Mar 28 08:58:06 block group 579904399736832 has 3221225472 bytes,
3221225472 used 0 pinned 0 reserved
Mar 28 08:58:06 block group has cluster?: no

... about 3 million lines later with different block group numbers it ends at

Mar 28 09:16:48 block group 607319175987200 has 1073741824 bytes, 0
used 0 pinned 0 reserved
Mar 28 09:16:48 block group has cluster?: no
Mar 28 09:16:48 0 blocks of free space at or bigger than bytes is
Mar 28 09:16:48 block group 607320249729024 has 1073741824 bytes, 0
used 0 pinned 0 reserved
Mar 28 09:16:48 block group has cluster?: no
Mar 28 09:16:48 0 blocks of free space at or bigger than bytes is
Mar 28 09:16:48 btrfs: 17 enospc errors during balance

space info:
Total devices 3 FS bytes used 62.69TiB
devid    1 size 30.01TiB used 18.16TiB path /dev/sdb
devid    2 size 30.01TiB used 18.17TiB path /dev/sdc
devid    3 size 40.02TiB used 28.01TiB path /dev/sdd

Data, RAID0: total=9.72TiB, used=9.72TiB
Data, single: total=54.36TiB, used=52.88TiB
System, RAID1: total=40.00MiB, used=6.80MiB
Metadata, RAID1: total=134.00GiB, used=89.69GiB
