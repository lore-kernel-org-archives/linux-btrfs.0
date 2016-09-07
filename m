Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31228 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S934617AbcIGA3n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 20:29:43 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 9B3FF4042400
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Sep 2016 08:29:37 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/3] Introduce dump option for btrfs-receive
Date: Wed, 7 Sep 2016 08:29:32 +0800
Message-ID: <20160907002935.8539-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new "--dump" option for btrfs-receive, which will exam and dump
metadata info of a send stream.
This is quite handy to debug send stream.

Since such function is provided by old send-test tool, which doesn't even
compile now, remove the old send-test tool.

changelog:
v2:
  Move from inspect subcommand to receive subcommand.

Qu Wenruo (3):
  btrfs-progs: Introduce new send-dump object
  btrfs-progs: receive: Introduce option to exam and dump send stream
  btrfs-progs: Remove send-test tool

 Documentation/btrfs-receive.asciidoc |  17 +-
 Makefile.in                          |   8 +-
 cmds-receive.c                       |  41 +++-
 send-dump.c                          | 367 ++++++++++++++++++++++++++++
 send-dump.h                          |  24 ++
 send-test.c                          | 447 -----------------------------------
 6 files changed, 443 insertions(+), 461 deletions(-)
 create mode 100644 send-dump.c
 create mode 100644 send-dump.h
 delete mode 100644 send-test.c

-- 
2.9.3



