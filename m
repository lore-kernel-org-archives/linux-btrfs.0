Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:20531 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751428AbdKBDT5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 23:19:57 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 78E7447F13A7
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Nov 2017 11:19:54 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 0/5] btrfs-progs: resolve property and enhance defragment
Date: Thu, 2 Nov 2017 11:23:15 +0800
Message-ID: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset adds an option '--compress-force' to work with
'btrfs fi defrag -c'. Then no-compression files will be set with
compression property specified by '-c' (zlib default).

patch[1-4] divide property handler to setter, getter, and printer.

Then patch[5] could enhance defragment easier.

Su Yue (5):
  btrfs-progs: property: divide prop_handler_t into
    setter,getter,printer
  btrfs-progs: property: set/get/print ro property
  btrfs-progs: property: set/get/print label property
  btrfs-progs: property: set/get/print compression property
  btrfs-progs: fi defrag: extend -c to drop nocompress flag on files

 cmds-filesystem.c |  94 +++++++++++++++++++++++--
 cmds-property.c   |   7 +-
 props.c           | 207 +++++++++++++++++++++++++++++++++++++++++++++---------
 props.h           |  19 +++--
 4 files changed, 283 insertions(+), 44 deletions(-)

-- 
2.15.0



