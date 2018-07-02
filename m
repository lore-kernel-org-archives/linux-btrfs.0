Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:25975 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753550AbeGBJWE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 05:22:04 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id D833B4B43D4F
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 17:21:59 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH RFC 0/3] btrfs-progs: lowmem: delay before lowmem repair
Date: Mon, 2 Jul 2018 17:28:17 +0800
Message-ID: <20180702092820.16285-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since lowmem repair is dangerous, it should remind user more obviously.
The patchset add 10 seconds delay like btrfs balance and add am option
'--force-repair-lowmem' to skip the delay.

---
I don't whether it's a good idea to add delay and the option only for
lowmem repair is acceptable, so make it RFC.

Su Yue (3):
  btrfs-progs: lowmem: delay before lowmem repair starts
  btrfs-progs: lowmem: force to start without delay with option
    '--force-repair-lowmem'
  btrfs-progs: tests: append '--force-repair-lowmem' if lowmem repair is
    enabled

 check/main.c       | 43 ++++++++++++++++++++++++++++++++++++-------
 tests/common.local |  1 +
 2 files changed, 37 insertions(+), 7 deletions(-)

-- 
2.17.1



