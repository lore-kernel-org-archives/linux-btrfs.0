Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:54241 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754771AbeBOGlW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 01:41:22 -0500
Received: by mail-wm0-f53.google.com with SMTP id t74so26887047wme.3
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 22:41:21 -0800 (PST)
MIME-Version: 1.0
From: Dave <davestechshop@gmail.com>
Date: Thu, 15 Feb 2018 01:41:00 -0500
Message-ID: <CAH=dxU4_cpDC38+h=2FNVOrt9NQxexOQ2dtqQwUursiAdeLW3A@mail.gmail.com>
Subject: btrfs send | receive ERROR rename file exists
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can anyone give me any ideas why this error would happen? The receive
directory started empty. Snapshot 3 exists at both source and target.

# mkdir /.snapshots/bw538/
# btrfs send -p /mnt/backup/root/laptop/3/snapshot/
/mnt/backup/root/laptop/4/snapshot/ | btrfs receive /.snapshots/bw538/
At subvol /mnt/backup/root/laptop/4/snapshot/
At snapshot snapshot
ERROR: rename o439638-244-0 -> var/cache/man/pl/index.db failed: File exists
