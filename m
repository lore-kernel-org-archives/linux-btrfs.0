Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:43290 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3IAGPR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 02:15:17 -0400
Received: by mail-pb0-f48.google.com with SMTP id ma3so3488075pbc.35
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Aug 2013 23:15:16 -0700 (PDT)
Date: Sun, 01 Sep 2013 14:15:08 +0800
From: Wang Shilong <wangshilong1991@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Subject: Re:  Btrfs-progs: setup framework to corrupt specific fields of an
 inode
Cc: <linux-btrfs@vger.kernel.org>
Message-ID: <5222db6c.Axjz34Xmvh9zcbSy%wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Using checkpatch.pl, i get the following warnings(errors):
WARNING: %Ld/%Lu are not-standard C, use %lld/%llu
#93: FILE: btrfs-corrupt-block.c:317:
+			fprintf(stderr, "Couldn't find inode %Lu\n", inode);

WARNING: %Ld/%Lu are not-standard C, use %lld/%llu
#103: FILE: btrfs-corrupt-block.c:327:
+		fprintf(stderr, "Couldn't find inode %Lu\n", inode);

total: 0 errors, 2 warnings, 169 lines checked

patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Thanks, Wang
