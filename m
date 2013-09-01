Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47486 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3IAGPQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 02:15:16 -0400
Received: by mail-pd0-f178.google.com with SMTP id w10so3503245pde.9
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Aug 2013 23:15:16 -0700 (PDT)
Date: Sun, 01 Sep 2013 14:15:10 +0800
From: Wang Shilong <wangshilong1991@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Subject: Re:  rwsem: add rwsem_is_contended
Cc: <walken@google.com>, <linux-btrfs@vger.kernel.org>
Message-ID: <5222db6e.ob4KXUWDxA3KE3Y1%wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Using checkpatch.pl, i get the following warnings(errors):
WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#70: FILE: lib/rwsem.c:306:
+EXPORT_SYMBOL(rwsem_is_contended);

total: 0 errors, 1 warnings, 30 lines checked

patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Thanks, Wang
