Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:46699 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbeC2IWT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 04:22:19 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 6F9D4AC00C2
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 17:22:13 +0900 (JST)
Received: from g01jpexchyt36.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id BEAA66D6566
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 17:22:12 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v2 0/3] btrfs-progs: Some fix for fi usage
Message-ID: <99d3f3bf-ecc3-b6f5-c38c-8fba83db48d0@jp.fujitsu.com>
Date: Thu, 29 Mar 2018 17:21:29 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v1->v2
  These were sent several months ago, just rebased to current devel branch.

Patch 1 and 2 aims to fix the "fi du" to include the information of "fi df"
even when running without root privilege.

Patch 3 is an independent cleanup.

Tomohiro Misono (3):
  btrfs-progs: fi usage: change warning message more appropriately
  btrfs-progs: fi usage: change to output more info without root privilege
  btrfs-progs: fi usage: cleanup unnecessary permission error check

 cmds-fi-usage.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

-- 
2.14.3

