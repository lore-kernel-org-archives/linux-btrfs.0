Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:46715 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbeAQIgu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 03:36:50 -0500
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id B84C5AC0149
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jan 2018 17:36:46 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Anand Jain <anand.jain@oracle.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 0/2] btrfs: additional fix for mount cleanup
Message-ID: <7fba2dc9-44a9-4317-b9fd-263b2a687e9a@jp.fujitsu.com>
Date: Wed, 17 Jan 2018 17:36:38 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is based on the following branch:
https://github.com/kdave/btrfs-devel/tree/misc-next

And this is the additional fix for mount cleanup patch.
(https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg71148.html

1st patch fixes the problem "device scan/ready" fails for mounted
filesystem.
2nd patch drops unused argument.

Sorry for messing things up.
Regards,
Tomohiro Misono

*** BLURB HERE ***

Tomohiro Misono (2):
  btrfs: fix the bug of device scan/ready for mounted filesystem
  btrfs: remove unused arg from parse_subvol_options()

 fs/btrfs/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.14.3

