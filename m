Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20095 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S965656AbcKAICG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Nov 2016 04:02:06 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v3 0/4] Introduce dump option for btrfs-receive
Date: Tue,  1 Nov 2016 16:01:42 +0800
Message-Id: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The branch can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/send_dump

The branch doesn't contain the fake test case.

Introduce new "--dump" option for btrfs-receive, which will exam and dump
metadata info of a send stream.
This is quite handy to debug send stream.

Since such function is provided by old send-test tool, which doesn't even
compile now, remove the old send-test tool.

changelog:
v2:
  Move from inspect subcommand to receive subcommand.
v3:
  Add output for ctime/mtime/atime
  (Human readable local time like "1111-11-01 11:11:11")
  Rearrange the output from "key1: value1, key2: value2" to
  "key1=value1 key2=value2". Suggested by David
  Rename macro path_cat_or_error() to PATH_CAT_OR_RET(). Suggested by David
  Change pointer to array to avoid memory allocation error. Suggested by David
  Add the 5th patch to add a fake test case to show how the new output looks
  like.

Qu Wenruo (4):
  btrfs-progs: utils: Introduce function to escape characters
  btrfs-progs: introduce new send-dump object
  btrfs-progs: receive: introduce option to dump send stream
  btrfs-progs: remove send-test tool

 Documentation/btrfs-receive.asciidoc |  15 +-
 Makefile.in                          |   8 +-
 cmds-receive.c                       |  35 ++-
 send-dump.c                          | 299 +++++++++++++++++++++++
 send-dump.h                          |  29 +++
 send-test.c                          | 447 -----------------------------------
 utils.c                              |  17 ++
 utils.h                              |   2 +
 8 files changed, 394 insertions(+), 458 deletions(-)
 create mode 100644 send-dump.c
 create mode 100644 send-dump.h
 delete mode 100644 send-test.c

-- 
2.10.1



