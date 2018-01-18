Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:52733 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752184AbeAREYT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 23:24:19 -0500
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 5D29CAC0150
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:24:14 +0900 (JST)
Received: from g01jpexchkw36.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id A14B96924C0
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:24:13 +0900 (JST)
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: bug report: mounting the same device to different mount points in
 parallel may fail
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <db01b798-cc0a-f276-df4d-e9c334ea912e@jp.fujitsu.com>
Date: Thu, 18 Jan 2018 13:23:35 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although I think this rarely happens in the real world, mounting 
the same device to different mount points in parallel may fail:

- kernel 4.15.0-rc8

- Procedure
[mount.sh]
#!/bin/bash
for i in `seq 1 1000`; do
  echo $i
  mount $1 $2
  umount $2
  if [ $? -ne 0 ]; then
    exit 1;
  fi
done

$ mkfs.btrfs -f /dev/sde
$ ./mount.sh /dev/sde /mnt
$ ./mount.sh /dev/sde /mnt2 (on the different terminal)

- stdout
mount: /mnt2: wrong fs type, bad option, bad superblock on 
/dev/sde, missing codepage or helper program, or other error.

- dmesg
[  108.122576] BTRFS error (device sde): super_total_bytes 199481098240 mismatch with fs_devices total_rw_bytes 398962196480
[  108.122647] BTRFS error (device sde): failed to read chunk tree: -22
[  108.150060] BTRFS error (device sde): open_ctree failed

xfs or ext4 works fine.

Regards,
Tomohiro Misono

