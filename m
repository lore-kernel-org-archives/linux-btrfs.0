Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:35038 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3IAGPR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 02:15:17 -0400
Received: by mail-pb0-f49.google.com with SMTP id xb4so3439563pbc.8
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Aug 2013 23:15:14 -0700 (PDT)
Date: Sun, 01 Sep 2013 14:15:08 +0800
From: Wang Shilong <wangshilong1991@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Subject: Re:  Btrfs-progs: allow fsck to fix directory isize errors
Cc: <linux-btrfs@vger.kernel.org>
Message-ID: <5222db6c.1eGiowjcLKubyk/W%wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Using checkpatch.pl, i get the following warnings(errors):
WARNING: %Ld/%Lu are not-standard C, use %lld/%llu
#87: FILE: cmds-check.c:1389:
+	printf("reset isize for dir %Lu root %Lu\n", rec->ino,

total: 0 errors, 1 warnings, 141 lines checked

patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Thanks, Wang
