Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:20207 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbdK3Hvy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 02:51:54 -0500
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 9C559AC00B2
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 16:51:50 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id E9914BD6826
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 16:51:49 +0900 (JST)
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 0/3] Some fix for fi usage
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
Date: Thu, 30 Nov 2017 16:51:45 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1 and 2 aims to fix the "fi du" to include the information of "fi df"
even when runnning without root previlege.

Patch 3 is a independent cleanup.

Tomohiro Misono (3):
  btrfs-progs: fi usage: change warning message more appropriately
  btrfs-progs: fi usage: change to output more info without root privilege
  btrfs-progs: fi usage: cleanup unneccessary permission error check

 cmds-fi-usage.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

-- 
2.13.6

