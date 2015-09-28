Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45722 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932920AbbI1N76 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 09:59:58 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8SDxYfA005919
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 21:59:34 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v3 0/2] btrfs-progs: Introduce warning and error for common use
Date: Mon, 28 Sep 2015 21:58:12 +0800
Message-ID: <cover.1443448527.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current code use fprintf(stderr, "...") to output warnning and
error information.

The error message have different style, as:
 # grep fprintf *.c
 fprintf(stderr, "Open ctree failed\n");
 fprintf(stderr, "%s: open ctree failed\n", __func__);
 fprintf(stderr, "ERROR: cannot open ctree\n");
 ...

And sometimes, we forgot add tailed '\n', or use printf instead,
as in current code:
 printf("warning, device %llu is missing\n",

This patch introduce warning() and error() as common function,
to make:
1: Each warning and error information have same format
2: Easy to search/change all error message
3: Easy to modify function's internal for debug or other requirement,
   for example:
   print function/linenumber in error()
   dumpstack in error()
   add some trace for some style of message
   add support for -v, -vv, ...
   support for locales
   custom output functions
   support some special device/tty

Converting all source is a big work, this patch convert cmds-scrub.c
We'll convert others these days, and new code can use these function
directly.

Changelog v2->v3:
 1: Put variable definition to top of function
 2: Move __veprintf() to warning()/error()'s internal
 All suggested-by: David Sterba <dsterba@suse.cz>

Changelog v1->v2:
 1: Rename following functions:
    warningon() -> warning_on()
    erroron() -> error_on()
    Suggested-by: David Sterba <dsterba@suse.cz>
 2: Use static inline instead of macro
    Suggested-by: David Sterba <dsterba@suse.cz>
 3: Add return value of warning/error_on()
    Suggested-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Zhao Lei (2):
  btrfs-progs: Introduce warning and error for common use
  btrfs-progs: use common warning/error for cmds-scrub.c

 cmds-scrub.c | 176 +++++++++++++++++++++++++++++------------------------------
 utils.h      |  51 +++++++++++++++++
 2 files changed, 138 insertions(+), 89 deletions(-)

-- 
1.8.5.1

