Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:46236 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750964AbdISHuR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 03:50:17 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 83D00AC005E
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 16:50:10 +0900 (JST)
Received: from G01JPEXCHKW17.g01.fujitsu.local (G01JPEXCHKW17.g01.fujitsu.local [10.0.194.56])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id D9864BD6702
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 16:50:09 +0900 (JST)
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: btrfs-progs: suggestion of removing --commit-after option of subvol
 delete
To: <linux-btrfs@vger.kernel.org>
Message-ID: <3fab29e2-179e-2109-6217-1cb079f97f9e@jp.fujitsu.com>
Date: Tue, 19 Sep 2017 16:50:04 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I read the code of "subvolume delete" and found that --commit-after option is
not working well.

Since it issues BTRFS_IOC_START/WAIT_SYNC to the last fd (of directory
containing the last deleted subvolume),
1. sync operation affects only the last fd's filesystem.
   ("subvolume delete" can take multiple subvolumes on different filesystems.)
2. if the last delete action fails to open the path (fd == -1),
   SYNC is not issued at all.

One solution is to keep every fd for deleted subvolumes, but I think it takes
too much cost. Since we can just use "btrfs filesystem sync" after delete if
needed, I think it is ok to remove --comit-after option.

Regards,
Tomohiro Misono
(misono.tomohiro@jp.fujitsu.com)

