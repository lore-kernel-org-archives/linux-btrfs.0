Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38319 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3IAGPQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 02:15:16 -0400
Received: by mail-pa0-f53.google.com with SMTP id lb1so3945731pab.12
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Aug 2013 23:15:14 -0700 (PDT)
Date: Sun, 01 Sep 2013 14:15:08 +0800
From: Wang Shilong <wangshilong1991@gmail.com>
To: Anand Jain <Anand.Jain@oracle.com>
Subject: Re:  btrfs-progs: v3, move out print in cmd_df to another function
Cc: linux-btrfs@vger.kernel.org
Message-ID: <5222db6c.+9oeJwhGj6njPuoK%wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Using checkpatch.pl, i get the following warnings(errors):
ERROR: "foo * bar" should be "foo *bar"
#37: FILE: cmds-filesystem.c:47:
+static char * group_type_str(u64 flag)

ERROR: "foo * bar" should be "foo *bar"
#69: FILE: cmds-filesystem.c:63:
+static char * group_profile_str(u64 flag)

total: 2 errors, 0 warnings, 229 lines checked

patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Thanks, Wang
