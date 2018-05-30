Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:63132 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932618AbeE3Ewi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 00:52:38 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 64641AC01EF
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 13:52:31 +0900 (JST)
Received: from G01JPEXCHYT15.g01.fujitsu.local (G01JPEXCHYT15.g01.fujitsu.local [10.128.194.54])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id B703446E496
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 13:52:30 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/2] btrfs-progs: ins: dump-tree: Small updates for extent tree output
Date: Wed, 30 May 2018 13:55:18 +0900
Message-ID: <cover.1527655420.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Two small updates for extent tree to make output more human readable.

Misono Tomohiro (2):
  btrfs-progs: ins: dump-tree: Use %lld for extent data backref offset
  btrfs-progs: ins: dump-tree: Print tree name for tree block backref

 print-tree.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.14.3


