Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9236 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751756AbcKCEIS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Nov 2016 00:08:18 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v4 0/4] Introduce dump option for btrfs-receive
Date: Thu,  3 Nov 2016 12:07:30 +0800
Message-Id: <20161103040734.8098-1-quwenruo@cn.fujitsu.com>
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
v4:
  Fix two small output defeats exposed by David.
  Add printf format checker attritube for __print_dump, suggested by David.
  Manually disable -Wformat-zero-length in send-dump.
  Ouput fattr's data, suggested by David.
  Change c/m/a time to RFC3339 format, suggested by David.
  Avoid calling memmove() in a loop in escape_string_inplace().
  Proviode non-inplace version escape_string(), which will alloc memory by itself.

Qu Wenruo (4):
  btrfs-progs: utils: Introduce function to escape characters
  btrfs-progs: introduce new send-dump object
  btrfs-progs: receive: introduce option to dump send stream
  btrfs-progs: misc-test: Add send stream dump test

 Documentation/btrfs-receive.asciidoc               |  15 +-
 Makefile.in                                        |   2 +-
 cmds-receive.c                                     |  35 ++-
 send-dump.c                                        | 298 +++++++++++++++++++++
 send-dump.h                                        |  29 ++
 .../016-send-dump-output/creation.stream.xz        | Bin 0 -> 984 bytes
 .../016-send-dump-output/deletion.stream.xz        | Bin 0 -> 408 bytes
 tests/misc-tests/016-send-dump-output/test.sh      |  23 ++
 utils.c                                            |  24 ++
 utils.h                                            |  14 +
 10 files changed, 434 insertions(+), 6 deletions(-)
 create mode 100644 send-dump.c
 create mode 100644 send-dump.h
 create mode 100644 tests/misc-tests/016-send-dump-output/creation.stream.xz
 create mode 100644 tests/misc-tests/016-send-dump-output/deletion.stream.xz
 create mode 100755 tests/misc-tests/016-send-dump-output/test.sh

-- 
2.10.1



